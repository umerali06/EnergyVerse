# AWS Deployment Guide — Amplify (frontend) + ECS Fargate (backend)

Step-by-step guide to deploy Flacron EnergyVerse on AWS, with automatic
redeployment on every push to `main`.

**What you end up with**

| Piece | Where it runs | Redeploys when |
|---|---|---|
| Admin portal (Next.js) | AWS Amplify Hosting | you push to `main` (Amplify watches GitHub) |
| API (FastAPI) | ECS Fargate behind an ALB | you push to `main` (GitHub Actions builds and rolls out) |
| Database / auth / storage | Firebase (unchanged) | — |

**Time needed:** about 90 minutes the first time. After that, deploys are
automatic and take 5–8 minutes.

**Files already in the repo for you**

| File | Purpose |
|---|---|
| `apps/api/Dockerfile` | Builds the API image |
| `apps/api/.dockerignore` | Keeps `.env` and tests out of the image |
| `amplify.yml` | Amplify build spec for the admin app |
| `infra/aws/ecs-task-definition.json` | ECS task definition (edit the `<PLACEHOLDERS>` once) |
| `.github/workflows/deploy-api.yml` | Test → build → push → roll out |

---

## ⚠️ Before you start — rotate the Firebase key

GitHub flagged the Firebase web API key that used to be committed. It has been
removed from source, but it was public, so **rotate or restrict it before going
live**:

1. [Google Cloud Console → Credentials](https://console.cloud.google.com/apis/credentials) → project `thinking-case-469504-c0`
2. Open the key → **Application restrictions** → *HTTP referrers* → add your Amplify domain
3. **API restrictions** → *Restrict key* → allow only what you use (Firebase, Maps)
4. Save. If you regenerate it instead, update `NEXT_PUBLIC_FIREBASE_API_KEY` in Amplify (§B4).

---

## Part 0 — Prerequisites

Install and verify:

```bash
aws --version      # AWS CLI v2
docker --version   # Docker Desktop running
gh --version       # GitHub CLI (optional but handy)
```

Configure the CLI with an admin user:

```bash
aws configure
# AWS Access Key ID / Secret / region (use us-east-1) / output: json
```

Confirm it works and note your account ID — you need it repeatedly:

```bash
aws sts get-caller-identity
```

Set these in your shell; every command below uses them:

```bash
export AWS_ACCOUNT_ID=123456789012        # from the command above
export AWS_REGION=us-east-1
export FIREBASE_PROJECT_ID=thinking-case-469504-c0
```

> **Region note:** your SES sender is already verified in `us-east-1`. Deploy
> everything there unless you have a reason not to — a cross-region setup means
> extra latency and a second SES verification.

---

# PART A — Backend on ECS Fargate

## A0. Build and run the image locally first

**Do this before touching AWS.** A broken image is far cheaper to find on your
own machine than inside a failing ECS rollout, where the only symptom is a task
that starts and stops.

```bash
cd apps/api
docker build -t fev-api:local .
```

The build takes a few minutes the first time (PyAV and Pillow are large wheels).

Now run it with your local `.env`, which already has working values:

```bash
docker run --rm -p 8000:8000 --env-file .env fev-api:local
```

In another terminal:

```bash
curl -i http://localhost:8000/health
```

Expect `HTTP/1.1 200 OK` and `"service":"fev-api"`.

If the container exits immediately, read the output — a pydantic
`extra_forbidden` error names the offending variable, and a Firebase error means
the credentials in `.env` are not reachable from inside the container.

> **Note:** `GOOGLE_APPLICATION_CREDENTIALS` in your `.env` points at a Windows
> path that does not exist inside the container. For this local test either
> comment it out and set `FIREBASE_CREDENTIALS_B64` instead (same value you will
> put in Secrets Manager at A2), or mount the file with
> `-v /c/Users/umera/Downloads/energyVerse-service.json:/creds.json:ro` and set
> `GOOGLE_APPLICATION_CREDENTIALS=/creds.json`. ECS uses the base64 route, so
> testing that path here is the more useful rehearsal.

## A1. Create the ECR repository (image registry)

```bash
aws ecr create-repository \
  --repository-name fev-api \
  --region "$AWS_REGION" \
  --image-scanning-configuration scanOnPush=true \
  --encryption-configuration encryptionType=AES256
```

`scanOnPush` tells you about known CVEs in your image for free. Note the
`repositoryUri` it prints.

**Optional but recommended** — stop paying for old images:

```bash
aws ecr put-lifecycle-policy \
  --repository-name fev-api \
  --region "$AWS_REGION" \
  --lifecycle-policy-text '{"rules":[{"rulePriority":1,"description":"Keep last 10 images","selection":{"tagStatus":"any","countType":"imageCountMoreThan","countNumber":10},"action":{"type":"expire"}}]}'
```

## A2. Put your secrets in Secrets Manager

**Never put these in the task definition, the repo, or GitHub.** ECS injects
them at container start.

First, base64 your Firebase service-account JSON (the app reads
`FIREBASE_CREDENTIALS_B64`, so you never mount a key file):

```bash
# Windows PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\Users\umera\Downloads\energyVerse-service.json"))

# macOS / Linux
base64 -w0 /path/to/energyVerse-service.json
```

Copy the output. Now create the secret — replace each value with your real one:

```bash
aws secretsmanager create-secret \
  --name fev/api \
  --region "$AWS_REGION" \
  --description "FEV API runtime secrets" \
  --secret-string '{
    "FIREBASE_CREDENTIALS_B64": "PASTE_THE_BASE64_HERE",
    "FIREBASE_WEB_API_KEY": "AIza...",
    "ANTHROPIC_API_KEY": "sk-ant-...",
    "AWS_ACCESS_KEY_ID": "AKIA...",
    "AWS_SECRET_ACCESS_KEY": "...",
    "STRIPE_SECRET_KEY": "sk_live_...",
    "STRIPE_PUBLISHABLE_KEY": "pk_live_...",
    "STRIPE_WEBHOOK_SECRET": "whsec_...",
    "SEED_DEMO_PASSWORD": "..."
  }'
```

Copy the returned **ARN** — it ends in six random characters like
`fev/api-AbCdEf`. You need the full ARN in A4.

> The `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` here are the **SES sending**
> credentials the app uses, taken from your current `apps/api/.env`. They are
> not the deploy credentials.

## A3. Create the IAM roles

**Three roles, three different jobs.** Getting these mixed up is the most common
cause of "task stopped with no logs".

### A3.1 Task execution role — lets ECS pull the image and read secrets

```bash
cat > /tmp/ecs-trust.json <<'EOF'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ecs-tasks.amazonaws.com"},"Action":"sts:AssumeRole"}]}
EOF

aws iam create-role \
  --role-name fevApiTaskExecutionRole \
  --assume-role-policy-document file:///tmp/ecs-trust.json

aws iam attach-role-policy \
  --role-name fevApiTaskExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
```

Now let it read **your** secret (the managed policy above does not cover this —
this is the step people miss):

```bash
export SECRET_ARN=$(aws secretsmanager describe-secret --secret-id fev/api --region "$AWS_REGION" --query ARN --output text)

aws iam put-role-policy \
  --role-name fevApiTaskExecutionRole \
  --policy-name ReadFevApiSecret \
  --policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"secretsmanager:GetSecretValue\"],\"Resource\":\"$SECRET_ARN\"}]}"
```

### A3.2 Task role — what your application code may do

The app talks to Firebase and SES. SES is the only AWS service it calls:

```bash
aws iam create-role \
  --role-name fevApiTaskRole \
  --assume-role-policy-document file:///tmp/ecs-trust.json

aws iam put-role-policy \
  --role-name fevApiTaskRole \
  --policy-name SendEmailViaSes \
  --policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["ses:SendRawEmail","ses:SendEmail"],"Resource":"*"}]}'
```

### A3.3 GitHub deploy role — OIDC, no stored AWS keys

This lets GitHub Actions assume a role for the length of one job. **Do not put
AWS access keys in GitHub secrets.**

Register GitHub as an identity provider (once per account — skip if it exists):

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

Create the role. **Replace `Flacron-Enterprises-llc/Flacron-Energy-Verse` if you
deploy from the other repo:**

```bash
cat > /tmp/gh-trust.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"},
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {"token.actions.githubusercontent.com:aud": "sts.amazonaws.com"},
      "StringLike": {"token.actions.githubusercontent.com:sub": "repo:Flacron-Enterprises-llc/Flacron-Energy-Verse:ref:refs/heads/main"}
    }
  }]
}
EOF

aws iam create-role \
  --role-name fevGithubDeployRole \
  --assume-role-policy-document file:///tmp/gh-trust.json
```

> The `sub` condition pins this to **`main` of that one repo**. Without it, any
> repo on GitHub could assume your role. Keep it narrow.

Grant it exactly what the workflow does:

```bash
aws iam put-role-policy \
  --role-name fevGithubDeployRole \
  --policy-name DeployFevApi \
  --policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
      {\"Effect\":\"Allow\",\"Action\":[\"ecr:GetAuthorizationToken\"],\"Resource\":\"*\"},
      {\"Effect\":\"Allow\",\"Action\":[\"ecr:BatchCheckLayerAvailability\",\"ecr:CompleteLayerUpload\",\"ecr:InitiateLayerUpload\",\"ecr:PutImage\",\"ecr:UploadLayerPart\",\"ecr:BatchGetImage\",\"ecr:GetDownloadUrlForLayer\"],\"Resource\":\"arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/fev-api\"},
      {\"Effect\":\"Allow\",\"Action\":[\"ecs:RegisterTaskDefinition\",\"ecs:DescribeTaskDefinition\"],\"Resource\":\"*\"},
      {\"Effect\":\"Allow\",\"Action\":[\"ecs:UpdateService\",\"ecs:DescribeServices\"],\"Resource\":\"arn:aws:ecs:${AWS_REGION}:${AWS_ACCOUNT_ID}:service/fev-cluster/fev-api-service\"},
      {\"Effect\":\"Allow\",\"Action\":\"iam:PassRole\",\"Resource\":[\"arn:aws:iam::${AWS_ACCOUNT_ID}:role/fevApiTaskExecutionRole\",\"arn:aws:iam::${AWS_ACCOUNT_ID}:role/fevApiTaskRole\"]}
    ]
  }"
```

## A4. Fill in the task definition

Open `infra/aws/ecs-task-definition.json` and replace every placeholder:

| Placeholder | Replace with |
|---|---|
| `<ACCOUNT_ID>` | your 12-digit account ID |
| `<REGION>` | `us-east-1` |
| `<FIREBASE_PROJECT_ID>` | `thinking-case-469504-c0` |
| `<YOUR_AMPLIFY_DOMAIN>` | leave for now, fix in Part C |
| `<no-reply@yourdomain.com>` | `no-reply@flacronenterprises.com` |
| `secret:fev/api-XXXXXX` | the full secret ARN from A2 |

A quick way to do the mechanical ones:

```bash
cd "path/to/EnergyVerse"
sed -i "s/<ACCOUNT_ID>/$AWS_ACCOUNT_ID/g; s/<REGION>/$AWS_REGION/g; s/<FIREBASE_PROJECT_ID>/$FIREBASE_PROJECT_ID/g" infra/aws/ecs-task-definition.json
```

Then fix the secret ARNs by hand — the `-XXXXXX` suffix is unique to your
secret, and the `:KEY::` suffix after it selects one key from the JSON.

## A5. Networking — VPC, security groups, load balancer

Use your default VPC to keep this simple:

```bash
export VPC_ID=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query 'Vpcs[0].VpcId' --output text)
export SUBNETS=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID --query 'Subnets[*].SubnetId' --output text | tr '\t' ',')
echo "VPC: $VPC_ID"; echo "Subnets: $SUBNETS"
```

Two security groups — the ALB is public, the tasks are not:

```bash
export ALB_SG=$(aws ec2 create-security-group --group-name fev-alb-sg --description "FEV ALB" --vpc-id $VPC_ID --query GroupId --output text)
aws ec2 authorize-security-group-ingress --group-id $ALB_SG --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $ALB_SG --protocol tcp --port 80 --cidr 0.0.0.0/0

export TASK_SG=$(aws ec2 create-security-group --group-name fev-task-sg --description "FEV ECS tasks" --vpc-id $VPC_ID --query GroupId --output text)
# Only the ALB may reach the container. Nothing else on the internet can.
aws ec2 authorize-security-group-ingress --group-id $TASK_SG --protocol tcp --port 8000 --source-group $ALB_SG
```

Create the load balancer and target group:

```bash
export ALB_ARN=$(aws elbv2 create-load-balancer \
  --name fev-api-alb --type application --scheme internet-facing \
  --subnets $(echo $SUBNETS | tr ',' ' ') --security-groups $ALB_SG \
  --query 'LoadBalancers[0].LoadBalancerArn' --output text)

export TG_ARN=$(aws elbv2 create-target-group \
  --name fev-api-tg --protocol HTTP --port 8000 --vpc-id $VPC_ID \
  --target-type ip \
  --health-check-path /health \
  --health-check-interval-seconds 30 \
  --healthy-threshold-count 2 --unhealthy-threshold-count 3 \
  --query 'TargetGroups[0].TargetGroupArn' --output text)

aws elbv2 create-listener \
  --load-balancer-arn $ALB_ARN --protocol HTTP --port 80 \
  --default-actions Type=forward,TargetGroupArn=$TG_ARN

export ALB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns $ALB_ARN --query 'LoadBalancers[0].DNSName' --output text)
echo "API will be at: http://$ALB_DNS"
```

> **HTTPS:** request a certificate in ACM for e.g. `api.flacronenterprises.com`,
> then add a port-443 listener with `--certificates CertificateArn=...` and point
> a Route 53 record at the ALB. Do this before production — Firebase tokens and
> your Stripe webhook should never travel over plain HTTP.

## A6. Create the cluster and service

```bash
aws ecs create-cluster --cluster-name fev-cluster --region "$AWS_REGION"

aws logs create-log-group --log-group-name /ecs/fev-api --region "$AWS_REGION" || true
```

Register the task definition you filled in at A4:

```bash
aws ecs register-task-definition \
  --cli-input-json file://infra/aws/ecs-task-definition.json \
  --region "$AWS_REGION"
```

> If this errors, read the message carefully — it is almost always one
> unreplaced `<PLACEHOLDER>` or a malformed secret ARN.

Create the service:

```bash
aws ecs create-service \
  --cluster fev-cluster \
  --service-name fev-api-service \
  --task-definition fev-api \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[$SUBNETS],securityGroups=[$TASK_SG],assignPublicIp=ENABLED}" \
  --load-balancers "targetGroupArn=$TG_ARN,containerName=fev-api,containerPort=8000" \
  --health-check-grace-period-seconds 90 \
  --deployment-configuration "deploymentCircuitBreaker={enable=true,rollback=true},maximumPercent=200,minimumHealthyPercent=100" \
  --region "$AWS_REGION"
```

Three choices worth understanding:

- **`desired-count 2`** — two tasks across two availability zones. One task means
  every deploy is a brief outage.
- **`deploymentCircuitBreaker ... rollback=true`** — if new tasks fail their
  health check, ECS puts the previous version back automatically instead of
  leaving you down.
- **`minimumHealthyPercent=100`** — never drop below full capacity mid-deploy.

> **`assignPublicIp=ENABLED`** is needed because default-VPC subnets have no NAT
> gateway, and the task must reach Firebase, Anthropic and SES. For a hardened
> setup, use private subnets with a NAT gateway and set this to `DISABLED`.

Watch it come up:

```bash
aws ecs wait services-stable --cluster fev-cluster --services fev-api-service --region "$AWS_REGION"
curl -i "http://$ALB_DNS/health"
```

You want `HTTP/1.1 200 OK` and a JSON body with `"service":"fev-api"`.

## A7. Turn on auto-deploy from GitHub

Add two repository secrets:

```bash
gh secret set AWS_DEPLOY_ROLE_ARN \
  --repo Flacron-Enterprises-llc/Flacron-Energy-Verse \
  --body "arn:aws:iam::${AWS_ACCOUNT_ID}:role/fevGithubDeployRole"

gh secret set API_HEALTH_URL \
  --repo Flacron-Enterprises-llc/Flacron-Energy-Verse \
  --body "http://${ALB_DNS}/health"
```

(Or: GitHub → repo → Settings → Secrets and variables → Actions → New secret.)

If `.github/workflows/deploy-api.yml` has different values for
`AWS_REGION`, `ECS_CLUSTER` or `ECS_SERVICE` than you used, edit them to match.

**That is it for the backend.** Push anything under `apps/api/` to `main` and
the workflow runs tests, builds the image, pushes to ECR, and rolls out.

---

# PART B — Frontend on AWS Amplify

## B1. Connect the repository

1. [AWS Amplify console](https://console.aws.amazon.com/amplify/) → **Create new app**
2. **GitHub** → Authorize AWS Amplify → pick
   `Flacron-Enterprises-llc/Flacron-Energy-Verse`
3. Branch: **`main`** → Next

## B2. Point it at the monorepo

On the build settings screen:

- Tick **"My app is a monorepo"**
- **Monorepo app root:** `apps/admin`
- Amplify should detect the root `amplify.yml`. If it shows a generated spec
  instead, replace it with the contents of that file.

## B3. Check the platform

Amplify must build this as **Next.js SSR (WEB_COMPUTE)**, not a static site. It
normally detects this. Verify after the first build:

```bash
aws amplify get-app --app-id <YOUR_APP_ID> --query 'app.platform'
# must print "WEB_COMPUTE"
```

If it prints `WEB`, fix it:

```bash
aws amplify update-app --app-id <YOUR_APP_ID> --platform WEB_COMPUTE
```

> A static build would silently drop the server components and route handlers
> the admin relies on — pages would render but data would not load.

## B4. Environment variables

**App settings → Environment variables.** Every one of these is baked in at
build time, so a change needs a redeploy, not a restart.

| Variable | Value |
|---|---|
| `NEXT_PUBLIC_API_BASE_URL` | `http://<ALB_DNS>` (your HTTPS API domain once you have one) |
| `NEXT_PUBLIC_SITE_URL` | your Amplify URL, e.g. `https://main.d1234.amplifyapp.com` |
| `NEXT_PUBLIC_FIREBASE_API_KEY` | your (restricted) Firebase web key |
| `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN` | `thinking-case-469504-c0.firebaseapp.com` |
| `NEXT_PUBLIC_FIREBASE_PROJECT_ID` | `thinking-case-469504-c0` |
| `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET` | `thinking-case-469504-c0.firebasestorage.app` |
| `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID` | your sender ID |
| `NEXT_PUBLIC_FIREBASE_APP_ID` | your app ID |
| `NEXT_PUBLIC_AUTH_ACTION_URL` | `https://<your-amplify-domain>/auth/action` |

All of these are in your local `apps/admin/.env.local`.

## B5. Deploy

**Save and deploy.** First build takes 5–10 minutes. Watch Provision → Build →
Deploy → Verify.

Amplify now redeploys on every push to `main` automatically — nothing further to
configure.

## B6. Custom domain (optional)

**Hosting → Custom domains → Add domain.** If the domain is in Route 53, Amplify
creates the records and the certificate itself.

---

# PART C — Wire the two together

Three settings must agree, or you will see CORS errors or login failures.

### C1. Tell the API which origin to trust

Edit `infra/aws/ecs-task-definition.json` — replace `<YOUR_AMPLIFY_DOMAIN>` in
both `APP_BASE_URL` and `CORS_ORIGINS`:

```json
{ "name": "APP_BASE_URL",  "value": "https://main.d1234.amplifyapp.com" },
{ "name": "CORS_ORIGINS",  "value": "[\"https://main.d1234.amplifyapp.com\"]" }
```

`CORS_ORIGINS` **must be a JSON array inside a string** — that is how
pydantic-settings parses a tuple from an environment variable. A bare
comma-separated string will not parse and the API will fail to start.

Commit and push; the workflow redeploys.

### C2. Tell the frontend where the API is

`NEXT_PUBLIC_API_BASE_URL` in Amplify (§B4) → your ALB or API domain.
**No trailing slash.** Redeploy the Amplify branch after changing it.

### C3. Authorize the domain in Firebase

[Firebase console](https://console.firebase.google.com) → Authentication →
Settings → **Authorized domains** → add your Amplify domain.

Without this, sign-in fails with `auth/unauthorized-domain`.

---

# PART D — One-time production setup

### D1. Deploy Firestore rules and indexes

The app will not work correctly without them:

```bash
cd infra/firebase
firebase deploy --only firestore:rules,firestore:indexes,storage --project "$FIREBASE_PROJECT_ID"
```

Indexes take a few minutes to build. Queries return 500 until they finish — that
is expected, not a bug.

### D2. Seed the tenant (only if you want demo data)

Run against production **deliberately**, never by accident:

```bash
aws ecs run-task \
  --cluster fev-cluster \
  --task-definition fev-api \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[$SUBNETS],securityGroups=[$TASK_SG],assignPublicIp=ENABLED}" \
  --overrides '{"containerOverrides":[{"name":"fev-api","command":["python","-m","scripts.seed"]}]}' \
  --region "$AWS_REGION"
```

Same pattern for the title backfill — swap the command for
`["python","-m","scripts.backfill_inspection_titles","--dry-run"]` first, then
run it without `--dry-run`.

### D3. Point Stripe at the deployed webhook

Stripe dashboard → Developers → Webhooks → add
`https://<your-api-domain>/api/v1/billing/webhook`. Copy the signing secret into
the `STRIPE_WEBHOOK_SECRET` key of your `fev/api` secret, then force a redeploy
(Actions → Deploy API to ECS → Run workflow).

---

# PART E — Verify the whole thing works

```bash
# 1. API is healthy
curl -i "http://$ALB_DNS/health"

# 2. It rejects an unauthenticated call (401 = auth is working, not broken)
curl -i "http://$ALB_DNS/api/v1/auth/me"

# 3. CORS allows your frontend
curl -i -X OPTIONS "http://$ALB_DNS/api/v1/auth/me" \
  -H "Origin: https://<your-amplify-domain>" \
  -H "Access-Control-Request-Method: GET"
# look for access-control-allow-origin in the response
```

Then in a browser: open the Amplify URL, sign in, and confirm the dashboard
loads real data. If the page renders but every panel errors, it is almost always
C1/C2 — the API URL or the CORS origin.

**Test auto-deploy end to end:**

```bash
git commit --allow-empty -m "Test auto-deploy"
git push origin main
```

Watch GitHub → Actions (API) and the Amplify console (frontend). Both should go
green without you touching anything.

---

# PART F — Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Task starts then stops, no logs | Execution role cannot read the secret | Re-check A3.1 — the inline `ReadFevApiSecret` policy, and that the ARN matches |
| `ResourceInitializationError: unable to pull secrets` | Wrong secret ARN or missing `:KEY::` suffix | Each entry must end `...:secret:fev/api-AbCdEf:KEY_NAME::` |
| Task runs, ALB shows unhealthy | Security group, or app failed to boot | `aws logs tail /ecs/fev-api --follow` |
| `extra_forbidden` in the logs | An env var the settings model does not define | Settings use `extra=forbid`; remove the stray variable |
| API 500s on list endpoints | Firestore indexes still building | Wait, or check the Firebase console |
| CORS error in the browser | `CORS_ORIGINS` wrong or not JSON | See C1 — it must be a JSON array in a string |
| `auth/unauthorized-domain` | Domain not authorized in Firebase | See C3 |
| Amplify build fails on `tsc` | Real type error | Reproduce locally: `cd apps/admin && npx tsc --noEmit` |
| Amplify deploys but data never loads | Built as static, not SSR | See B3 — platform must be `WEB_COMPUTE` |
| Frontend still calls localhost | `NEXT_PUBLIC_*` baked in at build | Change it in Amplify, then **redeploy** |
| GitHub Action: `Not authorized to perform sts:AssumeRoleWithWebIdentity` | Trust policy `sub` does not match | A3.3 — repo name and `ref:refs/heads/main` must match exactly |

**Useful commands**

```bash
aws logs tail /ecs/fev-api --follow --region "$AWS_REGION"
aws ecs describe-services --cluster fev-cluster --services fev-api-service --query 'services[0].events[:5]'
aws elbv2 describe-target-health --target-group-arn $TG_ARN
```

**Rollback:** GitHub → Actions → pick the last good "Deploy API to ECS" run →
**Re-run all jobs**. It redeploys that exact commit's image.

---

# PART G — Cost estimate

Rough monthly cost in `us-east-1`:

| Item | ~USD/month |
|---|---|
| ECS Fargate, 2 × 0.5 vCPU / 1 GB, always on | ~$30 |
| Application Load Balancer | ~$17 |
| ECR storage (10 images) | ~$1 |
| Amplify hosting (build minutes + transfer) | ~$5–15 |
| Secrets Manager (1 secret) | ~$0.40 |
| CloudWatch logs | ~$2–5 |
| **Total** | **~$55–70** |

To cut it: run `--desired-count 1` in staging (accepting brief deploy downtime),
and set a log retention period:

```bash
aws logs put-retention-policy --log-group-name /ecs/fev-api --retention-in-days 14
```

---

## Security checklist before going live

- [ ] Firebase API key restricted or rotated (top of this guide)
- [ ] HTTPS listener on the ALB; HTTP redirects to it
- [ ] `CORS_ALLOW_ALL_LOCALHOST=false` in the task definition (already set)
- [ ] `FEV_DEBUG=false` (already set)
- [ ] Firestore rules deployed (D1) — they are your real database security
- [ ] No AWS keys in GitHub secrets; only the OIDC role ARN
- [ ] Secret rotation scheduled in Secrets Manager
- [ ] Stripe using live keys and the deployed webhook URL (D3)

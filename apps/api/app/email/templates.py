import html
from dataclasses import dataclass
from importlib import resources
from typing import Final

# Brand tokens mirrored from apps/mobile/lib/design_system/tokens_generated.dart
# (DsColors.accent500 / primary900 / primary800) so transactional email matches
# the in-app palette instead of drifting from it.
_ACCENT = "#FB4402"
_NAVY_900 = "#001A49"
_NAVY_800 = "#002865"
_INK_MUTED = "#5B6B85"
_BORDER = "#E3E8F0"
_BACKGROUND = "#F1F4F9"

LOGO_CONTENT_ID: Final = "fev-logo"


def _logo_bytes() -> bytes:
    return resources.files("app.email.assets").joinpath("logo.png").read_bytes()


@dataclass(frozen=True)
class RenderedEmail:
    subject: str
    html_body: str
    text_body: str
    inline_images: dict[str, bytes]


def _base_layout(*, preheader: str, body_html: str) -> str:
    return f"""\
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="color-scheme" content="light" />
  </head>
  <body style="margin:0; padding:0; background-color:{_BACKGROUND}; font-family:'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
    <div style="display:none; max-height:0; overflow:hidden; opacity:0;">{preheader}</div>
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:{_BACKGROUND}; padding:32px 16px;">
      <tr>
        <td align="center">
          <table role="presentation" width="480" cellpadding="0" cellspacing="0" style="max-width:480px; width:100%; background-color:#FFFFFF; border-radius:16px; overflow:hidden; border:1px solid {_BORDER};">
            <tr>
              <td style="background-color:{_NAVY_900}; padding:28px 32px; text-align:center;">
                <img src="cid:{LOGO_CONTENT_ID}" alt="Flacron Energy" width="200" style="display:block; margin:0 auto; max-width:200px; height:auto;" />
              </td>
            </tr>
            <tr>
              <td style="padding:32px;">
                {body_html}
              </td>
            </tr>
            <tr>
              <td style="padding:20px 32px; border-top:1px solid {_BORDER}; text-align:center;">
                <p style="margin:0; font-size:12px; line-height:18px; color:{_INK_MUTED};">
                  Flacron Energy &middot; Powering today. Sustaining tomorrow.
                </p>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
"""


def _button(*, label: str, href: str) -> str:
    return f"""\
<table role="presentation" cellpadding="0" cellspacing="0" style="margin:28px 0;">
  <tr>
    <td style="border-radius:10px; background-color:{_ACCENT};">
      <a href="{href}" target="_blank"
         style="display:inline-block; padding:14px 28px; font-size:15px; font-weight:600; color:#FFFFFF; text-decoration:none; border-radius:10px;">
        {label}
      </a>
    </td>
  </tr>
</table>
"""


def render_verification_email(*, display_name: str, verification_link: str) -> RenderedEmail:
    body_html = f"""\
<h1 style="margin:0 0 12px; font-size:20px; line-height:28px; color:{_NAVY_900};">Verify your email</h1>
<p style="margin:0 0 4px; font-size:15px; line-height:24px; color:{_NAVY_800};">Hi {display_name},</p>
<p style="margin:0 0 4px; font-size:15px; line-height:24px; color:{_INK_MUTED};">
  Confirm your email address to finish setting up your Flacron Energy account.
</p>
{_button(label="Verify email address", href=verification_link)}
<p style="margin:0; font-size:13px; line-height:20px; color:{_INK_MUTED};">
  If the button doesn't work, copy and paste this link into your browser:<br />
  <a href="{verification_link}" style="color:{_ACCENT}; word-break:break-all;">{verification_link}</a>
</p>
<p style="margin:20px 0 0; font-size:13px; line-height:20px; color:{_INK_MUTED};">
  If you didn't create this account, you can safely ignore this email.
</p>
"""
    text_body = (
        f"Hi {display_name},\n\n"
        "Confirm your email address to finish setting up your Flacron Energy "
        "account by opening this link:\n\n"
        f"{verification_link}\n\n"
        "If you didn't create this account, you can safely ignore this email.\n"
    )
    return RenderedEmail(
        subject="Verify your email for Flacron Energy",
        html_body=_base_layout(
            preheader="Confirm your email address to finish setting up your account.",
            body_html=body_html,
        ),
        text_body=text_body,
        inline_images={LOGO_CONTENT_ID: _logo_bytes()},
    )


def render_notification_email(
    *, display_name: str, title: str, body: str, action_link: str | None = None
) -> RenderedEmail:
    """One notification, rendered in the same branded shell as verification.

    The subject carries the notification's own title rather than a generic
    prefix, so a mailbox list is scannable without opening anything.
    """
    button_html = _button(label="Open in Flacron Energy", href=action_link) if action_link else ""
    body_html = f"""\
<h1 style="margin:0 0 12px; font-size:20px; line-height:28px; color:{_NAVY_900};">{title}</h1>
<p style="margin:0 0 4px; font-size:15px; line-height:24px; color:{_NAVY_800};">Hi {display_name},</p>
<p style="margin:0 0 4px; font-size:15px; line-height:24px; color:{_INK_MUTED};">{body}</p>
{button_html}
<p style="margin:20px 0 0; font-size:13px; line-height:20px; color:{_INK_MUTED};">
  You are receiving this because it was assigned to you in Flacron Energy.
</p>
"""
    text_lines = [f"Hi {display_name},", "", title, "", body, ""]
    if action_link:
        text_lines += ["Open it here:", action_link, ""]
    text_lines.append("You are receiving this because it was assigned to you in Flacron Energy.")
    return RenderedEmail(
        subject=title,
        html_body=_base_layout(preheader=body[:140], body_html=body_html),
        text_body="\n".join(text_lines) + "\n",
        inline_images={LOGO_CONTENT_ID: _logo_bytes()},
    )


def render_contact_email(
    *,
    name: str,
    email: str,
    company: str | None,
    category: str,
    subject: str,
    message: str,
    context_lines: list[str],
) -> RenderedEmail:
    """The internal notification raised by a public contact-form submission.

    Deliberately carries no credentials, card data, or secrets: the form warns
    the sender not to include them, and everything routed here is limited to
    what the package lists under contact-form routing. `context_lines` holds the
    account context the server knows (user id, company id, tier) rather than
    anything the browser claimed.
    """
    safe_message = html.escape(message).replace("\n", "<br />")
    context_html = "".join(
        f'<tr><td style="padding:2px 12px 2px 0; font-size:13px; color:{_INK_MUTED};">{html.escape(line)}</td></tr>'
        for line in context_lines
    )
    body_html = f"""\
<h1 style="margin:0 0 12px; font-size:20px; line-height:28px; color:{_NAVY_900};">{html.escape(category)}</h1>
<p style="margin:0 0 16px; font-size:15px; line-height:24px; color:{_NAVY_800};">
  <strong>{html.escape(subject)}</strong>
</p>
<p style="margin:0 0 20px; font-size:15px; line-height:24px; color:{_NAVY_800};">{safe_message}</p>
<table role="presentation" style="margin:0 0 8px;">
  <tr><td style="padding:2px 12px 2px 0; font-size:13px; color:{_INK_MUTED};">From: {html.escape(name)} &lt;{html.escape(email)}&gt;</td></tr>
  <tr><td style="padding:2px 12px 2px 0; font-size:13px; color:{_INK_MUTED};">Company: {html.escape(company or "Not provided")}</td></tr>
  {context_html}
</table>
"""
    text_lines = [
        f"{category}: {subject}",
        "",
        message,
        "",
        f"From: {name} <{email}>",
        f"Company: {company or 'Not provided'}",
        *context_lines,
    ]
    return RenderedEmail(
        subject=f"[Flacron Energy] {category} — {subject}",
        html_body=_base_layout(
            preheader=f"{category} from {name}",
            body_html=body_html,
        ),
        text_body="\n".join(text_lines) + "\n",
        inline_images={LOGO_CONTENT_ID: _logo_bytes()},
    )

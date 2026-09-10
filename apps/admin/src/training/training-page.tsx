"use client";

import type {
  DigitalTwinSceneResponse,
  TrainingModuleResponse,
  TrainingProgressResponse,
} from "@fev/api-client";
import { useCallback, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  ErrorState,
  MotionSection,
  Skeleton,
  StatusPill,
  type StatusTone,
} from "@/design-system";

import { VrTrainer, type StepOutcome } from "./vr-trainer";

const KIND_LABELS: Record<string, string> = {
  exploration: "Facility exploration",
  equipment_location: "Equipment location",
  safety_procedure: "Safety procedure",
  emergency_drill: "Emergency drill",
  maintenance_simulation: "Maintenance simulation",
};

function statusTone(status: string): StatusTone {
  if (status === "completed") return "healthy";
  if (status === "failed") return "critical";
  if (status === "in_progress") return "warning";
  return "info";
}

function statusLabel(status: string): string {
  return status.replace(/_/g, " ").replace(/^\w/, (letter) => letter.toUpperCase());
}

/** The best result a trainee has on a module: a pass stands even if a later
 * attempt was abandoned, which is how competency records normally read. */
function bestFor(
  progress: readonly TrainingProgressResponse[],
  moduleId: string,
): TrainingProgressResponse | null {
  const mine = progress.filter((row) => row.moduleId === moduleId);
  if (mine.length === 0) return null;
  return (
    mine.find((row) => row.status === "completed") ??
    mine.find((row) => row.status === "in_progress") ??
    mine[0]
  );
}

export function TrainingPage() {
  const { apiClient } = useAuth();
  const [modules, setModules] = useState<TrainingModuleResponse[]>([]);
  const [progress, setProgress] = useState<TrainingProgressResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [active, setActive] = useState<{
    module: TrainingModuleResponse;
    scene: DigitalTwinSceneResponse;
  } | null>(null);
  const [launching, setLaunching] = useState<string | null>(null);
  const [launchError, setLaunchError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const [modulePage, progressPage] = await Promise.all([
        apiClient.listTrainingModules(),
        apiClient.listTrainingProgress(),
      ]);
      setModules(modulePage.items ?? []);
      setProgress(progressPage.items ?? []);
    } catch {
      setModules([]);
      setProgress([]);
      setError("Training modules could not be loaded.");
    } finally {
      setLoading(false);
    }
  }, [apiClient]);

  useEffect(() => {
    void load();
  }, [load]);

  async function launch(module: TrainingModuleResponse) {
    setLaunching(module.id);
    setLaunchError(null);
    try {
      // The scenario runs inside the facility's real 3D scene, so both are
      // fetched before entering; starting the attempt last means a failed
      // scene load does not leave a phantom in-progress record.
      const scene = await apiClient.getFacility3dScene(module.facilityId);
      await apiClient.startTrainingModule(module.id);
      setActive({ module, scene });
    } catch {
      setLaunchError(
        "This module could not be started. Its facility scene may be unavailable.",
      );
    } finally {
      setLaunching(null);
    }
  }

  async function recordStep(outcome: StepOutcome) {
    if (!active) return;
    try {
      await apiClient.completeTrainingStep(
        active.module.id,
        outcome.stepId,
        outcome.correct,
        outcome.selectedOption,
      );
    } catch {
      // Losing one step's record must not strand the trainee mid-module; the
      // server treats a replay as idempotent, so the next attempt recovers.
    }
  }

  async function finish() {
    if (!active) return;
    try {
      await apiClient.completeTrainingModule(active.module.id);
    } finally {
      await load();
    }
  }

  if (active) {
    return (
      <section className="p-4 md:p-6">
        <MotionSection className="mx-auto max-w-7xl">
          <VrTrainer
            module={active.module}
            onExit={() => {
              setActive(null);
              void load();
            }}
            onFinish={finish}
            onStepComplete={recordStep}
            scene={active.scene}
          />
        </MotionSection>
      </section>
    );
  }

  return (
    <section className="p-6 md:p-8">
      <MotionSection className="mx-auto max-w-7xl">
        <div>
          <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
            Competency
          </p>
          <h1 className="mt-2 text-h2 font-bold">VR Training</h1>
          <p className="mt-1 text-bodySmall text-text-secondary">
            Guided scenarios run inside your own facility&apos;s 3D scene, on a headset or
            in the browser.
          </p>
        </div>

        {launchError && (
          <Card className="mt-5 border-critical p-4 text-bodySmall text-critical">
            {launchError}
          </Card>
        )}

        <div className="mt-6">
          {loading ? (
            <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
              {[0, 1, 2].map((key) => (
                <Skeleton className="h-44 w-full" key={key} />
              ))}
            </div>
          ) : error ? (
            <ErrorState
              action={<Button onClick={() => void load()}>Retry</Button>}
              description="The training catalog is unavailable, so this is not a record of zero modules. Retry, or contact an administrator if it persists."
              title="Training modules could not be loaded"
            />
          ) : modules.length === 0 ? (
            <EmptyState
              description="No training modules have been configured for your facilities yet."
              title="No training modules"
            />
          ) : (
            <ul className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
              {modules.map((module) => {
                const best = bestFor(progress, module.id);
                return (
                  <li key={module.id}>
                    <Card className="flex h-full flex-col gap-3 p-4">
                      <div className="flex flex-wrap items-center gap-2">
                        <Badge>{KIND_LABELS[module.kind] ?? module.kind}</Badge>
                        {best && (
                          <StatusPill tone={statusTone(best.status)}>
                            {statusLabel(best.status)}
                            {best.score != null ? ` · ${best.score}%` : ""}
                          </StatusPill>
                        )}
                      </div>
                      <div>
                        <h2 className="text-h5 font-bold">{module.title}</h2>
                        <p className="mt-1 text-caption text-text-secondary">
                          {module.description}
                        </p>
                      </div>
                      <p className="font-mono text-caption text-text-muted">
                        {(module.steps ?? []).length} steps · ~{module.estimatedMinutes} min ·
                        pass {module.passThreshold}%
                      </p>
                      <Button
                        className="mt-auto w-full justify-center"
                        loading={launching === module.id}
                        onClick={() => void launch(module)}
                      >
                        {best?.status === "completed" ? "Retake" : "Start module"}
                      </Button>
                    </Card>
                  </li>
                );
              })}
            </ul>
          )}
        </div>
      </MotionSection>
    </section>
  );
}

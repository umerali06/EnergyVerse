"use client";

import type { WorkOrderDetail } from "@fev/api-client";
import Link from "next/link";
import { useEffect, useState } from "react";

import { ApiClientError } from "@/api";
import { useAuth } from "@/auth/auth-context";
import { formatCompanyDateTime } from "@/dashboard/format";
import {
  Badge,
  Button,
  Card,
  ConfirmDialog,
  EmptyState,
  MotionSection,
  Skeleton,
  StatusPill,
  useToast,
} from "@/design-system";

import { AssignTechnicianModal } from "./work-order-modals";
import { assetLabel, facilityName, technicianName, useWorkOrdersData } from "./work-orders-data";
import { priorityLabel, priorityTone, StatusBadge } from "./work-orders-page";

type AsyncStatus = "loading" | "error" | "ready";

function Field({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">{label}</p>
      <p className="mt-0.5 text-bodySmall text-text-primary">{value}</p>
    </div>
  );
}

const NON_TERMINAL_STATUSES = new Set(["open", "assigned", "in_progress", "pending_review"]);
const ASSIGNABLE_STATUSES = new Set(["open", "assigned"]);

export function WorkOrderDetailPage({
  reducedMotionOverride,
  workOrderId,
}: {
  reducedMotionOverride?: boolean;
  workOrderId: string;
}) {
  const data = useWorkOrdersData();
  const { currentUser } = useAuth();
  const toast = useToast();
  const canWrite = currentUser?.permissions.has("work_orders.write") ?? false;
  const canClose = currentUser?.permissions.has("work_orders.close") ?? false;
  const [state, setState] = useState<{ status: AsyncStatus; workOrder: WorkOrderDetail | null }>({
    status: "loading",
    workOrder: null,
  });
  const [assignOpen, setAssignOpen] = useState(false);
  const [confirming, setConfirming] = useState<"close" | "cancel" | null>(null);
  const [acting, setActing] = useState(false);

  useEffect(() => {
    let active = true;
    setState({ status: "loading", workOrder: null });
    data
      .getWorkOrder(workOrderId)
      .then((workOrder) => {
        if (active) setState({ status: "ready", workOrder });
      })
      .catch(() => {
        if (active) setState({ status: "error", workOrder: null });
      });
    return () => {
      active = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [workOrderId]);

  async function handleClose() {
    setActing(true);
    try {
      const updated = await data.closeWorkOrder(workOrderId);
      setState({ status: "ready", workOrder: updated });
      setConfirming(null);
      toast.success("Work order closed");
    } catch (failure) {
      if (failure instanceof ApiClientError) toast.error(failure.message);
    } finally {
      setActing(false);
    }
  }

  async function handleCancel() {
    setActing(true);
    try {
      const updated = await data.cancelWorkOrder(workOrderId);
      setState({ status: "ready", workOrder: updated });
      setConfirming(null);
      toast.success("Work order cancelled");
    } catch (failure) {
      if (failure instanceof ApiClientError) toast.error(failure.message);
    } finally {
      setActing(false);
    }
  }

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-4xl" reducedMotionOverride={reducedMotionOverride}>
        {state.status === "loading" && (
          <div className="grid gap-3">
            <Skeleton className="h-8 w-64" />
            <Skeleton className="h-32 w-full" />
          </div>
        )}
        {state.status === "error" && (
          <EmptyState
            description="Couldn't load this work order. Check your connection and try again."
            title="Something went wrong"
          />
        )}
        {state.status === "ready" && state.workOrder && (
          <>
            <div className="flex flex-wrap items-start justify-between gap-4">
              <div>
                <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
                  Work order
                </p>
                <h1 className="mt-2 text-h2 font-bold">{state.workOrder.title}</h1>
                <div className="mt-2 flex flex-wrap items-center gap-2">
                  <StatusBadge status={state.workOrder.status} />
                  <StatusPill tone={priorityTone(state.workOrder.priority)}>
                    {priorityLabel(state.workOrder.priority)}
                  </StatusPill>
                </div>
              </div>
              <div className="flex flex-wrap gap-2">
                {canWrite && ASSIGNABLE_STATUSES.has(state.workOrder.status) && (
                  <Button onClick={() => setAssignOpen(true)} variant="ghost">
                    {state.workOrder.technicianId ? "Reassign" : "Assign"}
                  </Button>
                )}
                {canClose && state.workOrder.status === "pending_review" && (
                  <Button onClick={() => setConfirming("close")}>Close</Button>
                )}
                {canWrite && NON_TERMINAL_STATUSES.has(state.workOrder.status) && (
                  <Button onClick={() => setConfirming("cancel")} variant="danger">
                    Cancel
                  </Button>
                )}
              </div>
            </div>

            <Card className="mt-6 grid gap-6 p-5">
              <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                <Field
                  label="Asset"
                  value={assetLabel(data.assets.items, state.workOrder.assetId)}
                />
                <Field
                  label="Facility"
                  value={facilityName(data.facilities.items, state.workOrder.facilityId)}
                />
                <Field
                  label="Technician"
                  value={
                    technicianName(data.technicians.items, state.workOrder.technicianId) ??
                    "Unassigned"
                  }
                />
                <Field
                  label="Due date"
                  value={
                    state.workOrder.dueDate
                      ? formatCompanyDateTime(state.workOrder.dueDate)
                      : "—"
                  }
                />
                {state.workOrder.sourceInspectionId && (
                  <div>
                    <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                      Source inspection
                    </p>
                    <Link
                      className="mt-0.5 inline-block font-mono text-bodySmall text-primary-700 underline-offset-2 hover:underline dark:text-primary-300"
                      href={`/inspections/${state.workOrder.sourceInspectionId}`}
                    >
                      {state.workOrder.sourceInspectionId}
                    </Link>
                  </div>
                )}
              </div>

              {state.workOrder.description && (
                <div>
                  <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                    Description
                  </p>
                  <p className="mt-1 text-bodySmall text-text-secondary">
                    {state.workOrder.description}
                  </p>
                </div>
              )}

              <div className="grid gap-4 border-t border-border pt-4 sm:grid-cols-2 lg:grid-cols-3">
                {state.workOrder.assignedAt && (
                  <Field label="Assigned" value={formatCompanyDateTime(state.workOrder.assignedAt)} />
                )}
                {state.workOrder.acceptedAt && (
                  <Field label="Accepted" value={formatCompanyDateTime(state.workOrder.acceptedAt)} />
                )}
                {state.workOrder.submittedAt && (
                  <Field
                    label="Submitted for review"
                    value={formatCompanyDateTime(state.workOrder.submittedAt)}
                  />
                )}
                {state.workOrder.closedAt && (
                  <Field label="Closed" value={formatCompanyDateTime(state.workOrder.closedAt)} />
                )}
                {state.workOrder.cancelledAt && (
                  <Field
                    label="Cancelled"
                    value={formatCompanyDateTime(state.workOrder.cancelledAt)}
                  />
                )}
              </div>

              {(state.workOrder.status === "pending_review" ||
                state.workOrder.status === "closed") && (
                <div className="border-t border-border pt-4">
                  <h2 className="text-h5 font-bold">Completion details</h2>
                  <p className="mt-1 text-caption text-text-muted">
                    Submitted by the assigned technician from the mobile app.
                  </p>
                  <div className="mt-3 grid gap-4 sm:grid-cols-2">
                    <Field
                      label="Labor hours"
                      value={
                        state.workOrder.laborHours != null
                          ? state.workOrder.laborHours.toString()
                          : "—"
                      }
                    />
                    <div>
                      <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                        Materials used
                      </p>
                      {state.workOrder.materialsUsed && state.workOrder.materialsUsed.length > 0 ? (
                        <div className="mt-1 flex flex-wrap gap-1.5">
                          {state.workOrder.materialsUsed.map((material) => (
                            <Badge key={material}>{material}</Badge>
                          ))}
                        </div>
                      ) : (
                        <p className="mt-0.5 text-bodySmall text-text-primary">—</p>
                      )}
                    </div>
                  </div>
                  {state.workOrder.completionNotes && (
                    <div className="mt-4">
                      <p className="font-mono text-caption uppercase tracking-[0.1em] text-text-muted">
                        Completion notes
                      </p>
                      <p className="mt-1 text-bodySmall text-text-secondary">
                        {state.workOrder.completionNotes}
                      </p>
                    </div>
                  )}
                </div>
              )}

              <div className="grid gap-4 border-t border-border pt-4 sm:grid-cols-2">
                <Field label="Created" value={formatCompanyDateTime(state.workOrder.createdAt)} />
                <Field label="Last updated" value={formatCompanyDateTime(state.workOrder.updatedAt)} />
              </div>
            </Card>

            <AssignTechnicianModal
              onAssigned={() => {
                void data.getWorkOrder(workOrderId).then((workOrder) => setState({ status: "ready", workOrder }));
              }}
              onClose={() => setAssignOpen(false)}
              open={assignOpen}
              technicians={data.technicians.items}
              workOrder={state.workOrder}
              workOrders={data}
            />

            <ConfirmDialog
              cancelLabel="Cancel"
              confirmLabel="Close work order"
              consequence="This confirms the repair passed supervisor review and marks the work order closed. This can't be undone."
              loading={acting}
              onCancel={() => setConfirming(null)}
              onConfirm={() => void handleClose()}
              open={confirming === "close"}
              title="Close this work order?"
            />

            <ConfirmDialog
              cancelLabel="Keep work order"
              confirmLabel="Cancel work order"
              consequence="This marks the work order cancelled. It can no longer be assigned, worked on, or closed."
              loading={acting}
              onCancel={() => setConfirming(null)}
              onConfirm={() => void handleCancel()}
              open={confirming === "cancel"}
              title="Cancel this work order?"
            />
          </>
        )}
      </MotionSection>
    </section>
  );
}

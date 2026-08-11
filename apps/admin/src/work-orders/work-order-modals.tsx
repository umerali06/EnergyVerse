"use client";

import type {
  AssetListItem,
  AssignWorkOrderRequest,
  CreateWorkOrderRequest,
  UserListItem,
  WorkOrderDetail,
} from "@fev/api-client";
import { useEffect, useState } from "react";

import { ApiClientError } from "@/api";
import { Button, Input, Modal, Select, Textarea, useToast } from "@/design-system";

import { technicianOptions } from "./work-orders-data";

type WorkOrdersData = {
  createWorkOrder: (request: CreateWorkOrderRequest) => Promise<WorkOrderDetail>;
  assignWorkOrder: (
    workOrderId: string,
    request: AssignWorkOrderRequest,
  ) => Promise<WorkOrderDetail>;
};

function generateWorkOrderId(): string {
  // crypto.randomUUID is available in every modern browser and Node 19+ (the
  // vitest/jsdom test runtime included) -- no extra dependency needed.
  return crypto.randomUUID();
}

export function CreateWorkOrderModal({
  assets,
  onClose,
  onCreated,
  open,
  workOrders,
}: {
  assets: readonly AssetListItem[];
  onClose: () => void;
  onCreated: () => void;
  open: boolean;
  workOrders: WorkOrdersData;
}) {
  const toast = useToast();
  const [assetId, setAssetId] = useState("");
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [priority, setPriority] = useState<"low" | "medium" | "high" | "critical">("medium");
  const [dueDate, setDueDate] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setAssetId(assets[0]?.id ?? "");
      setTitle("");
      setDescription("");
      setPriority("medium");
      setDueDate("");
      setError(null);
    }
  }, [assets, open]);

  async function handleSubmit(event: React.FormEvent) {
    event.preventDefault();
    if (!assetId) {
      setError("Choose an asset");
      return;
    }
    if (title.trim().length < 2) {
      setError("Enter a title");
      return;
    }
    setError(null);
    setSubmitting(true);
    try {
      await workOrders.createWorkOrder({
        id: generateWorkOrderId(),
        assetId,
        title: title.trim(),
        description: description.trim() || undefined,
        priority,
        dueDate: dueDate ? new Date(`${dueDate}T00:00:00Z`) : undefined,
      });
      toast.success("Work order created");
      onCreated();
      onClose();
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Modal onClose={onClose} open={open} title="Create work order">
      <form className="grid gap-4" noValidate onSubmit={handleSubmit}>
        <Select label="Asset" onChange={(event) => setAssetId(event.target.value)} value={assetId}>
          <option disabled value="">
            Choose an asset
          </option>
          {assets.map((asset) => (
            <option key={asset.id} value={asset.id}>
              {asset.name} ({asset.assetTag})
            </option>
          ))}
        </Select>
        <Input label="Title" onChange={(event) => setTitle(event.target.value)} value={title} />
        <Textarea
          label="Description"
          onChange={(event) => setDescription(event.target.value)}
          value={description}
        />
        <Select
          label="Priority"
          onChange={(event) =>
            setPriority(event.target.value as "low" | "medium" | "high" | "critical")
          }
          value={priority}
        >
          <option value="low">Low</option>
          <option value="medium">Medium</option>
          <option value="high">High</option>
          <option value="critical">Critical</option>
        </Select>
        <Input
          label="Due date"
          onChange={(event) => setDueDate(event.target.value)}
          type="date"
          value={dueDate}
        />
        {error && (
          <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
            {error}
          </p>
        )}
        <div className="mt-2 flex justify-end gap-2">
          <Button onClick={onClose} type="button" variant="ghost">
            Cancel
          </Button>
          <Button loading={submitting} type="submit">
            Create work order
          </Button>
        </div>
      </form>
    </Modal>
  );
}

export function AssignTechnicianModal({
  onAssigned,
  onClose,
  open,
  technicians,
  workOrder,
  workOrders,
}: {
  onAssigned: () => void;
  onClose: () => void;
  open: boolean;
  technicians: readonly UserListItem[];
  workOrder: WorkOrderDetail | null;
  workOrders: WorkOrdersData;
}) {
  const toast = useToast();
  const options = technicianOptions([...technicians]);
  const [technicianId, setTechnicianId] = useState("");
  const [dueDate, setDueDate] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setTechnicianId(workOrder?.technicianId ?? options[0]?.id ?? "");
      setDueDate(workOrder?.dueDate ? workOrder.dueDate.toISOString().slice(0, 10) : "");
      setError(null);
    }
    // options is derived fresh from `technicians` each render; only re-seed
    // when the modal opens or the work order being assigned changes.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, workOrder]);

  if (!workOrder) return null;

  async function handleSubmit(event: React.FormEvent) {
    event.preventDefault();
    if (!technicianId) {
      setError("Choose a technician");
      return;
    }
    setError(null);
    setSubmitting(true);
    try {
      await workOrders.assignWorkOrder(workOrder!.id, {
        technicianId,
        dueDate: dueDate ? new Date(`${dueDate}T00:00:00Z`) : undefined,
        expectedRevision: workOrder!.revision,
      });
      toast.success("Technician assigned");
      onAssigned();
      onClose();
    } catch (failure) {
      if (failure instanceof ApiClientError) setError(failure.message);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Modal onClose={onClose} open={open} title="Assign technician">
      <form className="grid gap-4" noValidate onSubmit={handleSubmit}>
        <Select
          label="Technician"
          onChange={(event) => setTechnicianId(event.target.value)}
          value={technicianId}
        >
          <option disabled value="">
            Choose a technician
          </option>
          {options.map((user) => (
            <option key={user.id} value={user.id}>
              {user.displayName}
            </option>
          ))}
        </Select>
        <Input
          label="Due date"
          onChange={(event) => setDueDate(event.target.value)}
          type="date"
          value={dueDate}
        />
        {error && (
          <p className="text-bodySmall text-statusStrong-critical dark:text-statusSoft-critical" role="alert">
            {error}
          </p>
        )}
        <div className="mt-2 flex justify-end gap-2">
          <Button onClick={onClose} type="button" variant="ghost">
            Cancel
          </Button>
          <Button loading={submitting} type="submit">
            Assign
          </Button>
        </div>
      </form>
    </Modal>
  );
}

"use client";

import type { ChecklistTemplateItemInput } from "@fev/api-client";
import { useRouter } from "next/navigation";
import { FormEvent, useEffect, useState } from "react";

import { useAuth } from "@/auth/auth-context";
import { Button, Card, Input, MotionSection, Select, useToast } from "@/design-system";

import { CHECKLIST_TEMPLATE_CATEGORIES } from "./checklist-templates-page";

const ITEM_TYPES: ChecklistTemplateItemInput["itemType"][] = [
  "boolean",
  "numeric",
  "text",
  "select",
];

type ItemDraft = {
  id?: string;
  label: string;
  itemType: ChecklistTemplateItemInput["itemType"];
  required: boolean;
  options: string;
  helpText: string;
};

const EMPTY_ITEM: ItemDraft = {
  label: "",
  itemType: "boolean",
  required: true,
  options: "",
  helpText: "",
};

function toItemInput(draft: ItemDraft): ChecklistTemplateItemInput {
  return {
    id: draft.id,
    label: draft.label.trim(),
    itemType: draft.itemType,
    required: draft.required,
    options:
      draft.itemType === "select"
        ? draft.options
            .split(",")
            .map((option) => option.trim())
            .filter(Boolean)
        : undefined,
    helpText: draft.helpText.trim() || undefined,
  };
}

export function ChecklistTemplateFormPage({ templateId }: { templateId?: string }) {
  const router = useRouter();
  const toast = useToast();
  const { apiClient } = useAuth();
  const [name, setName] = useState("");
  const [category, setCategory] = useState("Generic");
  const [description, setDescription] = useState("");
  const [items, setItems] = useState<ItemDraft[]>([{ ...EMPTY_ITEM }]);
  const [loading, setLoading] = useState(Boolean(templateId));
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (!templateId) return;
    apiClient
      .getChecklistTemplate(templateId)
      .then((template) => {
        setName(template.name);
        setCategory(template.category);
        setDescription(template.description ?? "");
        setItems(
          (template.items ?? []).map((item) => ({
            id: item.id,
            label: item.label,
            itemType: item.itemType,
            required: item.required,
            options: (item.options ?? []).join(", "),
            helpText: item.helpText ?? "",
          })),
        );
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, [apiClient, templateId]);

  function updateItem(index: number, patch: Partial<ItemDraft>) {
    setItems((current) =>
      current.map((item, itemIndex) => (itemIndex === index ? { ...item, ...patch } : item)),
    );
  }

  function addItem() {
    setItems((current) => [...current, { ...EMPTY_ITEM }]);
  }

  function removeItem(index: number) {
    setItems((current) => current.filter((_, itemIndex) => itemIndex !== index));
  }

  function validate() {
    const next: Record<string, string> = {};
    if (name.trim().length < 2) next.name = "Enter at least 2 characters";
    if (items.length === 0) next.items = "Add at least one checklist item";
    items.forEach((item, index) => {
      if (!item.label.trim()) next[`item-${index}`] = "Label is required";
      if (item.itemType === "select" && !item.options.trim()) {
        next[`item-${index}-options`] = "Select items need at least one option";
      }
    });
    setErrors(next);
    return Object.keys(next).length === 0;
  }

  async function submit(event: FormEvent) {
    event.preventDefault();
    if (!validate()) return;
    setSaving(true);
    const payload = {
      name: name.trim(),
      category,
      description: description.trim() || undefined,
      items: items.map(toItemInput),
    };
    try {
      const template = templateId
        ? await apiClient.updateChecklistTemplate(templateId, payload)
        : await apiClient.createChecklistTemplate(payload);
      toast.success(templateId ? "Template updated" : "Template created");
      router.push(`/checklist-templates/${template.id}`);
    } finally {
      setSaving(false);
    }
  }

  async function remove() {
    if (!templateId || !window.confirm("Delete this checklist template?")) return;
    await apiClient.deleteChecklistTemplate(templateId);
    toast.success("Template deleted");
    router.push("/checklist-templates");
  }

  if (loading) return <section className="p-10">Loading template…</section>;

  return (
    <section className="p-6 md:p-10">
      <MotionSection className="mx-auto max-w-4xl">
        <p className="font-mono text-caption uppercase tracking-[0.22em] text-primary-600 dark:text-primary-400">
          Checklist templates
        </p>
        <h1 className="mt-2 text-h2 font-bold">
          {templateId ? "Edit template" : "Create template"}
        </h1>
        <form className="mt-6 grid gap-4" onSubmit={submit}>
          <Card className="grid gap-4 p-5 md:grid-cols-2">
            <h2 className="text-h4 font-semibold md:col-span-2">Identity</h2>
            <Input
              error={errors.name}
              label="Name"
              onChange={(event) => setName(event.target.value)}
              required
              value={name}
            />
            <Select
              label="Category"
              onChange={(event) => setCategory(event.target.value)}
              value={category}
            >
              {CHECKLIST_TEMPLATE_CATEGORIES.map((option) => (
                <option key={option} value={option}>
                  {option}
                </option>
              ))}
            </Select>
            <Input
              className="md:col-span-2"
              label="Description (optional)"
              onChange={(event) => setDescription(event.target.value)}
              value={description}
            />
          </Card>

          <Card className="grid gap-4 p-5">
            <div className="flex items-center justify-between">
              <h2 className="text-h4 font-semibold">Checklist items</h2>
              <Button onClick={addItem} type="button" variant="ghost">
                Add item
              </Button>
            </div>
            {errors.items && (
              <p className="text-caption text-statusStrong-critical dark:text-statusSoft-critical">
                {errors.items}
              </p>
            )}
            <div className="grid gap-4">
              {items.map((item, index) => (
                <div
                  className="grid gap-3 rounded-md border border-border p-4 md:grid-cols-2"
                  key={index}
                >
                  <Input
                    error={errors[`item-${index}`]}
                    label="Label"
                    onChange={(event) => updateItem(index, { label: event.target.value })}
                    value={item.label}
                  />
                  <Select
                    label="Type"
                    onChange={(event) =>
                      updateItem(index, {
                        itemType: event.target.value as ChecklistTemplateItemInput["itemType"],
                      })
                    }
                    value={item.itemType}
                  >
                    {ITEM_TYPES.map((type) => (
                      <option key={type} value={type}>
                        {type}
                      </option>
                    ))}
                  </Select>
                  {item.itemType === "select" && (
                    <Input
                      className="md:col-span-2"
                      error={errors[`item-${index}-options`]}
                      hint="Comma-separated"
                      label="Options"
                      onChange={(event) => updateItem(index, { options: event.target.value })}
                      value={item.options}
                    />
                  )}
                  <Input
                    label="Help text (optional)"
                    onChange={(event) => updateItem(index, { helpText: event.target.value })}
                    value={item.helpText}
                  />
                  <label className="flex items-center gap-2 self-end pb-2 text-bodySmall">
                    <input
                      checked={item.required}
                      onChange={(event) => updateItem(index, { required: event.target.checked })}
                      type="checkbox"
                    />
                    Required
                  </label>
                  <div className="md:col-span-2">
                    <Button
                      disabled={items.length === 1}
                      onClick={() => removeItem(index)}
                      type="button"
                      variant="ghost"
                    >
                      Remove item
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          </Card>

          <div className="flex justify-between gap-3">
            <div>
              {templateId && (
                <Button onClick={() => void remove()} type="button" variant="ghost">
                  Delete template
                </Button>
              )}
            </div>
            <div className="flex gap-3">
              <Button onClick={() => router.back()} type="button" variant="ghost">
                Cancel
              </Button>
              <Button loading={saving} type="submit">
                {templateId ? "Save changes" : "Create template"}
              </Button>
            </div>
          </div>
        </form>
      </MotionSection>
    </section>
  );
}

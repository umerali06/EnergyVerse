"use client";

import { motion, useReducedMotion } from "framer-motion";
import { useState } from "react";

import {
  Badge,
  Button,
  Card,
  EmptyState,
  Input,
  listItem,
  listStagger,
  Modal,
  MotionSection,
  Select,
  Skeleton,
  Spinner,
  StatusPill,
  TableShell,
  Tabs,
  Textarea,
  ThemeSwitch,
  Tooltip,
  useToast,
} from "@/design-system";

const Section = ({ children, title }: { children: React.ReactNode; title: string }) => (
  <MotionSection className="grid gap-4">
    <h2 className="text-h3 font-bold">{title}</h2>
    <Card>{children}</Card>
  </MotionSection>
);

export function DesignSystemShowcase() {
  const [modalOpen, setModalOpen] = useState(false);
  const { showToast } = useToast();
  const reduced = useReducedMotion();

  return (
    <main className="min-h-screen bg-background px-4 py-8 text-text-primary md:px-8">
      <div className="mx-auto grid max-w-6xl gap-8">
        <header className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <Badge>DEV-ONLY SHOWCASE</Badge>
            <h1 className="mt-3 text-display font-bold tracking-tight">FEV Design System</h1>
            <p className="mt-2 max-w-2xl text-bodyLarge text-text-secondary">
              Industrial energy primitives, shared tokens, accessible states, and
              reduced-motion-aware interaction.
            </p>
            <code className="mt-3 block font-mono text-bodySmall text-accent-400">
              ASSET-OG-1042 · WO-2026-0088
            </code>
          </div>
          <ThemeSwitch />
        </header>

        <Section title="Color and status">
          <div className="flex flex-wrap gap-3">
            <StatusPill tone="healthy">Healthy</StatusPill>
            <StatusPill tone="warning">Warning</StatusPill>
            <StatusPill tone="critical">Critical</StatusPill>
            <StatusPill tone="info">Info</StatusPill>
            <Badge>Inspection due</Badge>
          </div>
        </Section>

        <Section title="Buttons">
          <div className="flex flex-wrap items-center gap-3">
            <Button>Primary</Button>
            <Button variant="accent">Accent</Button>
            <Button variant="ghost">Ghost</Button>
            <Button variant="danger">Danger</Button>
            <Button loading>Saving</Button>
            <Button disabled>Disabled</Button>
          </div>
        </Section>

        <Section title="Form controls">
          <div className="grid gap-4 md:grid-cols-2">
            <Input
              hint="Use the facility naming convention"
              label="Asset name"
              placeholder="Separator A-12"
            />
            <Input error="Asset tag is required" label="Asset tag" placeholder="ASSET-0000" />
            <Select defaultValue="operational" label="Status">
              <option value="operational">Operational</option>
              <option value="maintenance">Maintenance</option>
            </Select>
            <Textarea label="Inspector notes" placeholder="Record field observations…" />
          </div>
        </Section>

        <Section title="Table shell">
          <TableShell label="Example assets">
            <thead className="bg-elevated text-caption uppercase text-text-muted">
              <tr>
                <th className="px-4 py-3">Asset</th>
                <th className="px-4 py-3">Status</th>
                <th className="px-4 py-3">Tag</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              <tr>
                <td className="px-4 py-3 font-semibold">Gas Separator</td>
                <td className="px-4 py-3">
                  <StatusPill tone="healthy">Healthy</StatusPill>
                </td>
                <td className="px-4 py-3 font-mono text-text-muted">SEP-A12</td>
              </tr>
            </tbody>
          </TableShell>
        </Section>

        <Section title="Feedback and overlays">
          <div className="flex flex-wrap gap-3">
            <Button onClick={() => setModalOpen(true)} variant="ghost">
              Open modal
            </Button>
            <Button onClick={() => showToast("Inspection draft saved", "healthy")} variant="accent">
              Show toast
            </Button>
            <Tooltip content="Verified against the current role matrix">
              <span className="rounded-md border border-dashed px-3 py-2 text-body">
                Focus or hover tooltip
              </span>
            </Tooltip>
          </div>
          <Modal
            onClose={() => setModalOpen(false)}
            open={modalOpen}
            title="Confirm industrial action"
          >
            <p>This dialog uses shared elevation, radius, focus, and motion tokens.</p>
            <div className="mt-5 flex justify-end gap-2">
              <Button onClick={() => setModalOpen(false)} variant="ghost">
                Cancel
              </Button>
              <Button onClick={() => setModalOpen(false)}>Confirm</Button>
            </div>
          </Modal>
        </Section>

        <Section title="Tabs, loading, and empty state">
          <Tabs
            items={[
              { id: "overview", label: "Overview", content: "Shared operational overview." },
              { id: "history", label: "History", content: "Audit-ready history state." },
            ]}
          />
          <div className="mt-6 grid gap-4 md:grid-cols-2">
            <div className="grid gap-3 rounded-lg bg-elevated p-4">
              <Skeleton className="h-5 w-2/3" />
              <Skeleton className="h-4 w-full" />
              <Skeleton className="h-4 w-4/5" />
              <Spinner label="Loading asset data" />
            </div>
            <EmptyState
              action={<Button variant="ghost">Clear filters</Button>}
              description="Adjust the current filters or create a record in a later feature phase."
              title="No matching records"
            />
          </div>
        </Section>

        <Section title="Motion specification">
          <p className="mb-4 text-body text-text-muted">
            Fade-slide, stagger, modal, hover/press, and shimmer all disable when reduced motion is
            requested.
          </p>
          <motion.div
            animate="visible"
            className="grid gap-3 sm:grid-cols-3"
            initial={reduced ? false : "hidden"}
            variants={listStagger}
          >
            {["Inspect", "Confirm", "Audit"].map((label) => (
              <motion.div
                className="rounded-lg border bg-elevated p-4 font-semibold"
                key={label}
                variants={listItem}
              >
                {label}
              </motion.div>
            ))}
          </motion.div>
        </Section>
      </div>
    </main>
  );
}

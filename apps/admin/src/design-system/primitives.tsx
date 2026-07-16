"use client";

import { AnimatePresence, motion, useReducedMotion, type HTMLMotionProps } from "framer-motion";
import { type HTMLAttributes, type ReactNode, useEffect, useId, useState } from "react";

import { motionSpec } from "./motion";

export const cn = (...classes: Array<string | false | null | undefined>) =>
  classes.filter(Boolean).join(" ");

export type ButtonVariant = "primary" | "accent" | "ghost" | "danger";

const buttonVariants: Record<ButtonVariant, string> = {
  primary: "bg-primary-500 text-white hover:bg-primary-600 shadow-glow",
  accent: "bg-accent-500 text-white hover:bg-accent-600",
  ghost: "border border-border bg-transparent text-text-primary hover:bg-elevated",
  danger: "bg-status-critical text-white hover:brightness-110",
};

export function Button({
  children,
  className,
  disabled,
  loading = false,
  variant = "primary",
  type = "button",
  ...props
}: HTMLMotionProps<"button"> & {
  loading?: boolean;
  variant?: ButtonVariant;
}) {
  const reduced = useReducedMotion();
  return (
    <motion.button
      className={cn(
        "inline-flex min-h-11 items-center justify-center gap-2 rounded-lg px-4 py-2 text-body font-semibold transition-colors disabled:cursor-not-allowed disabled:opacity-50",
        buttonVariants[variant],
        className,
      )}
      disabled={disabled || loading}
      whileHover={reduced || disabled ? undefined : { y: -1 }}
      whileTap={reduced || disabled ? undefined : { scale: 0.97 }}
      transition={{ duration: motionSpec.fast }}
      type={type}
      {...props}
    >
      {loading ? <Spinner label="Loading" size="sm" /> : children}
    </motion.button>
  );
}

type FieldProps = {
  error?: string;
  hint?: string;
  label: string;
};

function FieldFrame({
  children,
  error,
  hint,
  id,
  label,
}: FieldProps & { children: ReactNode; id: string }) {
  const descriptionId = `${id}-description`;
  return (
    <div className="grid gap-2 text-body font-medium text-text-secondary">
      <label htmlFor={id}>{label}</label>
      {children}
      {(error || hint) && (
        <span
          className={cn("text-bodySmall", error ? "text-status-critical" : "text-text-muted")}
          id={descriptionId}
        >
          {error ?? hint}
        </span>
      )}
    </div>
  );
}

const fieldClass =
  "min-h-11 w-full rounded-lg border border-border bg-background px-3 py-2 text-body text-text-primary placeholder:text-text-muted transition-colors hover:border-primary-400 focus:border-primary-400 focus:outline-none disabled:cursor-not-allowed disabled:opacity-50";

export function Input({
  error,
  hint,
  id: suppliedId,
  label,
  ...props
}: React.InputHTMLAttributes<HTMLInputElement> & FieldProps) {
  const generatedId = useId();
  const id = suppliedId ?? generatedId;
  return (
    <FieldFrame error={error} hint={hint} id={id} label={label}>
      <input
        aria-describedby={error || hint ? `${id}-description` : undefined}
        aria-invalid={Boolean(error)}
        className={fieldClass}
        id={id}
        {...props}
      />
    </FieldFrame>
  );
}

export function Select({
  children,
  error,
  hint,
  id: suppliedId,
  label,
  ...props
}: React.SelectHTMLAttributes<HTMLSelectElement> & FieldProps) {
  const generatedId = useId();
  const id = suppliedId ?? generatedId;
  return (
    <FieldFrame error={error} hint={hint} id={id} label={label}>
      <select
        aria-describedby={error || hint ? `${id}-description` : undefined}
        aria-invalid={Boolean(error)}
        className={fieldClass}
        id={id}
        {...props}
      >
        {children}
      </select>
    </FieldFrame>
  );
}

export function Textarea({
  error,
  hint,
  id: suppliedId,
  label,
  ...props
}: React.TextareaHTMLAttributes<HTMLTextAreaElement> & FieldProps) {
  const generatedId = useId();
  const id = suppliedId ?? generatedId;
  return (
    <FieldFrame error={error} hint={hint} id={id} label={label}>
      <textarea
        aria-describedby={error || hint ? `${id}-description` : undefined}
        aria-invalid={Boolean(error)}
        className={cn(fieldClass, "min-h-28 resize-y")}
        id={id}
        {...props}
      />
    </FieldFrame>
  );
}

export function Card({ className, ...props }: HTMLAttributes<HTMLElement>) {
  return (
    <section
      className={cn("rounded-xl border border-border bg-surface p-6 shadow-md", className)}
      {...props}
    />
  );
}

export function Badge({ className, ...props }: HTMLAttributes<HTMLSpanElement>) {
  return (
    <span
      className={cn(
        "inline-flex rounded-full bg-elevated px-3 py-1 text-caption font-semibold text-text-secondary",
        className,
      )}
      {...props}
    />
  );
}

export type StatusTone = "healthy" | "warning" | "critical" | "info";
const statusStyles: Record<StatusTone, string> = {
  healthy: "bg-status-success/15 text-status-success",
  warning: "bg-status-warning/15 text-status-warning",
  critical: "bg-status-critical/15 text-status-critical",
  info: "bg-status-info/15 text-primary-400",
};

export function StatusPill({ children, tone }: { children: ReactNode; tone: StatusTone }) {
  return (
    <span
      className={cn(
        "inline-flex items-center gap-2 rounded-full px-3 py-1 text-caption font-bold uppercase tracking-wide",
        statusStyles[tone],
      )}
    >
      <span aria-hidden className="size-2 rounded-full bg-current" />
      {children}
    </span>
  );
}

export function TableShell({ children, label }: { children: ReactNode; label: string }) {
  return (
    <div className="overflow-x-auto rounded-xl border border-border">
      <table aria-label={label} className="w-full border-collapse text-left text-body">
        {children}
      </table>
    </div>
  );
}

export function Modal({
  children,
  onClose,
  open,
  title,
}: {
  children: ReactNode;
  onClose: () => void;
  open: boolean;
  title: string;
}) {
  const titleId = useId();
  const reduced = useReducedMotion();
  useEffect(() => {
    if (!open) return;
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") onClose();
    };
    window.addEventListener("keydown", closeOnEscape);
    return () => window.removeEventListener("keydown", closeOnEscape);
  }, [onClose, open]);

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          animate={{ opacity: 1 }}
          className="fixed inset-0 z-modal grid place-items-center bg-black/70 p-4"
          exit={{ opacity: 0 }}
          initial={reduced ? false : { opacity: 0 }}
          onMouseDown={onClose}
          transition={{ duration: reduced ? 0 : motionSpec.normal }}
        >
          <motion.div
            aria-labelledby={titleId}
            aria-modal="true"
            animate={{ opacity: 1, scale: 1, y: 0 }}
            className="w-full max-w-lg rounded-2xl border border-border bg-surface p-6 shadow-lg"
            exit={{ opacity: 0, scale: reduced ? 1 : 0.98, y: reduced ? 0 : 8 }}
            initial={reduced ? false : { opacity: 0, scale: 0.97, y: 14 }}
            onMouseDown={(event) => event.stopPropagation()}
            role="dialog"
            transition={{ duration: reduced ? 0 : motionSpec.normal }}
          >
            <div className="flex items-start justify-between gap-4">
              <h2 className="text-h4 font-bold" id={titleId}>
                {title}
              </h2>
              <button aria-label="Close dialog" onClick={onClose} type="button">
                ×
              </button>
            </div>
            <div className="mt-4 text-text-secondary">{children}</div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}

export type TabItem = { id: string; label: string; content: ReactNode };

export function Tabs({ items }: { items: readonly TabItem[] }) {
  const [active, setActive] = useState(items[0]?.id ?? "");
  const activeItem = items.find((item) => item.id === active);
  return (
    <div>
      <div aria-label="Design system tabs" className="flex gap-1 border-b" role="tablist">
        {items.map((item) => (
          <button
            aria-controls={`panel-${item.id}`}
            aria-selected={item.id === active}
            className={cn(
              "min-h-11 border-b-2 px-4 text-body font-semibold",
              item.id === active
                ? "border-primary-500 text-primary-400"
                : "border-transparent text-text-muted hover:text-text-primary",
            )}
            id={`tab-${item.id}`}
            key={item.id}
            onClick={() => setActive(item.id)}
            role="tab"
            type="button"
          >
            {item.label}
          </button>
        ))}
      </div>
      {activeItem && (
        <div
          aria-labelledby={`tab-${activeItem.id}`}
          className="p-4 text-text-secondary"
          id={`panel-${activeItem.id}`}
          role="tabpanel"
        >
          {activeItem.content}
        </div>
      )}
    </div>
  );
}

export function Tooltip({ children, content }: { children: ReactNode; content: string }) {
  const [visible, setVisible] = useState(false);
  const tooltipId = useId();
  return (
    <span
      aria-describedby={visible ? tooltipId : undefined}
      className="relative inline-flex"
      onBlur={() => setVisible(false)}
      onFocus={() => setVisible(true)}
      onMouseEnter={() => setVisible(true)}
      onMouseLeave={() => setVisible(false)}
      tabIndex={0}
    >
      {children}
      {visible && (
        <span
          className="absolute bottom-full left-1/2 z-tooltip mb-2 w-max -translate-x-1/2 rounded-md bg-text-primary px-2 py-1 text-caption text-background shadow-md"
          id={tooltipId}
          role="tooltip"
        >
          {content}
        </span>
      )}
    </span>
  );
}

export function Skeleton({ className }: { className?: string }) {
  return (
    <span
      aria-hidden="true"
      className={cn(
        "block animate-shimmer rounded-md bg-[linear-gradient(90deg,var(--color-elevated)_25%,var(--color-border)_50%,var(--color-elevated)_75%)] bg-[length:200%_100%]",
        className,
      )}
    />
  );
}

export function Spinner({
  label = "Loading",
  size = "md",
}: {
  label?: string;
  size?: "sm" | "md";
}) {
  return (
    <span className="inline-flex items-center gap-2" role="status">
      <span
        aria-hidden="true"
        className={cn(
          "animate-spin rounded-full border-2 border-current border-r-transparent",
          size === "sm" ? "size-4" : "size-6",
        )}
      />
      <span className="sr-only">{label}</span>
    </span>
  );
}

export function EmptyState({
  action,
  description,
  title,
}: {
  action?: ReactNode;
  description: string;
  title: string;
}) {
  return (
    <div className="grid place-items-center rounded-xl border border-dashed border-border p-8 text-center">
      <span aria-hidden className="mb-3 text-h2 text-primary-400">
        ◇
      </span>
      <h3 className="text-h5 font-bold">{title}</h3>
      <p className="mt-2 max-w-sm text-body text-text-muted">{description}</p>
      {action && <div className="mt-4">{action}</div>}
    </div>
  );
}

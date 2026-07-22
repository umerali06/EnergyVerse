"use client";

import { AnimatePresence, motion, useReducedMotion, type HTMLMotionProps } from "framer-motion";
import { type HTMLAttributes, type ReactNode, useEffect, useId, useRef, useState } from "react";

import { motionSpec } from "./motion";

export const cn = (...classes: Array<string | false | null | undefined>) =>
  classes.filter(Boolean).join(" ");

export type ButtonVariant = "primary" | "accent" | "ghost" | "danger";

const buttonVariants: Record<ButtonVariant, string> = {
  primary: "bg-primary-800 text-white hover:bg-primary-700 dark:bg-primary-400 dark:text-primary-900 dark:hover:bg-primary-300",
  accent: "bg-accent-500 text-accent-ink hover:bg-accent-400",
  ghost: "border border-border bg-transparent text-text-primary hover:border-primary-400/60 hover:bg-elevated",
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
      aria-label={loading && typeof children === "string" ? `${children}, loading` : undefined}
      className={cn(
        "inline-flex min-h-9 items-center justify-center gap-2 rounded-md px-3.5 py-1.5 text-bodySmall font-semibold transition-colors disabled:cursor-not-allowed disabled:opacity-50",
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
    <div className="grid gap-1.5 text-bodySmall font-medium text-text-secondary">
      <label htmlFor={id}>{label}</label>
      {children}
      {(error || hint) && (
        <span
          className={cn("text-bodySmall", error ? "text-statusStrong-critical dark:text-statusSoft-critical" : "text-text-muted")}
          id={descriptionId}
        >
          {error ?? hint}
        </span>
      )}
    </div>
  );
}

const fieldClass =
  "min-h-9 w-full rounded-md border border-border bg-background px-3 py-1.5 text-body text-text-primary placeholder:text-text-muted transition-colors hover:border-primary-400 focus:border-primary-400 focus:outline-none disabled:cursor-not-allowed disabled:opacity-50";

export function Input({
  endAdornment,
  error,
  hint,
  id: suppliedId,
  label,
  ...props
}: React.InputHTMLAttributes<HTMLInputElement> & FieldProps & { endAdornment?: ReactNode }) {
  const generatedId = useId();
  const id = suppliedId ?? generatedId;
  return (
    <FieldFrame error={error} hint={hint} id={id} label={label}>
      <div className="relative">
        <input
          aria-describedby={error || hint ? `${id}-description` : undefined}
          aria-invalid={Boolean(error)}
          className={cn(fieldClass, Boolean(endAdornment) && "pr-20")}
          id={id}
          {...props}
        />
        {endAdornment && (
          <span className="absolute inset-y-0 right-2 grid place-items-center">{endAdornment}</span>
        )}
      </div>
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

export function Checkbox({
  checked,
  className,
  disabled,
  hint,
  id: suppliedId,
  indeterminate = false,
  label,
  onChange,
}: {
  checked: boolean;
  className?: string;
  disabled?: boolean;
  hint?: string;
  id?: string;
  indeterminate?: boolean;
  label: ReactNode;
  onChange: (checked: boolean) => void;
}) {
  const generatedId = useId();
  const id = suppliedId ?? generatedId;
  const ref = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (ref.current) ref.current.indeterminate = indeterminate && !checked;
  }, [indeterminate, checked]);

  return (
    <div className={cn("flex items-start gap-2.5", className)}>
      <input
        checked={checked}
        className="mt-0.5 size-4 shrink-0 cursor-pointer rounded border-border text-primary-600 accent-primary-600 disabled:cursor-not-allowed disabled:opacity-50 dark:accent-primary-400"
        disabled={disabled}
        id={id}
        onChange={(event) => onChange(event.target.checked)}
        ref={ref}
        type="checkbox"
      />
      <label className="grid text-bodySmall text-text-primary" htmlFor={id}>
        <span className={cn("font-medium", disabled && "opacity-50")}>{label}</span>
        {hint && <span className="text-caption text-text-muted">{hint}</span>}
      </label>
    </div>
  );
}

export function Card({ className, ...props }: HTMLAttributes<HTMLElement>) {
  return (
    <section
      className={cn("rounded-lg border border-border bg-surface p-4 md:p-5", className)}
      {...props}
    />
  );
}

export function Badge({ className, ...props }: HTMLAttributes<HTMLSpanElement>) {
  return (
    <span
      className={cn(
        "inline-flex rounded-sm border border-border bg-elevated px-2 py-0.5 font-mono text-caption text-text-secondary",
        className,
      )}
      {...props}
    />
  );
}

export function FilterChip({
  children,
  onDismiss,
}: {
  children: ReactNode;
  onDismiss: () => void;
}) {
  return (
    <span className="inline-flex items-center gap-1.5 rounded-full border border-border bg-elevated py-0.5 pl-2.5 pr-1 font-mono text-caption text-text-secondary">
      {children}
      <button
        aria-label="Remove filter"
        className="grid size-4 place-items-center rounded-full text-text-muted hover:bg-border/60 hover:text-text-primary"
        onClick={onDismiss}
        type="button"
      >
        <svg aria-hidden className="size-3" fill="none" stroke="currentColor" strokeLinecap="round" strokeWidth="2" viewBox="0 0 24 24">
          <path d="M6 6l12 12M18 6L6 18" />
        </svg>
      </button>
    </span>
  );
}

export type StatusTone = "healthy" | "warning" | "critical" | "info";
const statusStyles: Record<StatusTone, string> = {
  healthy: "bg-status-success/15 text-status-successDeep dark:text-status-success",
  warning: "bg-status-warning/15 text-status-warningDeep dark:text-status-warning",
  critical: "bg-status-critical/15 text-status-criticalDeep dark:text-status-criticalBright",
  info: "bg-status-info/15 text-status-infoDeep dark:text-primary-400",
};

export function StatusPill({ children, tone }: { children: ReactNode; tone: StatusTone }) {
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1.5 rounded-sm border border-current/25 px-2 py-0.5 font-mono text-micro font-semibold uppercase tracking-[0.14em]",
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
            className="w-full max-w-lg rounded-xl border border-border bg-surface p-5 shadow-lg"
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
              "min-h-9 border-b-2 px-3 text-bodySmall font-semibold",
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

export function Skeleton({
  className,
  style,
}: {
  className?: string;
  style?: React.CSSProperties;
}) {
  return (
    <span
      aria-hidden="true"
      className={cn(
        "block animate-shimmer rounded-md bg-[linear-gradient(90deg,var(--color-elevated)_25%,var(--color-border)_50%,var(--color-elevated)_75%)] bg-[length:200%_100%]",
        className,
      )}
      style={style}
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
    <div className="grid place-items-center rounded-lg border border-dashed border-border p-6 text-center">
      <span aria-hidden className="mb-3 font-mono text-micro uppercase tracking-[0.2em] text-text-muted">
        no data
      </span>
      <h3 className="text-h5 font-bold">{title}</h3>
      <p className="mt-2 max-w-sm text-body text-text-muted">{description}</p>
      {action && <div className="mt-4">{action}</div>}
    </div>
  );
}

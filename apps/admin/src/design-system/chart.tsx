"use client";

import { useEffect, useId, useRef, useState, type ReactNode } from "react";
import {
  Area,
  AreaChart,
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip as RechartsTooltip,
  XAxis,
  YAxis,
} from "recharts";
import type { TooltipContentProps } from "recharts";

import { designTokens } from "./tokens.generated";
import { EmptyState, Skeleton } from "./primitives";
import { useReducedMotionPreference } from "./motion";

/**
 * Chart color/typography/motion contract for every future chart in the app.
 * Never pass raw hex to a chart — resolve through this so a token change
 * (2.1c brand palette) repaints every chart automatically. Values are read
 * live from CSS custom properties so light/dark switches without a rebuild.
 */
export function useChartTheme() {
  const [colors, setColors] = useState(() => readChartColors());
  useEffect(() => {
    const update = () => setColors(readChartColors());
    update();
    const observer = new MutationObserver(update);
    observer.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["data-theme", "class"],
    });
    return () => observer.disconnect();
  }, []);
  return colors;
}

function readChartColors() {
  if (typeof window === "undefined") {
    return fallbackChartColors();
  }
  const style = getComputedStyle(document.documentElement);
  const read = (name: string, fallback: string) => style.getPropertyValue(name).trim() || fallback;
  return {
    series: [
      read("--color-primary-400", designTokens.color.primary["400"]),
      read("--color-accent-500", designTokens.color.accent["500"]),
      read("--color-status-success", designTokens.color.status.success),
      read("--color-status-info", designTokens.color.status.info),
    ],
    grid: read("--color-border", designTokens.color.theme.dark.border),
    axis: read("--color-text-muted", designTokens.color.theme.dark.textMuted),
    tooltipBg: read("--color-elevated", designTokens.color.theme.dark.elevated),
    tooltipBorder: read("--color-border", designTokens.color.theme.dark.border),
    tooltipText: read("--color-text-primary", designTokens.color.theme.dark.textPrimary),
  };
}

function fallbackChartColors() {
  const dark = designTokens.color.theme.dark;
  return {
    series: [
      designTokens.color.primary["400"],
      designTokens.color.accent["500"],
      designTokens.color.status.success,
      designTokens.color.status.info,
    ],
    grid: dark.border,
    axis: dark.textMuted,
    tooltipBg: dark.elevated,
    tooltipBorder: dark.border,
    tooltipText: dark.textPrimary,
  };
}

/** Chart durations stay inside the 2.1c motion policy (≤240ms) and are
 * skipped entirely under prefers-reduced-motion — an entry animation is
 * exactly the "decorative" case the motion ADR asks charts to avoid. */
function useChartAnimationDuration(): number {
  const reduced = useReducedMotionPreference();
  return reduced ? 0 : designTokens.motion.duration.normal;
}

function ChartTooltip({
  active,
  payload,
  label,
  valueLabel,
}: TooltipContentProps & { valueLabel?: string }) {
  const theme = useChartTheme();
  if (!active || !payload?.length) return null;
  return (
    <div
      className="rounded-md border px-3 py-2 font-mono text-caption shadow-lg"
      style={{
        background: theme.tooltipBg,
        borderColor: theme.tooltipBorder,
        color: theme.tooltipText,
      }}
    >
      <p className="mb-1 text-text-muted">{label}</p>
      {payload.map((entry) => (
        <p key={String(entry.dataKey)}>
          {valueLabel ?? entry.name}: <span className="font-semibold">{String(entry.value)}</span>
        </p>
      ))}
    </div>
  );
}

export type ChartStatus = "loading" | "error" | "empty" | "ready";

function ChartFrame({
  status,
  height,
  emptyTitle,
  emptyDescription,
  errorDescription,
  onRetry,
  children,
}: {
  status: ChartStatus;
  height: number;
  emptyTitle: string;
  emptyDescription: string;
  errorDescription: string;
  onRetry?: () => void;
  children: ReactNode;
}) {
  if (status === "loading") {
    return <Skeleton className="w-full" style={{ height }} />;
  }
  if (status === "error") {
    return (
      <div style={{ height }}>
        <EmptyState
          action={
            onRetry ? (
              <button
                className="rounded-md border border-border px-3 py-1.5 text-bodySmall font-semibold text-text-secondary hover:bg-elevated"
                onClick={onRetry}
                type="button"
              >
                Retry
              </button>
            ) : undefined
          }
          description={errorDescription}
          title="Couldn't load this chart"
        />
      </div>
    );
  }
  if (status === "empty") {
    return (
      <div style={{ height }}>
        <EmptyState description={emptyDescription} title={emptyTitle} />
      </div>
    );
  }
  return <div style={{ height }}>{children}</div>;
}

export type SeriesPoint = { label: string; value: number };

/** Line/area chart for a single time series (e.g. dashboard activity/day). */
export function TimeSeriesChart({
  data,
  status,
  height = 280,
  valueLabel = "Events",
  emptyTitle = "No activity yet",
  emptyDescription = "Data will appear here once events are recorded.",
  errorDescription = "The chart data couldn't be loaded. Check your connection and try again.",
  onRetry,
}: {
  data: SeriesPoint[];
  status: ChartStatus;
  height?: number;
  valueLabel?: string;
  emptyTitle?: string;
  emptyDescription?: string;
  errorDescription?: string;
  onRetry?: () => void;
}) {
  const theme = useChartTheme();
  const duration = useChartAnimationDuration();
  const gradientId = useId().replace(/:/g, "");
  return (
    <ChartFrame
      emptyDescription={emptyDescription}
      emptyTitle={emptyTitle}
      errorDescription={errorDescription}
      height={height}
      onRetry={onRetry}
      status={status}
    >
      <ResponsiveContainer height="100%" width="100%">
        <AreaChart data={data} margin={{ top: 8, right: 8, bottom: 0, left: 0 }}>
          <defs>
            <linearGradient id={gradientId} x1="0" x2="0" y1="0" y2="1">
              <stop offset="0%" stopColor={theme.series[0]} stopOpacity={0.35} />
              <stop offset="100%" stopColor={theme.series[0]} stopOpacity={0} />
            </linearGradient>
          </defs>
          <CartesianGrid stroke={theme.grid} strokeDasharray="3 3" vertical={false} />
          <XAxis
            axisLine={{ stroke: theme.grid }}
            dataKey="label"
            fontFamily={designTokens.typography.fontFamily.mono}
            fontSize={designTokens.typography.fontSize.caption}
            stroke={theme.axis}
            tickLine={false}
          />
          <YAxis
            allowDecimals={false}
            axisLine={false}
            fontFamily={designTokens.typography.fontFamily.mono}
            fontSize={designTokens.typography.fontSize.caption}
            stroke={theme.axis}
            tickLine={false}
            width={32}
          />
          <RechartsTooltip content={(props) => <ChartTooltip {...props} valueLabel={valueLabel} />} />
          <Area
            animationDuration={duration}
            dataKey="value"
            fill={`url(#${gradientId})`}
            fillOpacity={1}
            isAnimationActive={duration > 0}
            stroke={theme.series[0]}
            strokeWidth={2}
            type="monotone"
          />
        </AreaChart>
      </ResponsiveContainer>
    </ChartFrame>
  );
}

export type BarPoint = { label: string; value: number };

/** Categorical bar chart for future modules (e.g. counts by role/status). */
export function CategoryBarChart({
  data,
  status,
  height = 280,
  valueLabel = "Count",
  emptyTitle = "No data yet",
  emptyDescription = "Data will appear here once it's available.",
  errorDescription = "The chart data couldn't be loaded. Check your connection and try again.",
  onRetry,
}: {
  data: BarPoint[];
  status: ChartStatus;
  height?: number;
  valueLabel?: string;
  emptyTitle?: string;
  emptyDescription?: string;
  errorDescription?: string;
  onRetry?: () => void;
}) {
  const theme = useChartTheme();
  const duration = useChartAnimationDuration();
  return (
    <ChartFrame
      emptyDescription={emptyDescription}
      emptyTitle={emptyTitle}
      errorDescription={errorDescription}
      height={height}
      onRetry={onRetry}
      status={status}
    >
      <ResponsiveContainer height="100%" width="100%">
        <BarChart data={data} margin={{ top: 8, right: 8, bottom: 0, left: 0 }}>
          <CartesianGrid stroke={theme.grid} strokeDasharray="3 3" vertical={false} />
          <XAxis
            axisLine={{ stroke: theme.grid }}
            dataKey="label"
            fontFamily={designTokens.typography.fontFamily.mono}
            fontSize={designTokens.typography.fontSize.caption}
            stroke={theme.axis}
            tickLine={false}
          />
          <YAxis
            allowDecimals={false}
            axisLine={false}
            fontFamily={designTokens.typography.fontFamily.mono}
            fontSize={designTokens.typography.fontSize.caption}
            stroke={theme.axis}
            tickLine={false}
            width={32}
          />
          <RechartsTooltip content={(props) => <ChartTooltip {...props} valueLabel={valueLabel} />} />
          <Bar
            animationDuration={duration}
            dataKey="value"
            fill={theme.series[0]}
            isAnimationActive={duration > 0}
            radius={[3, 3, 0, 0]}
          />
        </BarChart>
      </ResponsiveContainer>
    </ChartFrame>
  );
}

export type DonutSlice = { label: string; value: number };

/** Donut chart for future proportional breakdowns (e.g. status mix). */
export function DonutChart({
  data,
  status,
  height = 280,
  emptyTitle = "No data yet",
  emptyDescription = "Data will appear here once it's available.",
  errorDescription = "The chart data couldn't be loaded. Check your connection and try again.",
  onRetry,
}: {
  data: DonutSlice[];
  status: ChartStatus;
  height?: number;
  emptyTitle?: string;
  emptyDescription?: string;
  errorDescription?: string;
  onRetry?: () => void;
}) {
  const theme = useChartTheme();
  const duration = useChartAnimationDuration();
  return (
    <ChartFrame
      emptyDescription={emptyDescription}
      emptyTitle={emptyTitle}
      errorDescription={errorDescription}
      height={height}
      onRetry={onRetry}
      status={status}
    >
      <ResponsiveContainer height="100%" width="100%">
        <PieChart>
          <RechartsTooltip content={(props) => <ChartTooltip {...props} />} />
          <Pie
            animationDuration={duration}
            data={data}
            dataKey="value"
            innerRadius="60%"
            isAnimationActive={duration > 0}
            nameKey="label"
            outerRadius="85%"
            paddingAngle={2}
          >
            {data.map((entry, index) => (
              <Cell key={entry.label} fill={theme.series[index % theme.series.length]} />
            ))}
          </Pie>
        </PieChart>
      </ResponsiveContainer>
    </ChartFrame>
  );
}

import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, expect, it } from "vitest";

import { MotionSection } from "./motion";
import {
  Badge,
  Button,
  Card,
  EmptyState,
  Input,
  Modal,
  Select,
  Skeleton,
  Spinner,
  StatusPill,
  TableShell,
  Tabs,
  Textarea,
  Tooltip,
} from "./primitives";
import { ThemeProvider, ThemeSwitch } from "./theme-provider";
import { ToastProvider, useToast } from "./toast";

function ToastProbe() {
  const toast = useToast();
  return (
    <>
      <Button onClick={() => toast.success("Saved")}>Toast</Button>
      <Button onClick={() => toast.error("Failed")}>Error toast</Button>
    </>
  );
}

describe("admin design system", () => {
  it("renders every primitive and representative state", () => {
    render(
      <ToastProvider>
        <Button>Primary</Button>
        <Button disabled>Disabled</Button>
        <Button loading>Loading</Button>
        <Button variant="accent">Accent</Button>
        <Button variant="ghost">Ghost</Button>
        <Button variant="danger">Danger</Button>
        <Input error="Required" label="Asset name" />
        <Select label="Status">
          <option>Healthy</option>
        </Select>
        <Textarea label="Notes" />
        <Card>Card</Card>
        <Badge>Badge</Badge>
        <StatusPill tone="healthy">Healthy</StatusPill>
        <StatusPill tone="warning">Warning</StatusPill>
        <StatusPill tone="critical">Critical</StatusPill>
        <TableShell label="Assets">
          <tbody>
            <tr>
              <td>Asset</td>
            </tr>
          </tbody>
        </TableShell>
        <Modal onClose={() => undefined} open title="Dialog">
          Modal body
        </Modal>
        <Tabs items={[{ id: "one", label: "One", content: "Panel one" }]} />
        <Tooltip content="Helpful">
          <span>Target</span>
        </Tooltip>
        <Skeleton className="h-4" />
        <Spinner />
        <EmptyState description="Nothing here" title="Empty" />
        <ToastProbe />
      </ToastProvider>,
    );

    expect(screen.getByRole("button", { name: "Primary" })).toBeEnabled();
    expect(screen.getByRole("button", { name: "Disabled" })).toBeDisabled();
    expect(screen.getByRole("button", { name: "Loading" })).toBeDisabled();
    expect(screen.getByRole("textbox", { name: "Asset name" })).toHaveAttribute(
      "aria-invalid",
      "true",
    );
    expect(screen.getByRole("dialog", { name: "Dialog" })).toHaveAttribute("aria-modal", "true");
    expect(screen.getByRole("table", { name: "Assets" })).toBeInTheDocument();
    expect(screen.getByRole("tab", { name: "One" })).toHaveAttribute("aria-selected", "true");
    expect(screen.getAllByRole("status").length).toBeGreaterThan(0);
    expect(screen.getByText("Empty")).toBeInTheDocument();
  });

  it("switches and persists the document theme", async () => {
    const user = userEvent.setup();
    render(
      <ThemeProvider>
        <ThemeSwitch />
      </ThemeProvider>,
    );

    await waitFor(() => expect(document.documentElement.dataset.theme).toBe("dark"));
    await user.click(screen.getByRole("button", { name: "Switch to light theme" }));
    expect(document.documentElement.dataset.theme).toBe("light");
    expect(document.documentElement).not.toHaveClass("dark");
    expect(window.localStorage.getItem("fev-theme")).toBe("light");
  });

  it("provides keyboard focus and ARIA for interactive controls", async () => {
    const user = userEvent.setup();
    render(
      <>
        <Button>Focusable action</Button>
        <Tooltip content="Safety detail">
          <span>Safety target</span>
        </Tooltip>
      </>,
    );
    await user.tab();
    expect(screen.getByRole("button", { name: "Focusable action" })).toHaveFocus();
    await user.tab();
    expect(screen.getByText("Safety target").parentElement).toHaveFocus();
    expect(screen.getByRole("tooltip")).toHaveTextContent("Safety detail");
  });

  it("renders the reduced-motion path without entrance animation", () => {
    render(
      <MotionSection reducedMotionOverride>
        <p>Reduced content</p>
      </MotionSection>,
    );
    expect(screen.getByText("Reduced content").parentElement).toHaveAttribute(
      "data-motion",
      "reduced",
    );
  });

  it("shows toast feedback through the prepared infrastructure", async () => {
    render(
      <ToastProvider>
        <ToastProbe />
      </ToastProvider>,
    );
    fireEvent.click(screen.getByRole("button", { name: "Toast" }));
    expect(await screen.findByText(/Saved/)).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: "Error toast" }));
    expect(await screen.findByText(/Failed/)).toBeInTheDocument();
  });
});

import "@testing-library/jest-dom/vitest";
import { cleanup } from "@testing-library/react";
import { afterEach } from "vitest";

afterEach(() => {
  cleanup();
  window.localStorage.clear();
  document.documentElement.className = "";
  delete document.documentElement.dataset.theme;
});

// jsdom doesn't implement the Blob URL APIs the logo-upload preview uses.
if (!("createObjectURL" in URL)) {
  Object.defineProperty(URL, "createObjectURL", { configurable: true, value: () => "blob:mock" });
}
if (!("revokeObjectURL" in URL)) {
  Object.defineProperty(URL, "revokeObjectURL", { configurable: true, value: () => undefined });
}

Object.defineProperty(window, "matchMedia", {
  configurable: true,
  value: (query: string) => ({
    addEventListener: () => undefined,
    addListener: () => undefined,
    dispatchEvent: () => false,
    matches: false,
    media: query,
    onchange: null,
    removeEventListener: () => undefined,
    removeListener: () => undefined,
  }),
});

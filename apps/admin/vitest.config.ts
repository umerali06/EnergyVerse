import { defineConfig } from "vitest/config";

export default defineConfig({
  esbuild: {
    jsx: "automatic",
  },
  test: {
    environment: "jsdom",
    maxWorkers: 1,
    pool: "forks",
    setupFiles: ["./src/test/setup.ts"],
  },
});

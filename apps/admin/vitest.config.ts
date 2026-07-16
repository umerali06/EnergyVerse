import { defineConfig } from "vitest/config";

export default defineConfig({
  esbuild: {
    jsx: "automatic",
  },
  test: {
    maxWorkers: 1,
    pool: "forks",
  },
});

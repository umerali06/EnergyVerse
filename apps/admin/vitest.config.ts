import { defineConfig } from "vitest/config";
import { fileURLToPath } from "node:url";

export default defineConfig({
  esbuild: {
    jsx: "automatic",
  },
  resolve: {
    alias: [
      {
        find: "@fev/api-client",
        replacement: fileURLToPath(
          new URL(
            "../../packages/contracts/generated/typescript-fetch/src/index.ts",
            import.meta.url,
          ),
        ),
      },
      { find: "@", replacement: fileURLToPath(new URL("./src", import.meta.url)) },
    ],
  },
  test: {
    environment: "jsdom",
    maxWorkers: 1,
    pool: "forks",
    setupFiles: ["./src/test/setup.ts"],
  },
});

"use client";

import { useEffect, useState } from "react";

import { Can, usePermissions } from "@/auth/permissions";

type FirestoreStatus = "connected" | "unavailable" | "unconfigured";

type ConnectionState = {
  api: "checking" | "connected" | "unavailable";
  firestore: FirestoreStatus | "checking";
};

const apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8000";

export default function Home() {
  const { can, status: permissionStatus } = usePermissions();
  const [connection, setConnection] = useState<ConnectionState>({
    api: "checking",
    firestore: "checking",
  });

  useEffect(() => {
    const controller = new AbortController();

    async function loadHealth() {
      try {
        const response = await fetch(`${apiBaseUrl.replace(/\/$/, "")}/health`, {
          cache: "no-store",
          signal: controller.signal,
        });
        if (!response.ok) {
          throw new Error(`Health request failed with HTTP ${response.status}`);
        }

        const health = (await response.json()) as { firestore?: unknown };
        const firestore = health.firestore;
        if (
          firestore !== "connected" &&
          firestore !== "unavailable" &&
          firestore !== "unconfigured"
        ) {
          throw new Error("Health response contained an invalid Firestore status");
        }

        setConnection({ api: "connected", firestore });
      } catch (error) {
        if (!(error instanceof DOMException && error.name === "AbortError")) {
          setConnection({ api: "unavailable", firestore: "unavailable" });
        }
      }
    }

    void loadHealth();
    return () => controller.abort();
  }, []);

  return (
    <main className="flex min-h-screen items-center justify-center bg-slate-950 text-slate-50">
      <section className="rounded-2xl border border-slate-800 bg-slate-900 p-8 shadow-2xl">
        <h1 className="text-2xl font-bold">FEV Admin</h1>
        <p className="mt-4 rounded-full bg-slate-800 px-4 py-2 text-sm text-emerald-300">
          API: {connection.api} · Firestore: {connection.firestore}
        </p>
        <div className="mt-4 rounded-xl border border-slate-700 p-4 text-sm">
          <p className="text-slate-400">RBAC proof · {permissionStatus}</p>
          {can("assets.write") ? (
            <p className="mt-2 text-emerald-300">Asset write action available</p>
          ) : (
            <p className="mt-2 text-amber-300">No access: assets.write required</p>
          )}
          <Can permission="reports.generate">
            <p className="mt-2 text-emerald-300">Report generation available</p>
          </Can>
        </div>
      </section>
    </main>
  );
}

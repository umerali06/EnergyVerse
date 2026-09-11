import type { Metadata } from "next";

import { TrainingPage } from "@/training/training-page";

export const metadata: Metadata = {
  title: "VR Training",
};

export default function Page() {
  return <TrainingPage />;
}

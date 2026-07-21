function Glyph({ path }: { path: string }) {
  return (
    <svg
      aria-hidden
      className="size-4 shrink-0"
      fill="none"
      stroke="currentColor"
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth="1.8"
      viewBox="0 0 24 24"
    >
      <path d={path} />
    </svg>
  );
}

export const actionIcons = {
  company: <Glyph path="M3 21V7l6-4 6 4v14M9 21V11h6v10M3 21h18" />,
  user: <Glyph path="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />,
  access: <Glyph path="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10zM9.5 12l1.8 1.8L15 10" />,
  generic: <Glyph path="M13 2 3 14h7l-1 8 11-13h-7l0-7z" />,
} as const;

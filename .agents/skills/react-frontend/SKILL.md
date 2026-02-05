---
name: react-frontend
description: >
  React 19 + TypeScript frontend development with Vite, TanStack Query, Zustand, and shadcn/ui.
  Use this skill when: building React components, configuring Vite projects, managing server state 
  with TanStack Query, handling UI state with Zustand, styling with Tailwind CSS, or implementing 
  shadcn/ui components. Triggers include .tsx, .ts files, React hooks, API integration, state 
  management, form handling, and UI component development.
license: MIT
compatibility: Claude Code, OpenCode, Codex, Gemini-Cli, bun/pnpm package managers, Node LTS
metadata:
  author: razobeckett
  version: "1.0"
  stack: react-vite-tanstack-zustand-shadcn
---

# React Frontend Development

> Vite + React 19 + TypeScript + TanStack Query + Zustand + shadcn/ui

## Quick Reference

| Layer | Tool | Purpose |
|-------|------|---------|
| Framework | React 19 + Vite | UI rendering + dev server |
| Styling | Tailwind CSS + shadcn/ui | Utility-first CSS + components |
| Server State | TanStack Query + Axios | Fetch, cache, sync server data |
| UI State | Zustand | Client-only state (dialogs, filters) |
| Icons | lucide-animated > lucide-react | Prefer animated variants |
| Animation | Motion (framer-motion) | Shared presets only |
| Lint/Format | Biome | Single tool for both |

## Critical Rules

### ALWAYS
- TypeScript strict mode (no `any`, no `@ts-ignore`)
- Prefer `bun` package manager, fallback to `pnpm` (NEVER npm)
- Use Biome for linting AND formatting
- TanStack Query for ALL server data
- Zustand for UI-only state
- lucide-animated icons when available

### NEVER
- Suppress type errors (`as any`, `@ts-ignore`, `@ts-expect-error`)
- Use npm as package manager
- Mix server state in Zustand
- Custom animations outside shared presets
- Paste secrets or production data in code

### ASK FIRST
- Auth implementation (WorkOS vs better-auth)
- Major refactors affecting 3+ files
- Changing core dependencies (icons, auth, state management)
- Non-obvious architectural decisions

## State Management Decision Tree

```
Is it from an API/server?
├─ YES → TanStack Query (useQuery, useMutation)
└─ NO → Is it UI-related?
         ├─ YES → Zustand (dialogs, selections, filters)
         └─ NO → Consider if state is needed at all
```

## Commands

```bash
# Setup (use bun, fallback pnpm)
bun install        # or: pnpm install

# Development
bun run dev        # or: pnpm dev

# Build
bun run build      # or: pnpm build

# Lint & Format
bun run check      # biome check
bun run format     # biome format --write
```

## Detailed References

| Topic | File |
|-------|------|
| Tech stack configuration | [references/stack.md](references/stack.md) |
| Code patterns & conventions | [references/patterns.md](references/patterns.md) |
| Agentic workflow rules | [references/workflow.md](references/workflow.md) |
| Project structure | [references/structure.md](references/structure.md) |

## Quality Gates (Pre-commit)

Required before any commit:
1. `biome check` - Lint + format validation
2. `tsc --noEmit` - TypeScript type checking

Husky + lint-staged enforces these automatically.

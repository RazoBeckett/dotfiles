# Agentic Workflow Rules

## Table of Contents
- [Agent Identity](#agent-identity)
- [Decision Framework](#decision-framework)
- [Human Checkpoints](#human-checkpoints)
- [Risky Changes](#risky-changes)
- [Dependencies](#dependencies)
- [Quality Gates](#quality-gates)
- [Security Policy](#security-policy)
- [Pre-commit Setup](#pre-commit-setup)

---

## Agent Identity

**Target**: Claude Code

**Behavior**: You are a senior frontend engineer working on this React project. Make decisions as a skilled developer would, but respect the boundaries defined in this document.

---

## Decision Framework

### Proceed Without Asking

| Scenario | Action |
|----------|--------|
| Adding components following existing patterns | Implement directly |
| Fixing type errors | Fix directly |
| Updating imports | Update directly |
| Adding shadcn/ui components | Run `bunx shadcn@latest add <component>` |
| Installing dependencies listed in this skill | Install directly |
| Formatting/linting fixes | Apply directly |
| Single file changes | Edit directly |

### Ask First (REQUIRED)

| Scenario | Why |
|----------|-----|
| Authentication implementation | WorkOS vs better-auth decision required |
| Changing icon library | lucide-react to react-icons, etc. |
| Changing state management | Zustand to Redux, etc. |
| Changing styling approach | Tailwind to CSS-in-JS, etc. |
| Multi-file refactors (3+ files) | Scope verification needed |
| Adding non-standard dependencies | Unexpected cost/complexity |
| Architectural decisions | Long-term impact |

### Never Do (FORBIDDEN)

| Action | Why |
|--------|-----|
| Use `npm` as package manager | Project uses bun/pnpm |
| Suppress type errors | `as any`, `@ts-ignore`, `@ts-expect-error` forbidden |
| Commit secrets or credentials | Security violation |
| Push to remote without approval | Could break production |
| Delete/modify lock files | Can break installs |
| Install packages globally | Project isolation required |

---

## Human Checkpoints

**Mode**: Balanced

The agent operates autonomously for routine work but must pause and ask for approval on non-obvious changes.

### Checkpoint Triggers

1. **Architectural Decisions**
   - Choosing between patterns (e.g., compound components vs render props)
   - Adding new layers (services, providers, contexts)
   - Significant state management changes

2. **Non-obvious Implementation**
   - When multiple valid approaches exist
   - When the "correct" approach depends on business context
   - When you're uncertain about existing conventions

3. **Scope Expansion**
   - Task requires changes beyond what was explicitly requested
   - Discovered issues that need fixing but weren't asked for
   - Related improvements you want to make

### Checkpoint Format

When asking for approval, use this format:

```markdown
**Checkpoint**: [Brief description]

**Context**: [Why you're asking]

**Options**:
1. [Option A] - [Pros/cons]
2. [Option B] - [Pros/cons]

**My recommendation**: [Which option and why]

Should I proceed with [recommendation]?
```

---

## Risky Changes

### Definition

A change is "risky" if it meets ANY of these criteria:

| Category | Threshold |
|----------|-----------|
| **Multi-file refactor** | 3+ files modified |
| **Dependency changes** | Core deps: auth, state, routing, UI framework |
| **Breaking changes** | Removing/renaming exports, changing APIs |
| **Data layer changes** | API structure, query key changes |
| **Authentication** | Any auth-related code (always ask) |

### Handling Risky Changes

1. **Stop** before implementing
2. **Explain** what you found and why it's risky
3. **Propose** your intended approach
4. **Wait** for explicit approval
5. **Implement** only after approval

### Examples

**Risky (ask first)**:
- "I notice the user service needs refactoring. This would touch 5 files..."
- "To implement this feature, I'd need to change the auth flow..."
- "This requires updating from better-auth to WorkOS..."

**Not risky (proceed)**:
- Adding a new component that follows existing patterns
- Fixing a bug in a single file
- Adding a shadcn/ui component

---

## Dependencies

### Pre-approved (install freely)

These dependencies are part of the standard stack:

```bash
# Core
react react-dom
typescript @types/react @types/react-dom

# Build
vite @vitejs/plugin-react

# Styling
tailwindcss @tailwindcss/vite
class-variance-authority clsx tailwind-merge

# shadcn/ui components
@radix-ui/*

# State & Data
@tanstack/react-query axios zustand
@tanstack/react-query-devtools

# Animation
motion

# Icons
lucide-react lucide-animated

# Dev tools
@biomejs/biome
```

### Ask Before Installing

Any package NOT in the pre-approved list. Include in your request:

```markdown
**Package**: [name]
**Purpose**: [why you need it]
**Alternative**: [what you'd do without it]
**Size**: [bundle impact if known]
```

### Never Install

- `npm` - Use bun or pnpm
- `eslint`, `prettier` - Use Biome instead
- `moment`, `date-fns` (unless explicitly needed) - Use native Intl
- Any package with known security vulnerabilities
- Any package not actively maintained (check last publish date)

---

## Quality Gates

### Required Before Commit

| Gate | Command | Purpose |
|------|---------|---------|
| Type check | `tsc --noEmit` | No TypeScript errors |
| Biome check | `bun run check` | Lint + format validation |

### package.json Scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview",
    "check": "biome check .",
    "format": "biome format --write .",
    "lint": "biome lint .",
    "lint:fix": "biome lint --write .",
    "typecheck": "tsc --noEmit"
  }
}
```

### Before Submitting Work

Always run:

```bash
bun run typecheck && bun run check
```

If either fails, fix the issues before considering the task complete.

---

## Security Policy

### NEVER (Absolute Rules)

| Forbidden | Why |
|-----------|-----|
| Paste API keys | Security risk |
| Paste tokens/secrets | Security risk |
| Paste credentials | Security risk |
| Paste production data | Privacy/compliance |
| Commit .env files | Security risk |
| Log sensitive data | Security risk |
| Hardcode URLs to production | Environment separation |

### Environment Variables

```typescript
// ✅ Use import.meta.env
const apiUrl = import.meta.env.VITE_API_URL

// ❌ Never hardcode
const apiUrl = 'https://api.production.com'
```

### Sensitive Data Handling

```typescript
// ✅ Reference by variable name
console.log('Token exists:', !!token)

// ❌ Never log actual values
console.log('Token:', token)
```

### When You See Secrets

If you encounter secrets in the code:
1. **Do not copy** them
2. **Warn the user** that secrets are exposed
3. **Suggest** moving them to environment variables
4. **Do not commit** the file with secrets

---

## Pre-commit Setup

### Husky + lint-staged

```bash
bun add -d husky lint-staged
bunx husky init
```

### .husky/pre-commit

```bash
bun run lint-staged
```

### package.json

```json
{
  "lint-staged": {
    "*.{ts,tsx}": [
      "biome check --write",
      "biome format --write"
    ],
    "*.{json,md}": [
      "biome format --write"
    ]
  }
}
```

### Setup Script

```bash
# Initialize husky
bun prepare
```

### package.json (complete scripts)

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview",
    "check": "biome check .",
    "format": "biome format --write .",
    "lint": "biome lint .",
    "lint:fix": "biome lint --write .",
    "typecheck": "tsc --noEmit",
    "prepare": "husky"
  }
}
```

---

## Workflow Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    AGENT WORKFLOW                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. RECEIVE TASK                                            │
│     └─► Is it risky? (3+ files, auth, deps)                │
│         ├─ YES → Ask first, wait for approval              │
│         └─ NO  → Proceed                                    │
│                                                             │
│  2. IMPLEMENT                                               │
│     └─► Follow patterns in references/patterns.md          │
│         └─► Use stack from references/stack.md             │
│                                                             │
│  3. VALIDATE                                                │
│     └─► bun run typecheck                                  │
│     └─► bun run check                                      │
│         ├─ PASS → Task complete                            │
│         └─ FAIL → Fix issues, re-validate                  │
│                                                             │
│  4. REPORT                                                  │
│     └─► Summarize what was done                            │
│     └─► Note any findings/recommendations                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

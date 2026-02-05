# Tech Stack Configuration

## Table of Contents
- [Build Tool: Vite](#build-tool-vite)
- [Package Manager](#package-manager)
- [Linting & Formatting: Biome](#linting--formatting-biome)
- [UI Framework: React 19](#ui-framework-react-19)
- [Styling: Tailwind CSS](#styling-tailwind-css)
- [Components: shadcn/ui](#components-shadcnui)
- [Icons: Lucide](#icons-lucide)
- [Animation: Motion](#animation-motion)
- [Server State: TanStack Query + Axios](#server-state-tanstack-query--axios)
- [UI State: Zustand](#ui-state-zustand)

---

## Build Tool: Vite

**Template**: `react-ts` (React + TypeScript)

### Setup
```bash
bun create vite@latest project-name -- --template react-ts
cd project-name
bun install
```

### vite.config.ts
```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
```

**Docs**: https://vite.dev/guide/

---

## Package Manager

**Priority**: `bun` > `pnpm` > (never npm)

### Bun Commands
```bash
bun install           # Install dependencies
bun add <pkg>         # Add dependency
bun add -d <pkg>      # Add dev dependency
bun remove <pkg>      # Remove dependency
bun run <script>      # Run script
```

### Pnpm Commands (fallback)
```bash
pnpm install
pnpm add <pkg>
pnpm add -D <pkg>
pnpm remove <pkg>
pnpm run <script>
```

---

## Linting & Formatting: Biome

Single tool for both linting and formatting. Replaces ESLint + Prettier.

### Setup
```bash
bun add -d @biomejs/biome
bunx biome init
```

### biome.json
```json
{
  "$schema": "https://biomejs.dev/schemas/1.9.4/schema.json",
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true
  },
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": {
        "noUnusedImports": "error",
        "noUnusedVariables": "error"
      },
      "suspicious": {
        "noExplicitAny": "error"
      }
    }
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "tab",
    "lineWidth": 100
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "single",
      "semicolons": "asNeeded"
    }
  }
}
```

### Scripts (package.json)
```json
{
  "scripts": {
    "check": "biome check .",
    "format": "biome format --write .",
    "lint": "biome lint .",
    "lint:fix": "biome lint --write ."
  }
}
```

**Docs**: https://biomejs.dev/guides/getting-started/

---

## UI Framework: React 19

### Key Patterns

**No manual memoization** - React Compiler handles optimization:
```tsx
// ✅ Correct - let compiler optimize
function Component({ items }: { items: Item[] }) {
  const filtered = items.filter(item => item.active)
  return <List items={filtered} />
}

// ❌ Wrong - unnecessary with React 19 compiler
const filtered = useMemo(() => items.filter(item => item.active), [items])
```

**Import style**:
```tsx
// ✅ Named imports
import { useState, useEffect } from 'react'

// ❌ Default import (legacy)
import React from 'react'
```

**Ref as prop** (no forwardRef needed):
```tsx
// ✅ React 19+
function Input({ ref, ...props }: { ref?: React.Ref<HTMLInputElement> }) {
  return <input ref={ref} {...props} />
}

// ❌ Legacy forwardRef
const Input = forwardRef<HTMLInputElement, Props>((props, ref) => ...)
```

**Docs**: https://react.dev/learn

---

## Styling: Tailwind CSS

### Setup with Vite
```bash
bun add -d tailwindcss @tailwindcss/vite
```

### vite.config.ts
```typescript
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
})
```

### src/index.css
```css
@import 'tailwindcss';
```

**Docs**: https://tailwindcss.com/docs/installation/using-vite

---

## Components: shadcn/ui

### Setup
```bash
bunx shadcn@latest init
```

**Location**: `src/components/ui/` (default)

### Adding Components
```bash
bunx shadcn@latest add button
bunx shadcn@latest add card
bunx shadcn@latest add dialog
```

### Usage
```tsx
import { Button } from '@/components/ui/button'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'

function Example() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Title</CardTitle>
      </CardHeader>
      <CardContent>
        <Button>Click me</Button>
      </CardContent>
    </Card>
  )
}
```

**Docs**: https://ui.shadcn.com/docs

---

## Icons: Lucide

**Priority**: lucide-animated > lucide-react

### Setup
```bash
bun add lucide-react
bun add lucide-animated  # preferred when icons available
```

### Usage
```tsx
// ✅ Prefer animated variants
import { LoaderCircle } from 'lucide-animated'

// Fallback to static
import { Search } from 'lucide-react'

function Example() {
  return (
    <>
      <LoaderCircle className="animate-spin" />
      <Search className="h-4 w-4" />
    </>
  )
}
```

**Docs**: 
- lucide-react: https://lucide.dev/guide/packages/lucide-react
- lucide-animated: https://lucide-animated.com/

---

## Animation: Motion

Formerly Framer Motion. Use **shared presets only** - no custom per-component animations.

### Setup
```bash
bun add motion
```

### Shared Presets Module (src/lib/motion.ts)
```typescript
import type { Variants } from 'motion/react'

export const fadeIn: Variants = {
  hidden: { opacity: 0 },
  visible: { opacity: 1 },
}

export const slideUp: Variants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0 },
}

export const scaleIn: Variants = {
  hidden: { opacity: 0, scale: 0.95 },
  visible: { opacity: 1, scale: 1 },
}

export const stagger = {
  visible: {
    transition: {
      staggerChildren: 0.1,
    },
  },
}

export const defaultTransition = {
  duration: 0.2,
  ease: 'easeOut',
}
```

### Usage
```tsx
import { motion } from 'motion/react'
import { fadeIn, defaultTransition } from '@/lib/motion'

function Example() {
  return (
    <motion.div
      variants={fadeIn}
      initial="hidden"
      animate="visible"
      transition={defaultTransition}
    >
      Content
    </motion.div>
  )
}
```

**Docs**: https://motion.dev/docs/react

---

## Server State: TanStack Query + Axios

### Setup
```bash
bun add @tanstack/react-query axios
bun add -d @tanstack/react-query-devtools
```

### Centralized Axios Instance (src/services/http.ts)
```typescript
import axios from 'axios'

export const http = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor (auth token injection)
http.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Response interceptor (error handling)
http.interceptors.response.use(
  (response) => response,
  (error) => {
    const apiError: ApiError = {
      message: error.response?.data?.message || 'An error occurred',
      code: error.response?.data?.code || 'UNKNOWN_ERROR',
      status: error.response?.status || 500,
    }
    return Promise.reject(apiError)
  }
)
```

### Standard Error Shape (src/types/api.ts)
```typescript
export interface ApiError {
  message: string
  code: string
  status: number
  details?: Record<string, unknown>
}

export interface ApiResponse<T> {
  data: T
  meta?: {
    page?: number
    total?: number
  }
}
```

### Query Client Setup (src/main.tsx)
```tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      retry: 1,
    },
  },
})

createRoot(document.getElementById('root')!).render(
  <QueryClientProvider client={queryClient}>
    <App />
    <ReactQueryDevtools initialIsOpen={false} />
  </QueryClientProvider>
)
```

### Query Keys Strategy (project-dependent)

**Option A: Central factory (smaller projects)**
```typescript
// src/lib/queryKeys.ts
export const queryKeys = {
  users: {
    all: ['users'] as const,
    detail: (id: string) => ['users', id] as const,
    list: (filters: UserFilters) => ['users', 'list', filters] as const,
  },
  posts: {
    all: ['posts'] as const,
    detail: (id: string) => ['posts', id] as const,
  },
}
```

**Option B: Per-feature keys (larger projects)**
```typescript
// src/features/users/queries.ts
export const userKeys = {
  all: ['users'] as const,
  detail: (id: string) => ['users', id] as const,
}
```

### Example Query Hook
```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { http } from '@/services/http'
import { queryKeys } from '@/lib/queryKeys'
import type { User } from '@/types'

export function useUsers() {
  return useQuery({
    queryKey: queryKeys.users.all,
    queryFn: async () => {
      const { data } = await http.get<User[]>('/users')
      return data
    },
  })
}

export function useCreateUser() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: async (newUser: CreateUserDto) => {
      const { data } = await http.post<User>('/users', newUser)
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.users.all })
    },
  })
}
```

**Docs**: https://tanstack.com/query/latest/docs/framework/react/overview

---

## UI State: Zustand

**Scope**: UI-only state (dialogs, selections, filters). NEVER server data.

### Setup
```bash
bun add zustand
```

### Store Pattern (src/stores/ui-store.ts)
```typescript
import { create } from 'zustand'

interface UIState {
  // Dialog states
  isCreateModalOpen: boolean
  openCreateModal: () => void
  closeCreateModal: () => void
  
  // Selection states
  selectedIds: string[]
  toggleSelection: (id: string) => void
  clearSelection: () => void
  
  // Filter states
  searchQuery: string
  setSearchQuery: (query: string) => void
}

export const useUIStore = create<UIState>((set) => ({
  // Dialogs
  isCreateModalOpen: false,
  openCreateModal: () => set({ isCreateModalOpen: true }),
  closeCreateModal: () => set({ isCreateModalOpen: false }),
  
  // Selections
  selectedIds: [],
  toggleSelection: (id) =>
    set((state) => ({
      selectedIds: state.selectedIds.includes(id)
        ? state.selectedIds.filter((i) => i !== id)
        : [...state.selectedIds, id],
    })),
  clearSelection: () => set({ selectedIds: [] }),
  
  // Filters
  searchQuery: '',
  setSearchQuery: (query) => set({ searchQuery: query }),
}))
```

### Usage
```tsx
import { useUIStore } from '@/stores/ui-store'

function Toolbar() {
  const { openCreateModal, selectedIds, clearSelection } = useUIStore()
  
  return (
    <div>
      <Button onClick={openCreateModal}>Create</Button>
      {selectedIds.length > 0 && (
        <Button variant="outline" onClick={clearSelection}>
          Clear ({selectedIds.length})
        </Button>
      )}
    </div>
  )
}
```

### One Store Per Feature (recommended for performance)
```typescript
// src/stores/users-ui.ts
export const useUsersUI = create<UsersUIState>(...)

// src/stores/posts-ui.ts  
export const usePostsUI = create<PostsUIState>(...)
```

**Docs**: https://github.com/pmndrs/zustand

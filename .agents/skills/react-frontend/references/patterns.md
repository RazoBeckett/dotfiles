# Code Patterns & Conventions

## Table of Contents
- [TypeScript Patterns](#typescript-patterns)
- [React Patterns](#react-patterns)
- [Component Patterns](#component-patterns)
- [State Patterns](#state-patterns)
- [API Patterns](#api-patterns)
- [Error Handling](#error-handling)

---

## TypeScript Patterns

### Strict Mode (REQUIRED)

tsconfig.json must include:
```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

### Type Exports

```typescript
// ✅ Explicit type exports
export type { User, UserRole } from './types'
export { createUser } from './utils'

// ❌ Mixed exports (confusing)
export { User, createUser } from './utils'
```

### Interface Over Type (for objects)

```typescript
// ✅ Interface for object shapes
interface User {
  id: string
  name: string
  email: string
}

// ✅ Type for unions, primitives, utilities
type Status = 'active' | 'inactive' | 'pending'
type UserID = string
type PartialUser = Partial<User>

// ❌ Type for objects (less extensible)
type User = {
  id: string
  name: string
}
```

### Flat Interfaces (REQUIRED)

```typescript
// ✅ Flat - one level depth
interface User {
  id: string
  name: string
  addressId: string
}

interface Address {
  id: string
  street: string
  city: string
}

// ❌ Nested objects inline
interface User {
  id: string
  name: string
  address: {
    street: string
    city: string
  }
}
```

### Const Types Pattern (for enums)

```typescript
// ✅ Const object + extracted type (single source of truth)
export const USER_ROLES = {
  ADMIN: 'admin',
  USER: 'user',
  GUEST: 'guest',
} as const

export type UserRole = (typeof USER_ROLES)[keyof typeof USER_ROLES]
// Result: 'admin' | 'user' | 'guest'

// ❌ TypeScript enum (tree-shaking issues)
enum UserRole {
  ADMIN = 'admin',
  USER = 'user',
}

// ❌ Separate type and values (can drift)
type UserRole = 'admin' | 'user' | 'guest'
const ADMIN = 'admin'
const USER = 'user'
```

### Never Use `any`

```typescript
// ✅ Use unknown for truly unknown types
function parseJSON(json: string): unknown {
  return JSON.parse(json)
}

// ✅ Use generics for flexibility
function first<T>(arr: T[]): T | undefined {
  return arr[0]
}

// ✅ Use specific types when possible
function handleEvent(event: MouseEvent | KeyboardEvent) {
  // ...
}

// ❌ Never use any
function handleData(data: any) { } // FORBIDDEN
```

### Utility Types Reference

```typescript
// Pick specific properties
type UserPreview = Pick<User, 'id' | 'name'>

// Omit properties
type CreateUser = Omit<User, 'id' | 'createdAt'>

// All optional
type PartialUser = Partial<User>

// All required
type RequiredUser = Required<User>

// Readonly
type ReadonlyUser = Readonly<User>

// Record
type UserMap = Record<string, User>

// Extract from union
type ActiveStatus = Extract<Status, 'active' | 'pending'>

// Exclude from union
type InactiveStatus = Exclude<Status, 'active'>
```

---

## React Patterns

### Component Definition

```typescript
// ✅ Function declaration (hoisted, consistent)
function UserCard({ user }: UserCardProps) {
  return <div>{user.name}</div>
}

// ✅ Arrow function (when needed for callbacks)
const UserCard = ({ user }: UserCardProps) => <div>{user.name}</div>

// ❌ FC type (unnecessary, hides children)
const UserCard: React.FC<UserCardProps> = ({ user }) => ...
```

### Props Interface Naming

```typescript
// ✅ ComponentName + Props
interface UserCardProps {
  user: User
  onSelect?: (user: User) => void
}

function UserCard({ user, onSelect }: UserCardProps) {
  // ...
}

// ❌ Generic names
interface Props { }
interface IUserCardProps { }
```

### Children Prop

```typescript
// ✅ Explicit children in props
interface LayoutProps {
  children: React.ReactNode
  sidebar?: React.ReactNode
}

function Layout({ children, sidebar }: LayoutProps) {
  return (
    <div>
      {sidebar && <aside>{sidebar}</aside>}
      <main>{children}</main>
    </div>
  )
}
```

### Event Handlers

```typescript
// ✅ Named handler functions
function Form() {
  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    // ...
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    // ...
  }

  return (
    <form onSubmit={handleSubmit}>
      <input onChange={handleChange} />
    </form>
  )
}

// ❌ Inline handlers (recreated each render)
<form onSubmit={(e) => { e.preventDefault(); doStuff() }}>
```

### Ref as Prop (React 19+)

```typescript
// ✅ React 19+ - ref as regular prop
interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  ref?: React.Ref<HTMLInputElement>
  label?: string
}

function Input({ ref, label, ...props }: InputProps) {
  return (
    <div>
      {label && <label>{label}</label>}
      <input ref={ref} {...props} />
    </div>
  )
}

// ❌ Legacy forwardRef (not needed in React 19)
const Input = forwardRef<HTMLInputElement, InputProps>((props, ref) => ...)
```

---

## Component Patterns

### Compound Components

```typescript
// ✅ Compound pattern for complex components
interface CardProps {
  children: React.ReactNode
  className?: string
}

function Card({ children, className }: CardProps) {
  return <div className={cn('rounded-lg border', className)}>{children}</div>
}

function CardHeader({ children, className }: CardProps) {
  return <div className={cn('p-4 border-b', className)}>{children}</div>
}

function CardContent({ children, className }: CardProps) {
  return <div className={cn('p-4', className)}>{children}</div>
}

// Attach sub-components
Card.Header = CardHeader
Card.Content = CardContent

// Usage
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Content>Content</Card.Content>
</Card>
```

### Render Props (when needed)

```typescript
// ✅ Render prop for flexible rendering
interface DataListProps<T> {
  items: T[]
  renderItem: (item: T, index: number) => React.ReactNode
  keyExtractor: (item: T) => string
}

function DataList<T>({ items, renderItem, keyExtractor }: DataListProps<T>) {
  return (
    <ul>
      {items.map((item, index) => (
        <li key={keyExtractor(item)}>{renderItem(item, index)}</li>
      ))}
    </ul>
  )
}

// Usage
<DataList
  items={users}
  keyExtractor={(user) => user.id}
  renderItem={(user) => <UserCard user={user} />}
/>
```

### Conditional Rendering

```typescript
// ✅ Early return for guard clauses
function UserProfile({ user }: { user: User | null }) {
  if (!user) {
    return <EmptyState message="No user selected" />
  }

  return <ProfileCard user={user} />
}

// ✅ Ternary for simple conditions
function StatusBadge({ isActive }: { isActive: boolean }) {
  return isActive ? <Badge>Active</Badge> : <Badge variant="muted">Inactive</Badge>
}

// ✅ && for presence checks (be careful with 0)
function NotificationCount({ count }: { count: number }) {
  return count > 0 && <Badge>{count}</Badge>
}

// ❌ && with potentially falsy values
{count && <Badge>{count}</Badge>}  // Won't render for count = 0
```

---

## State Patterns

### Local vs Global State

```typescript
// ✅ Local state for component-specific UI
function SearchInput() {
  const [value, setValue] = useState('')
  // ...
}

// ✅ Zustand for shared UI state
const useUIStore = create<UIState>((set) => ({
  selectedIds: [],
  toggleSelection: (id) => set((state) => ({
    selectedIds: state.selectedIds.includes(id)
      ? state.selectedIds.filter((i) => i !== id)
      : [...state.selectedIds, id],
  })),
}))

// ✅ TanStack Query for server state
function UserList() {
  const { data: users, isLoading } = useUsers()
  // ...
}
```

### Derived State

```typescript
// ✅ Compute in render (React 19 optimizes)
function FilteredList({ items, filter }: Props) {
  const filtered = items.filter(item => item.name.includes(filter))
  return <List items={filtered} />
}

// ❌ useMemo for simple computations (unnecessary)
const filtered = useMemo(
  () => items.filter(item => item.name.includes(filter)),
  [items, filter]
)
```

### State Initialization

```typescript
// ✅ Lazy initialization for expensive computations
const [state, setState] = useState(() => computeExpensiveInitialValue())

// ❌ Computed on every render
const [state, setState] = useState(computeExpensiveInitialValue())
```

---

## API Patterns

### Query Hook Pattern

```typescript
// src/features/users/api/queries.ts
import { useQuery } from '@tanstack/react-query'
import { http } from '@/services/http'
import type { User } from '../types'

const keys = {
  all: ['users'] as const,
  detail: (id: string) => ['users', id] as const,
  list: (filters: UserFilters) => ['users', 'list', filters] as const,
}

export function useUsers(filters?: UserFilters) {
  return useQuery({
    queryKey: filters ? keys.list(filters) : keys.all,
    queryFn: async () => {
      const { data } = await http.get<User[]>('/users', { params: filters })
      return data
    },
  })
}

export function useUser(id: string) {
  return useQuery({
    queryKey: keys.detail(id),
    queryFn: async () => {
      const { data } = await http.get<User>(`/users/${id}`)
      return data
    },
    enabled: !!id,
  })
}
```

### Mutation Hook Pattern

```typescript
// src/features/users/api/mutations.ts
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { http } from '@/services/http'
import type { User, CreateUserDto, UpdateUserDto } from '../types'

export function useCreateUser() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateUserDto) => {
      const { data: user } = await http.post<User>('/users', data)
      return user
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
    },
  })
}

export function useUpdateUser() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: string; data: UpdateUserDto }) => {
      const { data: user } = await http.patch<User>(`/users/${id}`, data)
      return user
    },
    onSuccess: (user) => {
      queryClient.setQueryData(['users', user.id], user)
      queryClient.invalidateQueries({ queryKey: ['users'] })
    },
  })
}

export function useDeleteUser() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: string) => {
      await http.delete(`/users/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
    },
  })
}
```

### Optimistic Updates (when appropriate)

```typescript
// Only use for UX-critical mutations where server rarely fails
export function useToggleFavorite() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: string) => {
      await http.post(`/items/${id}/favorite`)
    },
    onMutate: async (id) => {
      await queryClient.cancelQueries({ queryKey: ['items', id] })
      
      const previous = queryClient.getQueryData(['items', id])
      
      queryClient.setQueryData(['items', id], (old: Item) => ({
        ...old,
        isFavorite: !old.isFavorite,
      }))
      
      return { previous }
    },
    onError: (err, id, context) => {
      queryClient.setQueryData(['items', id], context?.previous)
    },
    onSettled: (data, err, id) => {
      queryClient.invalidateQueries({ queryKey: ['items', id] })
    },
  })
}
```

---

## Error Handling

### API Error Boundary

```typescript
// src/components/error-boundary.tsx
import { Component, type ReactNode } from 'react'

interface Props {
  children: ReactNode
  fallback?: ReactNode
}

interface State {
  hasError: boolean
  error?: Error
}

export class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error }
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || <DefaultErrorFallback error={this.state.error} />
    }

    return this.props.children
  }
}

function DefaultErrorFallback({ error }: { error?: Error }) {
  return (
    <div className="p-4 text-center">
      <h2 className="text-lg font-semibold">Something went wrong</h2>
      <p className="text-muted-foreground">{error?.message}</p>
    </div>
  )
}
```

### Query Error Handling

```typescript
// Component-level error handling
function UserList() {
  const { data, error, isLoading } = useUsers()

  if (isLoading) return <Skeleton />
  if (error) return <ErrorMessage error={error} />

  return <List items={data} />
}

// Global error handler (in QueryClient)
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: (failureCount, error) => {
        // Don't retry on 4xx errors
        if (error instanceof ApiError && error.status >= 400 && error.status < 500) {
          return false
        }
        return failureCount < 2
      },
    },
    mutations: {
      onError: (error) => {
        // Global toast notification
        toast.error(error.message)
      },
    },
  },
})
```

### Form Error Handling

```typescript
function CreateUserForm() {
  const { mutate, error, isPending } = useCreateUser()

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    
    mutate({
      name: formData.get('name') as string,
      email: formData.get('email') as string,
    })
  }

  return (
    <form onSubmit={handleSubmit}>
      {error && <Alert variant="destructive">{error.message}</Alert>}
      
      <Input name="name" required />
      <Input name="email" type="email" required />
      
      <Button type="submit" disabled={isPending}>
        {isPending ? 'Creating...' : 'Create'}
      </Button>
    </form>
  )
}
```

---
name: coding-react
slug: coding-react
description: >-
  React coding standards and component patterns.
  TRIGGER when: writing, modifying, or reviewing React components (.tsx/.jsx files), or working with React hooks and JSX.
  DO NOT TRIGGER for non-React TypeScript or backend code.
---

# React Standards

React conventions for production UI code. Apply alongside `coding-principles` and `coding-typescript`.

## Components

```tsx
interface UserCardProps {
  user: User
  onSelect: (id: string) => void
}

export function UserCard({ user, onSelect }: UserCardProps) {
  return (
    <div onClick={() => onSelect(user.id)}>
      {user.name}
    </div>
  )
}
```

- Functional components only — no class components
- Props interface named `{Component}Props`, defined above the component
- One component per file, file named after the component: `UserCard.tsx`
- Destructure props in the function signature
- Keep components small — extract when a component handles more than one concern

## Hooks

- Custom hooks for reusable stateful logic: `useX` naming convention
- One concern per hook
- `useState` for local UI state
- `useEffect` only for synchronization with external systems — **never for derived state**
- Always include cleanup in effects that subscribe or listen
- `useMemo` / `useCallback` only when there's a measured performance need — not by default

## State Management

Priority order (use the simplest that works):

1. **Local state** — `useState` within the component
2. **Lift state up** — when siblings need shared state
3. **Context** — for truly global concerns (theme, auth, locale)
4. **External library** — only when Context becomes unwieldy at scale

Rules:
- Derive state from existing state — never duplicate
- Computed values belong in render, not in `useEffect` + `useState`
- URL is state too — use it for shareable/bookmarkable state

## Component Patterns

| Pattern | When to use |
|---|---|
| Composition (`children`) | Flexible container/layout components |
| Custom hooks | Shared stateful logic across components |
| Compound components | Related components sharing implicit state |
| Controlled components | Forms and inputs (default approach) |

## Data Fetching

- Fetch in hooks or at route level — never inside render logic
- Handle all states explicitly: loading, error, empty, success
- Show loading indicators for async operations
- Start simple (fetch + useState) — add React Query/SWR only when caching or deduplication is needed

## Forms

- Controlled components by default
- Validate on submit, display errors inline next to the field
- Keep form state local unless it needs to persist across routes
- React Hook Form only for complex multi-step forms — simple forms don't need a library

## File Structure

```
src/
  components/             # Shared, reusable UI components
    Button.tsx
    Modal.tsx
  features/               # Feature-specific code
    users/
      UserList.tsx
      UserCard.tsx
      useUsers.ts
      users.api.ts
      users.types.ts
  hooks/                  # Shared hooks
  types/                  # Shared types
  App.tsx
  main.tsx
```

- Group by feature — co-locate components, hooks, types, and API calls together
- Shared components rise to `components/` only when genuinely reused across features
- One component per file

## Styling

- Use whatever approach the project already uses
- If starting fresh: **Tailwind CSS** or **CSS Modules**
- Component-scoped styles — avoid global CSS beyond resets and design tokens
- Responsive design from the start — mobile-first

## Performance

- Don't optimize prematurely — React is fast by default
- Profile with React DevTools before adding `React.memo`, `useMemo`, `useCallback`
- Virtualize long lists (`@tanstack/react-virtual`)
- Lazy load routes and heavy components with `React.lazy` + `Suspense`
- Avoid creating new objects/arrays in JSX props on every render

## Build Tool

- **Vite** as the default (aligns with `coding-typescript`)
- Use Vite's HMR and fast refresh — no extra config needed for React

## Testing

- **Vitest** + **React Testing Library** for component tests
- Test what the user sees and does — not implementation details
- Query by role, label, or text — not by test IDs or class names
- Avoid testing internal state — test the rendered output

## Avoid

- `useEffect` for derived/computed state — compute during render
- Prop drilling beyond 2 levels — use composition or context
- `dangerouslySetInnerHTML` unless content is sanitized
- Direct DOM manipulation — use refs only when React can't handle it
- God components that own too much state and logic
- Premature splitting into too many tiny components — readability matters
- `forwardRef` unless the component genuinely needs to expose a DOM node

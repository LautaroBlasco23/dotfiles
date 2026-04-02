---
name: coding-typescript
slug: coding-typescript
description: >-
  TypeScript coding standards and patterns.
  TRIGGER when: writing, modifying, or reviewing TypeScript code, or working in a project with tsconfig.json or package.json with TypeScript dependencies.
  DO NOT TRIGGER for non-TypeScript code.
---

# TypeScript Standards

TypeScript conventions for production code. Apply alongside `coding-principles`.

## Strict Mode

- `"strict": true` in tsconfig — non-negotiable
- Never use `any` — use `unknown` + type narrowing when the type is uncertain
- Enable `noUncheckedIndexedAccess` for safer array/object access

## Types

```typescript
// Prefer discriminated unions over optional fields
type Result<T> =
  | { ok: true; data: T }
  | { ok: false; error: string }

// Derive types from data when possible
const ROLES = ["admin", "user", "viewer"] as const
type Role = (typeof ROLES)[number]
```

- `type` over `interface` unless you need declaration merging
- Derive types: `typeof`, `keyof`, `ReturnType`, `Awaited`
- `as const` for literal types and exhaustive checks
- Generics only when they reduce real duplication — avoid over-engineering
- Zod for runtime validation at boundaries (API inputs, form data, env vars)

## Error Handling

- Use typed Result types or custom Error classes at domain boundaries
- `try/catch` only around I/O operations — not around business logic
- Never catch and ignore — always handle or rethrow with context
- Errors should describe what was attempted

## Functions

```typescript
// Explicit return types on exported functions
export function createUser(input: CreateUserInput): Promise<User> {
  // ...
}
```

- Small functions, one responsibility
- Explicit return types on public API / exported functions
- Arrow functions for callbacks, named functions for top-level declarations
- Prefer pure functions — push side effects to the edges
- `const` by default, `let` only when mutation is truly required

## Modules & Imports

- Named exports over default exports
- Barrel files (`index.ts`) only at module boundaries — not in every folder
- Import order: node builtins → external packages → internal modules → relative
- Avoid circular dependencies — they signal wrong boundaries

## Async

- `async/await` over raw Promise chains
- Always handle rejections — no unhandled promises
- `Promise.all()` for independent concurrent operations
- `Promise.allSettled()` when partial failure is acceptable
- Set timeouts on external calls — never wait forever

## Build Tool

- **Vite** as the default build tool
- Minimal config — rely on Vite defaults where possible
- Use Vite's built-in features before reaching for plugins

## Testing

- **Vitest** as the default test runner (Vite-native, fast)
- Test behavior, not implementation
- Co-locate tests: `user.ts` → `user.test.ts`
- Factory functions for test data — not hardcoded fixtures
- Mock only external boundaries (network, filesystem) — use real code internally

## Project Structure

```
src/
  features/             # Feature-specific code grouped by domain
    users/
      users.service.ts
      users.types.ts
      users.test.ts
  lib/                  # Shared utilities
  types/                # Shared type definitions
  main.ts               # Entry point
```

Group by feature. Shared code rises to `lib/` or `types/` only when genuinely reused.

## Avoid

- `any` — use `unknown` + type guards
- `enum` — use `as const` objects or union types
- Class-heavy OOP — prefer functions + types
- Deep inheritance hierarchies
- Over-abstraction with generics
- Barrel re-exports in every folder
- `@ts-ignore` / `@ts-expect-error` without an explanation comment
- Default exports — named exports are greppable and refactor-safe

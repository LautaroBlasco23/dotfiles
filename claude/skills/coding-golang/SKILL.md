---
name: coding-golang
slug: coding-golang
description: >-
  Idiomatic Go coding standards, patterns, and conventions.
  TRIGGER when: writing, modifying, or reviewing Go code, or working in a project with go.mod.
  DO NOT TRIGGER for non-Go code.
---

# Go Standards

Idiomatic Go conventions for production code. Apply alongside `coding-principles`.

## Style

- `gofmt` and `go vet` are non-negotiable
- Short, clear names: `srv` not `server`, `u` not `user` (in small scopes)
- Receivers: short (1-2 chars), consistent across methods of the same type
- Acronyms stay capitalized: `ID`, `HTTP`, `URL`
- Package names: lowercase, single word, no underscores
- Exported names need no package prefix: `user.New()` not `user.NewUser()`

## Error Handling

```go
if err != nil {
    return fmt.Errorf("creating user: %w", err)
}
```

- Always wrap with `%w` and describe **what was attempted**
- Define sentinel errors for domain boundaries:
  ```go
  var ErrNotFound = errors.New("not found")
  var ErrConflict = errors.New("already exists")
  ```
- Check with `errors.Is()` and `errors.As()` — never compare strings
- Never use `panic` in library or production code
- Handle `sql.ErrNoRows` explicitly — map to domain errors

## Interfaces

- Define where consumed, not where implemented
- 1-3 methods max
- Use concrete types by default — interfaces only for polymorphism or testing seams
- stdlib interfaces are your vocabulary: `io.Reader`, `io.Writer`, `http.Handler`, `fmt.Stringer`

## Context

```go
func (s *Service) CreateUser(ctx context.Context, input CreateUserInput) (*User, error)
```

- Always first parameter in any function that does I/O
- Never store in a struct
- Respect cancellation in long-running or concurrent operations:
  ```go
  select {
  case <-ctx.Done():
      return ctx.Err()
  case result := <-ch:
      // process
  }
  ```

## Concurrency

- No unbounded goroutines — always control lifecycle
- `errgroup.Group` for parallel tasks with error handling and cancellation
- `sync.WaitGroup` for fire-and-forget coordination
- Channels for communication, mutexes for state protection
- Always handle goroutine cleanup on context cancellation
- Never start a goroutine without knowing how it stops

## Constructors & Configuration

```go
func NewServer(db *sql.DB, logger *slog.Logger, opts ...Option) *Server
```

- `NewX` constructors with explicit dependencies as parameters
- Functional options pattern for optional configuration
- Validate and fail at construction time, not at use time

## HTTP — Fiber

- **Fiber** is the default web framework
- Group routes by domain: `api.Route("/users", userHandler.Register)`
- Middleware for cross-cutting concerns: auth, logging, recovery, request ID
- Parse and validate request input early in the handler
- Return consistent error responses with appropriate status codes:
  ```go
  func (h *UserHandler) Create(c fiber.Ctx) error {
      var input CreateUserInput
      if err := c.BodyParser(&input); err != nil {
          return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "invalid input"})
      }
      // ...
  }
  ```
- Separate handler logic from business logic — handlers parse/respond, services decide

## Database — sqlx + pgx

- Use `sqlx` with `pgx` driver for PostgreSQL
- **Repository pattern**: one file per domain (e.g., `user_repository.go`)
- Named queries with struct scanning:
  ```go
  func (r *UserRepo) GetByID(ctx context.Context, id string) (*User, error) {
      var user User
      err := r.db.GetContext(ctx, &user, `SELECT * FROM users WHERE id = $1`, id)
      if errors.Is(err, sql.ErrNoRows) {
          return nil, ErrNotFound
      }
      if err != nil {
          return nil, fmt.Errorf("getting user %s: %w", id, err)
      }
      return &user, nil
  }
  ```
- Always pass `ctx` to database calls
- Use transactions for multi-step write operations:
  ```go
  tx, err := r.db.BeginTxx(ctx, nil)
  if err != nil {
      return fmt.Errorf("starting transaction: %w", err)
  }
  defer tx.Rollback()
  // ... operations ...
  return tx.Commit()
  ```
- Keep SQL in the repository — don't leak it into services

## Logging — slog

```go
slog.Info("user created", "user_id", id, "email", email)
```

- Use `log/slog` (stdlib structured logging)
- Log at boundaries: HTTP handlers, service entry points, external calls
- Include context: request ID, user ID, operation name
- Levels: `Debug` for dev, `Info` for events, `Warn` for recoverable issues, `Error` for failures
- Never log passwords, tokens, or PII

## Testing

```go
func TestCreateUser(t *testing.T) {
    tests := []struct {
        name    string
        input   CreateUserInput
        wantErr bool
    }{
        {name: "valid input", input: CreateUserInput{Name: "Alice"}, wantErr: false},
        {name: "empty name", input: CreateUserInput{Name: ""}, wantErr: true},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // ...
        })
    }
}
```

- Table-driven tests as the default pattern
- Use stdlib `testing` package
- Test files next to source: `user.go` → `user_test.go`
- Use real structs over mocks unless hitting external services
- `testify` is acceptable for assertions when it improves readability
- Name tests after the behavior they verify, not the function name

## Project Structure

```
cmd/app/main.go
internal/
  {domain}/
    domain.go             # Entities, value objects, interfaces, errors
    service.go            # Business logic / use cases
    repository.go         # Database queries (sqlx)
    handler.go            # HTTP handlers (Fiber)
    wiring.go             # Dependency wiring
```

Defer to the `architecture` skill for full project structure decisions.

## Approved Patterns

| Pattern | When to use |
|---|---|
| Functional options | Config-heavy constructors |
| Worker pool | Controlled parallelism with bounded resources |
| Pipeline | Streaming transformations (channels) |
| Fan-out / fan-in | Parallel processing + merge results |
| Middleware | Cross-cutting HTTP/handler concerns |
| Repository | Database access isolated per domain |
| Decorator | Wrapping behavior (logging, metrics, retries) |
| Strategy (interface) | Swappable behavior at runtime |
| errgroup | Parallel tasks with shared cancellation |

## Avoid

- Java-style forced layering — keep it flat until complexity demands otherwise
- Interfaces for every struct — use concrete types by default
- Global mutable state — pass dependencies explicitly
- Reflection — unless truly unavoidable
- Goroutine leaks — every goroutine must have a shutdown path
- External dependencies when stdlib works — check stdlib first
- `init()` functions — prefer explicit initialization in `main()`
- Naked returns — always name what you're returning

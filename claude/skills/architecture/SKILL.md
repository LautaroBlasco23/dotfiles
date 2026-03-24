---
name: architecture
slug: architecture
description: >-
  Guidance on system architecture and design patterns.
  TRIGGER when: user asks to design a system, plan a new service, choose a pattern, or review architecture.
  DO NOT TRIGGER for small, isolated changes.
---

# Architecture Prompt

When designing systems, prefer a modular monolith with per-domain layering (Clean Architecture / Hexagonal).

## Suggested Structure

cmd/                          # Entry points
  api/main.go                 # Application entry point

internal/                     # Domain code
  api/                        # Shared infrastructure (cross-cutting)
    domain/                   # Global interfaces, errors
    infrastructure/           # Shared implementations (validator, ID generator)
  {domain}/                   # Each domain (user, store, auth, product...)
    domain/                   # Entities + repository interfaces
    application/              # Use cases / service layer
    infrastructure/           # Controllers, DTOs, repos, wiring

## Layer Responsibilities

- **domain**: Entities, value objects, repository interfaces, domain events
- **application**: Use cases, service orchestration, command/query handlers
- **infrastructure**: Controllers, DTOs, repository implementations, wiring

## Key Patterns

- **Wiring pattern**: Each module has `infrastructure/wiring.go` that instantiates all layers and registers routes
- **Interface boundaries**: Repository interfaces defined in domain, implemented in infrastructure
- **Shared errors**: Centralized in internal/api/domain/errors.go
- **Entry point**: main.go initializes modules in dependency order, passing shared dependencies (DB, etc.)
- **Cross-module dependencies**: Define explicit dependency graph (e.g., auth depends on user + store)

## Considerations

- separation of concerns
- testability
- scalability
- module initialization order
- dependency injection strategy

Mention trade-offs when proposing designs.
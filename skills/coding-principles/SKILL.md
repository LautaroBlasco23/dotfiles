---
name: coding-principles
slug: coding-principles
description: >-
  Universal code quality principles, language-agnostic.
  TRIGGER when: user asks to implement a feature, write new code, or build something from scratch.
    TRIGGER when: implementing new features, making architectural decisions, refactoring existing code, generating production-ready code
  Also loaded by the build skill.
---

## Simplicity

- Flat over layered when structure isn't justified
- Small functions with a single responsibility.
- Extract only when readability improves.- Return early to reduce nesting
- Three similar lines > premature abstraction
- Only abstract when a pattern has proven itself across 3+ real use cases

#### Before adding new code:
- Can existing code be extended instead?
- Can existing abstractions be reused?
- Prefer modifying working code over introducing parallel paths.


## Error handling

- Never swallow errors
- Wrap with context describing **what was attempted**: `"creating user: %w"`
- Domain-specific error types at system boundaries
- Fail fast on invalid state
- Validate at boundaries (user input, external APIs) — trust internal code

## Dependencies

- Pass via constructors — never use globals or service locators
- Accept interfaces, return concrete types
- Dependencies flow downward: handlers → services → repositories

## Resource safety

- Close what you open (files, connections, response bodies)
- Set timeouts on all I/O (HTTP, DB, external calls)
- Handle cancellation in concurrent work

## Code organization

- Group by feature/domain, not by technical layer
- Public API minimal — expose only what consumers need
- Internal details stay private

## Logging

- Structured, with context (request ID, user ID, operation name)
- Log at boundaries only
- Never log passwords, tokens, or PII

## Security

- Validate all external inputs at the boundary
- No panic/crash in production paths
- Sanitize data before outputting to different contexts (HTML, SQL, logs)

## Decision checklist

Before writing code:
1. Can this be simpler?
2. Is this abstraction justified by real (not hypothetical) reuse?
3. Does the standard library solve this?
4. Are errors handled with context?
5. Are resources cleaned up?

---
name: coding-principles
slug: coding-principles
description: >-
  Core coding principles for writing high-quality, maintainable code.
  TRIGGER when: user asks to implement a feature, write new code, or build something from scratch.
  Complements the architecture skill (structure) with how to write the code itself.
---

# Coding Principles

Universal principles for production-grade code. Language-specific conventions live in dedicated `coding-*` skills — this skill defines the rules that apply regardless of language.

## Core Philosophy

**Make it work → Make it clear → Make it reusable**

- Resist abstraction by default
- Prefer duplication over wrong generalization
- Only abstract when a pattern has proven itself across 3+ use cases
- Solve the current problem, not hypothetical future ones

## Simplicity First

- Flat over layered when structure isn't justified
- Small functions with one clear responsibility (~30 lines max)
- Return early to reduce nesting
- No unnecessary patterns, frameworks, or indirection
- Three similar lines of code > premature abstraction

## Error Handling

- Errors are explicit — never swallowed or ignored
- Wrap errors with context describing **what was attempted**, not just what failed
- Define domain-specific error types at system boundaries
- Fail fast on invalid state
- Validate at boundaries (user input, external APIs), trust internal code

## Dependency Injection

- Pass dependencies via constructors — never use globals or service locators
- Accept interfaces, return concrete types
- Dependencies flow downward: handlers → services → repositories
- Make dependencies explicit in function/constructor signatures

## Testing

- Test public behavior, not implementation details
- Prefer real dependencies over mocks unless the real thing is slow or flaky
- One test verifies one behavior
- Tests are documentation — name them so a reader understands what's being verified
- Co-locate tests with source code

## Resource Safety

- Always close what you open (files, connections, response bodies)
- Use defer/finally/dispose patterns appropriate to the language
- Set timeouts on **all** I/O operations (HTTP, DB, external calls)
- Handle cancellation and context propagation in async/concurrent work

## Code Organization

Works alongside the `architecture` skill:

- **Architecture** defines project structure and layer boundaries
- **This skill** defines how to write the code within those layers

Rules:
- Group by feature/domain, not by technical layer
- Keep modules small and focused
- Public API should be minimal — expose only what consumers need
- Internal implementation details stay private

## Logging & Observability

- Structured logging with context (request ID, user ID, operation name)
- Log at boundaries: HTTP handlers, service entry points, external calls
- Log **what happened** and **with what data**, not just "error occurred"
- Don't log sensitive data (passwords, tokens, PII)

## Security Basics

- Validate all external inputs at the boundary
- Never panic/crash in production code paths
- Timeouts everywhere: HTTP clients, DB queries, external services
- Sanitize data before outputting to different contexts (HTML, SQL, logs)

## Config Management

- Config via environment variables
- Validate config at startup — fail fast if required values are missing
- Immutable config structs — set once, read many

## Production Readiness

- Optimize for readability over cleverness
- Benchmark before optimizing — don't guess at bottlenecks
- Avoid allocations in hot paths only when measured
- Graceful shutdown: drain connections, finish in-flight work

## Decision Checklist

When writing code, ask:

1. Can this be simpler?
2. Is this abstraction justified by real (not hypothetical) reuse?
3. Can the standard library solve this?
4. Are errors handled with context?
5. Are resources properly cleaned up?
6. Would a new team member understand this without explanation?

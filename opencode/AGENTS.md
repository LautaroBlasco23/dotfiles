# Core Philosophy

Every line of code becomes a long-term liability.

Treat code as a maintenance cost, not an asset.

The highest-quality solution is one that:
- solves the problem,
- introduces the least complexity,
- maximizes reuse,
- minimizes future maintenance,
- and remains obvious to the next engineer.

# Universal Engineering Principles

These rules apply to every software engineering task regardless of language, framework, repository, or technology stack.

The objective is not to generate code.

The objective is to improve the software with the smallest correct, maintainable, and well-reasoned change.

---

# 1. Think Before Coding

Never begin implementation immediately.

First:

* Understand the problem.
* Identify the actual requirement.
* Understand the current architecture.
* Identify constraints.
* Identify existing solutions.
* Determine the smallest correct change.

Implementation is the final step—not the first.

---

# 2. Evidence Over Assumptions

Never assume how the system works.

Inspect:

* source code
* tests
* documentation
* configuration
* build scripts

Base every decision on evidence from the repository.

If evidence is missing, explicitly state assumptions instead of presenting them as facts.

---

# 3. Understand Before Modifying

Do not modify code that has not been understood.

Before changing existing code, determine:

* its purpose
* its dependencies
* who calls it
* what depends on it
* important invariants
* possible side effects

---

# 4. Reuse Before Creating

Always prefer, in order:

1. Existing project code
2. Standard library
3. Existing project dependencies
4. Framework capabilities
5. New implementation

Treat new code as the last option.

---

# 5. Delete Before Adding

Before writing new code, ask:

* Can existing code be reused?
* Can existing code be extended?
* Can duplicate code be removed?
* Can obsolete code be deleted?
* Can complexity be reduced instead?

Removing unnecessary code is often the highest-value improvement.

---

# 6. Prefer Simplicity

Choose the solution with:

* fewer concepts
* fewer abstractions
* fewer moving parts
* lower cognitive load
* clearer behavior

Avoid solving hypothetical future problems.

Simple solutions age better.

---

# 7. Minimize Maintenance Cost

Every new artifact creates long-term cost.

Before introducing:

* files
* packages
* modules
* classes
* interfaces
* abstractions
* dependencies
* configuration
* services

Ask:

"Will this permanently reduce complexity?"

If not, avoid introducing it.

---

# 8. Keep Scope Small

Implement only what was requested.

Avoid adding:

* speculative features
* future-proofing
* optional architecture
* unrelated improvements
* hidden behavioral changes

Every change should have a clear justification.

---

# 9. Stay Consistent

Prefer consistency over personal preference.

Match the repository's existing conventions:

* architecture
* naming
* project structure
* dependency injection
* error handling
* logging
* testing style
* formatting

The code should look like it belongs in the project.

---

# 10. Refactor Opportunistically

Whenever touching existing code:

* remove duplication
* improve naming
* simplify logic
* eliminate dead code
* reduce nesting
* reduce complexity

Leave the surrounding code cleaner than you found it.

---

# 11. Avoid Premature Abstraction

Do not introduce abstractions without multiple concrete use cases.

Avoid creating:

* generic managers
* factories
* adapters
* strategy patterns
* plugin systems
* extension points

Generalize only after repetition proves the abstraction is valuable.

---

# 12. Prefer Composition

Prefer:

* composition
* configuration
* extension

Over:

* inheritance
* deep abstraction hierarchies
* unnecessary polymorphism

---

# 13. Optimize for Readability

Code is read far more often than it is written.

Prioritize:

* explicit behavior
* meaningful names
* predictable control flow
* clear error handling
* straightforward logic

Avoid cleverness.

---

# 14. Preserve Existing Behavior

Unless explicitly requested:

* avoid breaking public APIs
* preserve backward compatibility
* avoid changing observable behavior
* minimize migration cost

Changes should be intentional.

---

# 15. Respect Performance

Do not optimize prematurely.

However, avoid obvious inefficiencies such as:

* repeated work
* duplicate queries
* unnecessary allocations
* unnecessary I/O
* unnecessary network calls
* inefficient algorithms

Write reasonable code first.

Optimize when evidence justifies it.

---

# 16. Verify Changes

Before considering work complete, verify:

* correctness
* edge cases
* error paths
* resource cleanup
* backward compatibility
* test impact

Never assume a change works because it compiles.

---

# 17. Explain Trade-offs

When multiple valid approaches exist:

* briefly compare them
* explain the chosen solution
* justify the decision

Favor reasoning over opinion.

---

# 18. Local Changes Over Global Rewrites

Prefer the smallest localized change that solves the problem.

Avoid rewriting large sections of the system unless:

* explicitly requested
* the existing implementation is fundamentally incorrect
* the benefits clearly outweigh the migration cost

---

# 19. Security Is Non-Negotiable

Never simplify away:

* authentication
* authorization
* validation
* input sanitization
* error handling
* secrets management
* auditability

Minimal code must still be secure.

---

# 20. Engineer, Don't Generate

Act as an experienced software engineer.

Every decision should balance:

* correctness
* maintainability
* simplicity
* consistency
* operational safety
* long-term ownership

The best solution is not the one that produces the most code.

It is the one that delivers the greatest value with the least unnecessary complexity.


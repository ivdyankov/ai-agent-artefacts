---
name: clean-code-architect
description: >
  Clean-code and anti-slop rules for writing, reviewing, or refactoring code.
user-invocable: true
disable-model-invocation: true
---

# Clean Code Architect

Heuristics, not laws: follow repository idioms, architecture, contracts, and
performance needs. Preserve observable behavior unless asked otherwise.

## Scope and review

- Invoke with `/clean-code-architect`. If unspecified, clarify scope (diff,
  files, or project) and mode (review or implementation). Never edit in review mode.
- Inspect relevant source, tests, and configuration; skip generated, dependency,
  and vendored code. Diff reviews include staged and unstaged changes.
- Report only evidence-backed findings: file, line, concrete consequence, and
  smallest safe recommendation. Rank by impact; distinguish defects from optional
  maintainability improvements. Omit unsupported style preferences.
- State inspection coverage and limits; do not imply exhaustive project review.
  If no actionable findings exist, say so.

## Design

- Use intention-revealing names, cohesive functions, few arguments, and consistent
  abstraction levels. Use options objects only when they improve cohesion.
- Bound cleanup to touched areas; stop before unrelated redesigns, broad renames,
  API changes, or rewrites.
- Hide unstable internals or expose intentional data structures. Avoid output
  arguments and surprising side effects; make mixed command/query contracts explicit.
- Extract cohesive responsibilities or shared domain rules, not hypothetical reuse
  or arbitrary line counts. Do not merge similar code with different meanings.

## Comments and smells

- Explain non-obvious intent, not obvious mechanics. Delete commented-out code.
- Remove demonstrably unused code or redundant checks after checking callers,
  registration/reflection, and contracts; avoid filler abstractions and messages.
- Name literals when this explains domain meaning; leave obvious literals inline.
- Prefer positive conditions and declarations near use without contorting clear code.

## Errors and observability

- Use idiomatic error and absence models; preserve context and meaningful nullable
  contracts. Handle errors at meaningful boundaries.
- Validate external inputs/responses; trust established internal invariants.
  Avoid speculative checks, broad catches, and silent failures.
- Log operationally useful structured context at project-standard levels, never
  secrets or sensitive payloads.

## Validate

- For changes, test affected behavior and error paths; run the narrowest relevant
  tests, type checks, and linters. Consider hot paths before adding allocations or I/O.
- Report changes, verification, and checks that could not run.

## TDD (opt-in)

Read [`TDD.md`](TDD.md) only when requested; apply until the user disables TDD
or the session ends.

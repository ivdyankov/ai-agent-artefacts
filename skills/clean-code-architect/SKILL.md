---
name: clean-code-architect
description: >
  Clean-code and anti-slop rules for writing, reviewing, or refactoring code.
  Covers naming, design, errors, comments, smells, and validation.
user-invocable: true
disable-model-invocation: true
---

# Universal Clean Code Architect

These are heuristics, not laws. Follow the repository's language idioms,
architecture, API contracts, performance needs, and existing voice first.
Preserve observable behavior unless the requested change says otherwise.

## Usage

Invoke explicitly with `/clean-code-architect`, then choose a scope:

```text
/clean-code-architect
Review the current git diff, including staged and unstaged changes. Report
actionable clean-code issues with file, line, rationale, and recommendation.
Do not modify files.
```

```text
/clean-code-architect
Review the current project for clean-code issues. Inspect relevant source,
tests, and configuration; skip generated files, dependencies, and vendored
code. Prioritize actionable findings and report files and lines. Do not modify
files.
```

```text
/clean-code-architect
Review these files: src/example.ts and tests/example.test.ts. Check the
implementation and its tests against the skill's principles, then suggest the
smallest safe improvements.
```

For implementation work, be explicit:

```text
/clean-code-architect
Apply the clean-code improvements to the current diff. Preserve behavior,
avoid unrelated refactors, update tests when needed, and run the narrowest
relevant validation.
```

## Design

- Optimize for the reader: use intention-revealing names and one clear
  abstraction level per function.
- Keep incidental cleanup bounded to the touched area; stop before a separate
  design decision, broad rename, API change, or rewrite.
- Prefer cohesive functions with few arguments. Use an options object only when
  it improves cohesion; avoid output arguments and surprising side effects.
- Avoid chains that expose unstable internals. Choose either behavior-hiding
  objects or intentionally exposed data structures.
- Keep commands and queries distinct where practical; if a method does both,
  make that contract explicit.

## Comments and smells

- Comment non-obvious intent or business context, not what the code already
  says. Delete commented-out code.
- Remove dead code, magic values, redundant checks, filler abstractions, and
  placeholder messages.
- Prefer positive conditions and keep declarations near their use, but do not
  contort clear code to satisfy a heuristic.
- Extract a repeated concept when it has a meaningful name, stable contract, or
  likely second caller; do not extract by line count alone.
- Match the codebase's naming, patterns, and paradigm.

## Errors and observability

- Use the repository's idiomatic error model; preserve context and handle
  errors at meaningful boundaries.
- Model absence using the language/API's idiomatic representation. Preserve
  nullable or equivalent boundary contracts when they are meaningful.
- Validate user input and external responses; trust established internal
  invariants rather than adding speculative checks or broad catches.
- Log only where operationally useful, using project levels and structured
  context. Never log secrets or sensitive payloads.

## Validate

- Run the narrowest relevant tests, type checks, and linters.
- Test changed behavior and important error paths; consider performance-sensitive
  paths before adding allocations, abstraction, or I/O.
- Report what changed, what was verified, and any checks that could not run.

## TDD (opt-in)

When the user asks for TDD, read [`TDD.md`](TDD.md) and use its three laws,
red-green-refactor cycle, and F.I.R.S.T. principles for the rest of the session.

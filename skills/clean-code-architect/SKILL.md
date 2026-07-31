---
name: clean-code-architect
description: >
  Clean-code and anti-slop rules for any task that produces or changes code.
  Use whenever writing, reviewing, or refactoring code in any language.
  Covers naming, function design, error handling, comments, code smells, and AI slop prevention.
---

# The Universal Clean Code Architect

> Based on *Clean Code: A Handbook of Agile Software Craftsmanship* by Robert C. Martin.

## Core Philosophy

- **One thing, for the reader:** Each unit does one thing well; optimize for the reader, since code is read far more than written.
- **Boy Scout Rule:** Leave code cleaner than found, but cap incidental fixes at 2-3 per file (rename a misleading variable, extract one small function, replace a magic value) — no snowballing into a rewrite; keep the diff reviewable.

## Naming

- **Intention-revealing:** A name says why it exists and how it's used; if it needs a comment, it failed. Length matches scope.
- **Plain:** No single-letter names (except locals in tiny methods), no encodings — `m_` prefixes, Hungarian notation, or mental-map abbreviations.

## Functions & Methods

- **One thing, one abstraction level:** Small functions that read top-down as a narrative (stepdown rule).
- **Argument count:** Zero or one ideal; three needs justification, four+ special justification.
- **No output arguments:** Mutate the owning object's state instead.
- **Command-query separation:** A function changes state OR returns information, never both.

## Comments Policy

- **Comment only non-obvious intent:** Let well-named functions and variables carry meaning; reserve comments for business context or intent that naming cannot express. A restating comment (`// increment counter` above `counter++`) is slop.
- **Delete commented-out code:** Remove it on sight — it pollutes modules and confuses readers.

## Objects vs. Data Structures

- **Law of Demeter:** Talk only to immediate friends — no chains like `a.getB().getC().doSomething()`.
- **Pick one:** Objects hide data and expose behavior; data structures expose data and have no behavior. Don't blur them.

## Error Handling

- **Exceptions over error codes:** Separate the happy path from error processing.
- **Extracted try/catch:** Move try/catch blocks into their own functions so main logic stays clear.
- **Never return or pass null:** Use empty collections or Special Case objects instead. Exception: when an external API explicitly requires null as a parameter, passing null is acceptable at the boundary.

## Smells & Heuristics

- **Dead code:** Discard methods and logic that are never executed.
- **Magic numbers:** Replace raw numbers/tokens with well-named constants.
- **Negative conditionals:** Express logic as positives whenever possible.
- **Vertical separation:** Define variables and functions close to where they are used.
- **Redundant conditionals:** After an early return or guard clause, do not re-check the same condition — it's already guaranteed by the control flow.
- **Arbitrary structure:** Code structure must have a clear, self-communicating reason.

## Anti-Slop Rules

AI-generated code has recognizable tells. Lead with the positive behavior:

- **Log only where observability is needed:** One log at an entry point is fine; keep intermediate steps silent unless the caller asked for them.
- **Guard at boundaries, trust internals:** Validate user input and external-API responses; skip "just in case" null checks and try/catch on internal code paths.
- **Abstract on the third repetition:** Inline one-off logic — three similar lines beat a premature helper. Extract only when reuse is real.
- **Return expressions directly:** Skip a variable that exists only to be returned on the next line, unless its name adds genuine clarity.
- **Make every line earn its place:** Drop empty constructors, default toString methods, unused parameters, and placeholder messages like "Something went wrong."
- **Match the codebase voice:** Adopt the surrounding naming, patterns, and paradigm; introduce a new one (e.g. functional into OOP) only when asked.

## TDD Workflow (opt-in)

When the user asks for TDD ("use TDD"), enable it for the rest of the session and read [`TDD.md`](TDD.md) for the three laws, the red-green-refactor cycle, and F.I.R.S.T. principles. Do not proactively offer TDD otherwise.

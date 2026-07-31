# TDD Workflow

> Based on the TDD discipline from *Clean Code* by Robert C. Martin.

Enabled only when the user opts in ("use TDD"). Once enabled, apply to all code for the rest of the session — new features, bug fixes, refactoring, and legacy code.

## The Three Laws of TDD

Follow these laws strictly and in order:

1. **First Law:** Do not write production code until you have written a failing unit test.
2. **Second Law:** Do not write more of a unit test than is sufficient to fail — and not compiling counts as failing.
3. **Third Law:** Do not write more production code than is sufficient to pass the currently failing test.

Cycle: write one small failing test → write minimal production code to pass → refactor → repeat.

## The F.I.R.S.T. Principles

All tests produced under this workflow must be:

- **Fast:** Tests run quickly — no sleeps, no heavy I/O unless unavoidable.
- **Independent:** Tests do not depend on each other or on execution order.
- **Repeatable:** Tests work in any environment without external state.
- **Self-Validating:** Tests have a boolean outcome (pass/fail) — no manual inspection.
- **Timely:** Tests are written just *before* the production code they verify.

# TDD Workflow

> Based on the TDD discipline from *Clean Code* by Robert C. Martin.

Opt-in ("use TDD"); applies until disabled by the user or the session ends.

## Red-green-refactor

For new behavior and bug fixes:

1. Write only enough test code to expose the next missing behavior.
2. Run it before implementation; confirm failure for the intended reason.
   Compilation failure from a missing target API counts; missing dependencies
   or unrelated setup failures do not.
3. Write only enough production code to pass; rerun the test to observe green.
4. Refactor while green, then run the relevant suite. Repeat.

For behavior-preserving refactoring, including legacy code, first establish
passing coverage; add characterization tests where needed. Refactor while
keeping tests green; do not manufacture a failure.

If execution is unavailable, report the cycle as unverified; do not claim
observed red/green results.

## F.I.R.S.T.

- **Fast:** Avoid sleeps and unnecessary heavy I/O.
- **Independent:** No execution-order or cross-test dependencies.
- **Repeatable:** Control time, randomness, and external state in supported environments.
- **Self-validating:** Automated pass/fail assertions.
- **Timely:** Tests precede behavior changes; coverage precedes refactoring.

---
name: go-code-review
description: Reviews Go code for correctness, concurrency, errors, tests, and API design. Use when reviewing pull requests, examining Go diffs, or when the user asks for a Go code review.
---

# Go code review

## Instructions

1. **Scope**: Read the changed files and nearby call sites; note exported API changes and version/module impact.
2. **Correctness**: Trace control flow; check nil handling, bounds, and error branches.
3. **Concurrency**: Flag data races, unsynchronized shared state, goroutine leaks, and misuse of `WaitGroup` / channels; suggest `go test -race` when relevant.
4. **Errors**: Ensure errors are wrapped with context (`fmt.Errorf` with `%w` where appropriate); no silent ignores without justification.
5. **Context**: Verify `context.Context` is passed and respected on I/O and cancelable work.
6. **Tests**: Check table-driven coverage, edge cases, and that new behavior has tests; integration tests marked or short-mode gated if slow.
7. **API**: Exported names, godoc, backward compatibility; avoid breaking changes without migration notes.

## Output format

- **Blocking**: Must fix before merge (correctness, security, data loss).
- **Should fix**: Strongly recommended (bugs waiting to happen, API debt).
- **Nit**: Optional style or minor clarity.

## Optional reference

Team-specific standards can live in `reference.md` next to this skill; read it only if present.

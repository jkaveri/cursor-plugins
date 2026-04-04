---
name: go-logging-audit
description: >
  Audits logging in Go files or packages: Debug/Info/Error choice, whether Error is
  duplicated across middleware vs handlers, WithContext and WithError usage, structured
  Attrs, and noise. Treats Error as the boundary/terminal log per failure when outer layers
  already log errors. Use when reviewing log levels, logging patterns, or observability.
---

# Go logging audit

**Scope:** logging only—**not** a general correctness or security code review (use **go-code-review** for that).

Audit **one or more `.go` files** or a **whole package** (directory). Prefer **small, targeted edits** to logging calls and logger wiring.

## 1) Scope the target

- **Files:** user-provided paths → read those files; follow logger types through imports if the audit needs it.
- **Package:** all `*.go` in that directory (include `*_test.go` only if the user cares about test logs).
- Identify which **logger** the code uses (prefer **`github.com/jkaveri/golog/v2`** semantics below; if the project uses another API, map recommendations to that API).

## 2) Audit dimensions

Work through the scoped code and note issues under these headings. Prefer the philosophy in [Let’s talk about logging](https://dave.cheney.net/2015/11/05/lets-talk-about-logging): fewer levels, and **not** every `if err != nil` implies an **`Error`** log line.

### Levels and call-chain ownership

- **`Error`** should be **authoritative** for that failure: typically **one** **`Error`** per logical incident at the **boundary** (middleware, job runner, `main`) that owns observability—not repeated at **`Error`** in both middleware **and** inner handler for the same returned `err`.
- If **middleware** (or recovery, or RPC interceptor) already logs failures at **`Error`**, flag **duplicate `Error`** inside handlers/services → recommend **`return err`** only, or **`Info` + `WithError(err)`** for a breadcrumb, not a second **`Error`**.
- **`Info` + `WithError`**: appropriate for “failure occurred here but the **terminal** log is elsewhere” or recoverable/handled paths (see team **`go-logging.mdc`**).
- **`Debug`** vs **`Info`**: hot paths, retries, per-item loops → often **Debug** or aggregate **Info**; avoid **Info** spam.
- Any **`Warn`**-style usage → **`Info`** (golog/v2 has no `Warn`).

### Context

- Functions that take **`context.Context`**: is logging done with **`log.WithContext(ctx)`** (or equivalent) for that function’s body?
- Avoid mixing context-aware and non-context-aware loggers in the same function.

### Errors (content, not just API)

- Is **`WithError(err)`** paired with the **right level**? **`Error`** only when this site owns the failure record; otherwise **`Info`** (or no log) when returning to a boundary logger.
- Same failure at **`Error`** in **multiple** stack frames without new operational value → consolidate or downgrade inner logs to **`Info`**.

### Structure

- Identifiers and dimensions should be **`Attr`**s (`String`, `Int`, **`Group`**, **`With`** for repeated scope), not only buried in the message string.
- Messages: **English**, **lowercase**; stable keys for search (`operation`, `component`, `request_id`, …).

### Safety

- Flag **secrets**, tokens, **PII**, or full request/response bodies in logs.

### Wiring

- If the package cannot log consistently because **`Logger`** is not passed in, suggest the **smallest** dependency-injection or constructor change that matches the repo—avoid introducing globals when the codebase already injects loggers.

## 3) Deliverables

1. **Findings** — grouped by the audit dimensions above (short bullets).
2. **Severity** — **Must fix** (duplicate **`Error`** for one incident, missing `WithContext` where required, leaks) vs **Should** vs **Optional**.
3. **Changes** — concrete patches or snippets (updated log lines / `With` / constructor signatures only).

## Reference

Align with **`godev/rules/go-logging.mdc`** when present (especially **Error severity and call chain**). Supplement with [Let’s talk about logging](https://dave.cheney.net/2015/11/05/lets-talk-about-logging) when discussing level minimalism.

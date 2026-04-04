---
name: go-write-test
description: Writes Go tests using strict table-driven tests (Args/Expects/Deps), testify assert/require, mockery-style EXPECT mocks, co-located mock_*_test.go files, and linear arrange/mock/act/assert flow. Use when adding or editing *_test.go, Go unit tests, mocks, or when the user asks for the go-write-test skill or strict TDT tests.
---

# Go write test

# Go Testing Standards (Strict TDT)

**Correctness over green builds:** The goal is **correct production behavior**, not a passing test run. Do **not** change implementation just to make tests green—e.g. removing validation, swallowing errors, returning hard-coded values, or dumbing down logic so assertions match. When a test fails, determine whether **the code is wrong** (fix the code) or **the test or expectations are wrong** (fix the test, mocks, or `Expects`). Never trade real correctness for convenience.

## 1) Required shape (inside each TestXxx)
Define these **inside** the test function (never global):

- `type Args struct { ... }` — inputs to the function under test
- `type Expects struct { ... }` — expected results (`want`, `wantErr`, etc.)
- `type Deps struct { ... }` — mocks/deps (**only if needed**)

Then define:

- `testCases := []struct { name string; args Args; expects Expects; mocks func(d Deps, a Args) }`

Rules:
- If no deps: omit `Deps` and omit `mocks` field entirely.
- Case names must be **lowercase kebab-case** (e.g. `success-create-user`, `repo-error`).
- **CRITICAL**: Never include mocks (e.g. `mockhandlers.NewHandler(t)`) in test case structs. Mocks must be initialized **inside** `t.Run` using the subtest's `*testing.T` instance.
- Static configuration (e.g. `*config.Config`) can be in test cases, but mocks that require `*testing.T` must be created in `t.Run`.

## 2) Time & dynamic values
- Define shared constants (e.g. `now := time.Date(...)`) once **inside** `TestXxx` and reuse in both `Args` and `Expects`.
- Avoid `time.Now()` and randomness unless explicitly tested.

## 3) Assertions (uniform, no branching by case)
- Use `assert` for values and `require` for blockers.
- Error check must use:
  - `assert.Equal(t, tc.expects.wantErr, err != nil, "unexpected error: %v", err)`
- **Always use `assert.Equal` or `require.Equal` to compare entire expected results**, not individual fields.
- For dynamic fields (e.g. generated IDs, timestamps), copy them from actual to expected before comparison.
- Prefer `assert.Equal` for struct/slice diff readability.
- Do **not** branch assertion logic based on `tc.name`.
- Do **not** compare individual fields when you can compare the entire result structure.

## 4) Mocking (strict)
- Use `.EXPECT()` only. Forbidden: `On()`, `When()` style mocking.
- Mock setup must run **before** constructing the system under test.
- Keep expectations minimal but strict (correct args/order/returns).
- **Generated mock file placement:** Emit mocks **next to the interface** they implement, in the **same package**, with a `mock_` prefix and **`_test.go` suffix** so mocks compile only in tests and stay out of non-test binaries. Example: interface `Enricher` → `mock_enricher_test.go`.
- Generate mocks with your project's command `godev mock`; if the repo still uses a central `./mock` tree, follow that repo's convention instead.

## 5) Execution flow (must be linear)
Inside each `t.Run` use this order, exactly:

1. **Arrange**: create mocks/deps + `Deps` struct **using the subtest's `*testing.T` instance**
2. **Mock**: `tc.mocks(deps, tc.args)` (only if not nil)
3. **Construct**: init service/instance under test
4. **Act**: call function under test
5. **Assert**: compare with `tc.expects`

**Important**: Mocks that require `*testing.T` (e.g. `mockhandlers.NewHandler(t)`) must be created inside `t.Run`, not in test case structs. This ensures each subtest has its own mock instance tied to the correct `*testing.T`.

## 6) Forbidden patterns
- **Papering over failures:** Altering production code only to satisfy tests (weaker invariants, fake success paths, deleted branches) when that misrepresents real requirements
- Deleting or skipping failing tests instead of fixing the underlying bug or updating wrong expectations
- `if tc.name == ...` / `switch tc.name` inside runner
- shared mutable state outside `t.Run`
- mixing different constructors/flows in one table — split into a new `TestXxx`
- **Including mocks in test case structs** — mocks must be initialized inside `t.Run` with subtest's `*testing.T`
  ```go
  // WRONG - mock created with parent test's *testing.T
  testCases := []struct {
    deps Deps{mockHandler: mockhandlers.NewHandler(t)} // BAD!
  }

  // CORRECT - mock created inside t.Run with subtest's *testing.T
  testCases := []struct {
    config *config.Config // OK - static config
  }
  t.Run(tc.name, func(t *testing.T) {
    deps := Deps{mockHandler: mockhandlers.NewHandler(t)} // GOOD!
  })
  ```

---

## Template

```go
func TestService_CreateUser(t *testing.T) {
	type Args struct {
		ctx  context.Context
		name string
	}
	type Expects struct {
		wantID  string
		wantErr bool
	}
	type Deps struct {
		repo *MockUserRepository // generated mock, same package (e.g. mock_user_repository_test.go)
	}

	testCases := []struct {
		name    string
		args    Args
		expects Expects
		mocks   func(d Deps, a Args)
	}{
		{
			name: "success-create-user",
			args: Args{ctx: context.Background(), name: "Alice"},
			expects: Expects{wantID: "123", wantErr: false},
			mocks: func(d Deps, a Args) {
				d.repo.EXPECT().Create(a.ctx, a.name).Return("123", nil)
			},
		},
		{
			name: "repo-error",
			args: Args{ctx: context.Background(), name: "Bob"},
			expects: Expects{wantID: "", wantErr: true},
			mocks: func(d Deps, a Args) {
				d.repo.EXPECT().Create(a.ctx, a.name).Return("", errors.New("db error"))
			},
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			// 1) Arrange
			deps := Deps{repo: NewMockUserRepository(t)}

			// 2) Mock
			if tc.mocks != nil {
				tc.mocks(deps, tc.args)
			}

			// 3) Construct
			svc := NewService(deps.repo)

			// 4) Act
			gotID, err := svc.CreateUser(tc.args.ctx, tc.args.name)

			// 5) Assert (uniform)
			assert.Equal(t, tc.expects.wantErr, err != nil, "unexpected error: %v", err)
			if err == nil {
				// Compare entire expected result, not individual fields
				assert.Equal(t, tc.expects.wantID, gotID)
			}
		})
	}
}
```

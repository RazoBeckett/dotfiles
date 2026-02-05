---
name: conventional-commits
description: Format git commit messages following the Conventional Commits specification. Use when the user asks to format commit messages, write commits, or mentions git commits, commit conventions, or commit message standards.
auto_detect_changes: true
git_inspection: true
fallback_to_user_input: true
---

# Conventional Commits

Help users write properly formatted conventional commit messages following the specification.

## Format Structure

```
<type>(<optional scope>): <description>

<optional body>

<optional footer>
```

## Commit Types

### API/UI Changes
- **feat**: Add, adjust, or remove a feature to the API or UI
- **fix**: Fix an API or UI bug from a previous `feat` commit

### Code Quality
- **refactor**: Rewrite or restructure code without altering API or UI behavior
  - **perf**: Special refactor that specifically improves performance
- **style**: Address code style only (whitespace, formatting, semi-colons) without affecting behavior

### Supporting Changes
- **test**: Add missing tests or correct existing ones
- **docs**: Changes that exclusively affect documentation
- **build**: Affect build components (tools, dependencies, project version)
- **ops**: Affect operational aspects (infrastructure, deployment, CI/CD, monitoring, backups)
- **chore**: Miscellaneous tasks (initial commit, modifying .gitignore)

## Formatting Rules

### Description
- **MANDATORY** field
- Use imperative present tense: "add" not "added" or "adds"
  - Think: "This commit will [description]"
- Do NOT capitalize first letter
- Do NOT end with period (.)
- Keep concise and under 100 characters

### Scope
- **OPTIONAL** contextual information
- Project-specific (e.g., `api`, `ui`, `shopping-cart`, `database`)
- Keep under 20 characters
- Do NOT use issue identifiers as scopes

### Breaking Changes
- Add `!` before `:` in subject line: `feat(api)!: remove status endpoint`
- Must include `BREAKING CHANGE:` in footer with explanation
- Footer required when breaking changes introduced

### Body
- **OPTIONAL** - explains motivation and contrasts with previous behavior
- Use imperative present tense
- Separate from description with blank line

### Footer
- **OPTIONAL** unless breaking changes present
- Reference issues: `Closes #123`, `Fixes JIRA-456`
- Breaking changes: `BREAKING CHANGE:` followed by explanation
  - Single line: space after colon
  - Multi-line: two newlines after colon
- Separate from body with blank line

## Special Commits

- **Initial commit**: `chore: init`
- **Merge commit**: Use default git merge message format
- **Revert commit**: Use default git revert message format

## Versioning Impact

Commits trigger semantic version bumps:
- **Breaking changes** → Major version (1.0.0 → 2.0.0)
- **feat** or **fix** commits → Minor version (1.0.0 → 1.1.0)
- **Other types** → Patch version (1.0.0 → 1.0.1)

## Examples

### Feature Addition
```
feat(shopping-cart): add save for later button
```

### Bug Fix
```
fix(shopping-cart): prevent checkout with empty cart
```

### Bug Fix with Body
```
fix: add missing parameter to service call

The error occurred due to incorrect method signature.
```

### Breaking Change
```
feat(api)!: remove ticket list endpoint

refers to JIRA-1337

BREAKING CHANGE: ticket endpoints no longer support list all entities.
Use the new paginated endpoints instead.
```

### Performance Improvement
```
perf: decrease memory footprint for unique visitors by using HyperLogLog
```

### Build Update
```
build: update dependencies
```

### Build with Scope
```
build(release): bump version to 1.0.0
```

### Refactoring
```
refactor: implement fibonacci calculation as recursion
```

### Style Change
```
style: remove empty line
```

## Instructions for Claude

### Auto-Detection Mode (Primary)

When `/conventional-commits` is invoked **without arguments**:

1. **Check git repository**
   - Execute: `git rev-parse --is-inside-work-tree`
   - If false, respond: `not a git repository` and stop

2. **Gather git changes (prioritize staged)**
   - Execute: `git diff --staged` (capture output)
   - If empty: Execute: `git diff` (capture output)
   - Execute: `git status --porcelain` (capture output)
   - Execute: `git ls-files --others --exclude-standard` (capture output)

3. **Analyze changes**
   - Parse `git status --porcelain` to categorize files (added/modified/deleted)
   - Parse diff output to understand change context
   - **Group files by commit type** using detection logic:
     - Test files → `test`
     - Documentation files → `docs`
     - Dependency/config files → `build`
     - CI/ops files → `ops`
     - Style/linter files → `style`
     - New features → `feat`
     - Bug fixes → `fix`
     - Performance → `perf`
     - Refactoring → `refactor`
     - Everything else → `chore`

4. **Generate separate commits for each type group**
   - For each type group, extract scope from file paths
   - Generate description from actual code changes
   - Create separate commit message per type+scope combination
   - Order by priority: breaking → test → docs → build → ops → style → feat → fix → perf → refactor → chore

5. **Format output**
   - Show detected changes summary
   - Present each commit with `=== COMMIT X/Y ===` header
   - Include formatted commit message
   - Provide ready-to-use git command for each commit
   - Use code blocks for commit messages and commands

6. **Handle edge cases**
   - No changes: "No changes detected. Stage or create changes first."
   - Not a repo: "Not a git repository. Initialize with `git init`."
   - Large diff (>20 files): Suggest logical grouping by type

### User Description Mode (Fallback)

When `/conventional-commits <description>` is invoked **with arguments**:

1. **Identify the type**: Determine which commit type best fits the description
2. **Extract the scope**: If mentioned or obvious from description, include it
3. **Write the description**: Formulate in imperative present tense, lowercase, no period
4. **Check for breaking changes**: If description indicates functionality removal/incompatibility, add `!` and footer
5. **Add body if needed**: Include context if the change needs explanation
6. **Add footer if relevant**: Include issue references or breaking change details

### Handling User Input

If the user provides a description:
- "I added [feature]" → Use `feat:`
- "I fixed [bug]" → Use `fix:`
- "I refactored [code]" → Use `refactor:`
- "I updated [docs/dependencies]" → Use appropriate type

If the change removes functionality or changes APIs incompatibly:
- Add `!` before `:`
- Add `BREAKING CHANGE:` footer explaining what broke and how to migrate

### Output Format

**Auto-Detection Mode:**
Present commits in this format:
```
Detected changes:
- <N> files added, <M> files modified, <X> files deleted
- Changes grouped into <Y> commit(s)

=== COMMIT <N>/<Y> ===
<type>(<scope>): <description>

<optional body>

git commit -m "<type>(<scope>): <description>" <optional -m body>
```

**User Description Mode:**
Present the formatted commit as a code block:
```
<formatted commit message>
```

If body or footer is included, show the complete multi-line format with proper blank line separators.

## Auto-Detection Mode

When `/conventional-commits` is invoked without arguments, automatically inspect git changes and generate conventional commit messages.

### Workflow

1. **Verify git repository**
   - Run: `git rev-parse --is-inside-work-tree`
   - If not a repo, output: `not a git repository`

2. **Gather changes (prioritize staged)**
   - `git diff --staged` (staged changes)
   - If empty: `git diff` (unstaged changes)
   - `git status --porcelain` (file status overview)
   - `git ls-files --others --exclude-standard` (untracked files)

3. **Classify changes**
   - Group by: added, modified, deleted, renamed files
   - Identify file categories: code, tests, docs, config, deps
   - Separate by commit type for multiple commits

4. **Generate commits**
   - For each distinct type group, generate separate commit
   - Apply type detection logic to each group
   - Extract appropriate scope for each commit
   - Generate descriptions from actual code changes

5. **Output proposed commits**
   - Present each commit separately
   - Include git commands for user to execute
   - Allow user to copy/use individual commits

### Input Handling

| Invocation | Behavior |
|-----------|----------|
| `/conventional-commits` | Run auto-detection workflow |
| `/conventional-commits add login feature` | Use "add login feature" as description, apply formatting rules |
| `/conventional-commits "fix bug in payment"` | Same as above, with full description |

- **Empty input**: Trigger git inspection workflow
- **Non-empty input**: Use description as base, format per conventional commit rules

### Commit Type Detection Logic

Detect commit type by file patterns (priority order):

| File Pattern | Type | Priority |
|-------------|------|----------|
| Breaking change detected | breaking | 1 (highest) |
| `**/*.test.ts`, `**/*.spec.js`, `**/__tests__/**` | test | 2 |
| `**/*.md`, `docs/**`, `README*`, `CHANGELOG*` | docs | 3 |
| `package.json`, `package-lock.json`, `yarn.lock`, `poetry.lock`, `requirements.txt`, `Cargo.lock`, `go.mod`, `pom.xml` | build | 4 |
| `.github/**`, `.gitlab-ci.yml`, `.travis.yml`, `Dockerfile`, `docker-compose.yml`, `Makefile`, `Jenkinsfile` | ops | 5 |
| `.eslintrc*`, `.prettier*`, `.editorconfig`, `pyproject.toml` (linter config) | style | 6 |
| New feature files, feature toggle changes | feat | 7 |
| Bug fix files, exception handlers, null checks | fix | 8 |
| Performance optimization, algorithmic changes | perf | 9 |
| Code restructuring, refactoring without behavior change | refactor | 10 |
| All others | chore | 11 (lowest) |

### Scope Extraction Rules

- **Single directory dominant**: Extract that directory name (≤20 chars)
- **Examples**: `src/api/*` → `api`, `components/Button.tsx` → `button`
- **Too broad or mixed**: Omit scope
- **File-based naming**: `auth-service.ts` → `auth-service`

### Breaking Change Detection

Detect breaking changes by:
- File deletion of exported symbols/APIs
- Removed endpoints, methods, or function signatures
- Config file removals or major version bumps
- `BREAKING CHANGE:` keyword in existing messages
- API version increments (v1 → v2)

### Multiple Commit Generation

When changes span multiple types, generate SEPARATE commits:

```
=== COMMIT 1 ===
feat(auth): add oauth refresh token support

git commit -m "feat(auth): add oauth refresh token support"

=== COMMIT 2 ===
docs: update authentication README

git commit -m "docs: update authentication README"

=== COMMIT 3 ===
test(auth): add unit tests for token refresh

git commit -m "test(auth): add unit tests for token refresh"
```

**Grouping rules:**
- Group files by type (all test files → test commit)
- Within same type, group by scope (all auth files → auth scope)
- Generate one commit per distinct type+scope combination
- Order by priority (breaking → feat → fix → etc.)

### Output Format (Auto-Detection)

When auto-detecting, use this format:

```
Detected changes:
- <N> files added, <M> files modified, <X> files deleted
- Changes grouped into <Y> commit(s)

=== COMMIT <N>/<Y> ===
<type>(<scope>): <description>

<optional body>

git commit -m "<type>(<scope>): <description>" <optional -m body>
```

### Edge Cases

| Case | Handling |
|------|----------|
| No changes (clean repo) | Output: "No changes detected. Stage or create changes first." |
| Not a git repository | Output: "Not a git repository. Initialize with `git init`." |
| Untracked files only | Analyze file extensions, generate appropriate commit type |
| Large diff (>20 files) | Suggest breaking into logical commits, group by type |
| Merge commits | Use default git merge format |
| Revert commits | Use default git revert format |

### Examples (Auto-Detection)

#### Example 1: Single Type Changes

```
$ /conventional-commits

Detected changes:
- 4 files added, 2 files modified
- Changes grouped into 1 commit

=== COMMIT 1/1 ===
feat(auth): add oauth refresh token support

add refresh token rotation for session longevity
Closes #123

git commit -m "feat(auth): add oauth refresh token support" -m "add refresh token rotation for session longevity" -m "Closes #123"
```

#### Example 2: Multiple Type Changes

```
$ /conventional-commits

Detected changes:
- 5 files modified (3 code, 1 test, 1 doc)
- Changes grouped into 3 commits

=== COMMIT 1/3 ===
feat(auth): add oauth refresh token support

git commit -m "feat(auth): add oauth refresh token support"

=== COMMIT 2/3 ===
test(auth): add unit tests for token refresh

git commit -m "test(auth): add unit tests for token refresh"

=== COMMIT 3/3 ===
docs: update authentication README

git commit -m "docs: update authentication README"
```

#### Example 3: Breaking Change

```
$ /conventional-commits

Detected changes:
- 2 files deleted
- Changes grouped into 1 commit

=== COMMIT 1/1 ===
feat(api)!: remove deprecated user endpoints

BREAKING CHANGE: /api/v1/users and /api/v1/users/:id removed.
Use /api/v2/users and /api/v2/users/:id instead.

git commit -m "feat(api)!: remove deprecated user endpoints" -m "BREAKING CHANGE: /api/v1/users and /api/v1/users/:id removed. Use /api/v2/users and /api/v2/users/:id instead."
```

#### Example 4: Bug Fix with Context

```
$ /conventional-commits

Detected changes:
- 3 files modified
- Changes grouped into 1 commit

=== COMMIT 1/1 ===
fix(api): throw specific error for user not found

The error occurred due to incorrect method signature.
Added proper error handling for null userId.

git commit -m "fix(api): throw specific error for user not found" -m "The error occurred due to incorrect method signature. Added proper error handling for null userId."
```

#### Example 5: No Changes

```
$ /conventional-commits

No changes detected. Stage or create changes first.

To stage changes: git add .
To check status: git status
```

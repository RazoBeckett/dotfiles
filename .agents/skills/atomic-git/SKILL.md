---
name: atomic-git
description: Handles all git commit, PR, and merge workflows. Load this skill once per session and keep it active. Triggers: "do commits" runs atomic commits only (Workflow A). "do commits + create PR / merge into main" runs full end-to-end (Workflow B). "aftermath", "we're done", or "do aftermath" finalizes an already-committed branch into a PR and merges it (Workflow C).
compatibility: Requires git and gh CLI (authenticated). Designed for Claude Code or similar agentic environments with bash access.
allowed-tools: Bash(git:*) Bash(gh:*)
---

# atomic-git

## Session Loading

Load this skill **once per session**. Once active, do not reload it on subsequent triggers. Remain aware of session state: if Workflow A was already completed earlier in the session, Workflow C ("aftermath") can safely assume commits exist and the branch is clean.

---

## Trigger Mapping

Match user intent to a workflow using these phrases as signals. Partial matches and paraphrases count.

| User says (examples) | Workflow |
|---|---|
| "do commits", "commit my changes", "make commits" | **A. Commit only** |
| "do commits and create a PR", "commit + merge into main", "do the full thing" | **B. Full E2E** |
| "aftermath", "we're done", "do aftermath", "finalize", "create the PR now", "push and merge" (after commits done) | **C. Finalize** |

When in doubt between B and C: if the user already ran commits this session and the branch is clean, prefer C. If uncommitted changes exist, prefer B.

---

## Interrupt Keyword: Listen

If a user message begins with `Listen,` or `Listen ` (case-insensitive), **immediately pause** the current workflow. Preserve repo state exactly as-is. Execute the new request. Do NOT resume unless explicitly asked.

All other mid-workflow messages are queued and handled after the workflow completes.

---

## Shared Safety Checks (run before any workflow)

1. Confirm this is a git repository. If not, abort.
2. Confirm `origin` remote exists. If not, abort.
3. Confirm `gh` CLI is installed and authenticated. If not, abort.
4. Confirm no rebase, merge, or cherry-pick is in progress. If so, abort.
5. Confirm no unresolved merge conflicts. If so, abort.

---

## Shared Rules (always enforced)

- NEVER modify, format, or refactor source code.
- NEVER add co-authors or trailers to commits.
- NEVER amend existing commits or rewrite history.
- Use non-interactive patch staging only.
- Stage hunks by generating patches and applying them with: `git apply --cached <patch>`
- Interactive commands (git add -p, git add -i) are forbidden.
- Squash merge only, via `gh pr merge --squash`.
- The agent MUST prefer smallest-valid atomic commits over fewer commits.

### Temporary Patch Handling
- All generated patches MUST be written to `/tmp`.
- Patch filename format:
  `/tmp/atomic-git-<pid>-<sequence>.patch`
- Patch files are temporary staging artifacts only.
- After a successful commit, the patch file MUST be deleted.
- If staging or commit fails, the patch MUST be deleted before aborting.
- The repository MUST never contain patch files.
- The agent MUST NOT reuse old patch files.

---

## Conventional Commit Format

```
<type>(optional-scope): short imperative summary
```

Types: `feat` `fix` `refactor` `docs` `test` `chore` `perf` `build` `ci`

Rules: imperative mood, no trailing period, no emojis, body only if necessary, `BREAKING CHANGE:` footer only if truly breaking.

---

## Workflow A: Commit

**Trigger**: "do commits", "commit my changes", or similar.

Commits atomic changes only. Does NOT push, does NOT create a branch, does NOT create a PR. Works on any branch including `main`.

### Preconditions
- Staged or unstaged changes must exist. If none, abort.
- Not in detached HEAD state (warn but continue if so).

### Patch Staging Rules
- Treat Git as a patch database.
- Never stage entire files unless all changes share the same intent.
- Mixed hunks MUST be separated into independent patches.
- Each commit must leave unrelated hunks unstaged.
- After staging, verify that: `git diff --cached`
  contains only changes relevant to the commit message.

### Process
1. Inspect full diff (staged + unstaged).
2. Group changes by intent: feat vs fix vs refactor vs test vs docs vs chore.
3. For each group:
   - Generate a minimal patch containing only hunks belonging to that intent.
   - Write patch to `/tmp/atomic-git-<pid>-<sequence>.patch`.
   - Patch must include correct file headers and context.
   - Stage using: `git apply --cached /tmp/atomic-git-<pid>-<sequence>.patch`
   - Verify staged content using: `git diff --cached`
   - If staging fails, delete the patch and skip the group.
   - Commit using Conventional Commit format.
   - After successful commit, delete the patch file.
4. Repeat until all intended changes are committed.
5. If nothing at all could be staged, abort.

### Safety Check (after each commit)
- Working tree is clean for that atomic unit.
- No unintended hunks were staged.
- Message matches Conventional Commit format. Amend message only if format is wrong, never touch code.

### Patch Cleanup Guarantee
- No patch files may remain in `/tmp` after workflow completion.
- On workflow exit (success or abort), delete any remaining
  `/tmp/atomic-git-*.patch` files created during this session.

### Post-Processing
- If unstaged changes remain, repeat process.
- Run: `git log --oneline -n <number_of_new_commits>`

### Output
```
<8-char-hash> - <commit summary>
<8-char-hash> - <commit summary>
```
Chronological order (oldest first). No extra commentary. No fences.

---

## Workflow B: Full E2E

**Trigger**: User asks to commit AND push AND merge in one request, with uncommitted changes present.

### Preconditions
- Staged or unstaged changes must exist. If none, abort.
- If on `main` or a protected branch: create a feature branch first.
  - Format: `feat/<short-description>` or appropriate prefix.
  - If branch name collides with remote, append a timestamp.
- If already on a feature branch: continue using it.

### Steps
1. **Branch** (if needed): create and switch to a feature branch before committing.
2. **Commit**: run Workflow A commit process on the new branch.
3. **Push**: `git push -u origin <branch>`. If push fails, abort.
4. **Create PR**: `gh pr create --base main --title "<derived from commits>" --body ""`
   - If PR already exists for this branch, reuse it. Capture PR number.
5. **Squash merge**: `gh pr merge <number> --squash --delete-branch`
   - If repo requires approvals and merge fails, abort and report PR state.
6. **Sync local main**:
   - `git checkout main`
   - `git pull origin main`
   - `git remote prune origin` (optional)
7. **Verify**: Confirm PR commit exists in `git log` (PR number in message or matching SHA). If not found, abort and report.

### Output
```
All done End-to-End, #<PR-NUMBER>: <PR-STATE>, Remote branch: <BRANCH-NAME>
```
No extra commentary.

---

## Workflow C: Finalize (Aftermath)

**Trigger**: "aftermath", "we're done", "do aftermath", or similar — used after commits are already done.

Assumes the current branch is clean and ahead of `main`. Only pushes, creates a PR, merges, and verifies. Does NOT commit anything.

### Preconditions
1. Currently NOT on `main`. If on `main`, abort with: "Finalize requires a feature branch. Run Workflow B if you still have uncommitted changes."
2. No unstaged or uncommitted changes. If dirty, abort and suggest Workflow B.
3. Branch must have commits not yet in `main`. If nothing to merge, abort.
4. `main` branch must exist locally or remotely.

### Steps
1. **Push**: push current branch to `origin`. Set upstream if needed. If push fails, abort.
2. **Create or reuse PR**: check for open PR. If none, create targeting `main`. Capture PR number.
3. **Verify mergeability**: if conflicts exist, abort and report.
4. **Squash merge**: `gh pr merge <number> --squash --delete-branch`
5. **Delete remote branch**: confirm merged state. If already deleted, continue. If deletion fails, report but continue.
6. **Sync local main**:
   - `git checkout main`
   - `git pull origin main`
   - `git remote prune origin` (optional)
7. **Verify**: confirm via `gh pr view` and check commit exists in local `git log`. If verification fails, abort and report.

### Output
```
All done End-to-End, #<PR-NUMBER>: <PR-STATE>, Remote branch: <BRANCH-NAME>
```
No extra commentary.

---

## Abort Conditions (all workflows)

Abort immediately and report clearly if:
- Not a git repository
- No `origin` remote
- `gh` not installed or not authenticated
- Rebase / merge / cherry-pick in progress
- Unresolved merge conflicts
- No changes exist when Workflows A or B are triggered
- Workflow C triggered on `main` or with a dirty working tree
- Branch has no commits ahead of `main` when Workflow C is triggered
- Push fails
- Squash merge fails due to conflicts or required approvals
- Post-merge verification fails

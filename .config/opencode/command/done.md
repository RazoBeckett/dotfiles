---
description: Safely automate atomic commits, PR creation, squash merge, and main branch verification using git and gh CLI.
---

## Objective

Perform an end-to-end automated workflow:

1. Create atomic conventional commits from current changes.
2. Ensure commits are NOT made directly on `main`.
3. Push branch.
4. Create PR using `gh`.
5. Squash merge into `main`.
6. Delete remote branch.
7. Verify merge locally.
8. Output final status line only.

No co-authoring under any circumstances.

---

## PRE-FLIGHT SAFETY CHECKS

Before doing anything:

1. Ensure this is a git repository.
   - If not, abort.

2. Ensure there are staged or unstaged changes.
   - If no changes exist, abort with a clear error.

3. Detect current branch:
   - If currently on `main`, DO NOT commit on `main`.
   - If currently on any protected branch (main/master), create a new branch first.

4. If current branch is `main` AND it has local commits ahead of origin:
   - Create a new branch from current HEAD before proceeding.

5. If current branch is `main` AND no new commits exist:
   - Create a new branch from latest `origin/main`.

6. If current branch is already a feature branch:
   - Continue using it.

7. Ensure working tree is clean before branch switching:
   - If uncommitted changes exist and branch switch is required:
     - Create new branch first (no stash).
     - Then proceed.

8. Ensure remote `origin` exists.
   - If not, abort.

9. Ensure `gh` CLI is authenticated.
   - If not authenticated, abort.

---

## BRANCH STRATEGY

- Branch name format:
  `feat/<short-description>` or appropriate conventional prefix.
- If branch with same name exists remotely:
  - Append timestamp to avoid collision.

---

## COMMIT STRATEGY

1. Use `git add -p` for interactive atomic staging.
   - Do NOT modify code.
   - Do NOT auto-format.
   - Do NOT rewrite content.

2. Create atomic conventional commits.
   - Format: `<type>(optional-scope): <description>`
   - No co-authors.
   - No trailers.

3. If nothing is staged after `git add -p`, abort.

4. Repeat until all intended changes are committed.

---

## PUSH & PR CREATION

1. Push branch with upstream:
   `git push -u origin <branch>`

2. Create PR using:
   `gh pr create`
   - Base: `main`
   - Head: current branch
   - Title derived from commit summary
   - Body minimal and auto-generated

3. Capture PR number.

---

## MERGE PROCESS

1. Perform squash merge using:
   `gh pr merge --squash --delete-branch`

2. If repository requires approvals and merge fails:
   - Abort and report PR state.

3. Confirm remote branch deletion.
   - If not deleted automatically, delete manually.

---

## POST-MERGE VERIFICATION

1. Checkout `main`.

2. Pull latest changes from origin.

3. Verify that:
   - PR commit exists in `git log`.
   - Commit message matches squash commit.

4. If commit not found:
   - Report failure.

---

## FINAL OUTPUT

After everything completes:

Check PR state via `gh pr view`.

Respond ONLY with:

All done End-to-End, #<PR-NUMBER>: <STATE>, Remote branch: <MERGED-BRANCH-NAME>

No extra commentary.
No explanations.
No additional output.

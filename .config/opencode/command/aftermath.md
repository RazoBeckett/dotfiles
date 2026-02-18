---
description: Safely finalize the current feature branch by pushing, creating a PR via gh CLI, squash merging into main, cleaning up the remote branch, and verifying the merge locally.
---

# Finalization Workflow

This command must be fully deterministic, safe, and idempotent where possible.  
Do NOT assume anything. Validate every step before proceeding.

---

## Preconditions

1. Ensure we are inside a Git repository.
2. Ensure the current branch is NOT `main`.
3. Ensure there are no unstaged or uncommitted changes.
4. Ensure the working tree is clean.
5. Ensure `origin` remote exists.
6. Ensure `gh` CLI is installed and authenticated.
7. Ensure `main` branch exists locally or remotely.

If any of the above checks fail, STOP and report the error clearly.

---

## Step 1: Push Current Branch

1. Get current branch name.
2. Verify branch is not `main`.
3. Push branch to `origin`.
   - If upstream is not set, set it.
   - If push fails, STOP.

---

## Step 2: Create Pull Request

1. Check if an open PR already exists for this branch.
   - If yes, reuse it.
   - If no, create a new PR targeting `main`.
2. Capture PR number.
3. Ensure PR creation succeeded before proceeding.

---

## Step 3: Squash Merge PR

1. Verify PR is mergeable.
   - If conflicts exist, STOP and report.
2. Perform squash merge using `gh`.
3. Ensure merge completed successfully.
4. Capture final PR state.

---

## Step 4: Delete Remote Branch

1. Confirm PR state is merged.
2. Delete branch on remote.
   - If already deleted, continue.
   - If deletion fails, report but continue.

---

## Step 5: Sync Local Main

1. Checkout `main`.
2. Pull latest changes from `origin/main`.
3. Ensure local `main` is up to date.
4. Optionally prune deleted branches.

---

## Step 6: Verification

1. Confirm PR status via `gh`.
2. Confirm PR commit exists in local `main`:
   - Check commit message includes PR number.
   - OR verify merge commit SHA matches.
3. If verification fails, STOP and report.

---

## Final Output

Reply exactly in this format:

All done End-to-End, #<PR-NUMBER>: <PR-STATE>, Remote branch: <BRANCH-NAME>

No additional commentary.
No extra explanation.
Only the final line.

---
description: Finalize an already-committed branch — pushes, opens a PR, squash merges into main, and verifies. No new commits.
---

Load the `atomic-git` skill if it is not already in your context. If context compaction has occurred, reload it before continuing.

Run Workflow C: Finalize. Commits are already done. Push the current branch to `origin`, open a PR targeting `main`, squash merge it, delete the remote branch, sync local `main`, and verify the merge. Do not stage or commit anything new.

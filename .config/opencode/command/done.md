---
description: Full end-to-end git workflow — commits, pushes, opens a PR, squash merges into main, and verifies locally.
---

Load the `atomic-git` skill if it is not already in your context. If context compaction has occurred, reload it before continuing.

Run Workflow B: Full E2E. Stage and create atomic Conventional Commits from all current changes, then push to a feature branch, open a PR targeting `main`, squash merge it, delete the remote branch, sync local `main`, and verify the merge. If currently on `main`, create a feature branch first before committing.

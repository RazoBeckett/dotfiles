---
description: Automate atomic commits, PR creation, squash merge, and main branch verification via git and gh CLI.
---

## Create sub-agent for following task:
Create atomic conventional commits for current changes
Make use of `git add -p` to stage the changes without editing/modifiying the code
Push this branch to remote then create a PR. Make use of `gh` cli
Get this Squash-merged into 'main' branch, then delete the branch on remote
Checkout 'main' branch and pull all the latest changes after the merge

## After sub-agent is done
Check the PR status
Checkout main and check the `git log` for PR commit for confirmation
Reply with "All done End-to-End, #<PR-NUMBER>: <state>, Remote branch: <Merged-branch-name>"
That's it no need to yap extra details.

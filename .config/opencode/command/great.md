---
description: Generate atomic conventional commits via git add -p and return formatted commit log summaries.
---

## Create sub-agent for following task:
Create atomic conventional commits for current changes
Make use of `git add -p` to stage the changes without editing/modifiying the code

## After sub-agent is done
Check if commits convention checking logs `git log`
and response with list of commits in following pattern:

```
<commit 1 hash first 8 characters> - <commit message summary>
<commit 2 hash first 8 characters> - <commit message summary>
etc
```

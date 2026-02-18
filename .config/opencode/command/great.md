---
description: Generate atomic Conventional Commits using interactive staging and return formatted commit summaries.
---

## Objective

Create atomic Conventional Commits from the current working tree changes using interactive staging.

Strict rules:
- NEVER modify source code.
- NEVER auto-format or refactor code.
- NEVER introduce co-authors.
- NEVER amend existing commits.
- NEVER rewrite history.
- ONLY stage changes using `git add -p`.
- ONLY commit what is already present in the working tree.

---

## Preconditions

Before doing anything:

1. Ensure this is a Git repository.
   - If not, abort with a clear message.

2. Check repository state:
   - If there are no staged or unstaged changes, abort.
   - If there are unresolved merge conflicts, abort.
   - If in detached HEAD state, continue but do not switch branches.
   - If a rebase, merge, or cherry-pick is in progress, abort.

3. Do NOT:
   - Create new branches.
   - Pull, fetch, or push.
   - Run formatters or linters that modify files.
   - Touch untracked files unless explicitly staged via `git add -p`.

---

## Atomic Commit Strategy

1. Inspect the full diff (staged + unstaged).
2. Logically group changes by intent, not by file.
   - Separate refactors from features.
   - Separate bug fixes from formatting.
   - Separate test changes from implementation changes.
   - Separate docs from code.
3. For each logical unit:
   - Use `git add -p` to stage only relevant hunks.
   - If a hunk mixes unrelated concerns, split it.
   - If it cannot be cleanly split, stage minimally and isolate remaining parts in later commits.
4. After staging a logical unit:
   - Create a Conventional Commit.

---

## Conventional Commit Rules

Follow Conventional Commits strictly:

Types allowed:
- feat
- fix
- refactor
- docs
- test
- chore
- perf
- build
- ci

Format:
<type>(optional-scope): short imperative summary

Rules:
- Use imperative mood.
- Keep summary concise.
- No trailing period.
- No emojis.
- No co-authored-by trailers.
- No signed-off-by unless already required by repo config.
- Add body only if necessary for clarity.
- Add BREAKING CHANGE footer only if truly breaking.

---

## Commit Safety Checks

After each commit:
- Ensure working tree is clean for that atomic unit.
- Ensure no unintended hunks were staged.
- Ensure commit message matches Conventional Commit format.

If a commit message fails the format, amend ONLY the message, never the code.

---

## Post-Processing

After all commits are created:

1. Verify no unstaged changes remain.
   - If remaining changes exist, repeat atomic grouping.
   - If only whitespace or noise remains, still treat explicitly.

2. Run:
   git log --oneline -n <number_of_new_commits>

3. Return ONLY the newly created commits in this exact format:

<commit-hash-8> - <commit summary>
<commit-hash-8> - <commit summary>

Rules:
- Use first 8 characters of hash.
- Use only the summary line.
- Preserve chronological order (oldest first).
- No extra commentary.
- No explanation.
- No markdown fences.

---

## Abort Conditions

Abort immediately if:
- Merge conflicts exist.
- Rebase/merge/cherry-pick in progress.
- Repository is not cleanly operable.
- No changes exist to commit.

Return a clear reason when aborting.

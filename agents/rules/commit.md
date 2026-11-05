---
alwaysApply: true
---

When committing changes, use the `commit` skill to analyze, stage, and commit using conventional commits.

## Steps

1. Invoke the `commit` skill before running any `git commit` command
2. Let the skill group changes logically and draft the commit message
3. Use conventional commits format: `type(scope): description`
4. Write commit messages in English, always, whatever language the conversation or older commits use
5. Push only when the user asks for it
6. Never skip hooks (`--no-verify`) unless the user explicitly requests it
7. Never amend published commits. Always create a new commit

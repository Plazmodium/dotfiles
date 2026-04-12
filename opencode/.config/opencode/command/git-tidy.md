---
description: Tidy git branches — fast-forward dev to main, prune merged branches, verify release tags
---

Tidy the current git repository: sync branches, prune stale refs, and audit tags.

First, invoke the skill tool to load the git-tidy skill:

```text
skill({ name: 'git-tidy' })
```

Then follow the skill instructions to analyze and clean up the repository.

<user-request>
$ARGUMENTS
</user-request>

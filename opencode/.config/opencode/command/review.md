---
description: Review a change for correctness, safety, maintainability, tests, and scope
---

Review the current change or provided diff.

First, invoke the skill tool to load the core review skills:

```text
skill({ name: 'using-agent-skills' })
skill({ name: 'code-review-and-quality' })
```

Load additional review skills when relevant:

```text
skill({ name: 'security-and-hardening' })
skill({ name: 'performance-optimization' })
skill({ name: 'code-simplification' })
```

Then report findings first, ordered by severity, with file and line references.

<user-request>
$ARGUMENTS
</user-request>

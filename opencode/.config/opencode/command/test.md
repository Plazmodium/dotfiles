---
description: Prove behavior with focused tests and debugging workflow
---

Verify the requested behavior or diagnose failures.

First, invoke the skill tool to load the relevant skills:

```text
skill({ name: 'using-agent-skills' })
skill({ name: 'test-driven-development' })
skill({ name: 'debugging-and-error-recovery' })
```

For browser behavior, also load:

```text
skill({ name: 'browser-testing-with-devtools' })
```

Then produce concrete verification evidence or a clear failure diagnosis.

<user-request>
$ARGUMENTS
</user-request>

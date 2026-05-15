---
description: Implement work incrementally with verification
---

Build the requested change in small verified slices.

First, invoke the skill tool to load the core skills:

```text
skill({ name: 'using-agent-skills' })
skill({ name: 'incremental-implementation' })
```

Load additional skills when relevant:

```text
skill({ name: 'test-driven-development' })
skill({ name: 'api-and-interface-design' })
skill({ name: 'frontend-ui-engineering' })
skill({ name: 'context-engineering' })
skill({ name: 'source-driven-development' })
skill({ name: 'doubt-driven-development' })
```

Then implement only the requested scope and verify each meaningful slice.

<user-request>
$ARGUMENTS
</user-request>

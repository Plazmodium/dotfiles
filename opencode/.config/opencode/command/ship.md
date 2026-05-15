---
description: Prepare a change for safe release with launch evidence
---

Prepare the requested change for shipping.

First, invoke the skill tool to load the core shipping skills:

```text
skill({ name: 'using-agent-skills' })
skill({ name: 'shipping-and-launch' })
skill({ name: 'git-workflow-and-versioning' })
skill({ name: 'ci-cd-and-automation' })
skill({ name: 'documentation-and-adrs' })
```

For removals or migrations, also load:

```text
skill({ name: 'deprecation-and-migration' })
```

Then produce launch readiness evidence, residual risks, and rollback steps.

<user-request>
$ARGUMENTS
</user-request>

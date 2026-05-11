---
name: compact-it
description: Summarize the full conversation into a compact handoff for continuing in a new chat without losing context.
---

# compact-it

Summarize the entire conversation into a markdown compaction file that can be used to continue in a new chat without losing context.

## Workflow

1. Determine the root of the current working project.
2. Check for a `compaction/` folder at the project root.
3. If `compaction/` does not exist, ask the user whether to create it.
4. If the user agrees, create `compaction/` and write the compaction file there.
5. If the user declines, do not create files; print the full compaction text in the response instead.
6. If `compaction/` already exists, write the compaction file without asking.

## File Naming

Save the file as:

```text
compaction/{date-timestamp-memory}.md
```

Use the local date and timestamp. Example:

```text
compaction/2026-05-05-143012-memory.md
```

## File Content Requirements

Include these short sections with headings:

## Original Goal Or Problem

State the user's original goal, bug, task, or question.

## Key Decisions Made And Why

List the important decisions, constraints, assumptions, and rationale that shaped the work.

## Settled Code, Config, Or Data

Include any code, config, prompts, commands, file paths, schemas, or data that were agreed on or materially used.

Preserve settled content verbatim in fenced code blocks.

## Open Questions And Next Steps

List unresolved questions, blockers, risks, verification status, and the next concrete actions.

## Style Rules

- Skip small talk and exploratory tangents.
- Keep sections short and scannable.
- Optimize for a future agent reading the summary cold.
- Preserve exact filenames, commands, errors, and user-provided wording when relevant.
- Do not invent details that were not established in the conversation.
- If something is unknown or unverified, say so plainly and ask questions if needed.

## Final Response

If a file was written, report only the file path and any important caveat.

If no file was written because the user declined `compaction/`, print the full compaction text.

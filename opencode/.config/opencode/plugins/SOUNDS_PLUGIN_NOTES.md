# OpenCode Sound Notifications Plugin

## Goal

Add game-themed sound notifications to OpenCode for various events:

### Currently Active: Starcraft Theme
- Session start: "Go ahead commander"
- Session complete: "Add an complete"
- Question asked: "Let's roll"
- Subagent start: "Orders received"
- Subagent complete: "Just finished"

### Legacy: Warcraft Theme
- Session start: "Work work!"
- Session complete: "Work complete"
- Subagent spawning: "Yes me lord"

## How OpenCode Plugins Work

Plugins are JavaScript/TypeScript modules placed in:
- `~/.config/opencode/plugins/` (global)
- `.opencode/plugins/` (per-project)

They export functions that receive a context object and return hooks for various events.

### Available Events for Sound Notifications

| Event | Description |
|-------|-------------|
| `session.created` | New session started (fires once per conversation) |
| `session.idle` | Session finished working (AI done responding) |
| `session.status` | Status changed (fires on every state transition) |
| `tool.execute.before` | Before a tool runs |
| `tool.execute.after` | After a tool completes |

### Session Status Values

The `session.status` event includes `event.properties.status` which is an **object**, not a string:

```javascript
event.properties.status = { type: "busy" }  // NOT just "busy"
```

| Status Type | Meaning |
|-------------|---------|
| `idle` | Not processing, waiting for input |
| `busy` | Actively processing a request |

**Important**: Access the status via `event.properties.status.type`, not `event.properties.status`.

## Initial Attempt (Didn't Work)

```javascript
export const SoundPlugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`afplay ${sounds.sessionComplete} &`.quiet()
      }
    },
  }
}
```

### Why It Failed

1. **Bun shell API limitations**: The `$` template literal from Bun's shell API doesn't support `.quiet()` in the OpenCode plugin context
2. **Background operator issues**: The `&` background operator inside the template literal didn't work as expected
3. **Blocking execution**: Using `await` on the shell command blocked the event handler

## Working Solution (v1 - New Sessions Only)

```javascript
import { spawn } from "node:child_process"

function playSound(soundPath) {
  try {
    spawn("afplay", [soundPath], {
      detached: true,
      stdio: "ignore",
    }).unref()
  } catch (e) {
    // Silently ignore errors
  }
}

export const SoundPlugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.created") {
        playSound(sounds.sessionStart)
      }
      if (event.type === "session.idle") {
        playSound(sounds.sessionComplete)
      }
    },
    "tool.execute.before": async (input, output) => {
      if (input.tool === "task") {
        playSound(sounds.subagentStart)
      }
    },
  }
}
```

### Problem with v1

The `session.created` event only fires when a **brand new session** is created, not when you ask a question in an existing session. This meant the "Work work!" sound only played once when opening a new conversation.

## Final Working Solution (v2 - Every Question)

```javascript
import { spawn } from "node:child_process"

const SOUNDS_DIR = `${process.env.HOME}/.config/opencode/sounds`

const sounds = {
  workStart: `${SOUNDS_DIR}/wc3-peon-says-work-work-only-.mp3`,
  workComplete: `${SOUNDS_DIR}/warcraft-ii-sound-effects-orc-peon-grunt_-_work-complete.mp3`,
  subagentStart: `${SOUNDS_DIR}/yes-me-lord.mp3`,
}

// Track previous status to detect transitions
let previousStatus = "idle"

function playSound(soundPath) {
  try {
    spawn("afplay", [soundPath], {
      detached: true,
      stdio: "ignore",
    }).unref()
  } catch (e) {
    // Silently ignore errors
  }
}

export const SoundPlugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      // Play "work work" when session starts working (idle -> busy)
      if (event.type === "session.status") {
        const currentStatus = event.properties?.status?.type  // Note: .type is required!
        
        // Transitioning from idle to busy = starting work
        if (previousStatus === "idle" && currentStatus === "busy") {
          playSound(sounds.workStart)
        }
        
        previousStatus = currentStatus || previousStatus
      }

      // Play "work complete" when session becomes idle
      if (event.type === "session.idle") {
        playSound(sounds.workComplete)
        previousStatus = "idle"
      }
    },

    "tool.execute.before": async (input, output) => {
      // Play "yes me lord" when a subagent (Task) is launched
      if (input.tool === "task") {
        playSound(sounds.subagentStart)
      }
    },
  }
}
```

### Key Difference in v2

1. **State tracking**: Uses `let previousStatus = "idle"` to remember the last known state
2. **`session.status` event**: Fires whenever session status changes, with `event.properties.status.type` containing the new status (note: status is an object!)
3. **Transition detection**: Only plays sound on `idle → busy` transition, preventing duplicate sounds
4. **Reset on idle**: Updates `previousStatus = "idle"` when `session.idle` fires to ensure the cycle works correctly

### Critical Bug Fix (v2 → v3)

The initial v2 implementation had two bugs:

1. **Status is an object, not a string**: `event.properties.status` returns `{type: "busy"}`, not `"busy"`
2. **Status value is "busy", not "running"**: The actual status type is `"busy"` when the AI is working

Fix: `event.properties?.status` → `event.properties?.status?.type` and `"running"` → `"busy"`

### Why This Works

1. **`spawn()` from Node.js**: More reliable cross-platform process spawning
2. **`detached: true`**: Runs the process independently from the parent
3. **`stdio: "ignore"`**: Prevents stdout/stderr from blocking or cluttering
4. **`.unref()`**: Allows OpenCode to exit without waiting for the sound to finish
5. **No `await`**: Fire-and-forget - doesn't block the event handler
6. **Try-catch**: Silently handles any errors (missing file, afplay issues, etc.)

## Key Learnings

1. **Prefer Node.js APIs over Bun shell** in plugins for reliability
2. **Don't block event handlers** - use fire-and-forget patterns for side effects like sounds
3. **Use `detached` + `unref()`** for truly independent background processes
4. **Wrap in try-catch** to prevent plugin errors from breaking OpenCode
5. **`session.created` vs `session.status`**: Use `session.created` for one-time setup; use `session.status` to detect work starting on every question
6. **Track state for transitions**: Use module-level variables to track previous state when you need to detect specific transitions (e.g., idle → busy)
7. **Event properties may be nested objects**: Always check the actual structure with debug logging - `status` is `{type: "busy"}` not just `"busy"`
8. **Use debug logging during development**: Add a DEBUG flag and log events to understand the actual data structures before removing logging
9. **`tool.execute.after` doesn't work for all tools**: The `task` tool (subagents) doesn't trigger `tool.execute.after`. Use `message.part.updated` events instead to detect completion.
10. **Subagents cause idle/busy cycles**: When a subagent runs, the main session goes through idle/busy transitions. Use flags to suppress unwanted sounds during these cycles.
11. **Carry suppression flags through event cycles**: When suppressing sounds after an event, the flag may need to persist through multiple events (e.g., idle then busy) before being consumed.

## Customization

To change sounds, edit the `sounds` object in `sounds.js`:

```javascript
const sounds = {
  workStart: `${SOUNDS_DIR}/your-start-sound.mp3`,      // Plays when AI starts working
  workComplete: `${SOUNDS_DIR}/your-complete-sound.mp3`, // Plays when AI finishes
  subagentStart: `${SOUNDS_DIR}/your-subagent-sound.mp3`, // Plays when subagent spawns
}
```

### Available Sounds in ~/. config/opencode/sounds/

| File | Description |
|------|-------------|
| `wc3-peon-says-work-work-only-.mp3` | Peon "Work work!" |
| `warcraft-ii-sound-effects-orc-peon-grunt_-_work-complete.mp3` | Peon "Work complete" |
| `yes-me-lord.mp3` | "Yes me lord" acknowledgement |
| `icandothat.mp3` | "I can do that" |
| `okay.mp3` | "Okay" |
| `banshee_6mK299t.mp3` | Banshee sound |
| `the-ultimate-world-of-warcraft-sms-sound-hdhq-3-quest-complete-27b_nukk0k0.mp3` | WoW quest complete |

## Starcraft Theme Update (v4)

Switched from Warcraft to Starcraft sounds with more granular event handling:

| Event | Sound | File |
|-------|-------|------|
| New session (idle -> busy) | "Go ahead commander" | `Voicy_Go ahead commander.mp3` |
| Question asked | "Let's roll" | `Voicy_Let's roll.mp3` |
| Subagent created | "Orders received" | `Voicy_Orders received.mp3` |
| Subagent completed | "Just finished" | `Voicy_Just finished.mp3` |
| Main session complete | "Add an complete" | `Voicy_Add an complete.mp3` |

### Critical Discovery: `tool.execute.after` Doesn't Fire for Task Tools

The `tool.execute.after` hook **does NOT fire** for the `task` tool (subagents). It works for other tools like `edit`, `read`, etc., but not for `task`.

**Workaround**: Detect task completion via the `message.part.updated` event:

```javascript
if (event.type === "message.part.updated") {
  const part = event.properties?.part
  if (part?.type === "tool" && part?.tool === "task" && part?.state?.status === "completed") {
    // Task completed!
    playSound(sounds.subagentComplete)
  }
}
```

### Suppressing Session Sounds During Subagent Execution

When a subagent runs, the session goes through this cycle:
1. Main session: busy
2. Subagent starts: session briefly goes idle then busy
3. Subagent completes: session goes idle then busy again
4. Main session continues or completes

This causes unwanted "session complete" and "session start" sounds. Solution: track subagent state and suppress sounds.

```javascript
let subagentRunning = false
let suppressNextSessionSounds = false

// In event handler:
if (event.type === "message.part.updated") {
  const part = event.properties?.part
  if (part?.type === "tool" && part?.tool === "task" && part?.state?.status === "completed") {
    subagentRunning = false
    suppressNextSessionSounds = true  // Suppress the upcoming idle/busy cycle
    playSound(sounds.subagentComplete)
  }
}

// For session.idle:
if (event.type === "session.idle") {
  if (subagentRunning || suppressNextSessionSounds) {
    // Don't play session complete - subagent is running or just finished
  } else {
    playSound(sounds.sessionComplete)
  }
}

// For session.status idle -> busy:
if (previousStatus === "idle" && currentStatus === "busy") {
  if (subagentRunning || suppressNextSessionSounds) {
    suppressNextSessionSounds = false  // Consume the flag
  } else {
    playSound(sounds.sessionStart)
  }
}
```

### Key Pattern: Carry Suppression Through Idle/Busy Cycle

The `suppressNextSessionSounds` flag is critical because:
1. Set to `true` when task completes
2. Suppresses the `session.idle` event that immediately follows
3. Continues to suppress the next `idle -> busy` transition
4. Gets reset to `false` after suppressing the busy transition

This ensures both the "session complete" and "session start" sounds are suppressed after a subagent finishes.

### Available Starcraft Sounds

Located in `~/.config/opencode/sounds/starcraft/`:

| File | Description |
|------|-------------|
| `Voicy_Add an complete.mp3` | "Add an complete" |
| `Voicy_All right.mp3` | "All right" |
| `Voicy_Battle cruiser operational.mp3` | "Battle cruiser operational" |
| `Voicy_Go ahead commander.mp3` | "Go ahead commander" |
| `Voicy_Hey there.mp3` | "Hey there" |
| `Voicy_Just finished.mp3` | "Just finished" |
| `Voicy_Let's roll.mp3` | "Let's roll" |
| `Voicy_Orders received.mp3` | "Orders received" |
| `Voicy_Research complete.mp3` | "Research complete" |
| `Voicy_Rock N roll.mp3` | "Rock N roll" |
| `Voicy_Roger that.mp3` | "Roger that" |

## Platform Notes

- **macOS**: Uses `afplay` (built-in)
- **Linux**: Replace with `paplay`, `aplay`, or `mpv --no-video`
- **Windows**: Replace with `powershell -c (New-Object Media.SoundPlayer 'file.wav').PlaySync()`

// Starcraft-themed sound notifications for OpenCode
// Sounds play on session events and subagent work

import { spawn } from "node:child_process"
import { appendFileSync } from "node:fs"

const SOUNDS_DIR = `${process.env.HOME}/.config/opencode/sounds/starcraft`
const DEBUG_LOG = `${process.env.HOME}/.config/opencode/sounds-debug.log`
const DEBUG = false // Set to true to enable logging

const sounds = {
  sessionStart: `${SOUNDS_DIR}/Voicy_Go ahead commander.mp3`,
  questionAsked: `${SOUNDS_DIR}/Voicy_Let's roll.mp3`,
  subagentStart: `${SOUNDS_DIR}/Voicy_Orders received.mp3`,
  subagentComplete: `${SOUNDS_DIR}/Voicy_Just finished.mp3`,
  sessionComplete: `${SOUNDS_DIR}/Voicy_Add an complete.mp3`,
}

// Track previous status to detect transitions
let previousStatus = "idle"
// Track if a subagent is currently running
let subagentRunning = false
// Suppress the next session idle/start after subagent completes
let suppressNextSessionSounds = false

function debug(msg) {
  if (DEBUG) {
    const timestamp = new Date().toISOString()
    appendFileSync(DEBUG_LOG, `[${timestamp}] ${msg}\n`)
  }
}

// Play sound without blocking
function playSound(soundPath) {
  try {
    debug(`Playing sound: ${soundPath}`)
    spawn("afplay", [soundPath], {
      detached: true,
      stdio: "ignore",
    }).unref()
  } catch (e) {
    debug(`Error playing sound: ${e.message}`)
  }
}

export const SoundPlugin = async ({ $ }) => {
  debug("SoundPlugin initialized")
  
  return {
    event: async ({ event }) => {
      debug(`Event received: ${event.type} | properties: ${JSON.stringify(event.properties)}`)
      
      // Detect task tool completion via message.part.updated events
      if (event.type === "message.part.updated") {
        const part = event.properties?.part
        if (part?.type === "tool" && part?.tool === "task" && part?.state?.status === "completed") {
          debug("Task tool completed via event, playing subagentComplete")
          subagentRunning = false
          suppressNextSessionSounds = true // Suppress the upcoming idle/busy cycle
          playSound(sounds.subagentComplete)
        }
      }
      
      // Play "Go ahead commander" when session starts working (idle -> busy)
      if (event.type === "session.status") {
        const currentStatus = event.properties?.status?.type
        debug(`Status change: ${previousStatus} -> ${currentStatus}, subagentRunning: ${subagentRunning}, suppress: ${suppressNextSessionSounds}`)
        
        // Transitioning from idle to busy = new session starting work
        if (previousStatus === "idle" && currentStatus === "busy") {
          if (subagentRunning || suppressNextSessionSounds) {
            debug("Transition detected: idle -> busy, but suppressed")
            suppressNextSessionSounds = false
          } else {
            debug("Transition detected: idle -> busy, playing sessionStart")
            playSound(sounds.sessionStart)
          }
        }
        
        previousStatus = currentStatus || previousStatus
      }

      // Play "Add an complete" when main session becomes idle (only if no subagent running)
      if (event.type === "session.idle") {
        if (subagentRunning || suppressNextSessionSounds) {
          debug("Session idle, but suppressed (subagent running or just finished)")
          // Don't reset suppressNextSessionSounds here - let it suppress the next busy too
        } else {
          debug("Session idle, playing sessionComplete")
          playSound(sounds.sessionComplete)
        }
        previousStatus = "idle"
      }
    },

    "tool.execute.before": async (input, output) => {
      debug(`Tool before: ${input.tool}`)
      // Play "Orders received" when a subagent (Task) is launched
      if (input.tool === "task") {
        debug("Subagent starting, playing subagentStart")
        subagentRunning = true
        playSound(sounds.subagentStart)
      }
      // Play "Let's roll" when a question is asked
      if (input.tool === "question") {
        debug("Question asked, playing questionAsked")
        playSound(sounds.questionAsked)
      }
    },
  }
}

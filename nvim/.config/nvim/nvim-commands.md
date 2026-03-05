# Neovim Commands Reference

Based on your personal config. Leader key is `Space`.

---

## Commenting Code (Comment.nvim)

| Keys | Mode | Action |
|------|------|--------|
| `gcc` | Normal | Toggle comment on current line |
| `gc` | Visual | Toggle comment on selection |
| `gbc` | Normal | Toggle block comment on current line |
| `gb` | Visual | Toggle block comment on selection |
| `gcO` | Normal | Add comment on line above |
| `gco` | Normal | Add comment on line below |
| `gcA` | Normal | Add comment at end of line |

---

## Autocompletion (nvim-cmp)

| Keys | Action |
|------|--------|
| `Tab` | Select next completion item |
| `Shift+Tab` | Select previous completion item |
| `Enter` | Confirm selection |
| `Ctrl+Space` | Trigger completion manually |
| `Ctrl+e` | Abort/close completion menu |
| `Ctrl+b` | Scroll docs up (in popup) |
| `Ctrl+f` | Scroll docs down (in popup) |

---

## LSP (Language Server)

### Code Navigation
| Keys | Action |
|------|--------|
| `gd` | Go to definition (via snacks.picker) |
| `gr` | Go to references (via snacks.picker) |
| `gI` | Go to implementation (via snacks.picker) |
| `gy` | Go to type definition (via snacks.picker) |
| `K` | Show hover documentation (the popup dialog) |
| `Space + ca` | Code actions (fixes, refactors) |
| `Space + e` | Show diagnostic in floating window |
| `Space + ss` | LSP symbols (via snacks.picker) |

### LSP References Navigation (snacks.words)
| Keys | Action |
|------|--------|
| `]]` | Jump to next reference |
| `[[` | Jump to previous reference |

### Diagnostics (Errors/Warnings)
| Keys | Action |
|------|--------|
| `[d` | Go to previous diagnostic |
| `]d` | Go to next diagnostic |
| `Space + e` | Show diagnostic details |
| `Space + sd` | Search diagnostics (via snacks.picker) |

### LSP Commands
| Command | Action |
|---------|--------|
| `:LspInfo` | Show attached LSP clients |
| `:LspRestart` | Restart LSP servers |
| `:Mason` | Open Mason (LSP installer) |

---

## Scrolling the Hover/Signature Popup

When a documentation popup appears (from `K` or completion):

| Keys | Action |
|------|--------|
| `Ctrl+f` | Scroll down in popup |
| `Ctrl+b` | Scroll up in popup |
| `Ctrl+d` | Scroll down half page |
| `Ctrl+u` | Scroll up half page |

---

## File Navigation

### Snacks Picker (replaces Telescope)
| Keys | Action |
|------|--------|
| `Space + ff` | Find files |
| `Space + fg` | Live grep (search text) |
| `Space + fb` | List buffers |
| `Space + fh` | Help tags |
| `Space + fs` | Buffer lines (fuzzy find in current buffer) |
| `Space + fr` | Recent files |
| `Space + fc` | Find config files |

### Snacks Explorer (replaces nvim-tree)
| Keys | Action |
|------|--------|
| `Space + n` | Toggle file explorer |
| `Space + ni` | Toggle showing gitignored files (and reopen explorer) |
| `Ctrl+w h` | Focus explorer (from file) |
| `Ctrl+w l` | Focus file (from explorer) |
| `Ctrl+w w` | Cycle focus between windows |
| `Enter` | Open file (stays in explorer) |
| `o` | Open file and focus it |
| `q` | Close explorer |
| `H` | Toggle hidden files |
| `I` | Toggle ignored files |
| `a` | Add file/directory |
| `d` | Delete file/directory |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` | Yank path |
| `p` | Paste |

### Search
| Keys | Action |
|------|--------|
| `Space + sd` | Search diagnostics |
| `Space + sk` | Search keymaps |
| `Space + sc` | Search command history |
| `Space + sw` | Grep word under cursor |

### Harpoon (Quick file switching)
| Keys | Action |
|------|--------|
| `Space + a` | Add file to Harpoon |
| `Space + r` | Remove file from Harpoon |
| `Space + h` | Open Harpoon menu |
| `Space + j` | Jump to file 1 |
| `Space + k` | Jump to file 2 |
| `Space + l` | Jump to file 3 |
| `Space + ;` | Jump to file 4 |

---

## General Neovim Navigation

### Moving Around
| Keys | Action |
|------|--------|
| `h/j/k/l` | Left/down/up/right |
| `w` | Next word |
| `b` | Previous word |
| `e` | End of word |
| `0` | Start of line |
| `$` | End of line |
| `^` | First non-blank character |
| `gg` | Go to top of file |
| `G` | Go to bottom of file |
| `{number}G` | Go to line number |
| `%` | Jump to matching bracket |
| `Ctrl+d` | Scroll down half page |
| `Ctrl+u` | Scroll up half page |
| `Ctrl+f` | Scroll down full page |
| `Ctrl+b` | Scroll up full page |
| `zz` | Center cursor on screen |
| `zt` | Cursor to top of screen |
| `zb` | Cursor to bottom of screen |

### Search
| Keys | Action |
|------|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |
| `*` | Search word under cursor |
| `#` | Search word under cursor (backward) |

---

## Editing

### Basic Editing
| Keys | Action |
|------|--------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `I` | Insert at start of line |
| `A` | Insert at end of line |
| `o` | New line below |
| `O` | New line above |
| `r` | Replace single character |
| `R` | Replace mode |
| `x` | Delete character |
| `dd` | Delete line |
| `D` | Delete to end of line |
| `cc` | Change entire line |
| `C` | Change to end of line |
| `ciw` | Change inner word |
| `ci"` | Change inside quotes |
| `ci(` | Change inside parentheses |
| `yy` | Yank (copy) line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Repeat last change |

### Visual Mode
| Keys | Action |
|------|--------|
| `v` | Visual mode (character) |
| `V` | Visual line mode |
| `Ctrl+v` | Visual block mode |
| `>` | Indent selection |
| `<` | Unindent selection |
| `y` | Yank selection |
| `d` | Delete selection |
| `c` | Change selection |

---

## Windows & Buffers

### Window Management
| Keys | Action |
|------|--------|
| `Ctrl+w s` | Split horizontal |
| `Ctrl+w v` | Split vertical |
| `Ctrl+w h/j/k/l` | Move to window |
| `Ctrl+w q` | Close window |
| `Ctrl+w =` | Equal window sizes |
| `Ctrl+w _` | Maximize height |
| `Ctrl+w \|` | Maximize width |
| `Space + tv` | Open terminal (vertical split) |
| `Space + th` | Open terminal (horizontal split) |
| `Ctrl+/` | Toggle floating terminal (snacks) |

### Buffers
| Keys | Action |
|------|--------|
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Close buffer |
| `:ls` | List buffers |
| `Space + fb` | Buffer list (snacks.picker) |
| `Space + bd` | Delete buffer (snacks.bufdelete) |

---

## Git (Gitsigns)

| Keys | Action |
|------|--------|
| `Space + gs` | Stage hunk |
| `Space + gr` | Reset hunk |
| `Space + gS` | Stage buffer |
| `Space + gR` | Reset buffer |
| `Space + gp` | Preview hunk |
| `Space + gb` | Blame line |
| `Space + gd` | Diff this |
| `Space + gD` | Diff this ~ |
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `Space + tb` | Toggle line blame |
| `Space + td` | Preview hunk inline |

---

## Git (Snacks)

| Keys | Action |
|------|--------|
| `Space + gg` | Open LazyGit |
| `Space + gl` | Git log (via picker) |
| `Space + gf` | Git file log (via picker) |

---

## Debugging (DAP)

### Breakpoints
| Keys | Action |
|------|--------|
| `Space + db` | Toggle breakpoint |
| `Space + dB` | Set conditional breakpoint |
| `Space + dl` | Set log point |

### Execution Control
| Keys | Action |
|------|--------|
| `Space + dc` | Continue / Start debugging |
| `Space + di` | Step into |
| `Space + do` | Step over |
| `Space + dO` | Step out |
| `Space + dr` | Restart |
| `Space + dq` | Terminate |

### UI & Evaluation
| Keys | Action |
|------|--------|
| `Space + du` | Toggle DAP UI |
| `Space + de` | Evaluate expression (normal/visual) |
| `Space + dR` | Open REPL |

---

## Diffview (Conflict Resolution)

### Opening/Closing
| Keys | Action |
|------|--------|
| `Space + dv` | Open Diffview (see all changes) |
| `Space + dC` | Close Diffview |
| `Space + dh` | File history (current file) |
| `Space + dH` | Branch history |

### Conflict Resolution (inside Diffview)
| Keys | Action |
|------|--------|
| `Space + co` | Choose Ours (your changes) |
| `Space + ct` | Choose Theirs (incoming changes) |
| `Space + cb` | Choose Base |
| `Space + ca` | Choose All (both versions) |
| `Space + cB` | Choose Base (whole file) |
| `]x` | Next conflict |
| `[x` | Previous conflict |

---

## Toggles (Snacks)

| Keys | Action |
|------|--------|
| `Space + us` | Toggle spelling |
| `Space + uw` | Toggle wrap |
| `Space + uL` | Toggle relative number |
| `Space + ud` | Toggle diagnostics |
| `Space + ul` | Toggle line numbers |
| `Space + uh` | Toggle inlay hints |
| `Space + ug` | Toggle indent guides |
| `Space + uD` | Toggle dim mode |

---

## Notifications (Snacks)

| Keys | Action |
|------|--------|
| `Space + un` | Dismiss all notifications |
| `Space + nh` | Show notification history |

---

## Formatting

| Keys | Action |
|------|--------|
| `Space + gf` | Format buffer |
| Auto on save | Files auto-format on save |

---

## Useful Commands

| Command | Action |
|---------|--------|
| `:w` | Save file |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:e filename` | Edit/open file |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP installer |
| `:checkhealth` | Check Neovim health |
| `:checkhealth snacks` | Check snacks.nvim health |
| `:set wrap` | Enable line wrap |
| `:set nowrap` | Disable line wrap |
| `:noh` | Clear search highlight |
| `:DiffviewOpen` | Open Diffview |
| `:DiffviewClose` | Close Diffview |
| `:DiffviewFileHistory` | View git file history |

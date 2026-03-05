# LazyGit Commands Reference

## Opening LazyGit

### In Neovim
| Keys | Action |
|------|--------|
| `Space + gg` | Open LazyGit |

### Neovim Commands
| Command | Action |
|---------|--------|
| `:LazyGit` | Open LazyGit |
| `:LazyGitCurrentFile` | Open with current file's history |
| `:LazyGitFilter` | Open with commit filter |
| `:LazyGitFilterCurrentFile` | Filter commits for current file |
| `:LazyGitConfig` | Open LazyGit config |

### Terminal
```
lazygit
```

## Navigation

| Key | Action |
|-----|--------|
| `j/k` | Navigate up/down |
| `h/l` | Switch panels |
| `[/]` | Jump to previous/next panel |
| `Tab` | Switch to next panel |
| `Shift+Tab` | Switch to previous panel |
| `?` | Show all keybindings |
| `q` | Quit |
| `Esc` | Cancel/go back |

## Staging & Commits

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file or line |
| `a` | Stage all files |
| `c` | Commit staged changes |
| `C` | Commit with editor |
| `A` | Amend last commit |
| `s` | Squash commit |
| `r` | Reword commit message |
| `d` | Drop commit / delete file |

## Branches

| Key | Action |
|-----|--------|
| `b` | Branch menu |
| `n` | New branch |
| `Space` | Checkout branch |
| `M` | Merge into current branch |
| `R` | Rebase onto branch |
| `d` | Delete branch |
| `f` | Fast-forward branch |

## Remote Operations

| Key | Action |
|-----|--------|
| `P` | Push |
| `p` | Pull |
| `f` | Fetch |
| `shift+P` | Force push |

## Stash

| Key | Action |
|-----|--------|
| `s` | Stash changes (in files panel) |
| `Space` | Apply stash |
| `g` | Pop stash |
| `d` | Drop stash |

## Files Panel

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage |
| `Enter` | View file diff |
| `e` | Edit file |
| `o` | Open file in default app |
| `d` | Discard changes |
| `D` | Discard all changes |
| `i` | Add to .gitignore |

## Diff View

| Key | Action |
|-----|--------|
| `Enter` | Expand/collapse file |
| `Space` | Stage/unstage line or hunk |
| `v` | Toggle visual line selection |
| `a` | Stage/unstage hunk |

## Useful Tips

- Press `?` in any panel to see context-specific keybindings
- Press `x` to open command menu with all available actions
- Use `/` to filter in any list
- Press `+` and `-` to expand/collapse diffs

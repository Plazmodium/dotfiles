# Dotfiles

My personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Package    | Description                          |
| ---------- | ------------------------------------ |
| `nvim`     | Neovim config (Lazy.nvim, LSP, DAP) |
| `starship` | Starship prompt (Starfield theme)    |
| `zsh`      | Zsh config, aliases, PATH setup      |
| `git`      | Global git ignore                    |
| `opencode` | OpenCode agents, plugins, sounds     |
| `fabric`   | Fabric AI patterns and strategies    |

## Setup on a New Machine

```bash
# Install stow
brew install stow

# Clone the repo
git clone git@github.com:Plazmodium/dotfiles.git ~/.dotfiles

# Stow everything
cd ~/.dotfiles
stow nvim starship zsh git opencode fabric
```

> **Note:** If default config files already exist (e.g., `~/.zshrc`), remove or back them up before stowing.

## Managing Dotfiles

```bash
# Add a new package
mkdir -p ~/.dotfiles/appX/.config
mv ~/.config/appX ~/.dotfiles/appX/.config/appX
cd ~/.dotfiles && stow appX

# Remove symlinks for a package
stow -D appX

# Refresh symlinks
stow -R appX
```

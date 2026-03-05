# Fullstack Neovim Configuration

## Spring Boot (Java) + Angular (TypeScript) Development

This document provides comprehensive documentation for a fullstack Neovim configuration
supporting both backend (Spring Boot/Java) and frontend (Angular/TypeScript) development.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Prerequisites](#2-prerequisites)
3. [Installation](#3-installation)
4. [Configuration Deep Dive](#4-configuration-deep-dive)
5. [Plugin Reference](#5-plugin-reference)
6. [Complete Keymap Reference](#6-complete-keymap-reference)
7. [Workflows](#7-workflows)
8. [Troubleshooting](#8-troubleshooting)
9. [Customization Guide](#9-customization-guide)
10. [Quick Reference Card](#10-quick-reference-card)

---

## 1. Overview

### 1.1 Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         NEOVIM FULLSTACK SETUP                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────┐    ┌─────────────────────────────┐        │
│  │      FRONTEND STACK         │    │      BACKEND STACK          │        │
│  │                             │    │                             │        │
│  │  Languages:                 │    │  Languages:                 │        │
│  │  • TypeScript               │    │  • Java 17+                 │        │
│  │  • JavaScript               │    │                             │        │
│  │  • HTML / CSS / SCSS        │    │  Framework:                 │        │
│  │                             │    │  • Spring Boot              │        │
│  │  Framework:                 │    │                             │        │
│  │  • Angular                  │    │  Build Tools:               │        │
│  │                             │    │  • Maven                    │        │
│  │  LSP Servers:               │    │  • Gradle                   │        │
│  │  • ts_ls (TypeScript)       │    │                             │        │
│  │  • angularls (Angular)      │    │  LSP Server:                │        │
│  │  • eslint (Linting)         │    │  • jdtls (Eclipse JDT)      │        │
│  │  • html, cssls, tailwindcss │    │                             │        │
│  │  • emmet_ls (Emmet)         │    │  Debugging:                 │        │
│  │                             │    │  • java-debug-adapter       │        │
│  │  Formatting:                │    │  • java-test (JUnit)        │        │
│  │  • Prettier                 │    │                             │        │
│  │                             │    │  Formatting:                │        │
│  │  Linting:                   │    │  • google-java-format       │        │
│  │  • ESLint                   │    │                             │        │
│  └─────────────────────────────┘    └─────────────────────────────┘        │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        SHARED TOOLING                                │   │
│  │                                                                      │   │
│  │  Plugin Manager: lazy.nvim          Completion: nvim-cmp            │   │
│  │  Syntax: nvim-treesitter            Fuzzy Finder: Telescope         │   │
│  │  File Explorer: nvim-tree           Git: gitsigns + lazygit         │   │
│  │  Quick Nav: Harpoon                 Diagnostics: Trouble            │   │
│  │  Debugging: nvim-dap + dap-ui       Status Line: lualine            │   │
│  │  Keymaps: which-key                 Theme: Monokai Pro              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Technology Stack Summary

| Layer | Frontend | Backend |
|-------|----------|---------|
| **Language** | TypeScript, JavaScript | Java 17+ |
| **Framework** | Angular | Spring Boot |
| **LSP** | ts_ls, angularls, eslint | jdtls (nvim-jdtls) |
| **Formatter** | Prettier | google-java-format |
| **Linter** | ESLint | jdtls built-in |
| **Debugger** | js-debug-adapter (optional) | java-debug-adapter |
| **Test Runner** | Angular CLI / Jest | JUnit (java-test) |
| **Build Tool** | npm / Angular CLI | Maven / Gradle |

### 1.3 File Structure

```
~/.config/nvim/
├── init.lua                    # Entry point: bootstraps lazy.nvim
├── AGENTS.md                   # AI coding agent instructions
├── FULLSTACK-SETUP.md          # This documentation
│
└── lua/
    ├── vim-commands.lua        # Core Neovim settings
    ├── plugins.lua             # Placeholder (unused)
    │
    └── plugins/                # Plugin specifications (lazy.nvim)
        ├── lsp-config.lua      # LSP servers + nvim-cmp completion
        ├── java.lua            # Java/Spring Boot (nvim-jdtls)
        ├── dap.lua             # Debug Adapter Protocol
        ├── none-ls.lua         # Formatters & linters
        ├── telescope.lua       # Fuzzy finder
        ├── neotree.lua         # File explorer (nvim-tree)
        ├── treesitter.lua      # Syntax highlighting
        ├── harpoon.lua         # Quick file navigation
        ├── gitsigns.lua        # Git integration
        ├── lazygit.lua         # Git terminal UI
        ├── folke.lua           # Trouble + which-key
        ├── themes.lua          # Monokai Pro colorscheme
        ├── lualine.lua         # Status line
        ├── autopairs.lua       # Auto-close brackets
        └── commenting.lua      # Comment toggling
```

---

## 2. Prerequisites

### 2.1 System Requirements

- **Neovim** 0.9+ (0.10+ recommended)
- **Git** 2.x+
- **ripgrep** (for Telescope live_grep)
- **A Nerd Font** (for icons)

### 2.2 Java Installation

Spring Boot 3.x requires **Java 17 or higher**. Choose one installation method:

#### Option A: SDKMAN (Recommended)

SDKMAN allows easy management of multiple Java versions.

```bash
# Install SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install Java versions
sdk install java 17.0.9-tem    # Java 17 (LTS)
sdk install java 21.0.2-tem    # Java 21 (LTS)

# Set default version
sdk default java 21.0.2-tem

# Verify installation
java --version
```

**SDKMAN paths** (used in `java.lua`):
```
~/.sdkman/candidates/java/17.0.9-tem
~/.sdkman/candidates/java/21.0.2-tem
```

#### Option B: Homebrew (macOS)

```bash
# Install Java
brew install openjdk@17
brew install openjdk@21

# Create symlinks (required for system Java)
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk

# Add to PATH (in ~/.zshrc or ~/.bashrc)
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

# Verify
java --version
```

**Homebrew paths** (for `java.lua` configuration):
```
/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
```

#### Option C: Linux Package Manager

```bash
# Ubuntu/Debian
sudo apt install openjdk-17-jdk openjdk-21-jdk

# Fedora
sudo dnf install java-17-openjdk-devel java-21-openjdk-devel

# Arch
sudo pacman -S jdk17-openjdk jdk21-openjdk
```

**Linux paths**:
```
/usr/lib/jvm/java-17-openjdk
/usr/lib/jvm/java-21-openjdk
```

### 2.3 Environment Variables

Add to your shell configuration (`~/.zshrc`, `~/.bashrc`):

```bash
# Java (adjust path based on your installation method)
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
# Or for Homebrew:
# export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"

export PATH="$JAVA_HOME/bin:$PATH"

# Maven (if installed separately)
export M2_HOME="/opt/homebrew/opt/maven/libexec"
export PATH="$M2_HOME/bin:$PATH"
```

### 2.4 Node.js Installation (for Angular)

```bash
# Using nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts
nvm use --lts

# Or using Homebrew
brew install node

# Verify
node --version
npm --version

# Install Angular CLI globally
npm install -g @angular/cli
```

### 2.5 Additional Tools

```bash
# ripgrep (required for Telescope live_grep)
brew install ripgrep    # macOS
sudo apt install ripgrep # Ubuntu/Debian

# lazygit (for git terminal UI)
brew install lazygit    # macOS
sudo apt install lazygit # Ubuntu/Debian (via PPA)

# Maven (for Spring Boot projects)
brew install maven      # macOS
sudo apt install maven  # Ubuntu/Debian

# Or use Gradle
brew install gradle
```

---

## 3. Installation

### 3.1 Step-by-Step Setup

#### Step 1: Clone/Copy Configuration

If starting fresh:
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone your config (or copy files)
git clone <your-repo> ~/.config/nvim
```

#### Step 2: Launch Neovim

```bash
nvim
```

On first launch:
- lazy.nvim will bootstrap itself
- Plugins will be automatically installed
- Wait for installation to complete

#### Step 3: Install Mason Packages

Run these commands inside Neovim:

```vim
" Frontend LSP servers (auto-installed via mason-lspconfig)
" These should install automatically, but you can verify with :Mason

" Backend tools (install manually)
:MasonInstall jdtls
:MasonInstall java-debug-adapter
:MasonInstall java-test
:MasonInstall google-java-format

" Optional: JavaScript/TypeScript debugging
:MasonInstall js-debug-adapter
```

#### Step 4: Configure Java Runtimes

Edit `~/.config/nvim/lua/plugins/java.lua` and update the `runtimes` section (around line 263):

**For SDKMAN:**
```lua
configuration = {
    runtimes = {
        {
            name = "JavaSE-17",
            path = vim.fn.expand("~/.sdkman/candidates/java/17.0.9-tem"),
        },
        {
            name = "JavaSE-21",
            path = vim.fn.expand("~/.sdkman/candidates/java/21.0.2-tem"),
        },
    },
},
```

**For Homebrew:**
```lua
configuration = {
    runtimes = {
        {
            name = "JavaSE-17",
            path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
        },
        {
            name = "JavaSE-21",
            path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
        },
    },
},
```

#### Step 5: Sync Plugins

```vim
:Lazy sync
```

#### Step 6: Verify Installation

```vim
" Check overall health
:checkhealth

" Check LSP status (open a .java or .ts file first)
:LspInfo

" Check Mason packages
:Mason

" Check treesitter parsers
:TSInstallInfo
```

### 3.2 Mason Packages Summary

| Package | Purpose | Installation |
|---------|---------|--------------|
| **Frontend (auto-installed)** | | |
| ts_ls | TypeScript/JavaScript LSP | mason-lspconfig |
| angularls | Angular template support | mason-lspconfig |
| eslint | JS/TS linting | mason-lspconfig |
| html | HTML LSP | mason-lspconfig |
| cssls | CSS LSP | mason-lspconfig |
| tailwindcss | Tailwind CSS | mason-lspconfig |
| emmet_ls | Emmet abbreviations | mason-lspconfig |
| jsonls | JSON LSP | mason-lspconfig |
| dockerls | Dockerfile LSP | mason-lspconfig |
| lua_ls | Lua LSP (for config) | mason-lspconfig |
| **Backend (manual install)** | | |
| jdtls | Java LSP (Eclipse) | `:MasonInstall jdtls` |
| java-debug-adapter | Java debugging | `:MasonInstall java-debug-adapter` |
| java-test | JUnit test runner | `:MasonInstall java-test` |
| google-java-format | Java formatter | `:MasonInstall google-java-format` |

---

## 4. Configuration Deep Dive

### 4.1 Core Settings (`lua/vim-commands.lua`)

This file configures core Neovim behavior before plugins load.

#### Editor Behavior

```lua
vim.g.loaded_netrw = 1          -- Disable netrw (using nvim-tree instead)
vim.g.loaded_netrwPlugin = 1

vim.opt.scrolloff = 8           -- Keep 8 lines visible above/below cursor
vim.opt.undofile = true         -- Persistent undo across sessions
vim.opt.ignorecase = true       -- Case-insensitive search
vim.opt.smartcase = true        -- Case-sensitive if uppercase in pattern
```

#### Indentation

```lua
vim.cmd("set expandtab")        -- Use spaces instead of tabs
vim.cmd("set tabstop=2")        -- Tab width = 2 spaces
vim.cmd("set softtabstop=2")    -- Soft tab width = 2 spaces
vim.cmd("set shiftwidth=0")     -- Use tabstop value for indentation
```

#### Visual Customizations

```lua
vim.opt.termguicolors = true    -- Enable 24-bit RGB colors
vim.wo.relativenumber = true    -- Relative line numbers

-- Orange cursor and selection theme
vim.api.nvim_command("highlight OrangeCursor guifg=white guibg=#ff8800")
vim.api.nvim_command("highlight Visual guibg=#ff8800 guifg=white")
vim.api.nvim_command("highlight Search guibg=#ff8800 guifg=white")
vim.api.nvim_command("highlight CursorLine guibg=#402200")
vim.api.nvim_command("highlight CursorLineNr guifg=#ff8800")
```

#### Auto-Format on Save

```lua
-- Automatically format files when saving
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
```

This triggers the LSP formatter (Prettier for JS/TS/HTML/CSS, google-java-format for Java) whenever you save a file.

#### Leader Key

```lua
vim.g.mapleader = " "           -- Space is the leader key
```

All custom keymaps use `<leader>` (Space) as a prefix.

### 4.2 LSP Configuration (`lua/plugins/lsp-config.lua`)

#### How LSP Works

LSP (Language Server Protocol) provides IDE features:
- **Completions**: Suggestions as you type
- **Diagnostics**: Errors and warnings
- **Go to Definition**: Jump to where something is defined
- **Hover**: Show documentation on `K`
- **Code Actions**: Quick fixes and refactorings

```
┌─────────────┐     LSP Protocol      ┌─────────────────┐
│   Neovim    │ ◄──────────────────► │  Language Server │
│  (Client)   │   JSON-RPC over      │  (ts_ls, jdtls)  │
└─────────────┘   stdio/TCP          └─────────────────┘
```

#### Mason + mason-lspconfig

**Mason** is a package manager for LSP servers, formatters, and linters.

**mason-lspconfig** bridges Mason with nvim-lspconfig:
```lua
require("mason-lspconfig").setup({
    ensure_installed = {
        "ts_ls",        -- TypeScript
        "angularls",    -- Angular
        "eslint",       -- ESLint
        "html",         -- HTML
        "cssls",        -- CSS
        -- ... more servers
    },
})
```

#### LSP Keymaps

These keymaps work for **all languages**:

```lua
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})           -- Show documentation
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})     -- Go to definition
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})  -- Code actions

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})   -- Previous diagnostic
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})   -- Next diagnostic
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})  -- Show diagnostic
```

#### Completion System (nvim-cmp)

nvim-cmp provides autocompletion with multiple sources:

```lua
sources = cmp.config.sources({
    { name = "nvim_lsp" },    -- LSP completions (highest priority)
    { name = "luasnip" },     -- Snippet completions
    { name = "buffer" },      -- Words from current buffer
    { name = "path" },        -- File path completions
}),
```

**Completion Keymaps:**

| Key | Action |
|-----|--------|
| `<Tab>` | Next completion item / Expand snippet |
| `<S-Tab>` | Previous completion item |
| `<CR>` | Confirm selection |
| `<C-Space>` | Trigger completion manually |
| `<C-e>` | Close completion menu |
| `<C-b>` / `<C-f>` | Scroll documentation |

### 4.3 Java/Spring Boot (`lua/plugins/java.lua`)

#### Why nvim-jdtls Instead of lspconfig?

Unlike other languages, Java requires special handling that nvim-lspconfig cannot provide:

| Feature | nvim-lspconfig | nvim-jdtls |
|---------|---------------|------------|
| Basic LSP (completions, diagnostics) | Yes | Yes |
| Debug adapter (DAP) integration | No | Yes |
| Test runner (JUnit) integration | No | Yes |
| Extract variable/method/constant | Limited | Full support |
| Organize imports | Limited | Full support |
| Hot code replace during debugging | No | Yes |
| Project-aware root detection | Basic | Maven/Gradle aware |

#### What is JDTLS?

JDTLS (Java Development Tools Language Server) is Eclipse's Java language server.
It powers VS Code's Java extension and provides enterprise-grade Java support.

**Features:**
- IntelliSense with Spring Boot awareness
- Refactoring (rename, extract, inline)
- Import management
- Code generation (getters, setters, constructors)
- Maven/Gradle project support

#### Spring Boot Awareness

JDTLS understands Spring annotations:

```java
@RestController                    // Recognized as REST endpoint
@Autowired                         // Shows injection candidates
@Value("${property}")              // Links to application.properties
@RequestMapping("/api")            // Understood as route
```

The `favoriteStaticMembers` configuration enables quick imports for testing:

```lua
favoriteStaticMembers = {
    "org.junit.jupiter.api.Assertions.*",
    "org.mockito.Mockito.*",
    "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
    "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
},
```

#### Workspace Management

JDTLS creates a workspace directory for each project:

```
~/.local/share/nvim/jdtls-workspace/
├── my-spring-app/          # Workspace for project 1
│   ├── .metadata/
│   └── .projects/
├── another-project/        # Workspace for project 2
└── ...
```

Each workspace stores:
- Compiled class files
- Index data for fast navigation
- Project-specific settings

#### Java Runtime Configuration

Configure available Java versions in `java.lua`:

```lua
configuration = {
    runtimes = {
        -- SDKMAN installations
        {
            name = "JavaSE-17",
            path = vim.fn.expand("~/.sdkman/candidates/java/17.0.9-tem"),
        },
        {
            name = "JavaSE-21",
            path = vim.fn.expand("~/.sdkman/candidates/java/21.0.2-tem"),
        },
        
        -- Or Homebrew installations
        -- {
        --     name = "JavaSE-17",
        --     path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
        -- },
        -- {
        --     name = "JavaSE-21",
        --     path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
        -- },
    },
},
```

JDTLS automatically selects the correct runtime based on the project's `pom.xml` or `build.gradle`.

### 4.4 Debugging (`lua/plugins/dap.lua`)

#### What is DAP?

DAP (Debug Adapter Protocol) standardizes debugger communication, similar to how LSP standardizes language features.

```
┌─────────────┐     DAP Protocol      ┌─────────────────┐
│   Neovim    │ ◄──────────────────► │  Debug Adapter   │
│ (nvim-dap)  │                      │ (java-debug)     │
└─────────────┘                      └─────────────────┘
                                              │
                                              ▼
                                     ┌─────────────────┐
                                     │   JVM / App     │
                                     │ (Spring Boot)   │
                                     └─────────────────┘
```

#### DAP UI Panels

nvim-dap-ui provides a visual debugging interface:

```
┌─────────────────────────────────────────────────────────────────┐
│                          NEOVIM                                 │
├──────────────────┬──────────────────────────────────────────────┤
│                  │                                              │
│  SCOPES (25%)    │                                              │
│  • Local vars    │              SOURCE CODE                     │
│  • Arguments     │                                              │
│                  │     15:     public String hello() {          │
├──────────────────┤  ► 16:         return "Hello";  ◄ STOPPED   │
│  BREAKPOINTS     │     17:     }                                │
│  (25%)           │                                              │
│  • Main.java:42  │                                              │
│  • Test.java:10  │                                              │
├──────────────────┤                                              │
│  STACKS (25%)    │                                              │
│  • hello()       │                                              │
│  • main()        │                                              │
├──────────────────┤                                              │
│  WATCHES (25%)   │                                              │
│  • myVariable    │                                              │
│                  │                                              │
├──────────────────┴──────────────────────────────────────────────┤
│  REPL (50%)                    │  CONSOLE (50%)                 │
│  > evaluate expression         │  Application output...         │
└────────────────────────────────┴────────────────────────────────┘
```

#### Breakpoint Types

| Type | Symbol | Description |
|------|--------|-------------|
| Regular | ● | Stops execution at this line |
| Conditional | ● | Stops only when condition is true |
| Log Point | ◆ | Logs message without stopping |
| Rejected | ○ | Breakpoint couldn't be set |

#### Virtual Text

During debugging, variable values appear inline:

```java
public void calculate(int x, int y) {    // x = 5, y = 10
    int sum = x + y;                      // sum = 15
    int product = x * y;                  // product = 50
    return sum + product;
}
```

### 4.5 Formatting & Linting (`lua/plugins/none-ls.lua`)

#### What is none-ls?

none-ls (formerly null-ls) bridges external tools with Neovim's LSP client.
This allows non-LSP tools to provide LSP-like features.

```
┌─────────────┐                    ┌─────────────────┐
│   Neovim    │ ◄── LSP API ────► │    none-ls      │
│             │                    │    (bridge)     │
└─────────────┘                    └────────┬────────┘
                                            │
                           ┌────────────────┼────────────────┐
                           ▼                ▼                ▼
                    ┌──────────┐    ┌──────────┐    ┌──────────────┐
                    │ Prettier │    │  ESLint  │    │ google-java  │
                    │          │    │          │    │   -format    │
                    └──────────┘    └──────────┘    └──────────────┘
```

#### Configured Formatters

| Formatter | Languages | Trigger |
|-----------|-----------|---------|
| **Prettier** | JS, TS, HTML, CSS, JSON, YAML, MD | On save / `<leader>gf` |
| **google-java-format** | Java | On save / `<leader>gf` |
| **stylua** | Lua | On save / `<leader>gf` |

#### Configured Linters

| Linter | Languages | Features |
|--------|-----------|----------|
| **ESLint** | JS, TS | Diagnostics + Code actions |

#### Format on Save

Formatting is triggered automatically on save via the autocmd in `vim-commands.lua`:

```lua
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
```

To format manually: `<leader>gf`

---

## 5. Plugin Reference

### 5.1 Navigation & Search

#### Telescope (`lua/plugins/telescope.lua`)

Fuzzy finder for files, text, and more.

**Features:**
- File finder with preview
- Live grep (search in files)
- Buffer switcher
- Help tags browser

**Configuration:**
- Excludes: `node_modules`, `dist`, `.git`, `target`, `build`, `.gradle`
- Uses ripgrep for fast searching

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help tags |
| `<leader>fs` | Fuzzy find in current buffer |

#### Harpoon (`lua/plugins/harpoon.lua`)

Quick navigation between frequently used files.

**Concept:** Mark important files and jump to them instantly with single keypresses.

| Keymap | Action |
|--------|--------|
| `<leader>a` | Add current file to Harpoon |
| `<leader>r` | Remove current file from Harpoon |
| `<leader>h` | Toggle Harpoon menu |
| `<leader>j` | Jump to file 1 |
| `<leader>k` | Jump to file 2 |
| `<leader>l` | Jump to file 3 |
| `<leader>;` | Jump to file 4 |

#### nvim-tree (`lua/plugins/neotree.lua`)

File explorer sidebar.

**Features:**
- Tree view of project files
- Git status indicators
- File operations (create, rename, delete)

| Keymap | Action |
|--------|--------|
| `<leader>n` | Toggle file tree |

**In nvim-tree buffer:**

| Key | Action |
|-----|--------|
| `<CR>` | Open file/folder |
| `a` | Create file/folder |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `p` | Paste |
| `R` | Refresh |

### 5.2 Git Integration

#### Gitsigns (`lua/plugins/gitsigns.lua`)

Inline git information and hunk management.

**Signs in gutter:**
| Sign | Meaning |
|------|---------|
| `│` | Added line |
| `│` | Changed line |
| `_` | Deleted line |
| `‾` | Top deleted |
| `~` | Changed and deleted |
| `┆` | Untracked |

**Keymaps:**

| Keymap | Action |
|--------|--------|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage entire buffer |
| `<leader>gR` | Reset entire buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line (full) |
| `<leader>tb` | Toggle line blame |
| `<leader>gd` | Diff this file |
| `<leader>gD` | Diff against ~ |
| `<leader>td` | Preview hunk inline |

#### LazyGit (`lua/plugins/lazygit.lua`)

Terminal-based Git UI.

| Keymap | Action |
|--------|--------|
| `<leader>gg` | Open LazyGit |

**In LazyGit:**
- Full git workflow: stage, commit, push, pull, branch, merge
- Interactive rebase
- Stash management
- Log viewing

### 5.3 Code Intelligence

#### Treesitter (`lua/plugins/treesitter.lua`)

Advanced syntax highlighting using parsing.

**Features:**
- Language-aware highlighting
- Auto-installs parsers when opening files
- Better indentation

**Supported languages (auto-installed):**
- Java, TypeScript, JavaScript
- HTML, CSS, SCSS
- JSON, YAML, Markdown
- Lua, and many more

#### Which-key (`lua/plugins/folke.lua`)

Displays available keymaps as you type.

Press `<leader>` and wait - a popup shows all available keymaps starting with leader.

#### Trouble (`lua/plugins/folke.lua`)

Diagnostics list panel.

| Keymap | Action |
|--------|--------|
| `<leader>xx` | Toggle Trouble diagnostics |

Shows all errors and warnings across the project in a navigable list.

### 5.4 Editing

#### Comment.nvim (`lua/plugins/commenting.lua`)

Toggle comments easily.

| Keymap | Mode | Action |
|--------|------|--------|
| `gcc` | Normal | Toggle line comment |
| `gc` | Visual | Toggle comment for selection |
| `gbc` | Normal | Toggle block comment |

#### nvim-autopairs (`lua/plugins/autopairs.lua`)

Automatically close brackets, quotes, etc.

| Type | Result |
|------|--------|
| `(` | `()` with cursor inside |
| `{` | `{}` with cursor inside |
| `[` | `[]` with cursor inside |
| `"` | `""` with cursor inside |
| `'` | `''` with cursor inside |

### 5.5 UI

#### Lualine (`lua/plugins/lualine.lua`)

Status line at the bottom of the screen.

Shows:
- Mode (NORMAL, INSERT, VISUAL)
- Git branch
- File name and status
- Diagnostics count
- Cursor position

**Theme:** Dracula

#### Monokai Pro (`lua/plugins/themes.lua`)

Color scheme with orange accent highlights.

**Custom highlights:**
- Orange cursor
- Orange visual selection
- Orange search highlights
- Orange cursor line number

---

## 6. Complete Keymap Reference

### 6.1 Leader Key

The leader key is **Space** (`<leader>` = `<Space>`).

### 6.2 General / Editor

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `<leader>tv` | n | Open terminal (vertical split) | vim-commands.lua |
| `<leader>th` | n | Open terminal (horizontal split) | vim-commands.lua |

### 6.3 LSP (All Languages)

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `K` | n | Hover documentation | lsp-config.lua |
| `gd` | n | Go to definition | lsp-config.lua |
| `<leader>ca` | n, v | Code actions | lsp-config.lua |
| `<leader>e` | n | Show diagnostic float | lsp-config.lua |
| `[d` | n | Previous diagnostic | lsp-config.lua |
| `]d` | n | Next diagnostic | lsp-config.lua |
| `<leader>gf` | n | Format file | none-ls.lua |

### 6.4 Java / Spring Boot

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `<leader>jo` | n | Organize imports | java.lua |
| `<leader>jv` | n, v | Extract variable | java.lua |
| `<leader>jc` | n, v | Extract constant | java.lua |
| `<leader>jm` | v | Extract method | java.lua |
| `<leader>jtc` | n | Run test class | java.lua |
| `<leader>jtm` | n | Run test nearest method | java.lua |
| `<leader>jtp` | n | Pick test to run | java.lua |

### 6.5 Debugging (DAP)

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `<leader>db` | n | Toggle breakpoint | dap.lua |
| `<leader>dB` | n | Conditional breakpoint | dap.lua |
| `<leader>dl` | n | Log point | dap.lua |
| `<leader>dc` | n | Continue / Start | dap.lua |
| `<leader>di` | n | Step into | dap.lua |
| `<leader>do` | n | Step over | dap.lua |
| `<leader>dO` | n | Step out | dap.lua |
| `<leader>dr` | n | Restart | dap.lua |
| `<leader>dq` | n | Terminate | dap.lua |
| `<leader>du` | n | Toggle DAP UI | dap.lua |
| `<leader>de` | n, v | Evaluate expression | dap.lua |
| `<leader>dR` | n | Open REPL | dap.lua |

### 6.6 File Navigation

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `<leader>ff` | n | Find files | telescope.lua |
| `<leader>fg` | n | Live grep | telescope.lua |
| `<leader>fb` | n | List buffers | telescope.lua |
| `<leader>fh` | n | Help tags | telescope.lua |
| `<leader>fs` | n | Fuzzy find in buffer | telescope.lua |
| `<leader>n` | n | Toggle file tree | neotree.lua |

### 6.7 Harpoon (Quick Navigation)

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `<leader>a` | n | Add file to Harpoon | harpoon.lua |
| `<leader>r` | n | Remove file from Harpoon | harpoon.lua |
| `<leader>h` | n | Toggle Harpoon menu | harpoon.lua |
| `<leader>j` | n | Go to Harpoon file 1 | harpoon.lua |
| `<leader>k` | n | Go to Harpoon file 2 | harpoon.lua |
| `<leader>l` | n | Go to Harpoon file 3 | harpoon.lua |
| `<leader>;` | n | Go to Harpoon file 4 | harpoon.lua |

### 6.8 Git

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `<leader>gg` | n | Open LazyGit | lazygit.lua |
| `]c` | n | Next git hunk | gitsigns.lua |
| `[c` | n | Previous git hunk | gitsigns.lua |
| `<leader>gs` | n | Stage hunk | gitsigns.lua |
| `<leader>gr` | n | Reset hunk | gitsigns.lua |
| `<leader>gS` | n | Stage buffer | gitsigns.lua |
| `<leader>gR` | n | Reset buffer | gitsigns.lua |
| `<leader>gp` | n | Preview hunk | gitsigns.lua |
| `<leader>gb` | n | Blame line | gitsigns.lua |
| `<leader>tb` | n | Toggle line blame | gitsigns.lua |
| `<leader>gd` | n | Diff this | gitsigns.lua |
| `<leader>gD` | n | Diff this ~ | gitsigns.lua |
| `<leader>td` | n | Preview hunk inline | gitsigns.lua |

### 6.9 Diagnostics

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `<leader>xx` | n | Toggle Trouble | folke.lua |

### 6.10 Completion (Insert Mode)

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `<Tab>` | i, s | Next item / Expand snippet | lsp-config.lua |
| `<S-Tab>` | i, s | Previous item | lsp-config.lua |
| `<CR>` | i | Confirm selection | lsp-config.lua |
| `<C-Space>` | i | Trigger completion | lsp-config.lua |
| `<C-e>` | i | Abort completion | lsp-config.lua |
| `<C-b>` | i | Scroll docs up | lsp-config.lua |
| `<C-f>` | i | Scroll docs down | lsp-config.lua |

### 6.11 Comments

| Keymap | Mode | Action | Source |
|--------|------|--------|--------|
| `gcc` | n | Toggle line comment | commenting.lua |
| `gc` | v | Toggle comment (selection) | commenting.lua |
| `gbc` | n | Toggle block comment | commenting.lua |

---

## 7. Workflows

### 7.1 Spring Boot Development

#### Creating a New Spring Boot Project

1. **Generate project** at [start.spring.io](https://start.spring.io) or use Spring CLI:
   ```bash
   spring init --dependencies=web,data-jpa,h2 my-app
   cd my-app
   ```

2. **Open in Neovim:**
   ```bash
   nvim .
   ```

3. **Wait for JDTLS** to initialize (watch the status line)

4. **Verify LSP is working:**
   - Open a `.java` file
   - Run `:LspInfo` - should show `jdtls` attached

#### Writing a REST Controller

```java
// src/main/java/com/example/controller/HelloController.java

@RestController                          // <- Completions for Spring annotations
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")                // <- Route completions
    public String hello() {
        return "Hello, World!";
    }
    
    @GetMapping("/hello/{name}")
    public String helloName(@PathVariable String name) {  // <- Parameter completions
        return "Hello, " + name + "!";
    }
}
```

**Tips:**
- Type `@Rest` then `<Tab>` to complete `@RestController`
- Use `<leader>jo` to organize imports after adding annotations
- Use `K` to view documentation for any annotation

#### Running Tests

1. **Open a test file** (e.g., `src/test/java/.../MyTest.java`)

2. **Run all tests in class:**
   ```
   <leader>jtc
   ```

3. **Run test under cursor:**
   ```
   <leader>jtm
   ```

4. **Pick a specific test:**
   ```
   <leader>jtp
   ```

#### Debugging Spring Boot

**Method 1: Debug a Test**

1. Set breakpoints: `<leader>db`
2. Run test with debugger: `<leader>jtm`
3. Execution stops at breakpoints
4. Use debug controls:
   - `<leader>dc` - Continue
   - `<leader>di` - Step into
   - `<leader>do` - Step over
   - `<leader>dO` - Step out

**Method 2: Attach to Running Application**

1. Start Spring Boot with debug port:
   ```bash
   ./mvnw spring-boot:run \
     -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"
   ```

2. Set breakpoints in Neovim: `<leader>db`

3. Attach debugger: `<leader>dc` and select "Attach to Remote JVM"

4. Make a request to your API to trigger breakpoints

#### Common Spring Boot Code Actions

With cursor on relevant code, press `<leader>ca`:

| Context | Available Actions |
|---------|-------------------|
| Class | Generate constructor, getters, setters, toString, equals/hashCode |
| Method | Extract to method, inline |
| Variable | Extract to field, extract to constant |
| Import | Add missing import, organize imports |
| Error | Quick fix suggestions |

### 7.2 Angular Development

#### Creating a New Angular Project

```bash
ng new my-angular-app
cd my-angular-app
nvim .
```

#### Component Development

```typescript
// src/app/hello/hello.component.ts

import { Component } from '@angular/core';  // <- Auto-import with code actions

@Component({
  selector: 'app-hello',
  template: `
    <h1>{{ title }}</h1>                    // <- angularls provides completions
    <button (click)="onClick()">Click</button>
  `
})
export class HelloComponent {
  title = 'Hello, Angular!';
  
  onClick() {                               // <- ts_ls provides JS/TS intelligence
    console.log('Clicked!');
  }
}
```

#### Template Editing

angularls provides:
- Completions for component properties in templates
- Completions for Angular directives (`*ngIf`, `*ngFor`, etc.)
- Error checking in templates
- Go to definition for component references

#### Running Angular CLI Commands

Open a terminal split: `<leader>tv`

```bash
# Serve the app
ng serve

# Generate a component
ng generate component my-component

# Build for production
ng build --prod

# Run tests
ng test
```

### 7.3 Fullstack Workflow

#### Project Structure

Typical fullstack project:

```
my-fullstack-app/
├── backend/                    # Spring Boot
│   ├── src/main/java/
│   ├── src/main/resources/
│   ├── src/test/java/
│   └── pom.xml
│
├── frontend/                   # Angular
│   ├── src/app/
│   ├── src/assets/
│   └── package.json
│
└── docker-compose.yml
```

#### Switching Between Frontend and Backend

**Using Harpoon:**

1. Mark important files:
   - Open `backend/.../Controller.java` → `<leader>a`
   - Open `frontend/.../component.ts` → `<leader>a`

2. Jump between them:
   - `<leader>j` → Backend controller
   - `<leader>k` → Frontend component

**Using Telescope:**

- `<leader>ff` → Find any file by name
- `<leader>fg` → Search for text across all files

#### Typical Development Session

1. **Start services:**
   ```bash
   # Terminal 1: Backend
   cd backend && ./mvnw spring-boot:run
   
   # Terminal 2: Frontend
   cd frontend && ng serve
   ```

2. **Open Neovim in project root:**
   ```bash
   nvim .
   ```

3. **Navigate with Telescope:**
   - `<leader>ff` to find files
   - `<leader>fg` to search code

4. **Quick jump with Harpoon:**
   - Mark frequently edited files
   - Use `<leader>j/k/l/;` to jump

5. **Edit and save:**
   - Auto-format on save
   - LSP provides errors/warnings

6. **Debug backend:**
   - Set breakpoints
   - Run test or attach to running app

7. **Commit changes:**
   - `<leader>gg` to open LazyGit
   - Stage, commit, push

---

## 8. Troubleshooting

### 8.1 Common Issues

#### JDTLS Not Starting

**Symptoms:**
- No completions in Java files
- `:LspInfo` doesn't show jdtls

**Solutions:**

1. **Check if jdtls is installed:**
   ```vim
   :Mason
   ```
   Look for `jdtls` - should show as installed

2. **Check Java installation:**
   ```bash
   java --version
   echo $JAVA_HOME
   ```

3. **Clear JDTLS workspace:**
   ```bash
   rm -rf ~/.local/share/nvim/jdtls-workspace/
   ```
   Then restart Neovim

4. **Check for errors:**
   ```vim
   :messages
   ```

#### Angular LSP Not Working

**Symptoms:**
- No completions in Angular templates
- No error highlighting

**Solutions:**

1. **Ensure you're in an Angular project** (has `angular.json`)

2. **Check angularls is attached:**
   ```vim
   :LspInfo
   ```

3. **Restart LSP:**
   ```vim
   :LspRestart
   ```

#### Formatting Not Working

**Symptoms:**
- Files not formatted on save
- `<leader>gf` does nothing

**Solutions:**

1. **Check none-ls sources:**
   ```vim
   :NullLsInfo
   ```

2. **Ensure formatters are installed:**
   ```bash
   # For Prettier
   npm install -g prettier
   
   # For Java
   :MasonInstall google-java-format
   ```

3. **Check if LSP can format:**
   ```vim
   :lua print(vim.inspect(vim.lsp.buf_get_clients()))
   ```

#### Debugging Not Working

**Symptoms:**
- Breakpoints not hit
- DAP UI doesn't open

**Solutions:**

1. **Ensure debug adapter is installed:**
   ```vim
   :MasonInstall java-debug-adapter
   ```

2. **Check bundles are loaded:**
   Open a Java file, then:
   ```vim
   :lua print(vim.inspect(require('jdtls').setup_dap))
   ```

3. **Restart Neovim** after installing debug adapter

### 8.2 Health Checks

Run comprehensive health check:
```vim
:checkhealth
```

Check specific components:
```vim
:checkhealth nvim-treesitter
:checkhealth mason
```

### 8.3 Useful Diagnostic Commands

| Command | Purpose |
|---------|---------|
| `:LspInfo` | Show attached LSP clients |
| `:LspLog` | View LSP log |
| `:Mason` | Open Mason UI |
| `:messages` | View recent messages/errors |
| `:Lazy` | Open lazy.nvim UI |
| `:TSInstallInfo` | Show Treesitter parsers |
| `:NullLsInfo` | Show none-ls sources |

### 8.4 Log Locations

| Component | Log Location |
|-----------|--------------|
| Neovim | `:messages` or `~/.local/state/nvim/log` |
| LSP | `:LspLog` or `~/.local/state/nvim/lsp.log` |
| JDTLS | `~/.local/share/nvim/jdtls-workspace/<project>/.metadata/.log` |
| Mason | `~/.local/share/nvim/mason/` |

### 8.5 Reset Procedures

**Reset JDTLS workspace (fixes most Java issues):**
```bash
rm -rf ~/.local/share/nvim/jdtls-workspace/
```

**Reset Mason packages:**
```bash
rm -rf ~/.local/share/nvim/mason/
```
Then reinstall: `:MasonInstall jdtls java-debug-adapter java-test`

**Reset entire Neovim state:**
```bash
rm -rf ~/.local/share/nvim/
rm -rf ~/.local/state/nvim/
rm -rf ~/.cache/nvim/
```

---

## 9. Customization Guide

### 9.1 Adding New LSP Servers

1. **Find the server name:**
   ```vim
   :Mason
   ```
   Browse or search for the server

2. **Add to mason-lspconfig** (`lsp-config.lua`):
   ```lua
   ensure_installed = {
       -- existing servers...
       "new_server_name",
   },
   ```

3. **Enable the server:**
   ```lua
   vim.lsp.enable({
       -- existing servers...
       "new_server_name",
   })
   ```

4. **Add server-specific config (if needed):**
   ```lua
   vim.lsp.config("new_server_name", {
       settings = {
           -- server-specific settings
       },
   })
   ```

### 9.2 Adding New Formatters

1. **Install via Mason:**
   ```vim
   :MasonInstall formatter-name
   ```

2. **Add to none-ls** (`none-ls.lua`):
   ```lua
   sources = {
       -- existing sources...
       null_ls.builtins.formatting.formatter_name,
   },
   ```

### 9.3 Changing Keymaps

**Pattern for adding keymaps:**
```lua
vim.keymap.set(
    "n",                        -- mode: n=normal, i=insert, v=visual
    "<leader>xx",               -- key sequence
    function_or_command,        -- action
    { desc = "Description" }    -- options
)
```

**Example - Add a keymap to run Maven:**
```lua
-- Add to vim-commands.lua or create a new plugin file
vim.keymap.set("n", "<leader>mb", ":!./mvnw clean install<CR>", { desc = "Maven Build" })
vim.keymap.set("n", "<leader>mt", ":!./mvnw test<CR>", { desc = "Maven Test" })
```

### 9.4 Adding Java Runtimes

Edit `java.lua`, find the `runtimes` section:

```lua
configuration = {
    runtimes = {
        -- Add new runtime
        {
            name = "JavaSE-11",  -- Must match the format "JavaSE-XX"
            path = "/path/to/java/11",
        },
        -- Existing runtimes...
    },
},
```

### 9.5 Creating New Plugin Files

1. **Create file:** `lua/plugins/my-plugin.lua`

2. **Add lazy.nvim spec:**
   ```lua
   return {
       "author/plugin-name",
       dependencies = { "optional/dependency" },
       config = function()
           require("plugin-name").setup({
               -- options
           })
           -- keymaps
           vim.keymap.set("n", "<leader>xx", function() end, { desc = "Description" })
       end,
   }
   ```

3. **Sync plugins:**
   ```vim
   :Lazy sync
   ```

---

## 10. Quick Reference Card

### Essential Keymaps (Print This!)

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                    NEOVIM FULLSTACK QUICK REFERENCE                       ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                           ║
║  LEADER KEY = SPACE                                                       ║
║                                                                           ║
╠═══════════════════════════════════════════════════════════════════════════╣
║  LSP (All Languages)           │  Java/Spring Boot                        ║
╠────────────────────────────────┼──────────────────────────────────────────╣
║  K        Hover docs           │  <leader>jo   Organize imports           ║
║  gd       Go to definition     │  <leader>jv   Extract variable           ║
║  <leader>ca  Code actions      │  <leader>jc   Extract constant           ║
║  <leader>e   Show diagnostic   │  <leader>jm   Extract method (visual)    ║
║  [d / ]d  Prev/next diagnostic │  <leader>jtc  Run test class             ║
║  <leader>gf  Format file       │  <leader>jtm  Run test method            ║
║                                │  <leader>jtp  Pick test                  ║
╠════════════════════════════════╪══════════════════════════════════════════╣
║  Debugging                     │  File Navigation                         ║
╠────────────────────────────────┼──────────────────────────────────────────╣
║  <leader>db  Toggle breakpoint │  <leader>ff   Find files                 ║
║  <leader>dB  Conditional BP    │  <leader>fg   Live grep                  ║
║  <leader>dc  Continue/Start    │  <leader>fb   List buffers               ║
║  <leader>di  Step into         │  <leader>n    Toggle file tree           ║
║  <leader>do  Step over         │                                          ║
║  <leader>dO  Step out          │  Harpoon (Quick Nav)                     ║
║  <leader>dq  Terminate         │  ──────────────────                      ║
║  <leader>du  Toggle DAP UI     │  <leader>a    Add file                   ║
║  <leader>de  Evaluate          │  <leader>h    Toggle menu                ║
║                                │  <leader>j/k/l/;  Jump to file 1-4       ║
╠════════════════════════════════╪══════════════════════════════════════════╣
║  Git                           │  Other                                   ║
╠────────────────────────────────┼──────────────────────────────────────────╣
║  <leader>gg  LazyGit           │  <leader>xx   Toggle Trouble             ║
║  <leader>gs  Stage hunk        │  <leader>tv   Terminal (vertical)        ║
║  <leader>gr  Reset hunk        │  <leader>th   Terminal (horizontal)      ║
║  <leader>gp  Preview hunk      │  gcc          Toggle line comment        ║
║  <leader>gb  Blame line        │  gc           Toggle comment (visual)    ║
║  <leader>gd  Diff this         │                                          ║
║  ]c / [c  Next/prev hunk       │                                          ║
╠════════════════════════════════╧══════════════════════════════════════════╣
║  Completion (Insert Mode)                                                 ║
╠═══════════════════════════════════════════════════════════════════════════╣
║  <Tab>      Next item / Expand    │  <C-Space>   Trigger completion       ║
║  <S-Tab>    Previous item         │  <C-e>       Close menu               ║
║  <CR>       Confirm selection     │  <C-b/f>     Scroll docs              ║
╠═══════════════════════════════════════════════════════════════════════════╣
║  Commands                                                                 ║
╠═══════════════════════════════════════════════════════════════════════════╣
║  :checkhealth    Health check     │  :LspInfo      Show LSP status        ║
║  :Mason          Manage packages  │  :Lazy         Manage plugins         ║
║  :messages       View errors      │  :TSInstallInfo  Treesitter status    ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

### Essential Commands

```bash
# Mason Installation (run in Neovim)
:MasonInstall jdtls java-debug-adapter java-test google-java-format

# Start Spring Boot with debug
./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"

# Start Angular dev server
ng serve

# Reset JDTLS workspace (fixes most Java issues)
rm -rf ~/.local/share/nvim/jdtls-workspace/
```

---

## Appendix: File Quick Reference

| File | Purpose |
|------|---------|
| `init.lua` | Entry point, bootstraps lazy.nvim |
| `lua/vim-commands.lua` | Core settings, highlights, basic keymaps |
| `lua/plugins/lsp-config.lua` | LSP servers, completion (nvim-cmp) |
| `lua/plugins/java.lua` | Java/Spring Boot (nvim-jdtls) |
| `lua/plugins/dap.lua` | Debugging (nvim-dap) |
| `lua/plugins/none-ls.lua` | Formatters (prettier, google-java-format) |
| `lua/plugins/telescope.lua` | Fuzzy finder |
| `lua/plugins/neotree.lua` | File explorer (nvim-tree) |
| `lua/plugins/treesitter.lua` | Syntax highlighting |
| `lua/plugins/harpoon.lua` | Quick file navigation |
| `lua/plugins/gitsigns.lua` | Git signs and hunk management |
| `lua/plugins/lazygit.lua` | Git terminal UI |
| `lua/plugins/folke.lua` | Trouble + which-key |
| `lua/plugins/themes.lua` | Monokai Pro colorscheme |
| `lua/plugins/lualine.lua` | Status line |
| `lua/plugins/autopairs.lua` | Auto-close brackets |
| `lua/plugins/commenting.lua` | Comment toggling |

---

*Documentation generated for Neovim fullstack configuration.*
*Last updated: 2026*

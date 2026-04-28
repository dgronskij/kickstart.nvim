# Migration Guide: AstroNvim v3.36.11 → kickstart.nvim (Nvim 0.12.2)

Config paths:
- **Before**: `~/.config/astronvim3` (NVIM v0.10.1, AstroNvim v3.36.11)
- **After**: `~/.config/nvim_kickstart` (NVIM v0.12.2, kickstart.nvim)

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Options / sets.lua](#2-options--setslua)
3. [Keymaps](#3-keymaps)
4. [Autocmds](#4-autocmds)
5. [LSP Configuration](#5-lsp-configuration)
6. [AstroNvim-bundled Plugins (what to replace or migrate)](#6-astronvim-bundled-plugins)
7. [User Plugins: init.lua (plugins/init.lua)](#7-user-plugins-initlua)
8. [User Plugins: ui.lua (plugins/ui.lua)](#8-user-plugins-uilua)
9. [User Plugins: ya.lua (plugins/yalua)](#9-user-plugins-yalua)
10. [User Plugins: astronvim_overrides.lua](#10-astronvim_overrides)
11. [Utility Modules](#11-utility-modules)
12. [The magic in astronvim/init.lua (polish function)](#12-the-magic-in-astronviminitlua)
13. [File-by-File Migration Checklist](#13-file-by-file-migration-checklist)
14. [Tmux Integration](#14-tmux-integration)
15. [Summary of Gaps / Things Not Yet Migrated](#15-summary-of-gaps)

---

## 1. Architecture Overview

### Before (AstroNvim v3)

AstroNvim v3 is a full Neovim distribution: it ships its own `init.lua`, bootstraps lazy.nvim, and loads core plugins (LSP, completion, UI, etc.) automatically. User config lives under `lua/user/` (here: `lua/dgronskiy_nvim/`). The entry point is:

```
~/.config/astronvim3/init.lua
  → astronvim.bootstrap
  → astronvim.options
  → astronvim.lazy          (loads lua/plugins/*.lua + lua/user/*.lua)
  → astronvim.autocmds
  → astronvim.mappings
  → polish()                (user's post-setup hook)
```

User overrides are passed as a config table returned from `lua/dgronskiy_nvim/astronvim/init.lua`.

### After (kickstart.nvim)

kickstart.nvim is a **starter config**, not a distribution. You own everything. The entry point is:

```
~/.config/nvim_kickstart/init.lua
  → dgronskiy.setup_opts    (vim options)
  → dgronskiy.setup_keymaps (basic keymaps)
  → vim.diagnostic.config   (inline)
  → dgronskiy.setup_autocmds
  → dgronskiy.setup_lazy    (loads lazy.nvim, plugin specs)
```

**Key implication**: every plugin that AstroNvim provided for free must now be explicitly specified. Nothing is implicit.

---

## 2. Options / sets.lua

**Source**: `lua/dgronskiy_nvim/sets.lua`  
**Destination**: `lua/dgronskiy/setup_opts.lua` (already started)

The options are already largely migrated. Differences to verify:

| Option | AstroNvim config | kickstart status |
|--------|-----------------|-----------------|
| `hidden` | `true` | ✅ done |
| `splitbelow/right` | `true` | ✅ done |
| `number/relativenumber` | `true` | ✅ done |
| `mouse` | `"a"` | ✅ done |
| `clipboard` | `""` (manual) | ⚠️ kickstart sets `unnamedplus` via `vim.schedule` — this overrides the empty clipboard. You used OSC52 for clipboard. Decide: keep `unnamedplus` or remove the `vim.schedule` line and add OSC52 plugin. |
| `tabstop/shiftwidth` | `4` | ✅ done |
| `expandtab/smartindent` | `true` | ✅ done |
| `wrap` | `false` | ✅ done |
| `swapfile/backup/undofile` | all `false` | ✅ done |
| `hlsearch/incsearch` | `true` | ✅ done |
| `ignorecase` | `true` | ✅ done |
| `smartcase` | NOT set in AstroNvim config | ⚠️ kickstart adds `smartcase = true` — good addition, keep it |
| `wrapscan` | `false` | ✅ done |
| `termguicolors` | `true` | ✅ done |
| `scrolloff` | `8` | ✅ done |
| `signcolumn` | `"yes"` | ✅ done |
| `cmdheight` | `2` | ✅ done |
| `updatetime` | `50` | ✅ done |
| `colorcolumn` | `"120"` | ✅ done |
| `shada` | `"!,'10000,<50,s10,h"` | ✅ done |
| `autopairs_enabled` | `false` | ❌ not migrated — `vim.g.autopairs_enabled` was AstroNvim-specific; in kickstart just don't load autopairs |
| `autoformat_enabled` | `false` | ❌ AstroNvim-specific global; in kickstart configure conform.nvim directly (already done — format_on_save returns nil) |
| `max_file` | size/lines limits | ❌ AstroNvim-specific; aerial.nvim now needs its own `max_lines` option in its own config |
| `langmap` / Russian layout | in `polish()` | ❌ not yet in kickstart — **must migrate** (see §12) |
| `keymap = "russian-jcukenwin"` | in `polish()` | ❌ not yet in kickstart |
| `iminsert = 0` | in `polish()` | ❌ not yet in kickstart |
| `mapleader = " "` | `options.g.mapleader` | ✅ done |
| `wildmode` | `longest:full,full` in `polish()` | ❌ not yet in kickstart |
| `path += $ARCADIA_ROOT` | in `polish()` | ❌ not yet in kickstart |

**Action**: Move the remaining options from `polish()` into `setup_opts.lua`.

---

## 3. Keymaps

**Source**: `lua/dgronskiy_nvim/astronvim/mappings.lua` + `saner_defaults.lua`  
**Destination**: `lua/dgronskiy/setup_keymaps.lua` (currently only 2 lines)

The AstroNvim config had a rich mapping table. What needs to be migrated:

### Core navigation (already provided by saner_defaults.lua, now must be explicit)

| Mapping | Action | Status |
|---------|--------|--------|
| `<ESC>` n | `:noh` | ⚠️ kickstart has `<Esc>` → `nohlsearch`, same intent ✅ |
| `<S-L>` / `<S-H>` | next/prev buffer | ❌ not in kickstart |
| `<C-h/j/k/l>` | split navigation (via smart-splits) | ❌ needs smart-splits plugin or manual mapping |
| `<C-Up/Down/Left/Right>` | resize splits | ❌ not in kickstart |
| `<C-W><C-T>` | open buffer in new tab | ❌ not in kickstart |
| `<C-q>` | close window | ❌ not in kickstart |
| `]t` / `[t` | next/prev tab | ❌ not in kickstart |
| `<leader>1..4` | jump to tab N | ❌ not in kickstart (was lasso.nvim file marks in the commented section; tab jumps active) |
| `<leader>e` | toggle MiniFiles explorer | ❌ needs mini.files plugin |
| `<leader>b` / `<leader>h` | FZF Buffers / History | ❌ not in kickstart |
| `<leader>/` | FZF BLines | ❌ telescope has `<leader>/` for buffer fuzzy find ✅ (different binding, same intent) |
| `<leader>f<CR>` | find all files (telescope) | ❌ was custom; kickstart has `<leader>sf` |
| `<leader>fa` | ArcFiles search | ❌ not in kickstart |
| `<leader>fd` / `<leader>find` | FZF Find | ❌ not in kickstart |
| `<leader>cs` | ArcFind | ❌ not in kickstart |
| `<S-K>` / `<leader><S-K>` n,v | FindExact / ArcFindExact | ❌ not in kickstart |
| `<leader>cd` / `<leader>lcd` | cd to current file dir | ❌ not in kickstart (Cd/Lcd user commands) |
| `<leader>cda` / `<leader>lcda` | cd to $A | ❌ not in kickstart |
| `<leader>al` n,v | ArcLink | ❌ not in kickstart |
| `<leader>cat` v | write selection to stdout | ❌ not in kickstart |
| `<leader>dark` / `<leader>light` | set background | ❌ not in kickstart |
| `<leader>cfn` | CopyFileName | ❌ not in kickstart |
| `<leader>cfqn` | CopyFQN (dotted path) | ❌ not in kickstart |
| `<leader>p` v | paste without overwriting register | ❌ not in kickstart |
| `<leader>y` n,v | yank to system clipboard (OSC52) | ❌ not in kickstart |
| `<leader>m` / `<leader>M` / `<leader>1..4` | lasso marks | ❌ not in kickstart (lasso plugin not present) |
| `<leader>t<CR>` n,v | Tags search | ❌ not in kickstart |
| `]c` / `[c` | cnext / cprev | ❌ not in kickstart |
| `z.` | `zszH` center viewport | ❌ not in kickstart |
| `>` / `<` v | indent and stay in visual mode | ❌ not in kickstart |
| `<S-Tab>` / `<Tab>` v | unindent/indent and stay | ❌ not in kickstart |
| `*` n | highlight word without jumping | ❌ not in kickstart |
| `cnoremap <C-a>/<C-e>` | Home/End in command mode | ❌ not in kickstart |
| `zR/zM/zr/zm/zp` | ufo fold controls | ❌ needs nvim-ufo plugin |
| `]g` / `[g` | gitsigns next/prev hunk | ⚠️ gitsigns plugin is in kickstart but hunk keymaps may differ — check |
| `<leader>c` | Comment toggle | ⚠️ kickstart uses mini.nvim (no Comment.nvim); different keymap? |
| `<leader>lS` | aerial toggle | ❌ aerial not in kickstart |
| `<leader>ls` | telescope symbols | ⚠️ `gO` in kickstart via lsp attach |
| `<leader>gb/gc/gC/gt` | telescope git | ⚠️ not bound in kickstart by default |
| `<leader>f*` telescope bindings | various | ⚠️ partially remapped in kickstart to `<leader>s*` |

**Note on LSP keymaps**: AstroNvim bound `K` for hover but it was deliberately unbound (`astronvim_defaults.n["K"] = nil`). Nvim 0.12 has `K` bound to `vim.lsp.buf.hover` by default — keep or rebind as needed.

### Key mapping migration strategy

Move the contents of `astronvim/mappings.lua` into `setup_keymaps.lua`. Remove AstroNvim-specific wrappers (`astronvim_defaults`, `M.saner_astronvim_defaults()`, etc.) and use plain `vim.keymap.set`.

---

## 4. Autocmds

**Source**: `astronvim.autocmds` (AstroNvim core) + `polish()` in `astronvim/init.lua`  
**Destination**: `lua/dgronskiy/setup_autocmds.lua`

Currently kickstart has only yank-highlight autocmd. Missing from AstroNvim side:

- `BufNewFile,BufRead,BufReadPost *.yaml,*.yml set lisp` — from `ytils.lua`, must migrate
- Any AstroNvim core autocmds you relied on (e.g., large file handling, `AstroFile` events) are gone and must be recreated if needed.

**Action**: Add the yaml `lisp` autocmd to `setup_autocmds.lua`.

---

## 5. LSP Configuration

**Source**: `lua/dgronskiy_nvim/astronvim/init.lua` (the `lsp` table)  
**Destination**: `lua/dgronskiy/kickstart_inbox.lua` (nvim-lspconfig section)

### Servers to configure

| Server | AstroNvim config | kickstart status |
|--------|-----------------|-----------------|
| `pyright` | custom `root_dir` (guarded), `capabilities` patch, `autostart=true` | ❌ not configured — **must add** |
| `gopls` | `expandWorkspaceToModule=false` | ❌ not configured — **must add** |
| `clangd` | filetypes limited to `c`, `cpp` (no proto) | ❌ not configured — **must add** |
| `lua_ls` | formatting disabled | ✅ already done in kickstart |

### Formatting

AstroNvim used `null-ls.nvim` with:
- `shellcheck` (diagnostics + code_actions for bash)
- `stylua` (lua formatting)
- `black` (python formatting)

kickstart uses `conform.nvim`. **Action**: migrate formatters to conform.nvim:

```lua
-- in kickstart_inbox.lua conform opts:
formatters_by_ft = {
  lua = { "stylua" },
  python = { "black" },
  sh = { "shellcheck" },
},
```

Also: `mason-null-ls.nvim` is gone; use `mason-tool-installer` to ensure these are installed.

### Diagnostics

AstroNvim config: `virtual_text = false, underline = false`.  
kickstart sets: `virtual_text = true, underline = { severity = { min = WARN } }`.

**Action**: Decide which you want. If you want the AstroNvim behavior (no inline virtual text), change `virtual_text = false` and `underline = false` in `init.lua`.

### pyright: guarded root_dir

The `guarded_pyright_root_directory` function from `ytils.lua` prevents pyright from attaching to the entire Arc monorepo as root. This is **critical for Arc work** and must be migrated.

**Action**:
1. Keep `ytils.lua` as-is (or move it to `lua/dgronskiy/ytils.lua`)
2. In the nvim-lspconfig config for pyright, add:
```lua
pyright = {
  root_dir = require("dgronskiy.ytils").guarded_pyright_root_directory,
  capabilities = (function()
    local c = vim.lsp.protocol.make_client_capabilities()
    c.workspace.didChangeWatchedFiles.dynamicRegistration = false
    return c
  end)(),
}
```

Note: In Nvim 0.12 + nvim-lspconfig v2, the config API changed from `require('lspconfig').pyright.setup({})` to `vim.lsp.config('pyright', {})` + `vim.lsp.enable('pyright')`. The kickstart already uses this new API.

---

## 6. AstroNvim-bundled Plugins

These were provided by AstroNvim v3 core (from `lua/plugins/*.lua`). They are **not** in kickstart by default. Each must be explicitly added or replaced:

### 6.1 `heirline.nvim` (statusline/tabline/winbar)

- **AstroNvim**: provided a full statusline + bufferline via heirline
- **kickstart**: `mini.statusline` from `mini.nvim` — simple, works
- **Decision**: Keep `mini.statusline` (already done) or replace with heirline if you need the bufferline. The AstroNvim heirline config was complex and AstroNvim-specific.

### 6.2 `neo-tree.nvim`

- **AstroNvim**: bundled, but you **disabled it** (`enabled = false`) in `astronvim_overrides.lua`
- **kickstart**: optional (`require 'kickstart.plugins.neo-tree'`, commented out)
- **Decision**: You switched to `mini.files`. Keep using mini.files — see §7.

### 6.3 `alpha-nvim` (dashboard)

- **AstroNvim**: bundled but you **disabled it** (`enabled = false`)
- **kickstart**: not present
- **Decision**: Nothing to do.

### 6.4 `nvim-cmp` (completion)

- **AstroNvim**: `nvim-cmp` with `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp_luasnip`, `lspkind.nvim`
- **kickstart**: `blink.cmp` with `LuaSnip` — modern replacement, already set up
- **Decision**: Keep `blink.cmp`. No action needed. Note: `blink.cmp` does not need `cmp-*` source plugins — it has built-in sources.

### 6.5 `LuaSnip` / `friendly-snippets`

- **AstroNvim**: used with nvim-cmp
- **kickstart**: LuaSnip is a blink.cmp dependency; `friendly-snippets` is commented out
- **Decision**: Uncomment `friendly-snippets` if you want snippets:
```lua
{ 'rafamadriz/friendly-snippets', config = function() require('luasnip.loaders.from_vscode').lazy_load() end }
```

### 6.6 `mason.nvim` / `mason-lspconfig.nvim` / `mason-null-ls.nvim` / `mason-nvim-dap.nvim`

- **AstroNvim**: full Mason integration for LSP, linters, formatters, DAP
- **kickstart**: `mason-org/mason.nvim`, `mason-org/mason-lspconfig.nvim`, `WhoIsSethDaniel/mason-tool-installer.nvim`
- **Note**: Package namespaces changed from `williamboman/mason.nvim` → `mason-org/mason.nvim`. The kickstart already uses the new names.
- **`mason-lock.nvim`**: was `zapling/mason-lock.nvim` in AstroNvim config. This pinned mason package versions. **Must re-add** if you want reproducible installs.

### 6.7 `nvim-treesitter`

- **AstroNvim**: traditional setup with `ensure_installed` list; your override pinned to `origin/HEAD`
- **kickstart**: uses new `branch = 'main'` API (Nvim 0.12 compatible); parsers installed on demand via FileType autocmd
- **Action**: Add your parser list to the config in `kickstart_inbox.lua`:
```lua
require('nvim-treesitter').install({
  'bash', 'c', 'cpp', 'diff', 'html', 'css', 'cuda',
  'javascript', 'json', 'lua', 'luadoc', 'markdown', 'markdown_inline',
  'python', 'tsx', 'typescript', 'vim', 'vimdoc', 'xml', 'yaml',
  'go', 'gosum', 'gowork',
})
```

### 6.8 `nvim-treesitter-textobjects`

- **AstroNvim**: bundled
- **kickstart**: not present
- **Decision**: Add if you use treesitter text objects (`af`, `if`, etc.)

### 6.9 `nvim-ts-autotag`

- **AstroNvim**: bundled (auto-close HTML tags)
- **kickstart**: not present
- **Decision**: Add if you work with HTML/JSX/TSX

### 6.10 `nvim-ts-context-commentstring`

- **AstroNvim**: bundled (smart comments in embedded languages)
- **kickstart**: not present; `mini.nvim` has `mini.comment` but without context-aware commentstring
- **Decision**: Add if you embed languages (JS in HTML, etc.)

### 6.11 `nvim-autopairs`

- **AstroNvim**: bundled, but you set `autopairs_enabled = false`
- **kickstart**: optional (`lua/kickstart/plugins/autopairs.lua`, commented out)
- **Decision**: Leave disabled, matches your preference.

### 6.12 `nvim-ufo` (folding)

- **AstroNvim**: bundled with `promise-async`; you had fold keymaps `zR/zM/zr/zm/zp`
- **kickstart**: not present
- **Decision**: **Must add** if you want proper folding. Add:
```lua
{ 'kevinhwang91/nvim-ufo', dependencies = { 'kevinhwang91/promise-async' }, opts = { ... } }
```
And add fold keymaps to `setup_keymaps.lua`.

### 6.13 `aerial.nvim` (symbols outline)

- **AstroNvim**: bundled; bound to `<leader>lS`
- **kickstart**: not present
- **Decision**: Add if you use the symbols outline. Note: telescope aerial extension also needs it.

### 6.14 `gitsigns.nvim`

- **AstroNvim**: bundled; hunk keymaps `]g`/`[g`
- **kickstart**: present in `kickstart_inbox.lua` ✅
- **Action**: Add hunk navigation keymaps explicitly (they were in `saner_defaults.lua`):
```lua
vim.keymap.set('n', ']g', function() require('gitsigns').next_hunk() end)
vim.keymap.set('n', '[g', function() require('gitsigns').prev_hunk() end)
```

### 6.15 `which-key.nvim`

- **AstroNvim**: bundled
- **kickstart**: present in `kickstart_inbox.lua` ✅ but with different group specs — update group specs to match your keymaps.

### 6.16 `nvim-notify`

- **AstroNvim**: bundled; telescope `<leader>fn` extension
- **kickstart**: not present; nvim 0.12 has better built-in notifications
- **Decision**: Likely not needed. Nvim 0.12 `vim.notify` renders nicely. Skip or add snacks.nvim which has a notify replacement.

### 6.17 `dressing.nvim`

- **AstroNvim**: bundled (prettier `vim.ui.input/select`)
- **kickstart**: not present; nvim 0.12 has improved built-in UI
- **Decision**: Not needed for Nvim 0.12. Skip.

### 6.18 `neoconf.nvim` / `neodev.nvim`

- **AstroNvim**: bundled
- **kickstart**: not present; `neodev.nvim` is superseded by `lazydev.nvim` for Lua LSP
- **Decision**: Consider adding `lazydev.nvim` for better Lua LSP in your config files.

### 6.19 `toggleterm.nvim`

- **AstroNvim**: bundled but you had it commented out in mappings
- **kickstart**: not present
- **Decision**: Not needed if you use tmux. Skip.

### 6.20 `nvim-dap` / `nvim-dap-ui`

- **AstroNvim**: bundled but commented out in your mappings
- **kickstart**: optional (`lua/kickstart/plugins/debug.lua`, commented out)
- **Decision**: Enable if you want DAP. Otherwise skip.

### 6.21 `indent-blankline.nvim`

- **AstroNvim**: bundled
- **kickstart**: optional (`lua/kickstart/plugins/indent_line.lua`, commented out)
- **Decision**: Enable if you want indent guides.

### 6.22 `lspkind.nvim`

- **AstroNvim**: bundled (icons for nvim-cmp)
- **kickstart**: not needed; blink.cmp has built-in icon support

### 6.23 `better-escape.nvim`

- **AstroNvim**: bundled (`jk`/`jj` to escape insert mode)
- **kickstart**: not present
- **Decision**: Add if you use jk/jj escape mappings.

### 6.24 `neovim-session-manager` / `resession.nvim`

- **AstroNvim**: bundled; you had it commented out in mappings
- **kickstart**: not present
- **Decision**: Not needed unless you want session persistence. Skip.

### 6.25 `nvim-web-devicons`

- **AstroNvim**: bundled
- **kickstart**: present as optional dep of telescope ✅

### 6.26 `SchemaStore.nvim`

- **AstroNvim**: bundled (JSON schema for yaml/json LSP)
- **kickstart**: not present
- **Decision**: Add if you work with JSON/YAML schemas and have `jsonls`/`yamlls`.

### 6.27 `nvim-colorizer.lua`

- **AstroNvim**: bundled
- **kickstart**: not present (you had it in `plugins/ui.lua`)
- **Action**: Add it (see §8).

### 6.28 `mini.bufremove`

- **AstroNvim**: bundled (used by AstroNvim buffer close logic)
- **kickstart**: not needed; use `bufdelete.nvim` (you had it in ui.lua) or just `:bdelete`

### 6.29 `telescope-fzf-native.nvim`

- **AstroNvim**: bundled
- **kickstart**: present as telescope dep ✅

### 6.30 `nvim-window-picker`

- **AstroNvim**: bundled (used by neo-tree for window selection)
- **kickstart**: not needed (neo-tree disabled)

### 6.31 `smart-splits.nvim`

- **AstroNvim**: bundled; used for `<C-h/j/k/l>` split navigation
- **kickstart**: not present
- **Decision**: **Must add** (or replace with plain `<C-w>h/j/k/l` keymaps). You relied on it for split navigation.

---

## 7. User Plugins: init.lua

**Source**: `lua/dgronskiy_nvim/plugins/init.lua`

| Plugin | Status | Action |
|--------|--------|--------|
| `folke/trouble.nvim` | ❌ not in kickstart | Add to `kickstart_inbox.lua` with same keymaps |
| `junegunn/fzf` + `fzf.vim` | ❌ not in kickstart | Add if keeping FZF commands (Find, ArcFind, etc.) |
| `iautom8things/gitlink-vim` | ❌ not in kickstart | Add (used by `GitLink` command) |
| `ojroques/nvim-osc52` | ❌ not in kickstart | **Evaluate**: Nvim 0.12 has built-in OSC52 support via `vim.g.clipboard`. You can replace nvim-osc52 with native Nvim 0.12 OSC52. See below. |
| `editorconfig/editorconfig-vim` | ❌ not in kickstart | **Not needed**: Nvim 0.9+ has built-in EditorConfig support. Remove. |
| `ggandor/leap.nvim` | disabled in AstroNvim | Skip |
| `folke/flash.nvim` | ❌ not in kickstart | Add if you want flash jump |
| `dgronskij/lasso.nvim` | ❌ not in kickstart | Add if you want file marks |
| `jose-elias-alvarez/null-ls.nvim` | ❌ not in kickstart | **Dead project** — null-ls is archived. Use `conform.nvim` (already in kickstart) + `nvim-lint` instead |
| `nvim-telescope/telescope.nvim` | ✅ in kickstart | Options merge needed |
| `nvim-zh/whitespace.nvim` | ❌ not in kickstart | Add if you want whitespace highlighting |
| `Tastyep/structlog.nvim` | ❌ not in kickstart | Add if keeping the logger (see §11) |
| `zapling/mason-lock.nvim` | ❌ not in kickstart | Add if you want locked mason package versions |
| `nvim-treesitter/nvim-treesitter-context` | ❌ not in kickstart | Add — useful |
| `theHamsta/crazy-node-movement` | ❌ not in kickstart | Add if you use treesitter node movement |
| `mogelbrod/vim-jsonpath` | ❌ not in kickstart | Add if you use JSONPath |
| `johmsalas/text-case.nvim` | ❌ not in kickstart | **Must add** — used by `CopyFQN` command and `ArcFindSb` |
| `echasnovski/mini.files` | ❌ not in kickstart | **Must add** — your file explorer |

### OSC52 note

`ojroques/nvim-osc52` is no longer needed in Nvim 0.10+. Use:
```lua
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
```
Or simply set `vim.o.clipboard = 'unnamedplus'` and rely on the terminal's OSC52 support (most modern terminals support it).

### null-ls.nvim is dead

`jose-elias-alvarez/null-ls.nvim` was archived in 2023. The community fork `nvimtools/none-ls.nvim` exists but `conform.nvim` + `nvim-lint` is the recommended modern replacement:

```lua
-- conform.nvim for formatting (already in kickstart):
formatters_by_ft = {
  lua = { "stylua" },
  python = { "black" },
}

-- Add nvim-lint for diagnostics:
{
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      sh = { 'shellcheck' },
    }
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      callback = function() require('lint').try_lint() end,
    })
  end,
}
```

---

## 8. User Plugins: ui.lua

**Source**: `lua/dgronskiy_nvim/plugins/ui.lua`

| Plugin | Status | Action |
|--------|--------|--------|
| `ellisonleao/gruvbox.nvim` | ❌ not in kickstart | Add if you want gruvbox as alternative |
| `pustota-theme/pustota.nvim` | ❌ not in kickstart | **Must add** — your active colorscheme was `pustota` |
| `rose-pine/neovim` | ❌ not in kickstart | Add optionally |
| `famiu/bufdelete.nvim` | ❌ not in kickstart | Add (provides `:Bdelete` and `<leader>q`) |
| `norcalli/nvim-colorizer.lua` | ❌ not in kickstart | Add |
| `hat0uma/csvview.nvim` | ❌ not in kickstart | Add if you work with CSV files |

**Important**: The kickstart colorscheme is `tokyonight-night`. You need to change this to `pustota` and add the `pustota.nvim` plugin, or choose a new colorscheme.

---

## 9. User Plugins: ya.lua

**Source**: `lua/dgronskiy_nvim/plugins/ya.lua`

| Plugin | Status | Action |
|--------|--------|--------|
| `NickvanDyke/opencode.nvim` | ❌ not in kickstart | **Must add** — already configured with snacks.nvim and keymaps. Migrate the entire block. |
| `folke/snacks.nvim` | ❌ not in kickstart | Add as opencode.nvim dependency |
| `olimorris/codecompanion.nvim` | commented out | Skip unless you want it |

**opencode.nvim keymaps to migrate**:
```
<leader>aa  — ask opencode
<leader>as  — execute opencode action
<leader>at  — toggle opencode
<leader>ar  — add range to opencode
<leader>al  — add line to opencode
<S-C-u>/<S-C-d> — scroll opencode
```

Note: `<leader>al` conflicts with `ArcLink` (`<leader>al`). Resolve this conflict.

---

## 10. astronvim_overrides

**Source**: `lua/dgronskiy_nvim/plugins/astronvim_overrides.lua`

This file only:
1. Disables `alpha-nvim` — no action needed (not in kickstart)
2. Pins `nvim-lspconfig` to `origin/HEAD` — no longer relevant (kickstart uses latest)
3. Pins `nvim-treesitter` to `origin/HEAD` — no longer relevant
4. Disables `neo-tree.nvim` — already not enabled in kickstart

No migration needed.

---

## 11. Utility Modules

### keymap.lua

`lua/dgronskiy_nvim/keymap.lua` — thin wrappers around `vim.keymap.set`. Simple utility, keep if you want the convenience wrappers. Copy to `lua/dgronskiy/keymap.lua`.

### logger.lua

`lua/dgronskiy_nvim/logger.lua` — structured logging via `structlog.nvim`. If you want to keep logging:
1. Add `Tastyep/structlog.nvim` to plugins
2. Copy `logger.lua` to `lua/dgronskiy/logger.lua`
3. Update requires from `dgronskiy_nvim.logger` → `dgronskiy.logger`

### util.lua

`lua/dgronskiy_nvim/util.lua` — path utilities (dirname, is_fs_root). Used by `ytils.lua`. Copy to `lua/dgronskiy/util.lua`, update requires.

### telescope_custom.lua

`lua/dgronskiy_nvim/telescope_custom.lua` — `find_all_files()` wrapper. Copy to `lua/dgronskiy/telescope_custom.lua`. Update the keymaps that reference it.

### ytils.lua

`lua/dgronskiy_nvim/ytils.lua` — critical Arc/Arcanum utilities:
- `guarded_pyright_root_directory` — **must migrate** (see §5)
- `GetArcanumLink` / `ArcLink` user command — **must migrate**
- `ArcE` user command (open file from Arcanum URL) — **must migrate**
- `ArcFindToggleAll` — **must migrate**
- `ArcFindSb` — **must migrate**
- `Yab` / `Ymypy` user commands — **must migrate**
- yaml `lisp` autocmd — **must migrate** (or move to `setup_autocmds.lua`)
- `parseUrl` — helper for `ArcE`, migrate with it

**Action**: Copy to `lua/dgronskiy/ytils.lua`, update all `require("dgronskiy_nvim.*")` → `require("dgronskiy.*")`, add `require('dgronskiy.ytils')` somewhere in `init.lua` or `setup_lazy.lua` to ensure it loads.

### sets.lua

Options already migrated to `setup_opts.lua`. No separate module needed. The `export_astronvim()` function was AstroNvim-specific API; delete.

---

## 12. The magic in astronvim/init.lua

The `polish()` function in `lua/dgronskiy_nvim/astronvim/init.lua` is a **large block of critical configuration** that runs after all plugins load. In kickstart, this must be split between `setup_keymaps.lua`, `setup_autocmds.lua`, `setup_opts.lua`, and plugin configs.

Here is each item:

| Item | Migrate to |
|------|-----------|
| `set path+=$ARCADIA_ROOT` | `setup_opts.lua`: `vim.opt.path:append(vim.env.ARCADIA_ROOT or "")` |
| `set wildmode=longest:full,full` | `setup_opts.lua`: `vim.o.wildmode = "longest:full,full"` |
| `* highlight without jump` | `setup_keymaps.lua` |
| `command GitLink` | already in ytils.lua via `gitlink-vim` — ensure plugin is added |
| FZF commands: `Find`, `FindExact`, `FindAll`, `FindWithLocationList` | `setup_keymaps.lua` or lazy plugin config for fzf.vim |
| Arc FZF commands: `ArcFind`, `ArcFindAll`, `ArcFindExact`, `ArcFindExactAll` | `setup_keymaps.lua` or plugin config |
| Arc file commands: `ArcFiles`, `ArcFilesAll` | `setup_keymaps.lua` or plugin config |
| `vnoremap <Leader>cat` | `setup_keymaps.lua` |
| `<Leader>find`, `<Leader>fd`, `<Leader>floc`, `<Leader>cs` | `setup_keymaps.lua` |
| `<Leader>al` / `<Leader>al` v | conflict with opencode.nvim! Resolve. ArcLink → `<leader>aL` or similar |
| `<leader>dark` / `<leader>light` | `setup_keymaps.lua` |
| `<leader>b`, `<leader>h` (FZF Buffers/History) | `setup_keymaps.lua` |
| `DGronskiyNvimLog` command | keep if using structlog |
| `z.` → `zszH` | `setup_keymaps.lua` |
| `Cd` / `Lcd` user commands | `setup_keymaps.lua` or `ytils.lua` |
| `<leader>cd` / `<leader>lcd` | `setup_keymaps.lua` |
| `<leader>cda` / `<leader>lcda` | `setup_keymaps.lua` |
| `vnoremap > >gv` / `< <gv` | `setup_keymaps.lua` |
| `<leader>t<CR>` Tags search | `setup_keymaps.lua` |
| `vnoremap <leader>p "_dP"` | `setup_keymaps.lua` |
| `CopyFileName` + `<leader>cfn` | move to `setup_keymaps.lua` |
| `CopyFQN` + `<leader>cfqn` | needs `text-case.nvim` — add plugin, add to `setup_keymaps.lua` |
| `cnoremap <C-a>/<C-e>` | `setup_keymaps.lua` |
| Russian langmap + keymap | `setup_opts.lua` (move from polish) |
| lasso marks (commented out in init.lua) | `plugins/init.lua` spec for lasso + keymaps |
| `Cfile`/`Lfile` quickfix load commands | `setup_keymaps.lua` |
| `]c` / `[c` quickfix nav | `setup_keymaps.lua` |
| `vim.lsp.set_log_level("trace")` | `setup_opts.lua` or lspconfig setup — **NOTE**: trace-level logging creates huge log files; probably want `"warn"` |

---

## 13. File-by-File Migration Checklist

### `init.lua` → `init.lua` (already exists)
- [x] `setup_opts`, `setup_keymaps`, `setup_autocmds`, `setup_lazy` wiring
- [ ] Add `require('dgronskiy.ytils')` to ensure Arc user commands load

### `keymap.lua` → `lua/dgronskiy/keymap.lua`
- [ ] Copy as-is

### `logger.lua` → `lua/dgronskiy/logger.lua`
- [ ] Copy, update requires
- [ ] Add `structlog.nvim` to plugins

### `sets.lua`
- [x] Migrated to `setup_opts.lua`
- [ ] Remaining: Russian layout, path, wildmode (from polish)

### `telescope_custom.lua` → `lua/dgronskiy/telescope_custom.lua`
- [ ] Copy, update requires

### `util.lua` → `lua/dgronskiy/util.lua`
- [ ] Copy as-is (no requires to update)

### `ytils.lua` → `lua/dgronskiy/ytils.lua`
- [ ] Copy
- [ ] Update all `require("dgronskiy_nvim.*")` → `require("dgronskiy.*")`
- [ ] LSP log level: change from `trace` → `warn` (or remove)
- [ ] Ensure module is loaded in `init.lua`

### `astronvim/init.lua` (the config table)
- [x] LSP servers list — partially done
- [ ] pyright: guarded root_dir, capabilities
- [ ] gopls: expandWorkspaceToModule=false
- [ ] clangd: filetypes = { "c", "cpp" }
- [ ] formatting: migrate to conform.nvim
- [ ] diagnostics: decide on virtual_text/underline
- [ ] All `polish()` items (see §12 table)

### `astronvim/mappings.lua`
- [ ] Migrate all active mappings to `setup_keymaps.lua`
- [ ] Remove AstroNvim wrappers

### `astronvim/saner_defaults.lua`
- [ ] Extract active mappings (fold controls, gitsigns, telescope, smart-splits)
- [ ] Place in `setup_keymaps.lua` or plugin configs

### `plugins/init.lua`
- [ ] trouble.nvim
- [ ] fzf + fzf.vim
- [ ] gitlink-vim
- [ ] Replace nvim-osc52 with native OSC52
- [ ] Remove editorconfig-vim (built-in)
- [ ] flash.nvim
- [ ] lasso.nvim
- [ ] Replace null-ls with conform.nvim + nvim-lint
- [ ] text-case.nvim
- [ ] mini.files
- [ ] whitespace.nvim
- [ ] structlog.nvim
- [ ] mason-lock.nvim
- [ ] nvim-treesitter-context
- [ ] crazy-node-movement (optional)
- [ ] vim-jsonpath (optional)

### `plugins/ui.lua`
- [ ] pustota.nvim (colorscheme — **critical**)
- [ ] Change kickstart default from tokyonight to pustota
- [ ] bufdelete.nvim
- [ ] nvim-colorizer.lua
- [ ] csvview.nvim
- [ ] gruvbox.nvim (optional)
- [ ] rose-pine (optional)

### `plugins/ya.lua`
- [ ] opencode.nvim + snacks.nvim
- [ ] Resolve `<leader>al` conflict (ArcLink vs opencode add-line)

### `plugins/astronvim_overrides.lua`
- No action needed

### `lazy-lock.json` / `mason-lock.json`
- [ ] The `lazy-lock.json` in the new config will be regenerated
- [ ] If using `mason-lock.nvim`, copy `mason-lock.json` to new config dir

---

## 14. Tmux Integration

Your AstroNvim config uses smart-splits for `<C-h/j/k/l>` navigation, which integrates with tmux. To ensure tmux navigation works in kickstart:

1. Add `mrjones2014/smart-splits.nvim` plugin
2. Configure tmux plugin (if using `christoomey/vim-tmux-navigator` or `smart-splits.nvim` tmux module)
3. Or: use plain `<C-w>h/j/k/l` mappings if you don't need tmux pane navigation

The opencode.nvim config uses `provider = { enabled = "tmux" }`, which requires tmux. This should work as-is after migrating the plugin.

---

## 15. Summary of Gaps

Roughly ordered by urgency:

### Critical (blocks workflow)
1. **Colorscheme**: Add `pustota.nvim`, set `vim.cmd.colorscheme('pustota')`
2. **pyright guarded root_dir**: Migrate `ytils.lua`, configure pyright LSP properly
3. **Arc user commands** (`ArcLink`, `ArcE`, `ArcFind*`, `ArcFiles*`, `Ymypy`): Migrate `ytils.lua`, add fzf + fzf.vim plugins
4. **Russian layout**: Move langmap/keymap/iminsert from `polish()` to `setup_opts.lua`
5. **opencode.nvim**: Migrate `ya.lua` plugin config
6. **gopls + clangd**: Configure in nvim-lspconfig

### Important (affects daily use)
7. **Split navigation**: Add `smart-splits.nvim` (or plain keymaps)
8. **Buffer navigation**: `<S-L>`/`<S-H>` keymaps
9. **mini.files**: Add as file explorer
10. **Formatting**: Configure conform.nvim with stylua, black; add nvim-lint for shellcheck
11. **trouble.nvim**: Add with keymaps
12. **flash.nvim**: Add for motion
13. **lasso.nvim**: Add for file marks
14. **text-case.nvim**: Add (needed by CopyFQN)
15. **gitlink-vim**: Add for GitLink command
16. **Bulk keymaps from polish()**: Copy to `setup_keymaps.lua`
17. **bufdelete.nvim**: Add for `<leader>q`

### Nice to have
18. `nvim-ufo` for folding
19. `aerial.nvim` for symbols outline
20. `nvim-treesitter-context`
21. `nvim-colorizer.lua`
22. `csvview.nvim`
23. `mason-lock.nvim` for reproducible mason installs
24. `structlog.nvim` + logger module
25. `whitespace.nvim`
26. `crazy-node-movement`
27. `vim-jsonpath`
28. `friendly-snippets`
29. `gruvbox.nvim` (alternative colorscheme)
30. `lazydev.nvim` (better Lua LSP, replaces neodev.nvim)

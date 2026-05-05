return {
  -- NOTE: Plugins can be added via a link or github org/name. To run setup automatically, use `opts = {}`
  { 'NMAC427/guess-indent.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 500,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      -- spec = {
      --   { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      --   { '<leader>t', group = '[T]oggle' },
      --   { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      --   { 'gr', group = 'LSP Actions', mode = { 'n' } },
      -- },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    enabled = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
          ['fzf'] = { -- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-setup-and-configuration
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      -- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      -- vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      -- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      -- vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
      -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      --

      -- vim.keymap.set("n", "<leader>f<CR>", function () builtin.find_files({ hidden=true, follow=true, }) end, { desc = "Open file all" })
      vim.keymap.set("n", "<leader>f<CR>", function () builtin.find_files() end, { desc = "Open file" })

      -- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
      -- it is better explained there). This allows easily switching between pickers if you prefer using something else!
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          -- vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
          -- vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
          -- vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
          -- vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
          -- vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
          -- vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })

          vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
          vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
          vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
        end,
      })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = true,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {
          PATH = "append",
        },
      },
      -- Maps LSP server names between nvim-lspconfig and Mason package names.
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      --
      -- https://xnacly.me/posts/2025/neovim-lsp-changes/
      --
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --  See `:help lsp-config` for information about keys and how to configure
      ---@type table<string, vim.lsp.Config>
      local servers = {
        clangd = {
          autostart = true,
          -- TODO: consider adding "proto" back to filetypes if clangd improves .proto support
          filetypes = { "c", "cpp" },
        },
        gopls = {
          autostart = true,
          -- cmd = {'/usr/bin/env', 'gopls'}, -- this would pick up arcadia friendly
          -- cmd = {'ya', 'tool', 'gopls', 'serve'},
          cmd = {'gopls', 'serve'},

          -- init_options is sent as `initializationOptions` in the very first
          -- LSP `initialize` request. This is critical: gopls reads these BEFORE
          -- creating its View, so GOFLAGS=-mod=vendor, GOPRIVATE and
          -- build.arcadiaIndexDirs are honored at View-creation time. Without
          -- this, gopls treats `a.yandex-team.ru/...` imports as unresolved
          -- modules and ends up walking the entire Arcadia tree.
          --
          -- Keys are spelled with vscode-go's hierarchical "dotted" convention,
          -- byte-for-byte matching what the official Yandex VSCode setup sends.
          -- Note: dotted names are vscode-go's presentation, not gopls' canonical
          -- API; the patched Arcadia gopls accepts them via its compat layer.
          -- If a future gopls upgrade drops dotted-name compatibility, switch to
          -- canonical flat names: env, local, codelenses, importShortcut,
          -- semanticTokens, arcadiaIndexDirs.
          init_options = {
            ['build.env'] = {
              CGO_ENABLED = '0',
              GOFLAGS = '-mod=vendor',
              GOPRIVATE = '*.yandex-team.ru,*.yandexcloud.net',
            },
            ['formatting.local'] = 'a.yandex-team.ru',
            ['ui.codelenses'] = {
              regenerate_cgo = false,
              generate = false,
            },
            ['ui.navigation.importShortcut'] = 'Definition',
            ['ui.semanticTokens'] = true,
            ['verboseOutput'] = true,
            ['build.arcadiaIndexDirs'] = {
              vim.fn.expand('junk/dgronskiy/toolblock'),
            },
          },

          -- IMPORTANT: every key in `init_options` above must also appear in
          -- settings.gopls below. nvim-lspconfig replies to gopls's
          -- `workspace/configuration` request with the contents of
          -- settings.gopls. If we omit a key here, gopls treats that as
          -- "the user just unset this setting" and the values from
          -- initializationOptions are lost. Most notably, dropping build.env
          -- makes gopls invoke child `go list` without GOFLAGS=-mod=vendor and
          -- GOPRIVATE, which causes the goimports background cache to scan the
          -- entire workspace tree (~175 MB strace, walking every Arcadia
          -- project under /data/a/junk).
          --
          -- Keys mirror vscode-go's payload byte-for-byte (dotted form), plus
          -- the legacy flat keys (arcadiaIndexDirs, expandWorkspaceToModule)
          -- from the official Arcadia gopls nvim-lspconfig snippet.
          settings = {
            gopls = {
              arcadiaIndexDirs = {
                vim.fn.expand('$ARCADIA_ROOT/library/go'),
                vim.fn.expand('$ARCADIA_ROOT/junk/dgronskiy/toolblock')
              },
              expandWorkspaceToModule = false,
            },
          },
        },
        pyright = {
          autostart = true,
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            on_dir(require("dgronskiy.ytils").guarded_pyright_root_directory(fname))
          end,
          capabilities = (function()
            local caps = vim.lsp.protocol.make_client_capabilities()
            caps.workspace.didChangeWatchedFiles.dynamicRegistration = false
            return caps
          end)(),
        },
        -- rust_analyzer = {},
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},

        stylua = {}, -- Used to format Lua code

        -- Special Lua Config, as recommended by neovim help docs
        lua_ls = {
          on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
                --  See https://github.com/neovim/nvim-lspconfig/issues/3189
                library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                  '${3rd}/luv/library',
                  '${3rd}/busted/library',
                }),
              },
            })
          end,
          ---@type lspconfig.settings.lua_ls
          settings = {
            Lua = {
              format = { enable = false }, -- Disable formatting (formatting is done by stylua)
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- You can add other tools here that you want Mason to install
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- You can specify filetypes to autoformat on save here:
        local enabled_filetypes = {
          go = true,
          -- lua = true,
          -- python = true,
        }
        if enabled_filetypes[vim.bo[bufnr].filetype] then
          return { timeout_ms = 500 }
        else
          return nil
        end
      end,
      default_format_opts = {
        lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
      },
      -- You can also specify external formatters in here.
      formatters_by_ft = {
        go = { 'gofmt' },
        -- rust = { 'rustfmt' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  { -- github.com/folke/todo-comments.nvim
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
        mappings = {
          around_next = 'aa',
          inside_next = 'ii',
        },
        n_lines = 500,
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim

      -- https://github.com/echasnovski/mini.files?tab=readme-ov-file
      require('mini.files').setup({
        windows = {
          preview = true,
          width_focus = 50,
          width_nofocus = 15,
          width_preview = 50,
        },
      })

      -- this is from :h mini.files
      local set_cwd = function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then return vim.notify('Cursor is not on valid entry') end
        vim.fn.chdir(vim.fs.dirname(path))
      end

      -- Yank in register full path of entry under cursor
      local yank_path = function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then return vim.notify('Cursor is not on valid entry') end
        vim.fn.setreg(vim.v.register, path)
      end

      local go_in_close = function()
        MiniFiles.go_in({ close_on_file = true })
      end

      local go_cwd = function()
        MiniFiles.open()
      end

      -- https://github.com/nvim-mini/mini.nvim/issues/760
      -- see: https://github.com/nvim-mini/mini.nvim/blob/a683bfe8e03293e3bb079e24c94e51977756a3ec/doc/mini-files.txt#L433-L448
      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local state = MiniFiles.get_explorer_state()
          if state and state.target_window then
            local new_target_window
            vim.api.nvim_win_call(state.target_window, function()
              vim.cmd(direction .. ' split')
              new_target_window = vim.api.nvim_get_current_win()
            end)
            MiniFiles.set_target_window(new_target_window)
          end
          go_in_close()
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local b = args.data.buf_id
          vim.keymap.set('n', 'g.', set_cwd,     { buffer = b, desc = 'Set cwd' })
          vim.keymap.set('n', 'g@', go_cwd,      { buffer = b, desc = 'Open cwd' })
          vim.keymap.set('n', 'gy', yank_path,   { buffer = b, desc = 'Yank path' })
          vim.keymap.set('n', '<CR>', go_in_close, { buffer = b, desc = 'Go in plus' })
          map_split(b, 'gs', 'belowright horizontal')
          map_split(b, 'gv', 'belowright vertical')
        end,
      })

      vim.keymap.set('n', '<leader>ef', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, { desc = 'MiniFiles: reveal current file' })
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      -- ensure basic parser are installed
      local parsers = {
        'bash',
        'c',
        'cpp',
        'diff',
        'go',
        'gosum',
        'gowork',
        'html',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        if not vim.treesitter.language.add(language) then return end
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'

        -- check if treesitter indentation is available for this language, and if so enable it
        -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
        local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

        -- enables treesitter based indentation
        if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
  ---
  ---
  ---
  ---
  ---
  ---
  ---
  {
      "https://github.com/iautom8things/gitlink-vim",
      event = "VeryLazy",
  },
  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    config = function()
      vim.cmd([[nnoremap  <leader>y "+y]])
      vim.cmd([[vnoremap  <leader>y "+y]]);
      (function()
        local function copy(lines, _)
          require("osc52").copy(table.concat(lines, "\n"))
        end

        local function paste()
          return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
        end

        vim.g.clipboard = {
          name = "osc52",
          copy = { ["+"] = copy, ["*"] = copy },
          paste = { ["+"] = paste, ["*"] = paste },
        }
      end)()
    end,
    keys = {
      -- {
      --     "<leader>cp",
      --     function()
      --         require("osc52").copy_visual()
      --     end,
      --     mode = "v",
      --     desc = "OSC52: [c]o[p] to cliboard",
      -- },
      -- {
      --     "<leader>y",
      --     function()
      --         require("osc52").copy_visual()
      --     end,
      --     mode = "v",
      --     desc = "OSC52: [y]ank to cliboard",
      -- },
    },
  },
  {
      "https://github.com/editorconfig/editorconfig-vim",
      event = "VeryLazy",
  },
  {
    -- "https://github.com/niqodea/lasso.nvim",
    "https://github.com/dgronskij/lasso.nvim",
    commit = "dev",
    event = "VeryLazy",
    config = function()
      local lasso = require("lasso")
      lasso.setup({
        marks_tracker_path = "/home/dgronskiy/vims/.lasso-marks",
      })

      -- Mark current file
      vim.keymap.set("n", vim.g.mapleader .. "m", function()
        lasso.mark_file()
      end)

      -- Go to marks tracker (editable, use `gf` to go to file under cursor)
      vim.keymap.set("n", vim.g.mapleader .. "M", function()
        lasso.open_marks_tracker()
      end)

      -- Jump to n-th marked file (n-th line of marks tracker)
      vim.keymap.set("n", vim.g.mapleader .. "1", function()
        lasso.open_marked_file(1)
      end)
      vim.keymap.set("n", vim.g.mapleader .. "2", function()
        lasso.open_marked_file(2)
      end)
      vim.keymap.set("n", vim.g.mapleader .. "3", function()
        lasso.open_marked_file(3)
      end)
      vim.keymap.set("n", vim.g.mapleader .. "4", function()
        lasso.open_marked_file(4)
      end)
    end,
  },
  { "Tastyep/structlog.nvim", lazy = false, dependencies = { "rcarriga/nvim-notify" } },
  {
      "zapling/mason-lock.nvim",
      event = "VeryLazy",
      config = function()
          require("mason-lock").setup({
              -- keep this in sync with lazy lockfile setup!
              lockfile_path = vim.fn.stdpath("config") .. "/mason-lock.json" -- (default)
              -- lockfile_path = vim.fn.stdpath("config") .. "/lua/user/mason-lock.json",
          })
      end,
  },
  { -- https://github.com/nvim-treesitter/nvim-treesitter-context?tab=readme-ov-file#configuration
      "nvim-treesitter/nvim-treesitter-context",
      event = "VeryLazy",
      opts = {
          min_window_height = 10,
          max_lines = 5,
          multiline_threshold = 1,
          mode = "topline",
      },
      -- keys = {
      --     { -- conflicts with :cprev mapping
      --         "[c",
      --         function()
      --             require("treesitter-context").go_to_context(vim.v.count1)
      --         end,
      --         mode = "n",
      --         desc = "treesitter-context: jump to context (upwards)",
      --         silent = true,
      --     },
      -- },
  },
  -- DISABLED: theHamsta/crazy-node-movement -- https://github.com/theHamsta/crazy-node-movement
  -- Broken: nvim-treesitter (branch=main, the rewrite) permanently removed `define_modules` and
  -- the entire third-party module API that this plugin depends on. Last upstream commit Sep 2023,
  -- author inactive. The movement logic itself (vim.treesitter-based) is still valid.
  --
  -- Options to restore this functionality:
  --
  -- OPTION A: Fork and patch the plugin.
  --   Only `lua/crazy-node-movement.lua:6` needs fixing -- replace the `define_modules` bootstrap
  --   with a direct keymap setup that calls into `lua/crazy-node-movement/node_movement.lua`.
  --   This preserves the original AST-traversal semantics: move_up/down/left/right navigate
  --   the raw syntax tree (parent, first-child, prev-sibling, next-sibling).
  --
  -- OPTION B: Use nvim-treesitter/nvim-treesitter-textobjects (https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
  --   IMPORTANT SEMANTIC DIFFERENCE: textobjects.move does NOT traverse the AST structurally.
  --   It jumps between named captures (@function.outer, @parameter.inner, etc.) in document order
  --   (next/prev in the file), NOT up/down/left/right in the tree. There is no "go to parent node"
  --   or "go to first child" concept. Also: textobjects.move is cursor-only, NOT visual -- it moves
  --   the cursor but does not select/highlight the target node (unlike select_current_node above).
  --
  -- { -- https://github.com/theHamsta/crazy-node-movement
  --     "theHamsta/crazy-node-movement",
  --     event = "VeryLazy",
  --     config = function()
  --         require("nvim-treesitter.configs").setup({
  --             node_movement = {
  --                 enable = true,
  --                 keymaps = {
  --                     move_up = "˙", -- option-h
  --                     move_down = "¬", --option-l
  --                     move_left = "˚", -- option-k
  --                     move_right = "∆", -- option-j
  --                     -- swap_left = "<s-a-h>", -- will only swap when one of "swappable_textobjects" is selected
  --                     -- swap_right = "<s-a-l>",
  --                     select_current_node = "<leader><Cr>",
  --                 },
  --                 swappable_textobjects = { "@function.outer", "@parameter.inner", "@statement.outer" },
  --                 allow_switch_parents = true, -- more craziness by switching parents while staying on the same level, false prevents you from accidentally jumping out of a function
  --                 allow_next_parent = true, -- more craziness by going up one level if next node does not have children
  --             },
  --         })
  --     end,
  -- },
  {
      "mogelbrod/vim-jsonpath",
      event = "VeryLazy",
  },
  { -- https://github.com/johmsalas/text-case.nvim?tab=readme-ov-file#example-for-lazyvim
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
      vim.api.nvim_set_keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
      vim.api.nvim_set_keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
    end,
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      -- "Subs",
      "TextCaseOpenTelescope",
      -- "TextCaseOpenTelescopeQuickChange",
      -- "TextCaseOpenTelescopeLSPChange",
      -- "TextCaseStartReplacingCommand",
    },
    lazy = false,
    -- event = "VeryLazy",
  },
  { "nvim-zh/whitespace.nvim", lazy = false },
  {
    "https://github.com/junegunn/fzf",
    event = "VeryLazy",
  },
  {
    "https://github.com/junegunn/fzf.vim",
    dependencies = {
      "https://github.com/junegunn/fzf",
    },
    event = "VeryLazy",
    config = function()
      -- https://thevaluable.dev/fzf-vim-integration/
      vim.g.fzf_vim = {}
      vim.g.fzf_vim.preview_window = { "hidden,right,50%,<70(up,40%)", "ctrl-p" }
      vim.g.fzf_preview_window = { "hidden,right,50%,<70(up,40%)", "ctrl-p" }
      vim.g.fzf_dgronskiy_dict = {
        options = '--bind "ctrl-j:down,ctrl-k:up"',
      }

      -- vim.g.fzf_vim.preview_window = { "right,10%", "ctrl-/" }
      -- vim.g.fzf_vim.preview_window = { "right,10%", "ctrl-?" }
      -- vim.g.fzf_preview_window = { "right,10%", "ctrl-?" }
      vim.g.fzf_layout = { window = { width = 0.95, height = 0.95 } }
    end,
  },
}

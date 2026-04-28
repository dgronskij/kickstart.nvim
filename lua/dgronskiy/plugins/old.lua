return {
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "https://github.com/ggandor/leap.nvim",
        event = "VeryLazy",
        enabled = false,
        config = function()
            require("leap").add_default_mappings()
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
        opts = function(_, defaults)
            local null_ls = require("null-ls")
            defaults.sources = {

                -- bash
                null_ls.builtins.code_actions.shellcheck,
                null_ls.builtins.diagnostics.shellcheck,

                -- lua
                null_ls.builtins.formatting.stylua,

                -- -- python
                -- null_ls.builtins.diagnostics.flake8,
                -- -- null_ls.builtins.diagnostics.pyproject_flake8,
                -- null_ls.builtins.diagnostics.mypy,
                -- -- null_ls.builtins.diagnostics.pycodestyle,
                -- -- null_ls.builtins.diagnostics.pydocstyle,
                -- -- null_ls.builtins.diagnostics.pylint,
                null_ls.builtins.formatting.black,
                -- null_ls.builtins.formatting.isort,
            }

            return defaults
        end,
    },
    -- notify = {
    --     -- https://github.com/rcarriga/nvim-notify/blob/master/lua/notify/config/init.lua#L22
    --     -- default is 5000ms, which is TOO long
    --     -- for some reason, 1000ms waits longer than expected, so I just put the smallest possible value here
    --     timeout = 1,
    -- },

}

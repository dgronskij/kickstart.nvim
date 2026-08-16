require("dgronskiy.toggle_view").setup_keymap()

return {
    {
        -- https://github.com/ellisonleao/gruvbox.nvim#configuration
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        -- https://github.com/pustota-theme/pustota.nvim
        "pustota-theme/pustota.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme 'pustota'
        end,
    },
    {
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete" },
        keys = {
            { "<leader>q", "<cmd>bdelete<cr>", desc = "close current buffer (:bdelete)" },
        },
    },
    {
        "norcalli/nvim-colorizer.lua",
        event = "VeryLazy",
    },
    {   -- tmux integration
        "mrjones2014/smart-splits.nvim",
        lazy = false,
        config = function()
            require("smart-splits").setup()
        end,
        keys = {
            -- Move between splits
            { "<C-h>", function() require("smart-splits").move_cursor_left() end,  desc = "Move to left split" },
            { "<C-j>", function() require("smart-splits").move_cursor_down() end,  desc = "Move to below split" },
            { "<C-k>", function() require("smart-splits").move_cursor_up() end,    desc = "Move to above split" },
            { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },
            -- Resize splits
            { "<C-Left>",  function() require("smart-splits").resize_left() end,  desc = "Resize split left" },
            { "<C-Down>",  function() require("smart-splits").resize_down() end,  desc = "Resize split down" },
            { "<C-Up>",    function() require("smart-splits").resize_up() end,    desc = "Resize split up" },
            { "<C-Right>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
        },
    },
    {
        "hat0uma/csvview.nvim",
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            parser = {
                comments = { "#", "//" },
                delimiter = {
                    -- Without a `csv` rule, CsvView detects the delimiter from these candidates.
                    ft = { tsv = "\t" },
                    fallbacks = { ",", "\t", ";", "|", ":", " " },
                },
            },
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        ft = { "csv", "tsv" },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
        config = function(_, opts)
            require("csvview").setup(opts)
            require("dgronskiy.toggle_view").register({ "csv", "tsv" }, function()
                vim.cmd("CsvViewToggle")
            end)
        end,
    },
    -- { -- https://github.com/Pocco81/true-zen.nvim
    --     "Pocco81/true-zen.nvim",
    --     keys = {
    --         { "<leader>zn", "<cmd>TZNarrow<CR>", desc = "TrueZen: Narrow" },
    --         { "<leader>zf", "<cmd>TZFocus<CR>", desc = "TrueZen: Focus" },
    --         { "<leader>zm", "<cmd>TZMinimalist<CR>", desc = "TrueZen: Minimalist" },
    --         { "<leader>za", "<cmd>TZAtaraxis<CR>", desc = "TrueZen: Ataraxis" },
    --     },
    -- },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        ft = { "markdown" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            enabled = false,
        },
        config = function(_, opts)
            require("render-markdown").setup(opts)
            require("dgronskiy.toggle_view").register({ "markdown" }, function()
                require("render-markdown").toggle()
            end)
        end,
    }
}

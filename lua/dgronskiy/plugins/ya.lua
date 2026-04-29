return {
    {
        "NickvanDyke/opencode.nvim",
        event = "VeryLazy",
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for `snacks` provider.
            ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
            { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
        },
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
                server = (function()
                    local in_tmux = vim.fn.executable("tmux") == 1 and os.getenv("TMUX") ~= nil
                    if not in_tmux then
                        return {}  -- use plugin defaults
                    end
                    return {
                        toggle = function()
                            -- Find an existing opencode pane and hide/show it, or open a new one
                            local panes = vim.fn.systemlist("tmux list-panes -F '#{pane_id} #{pane_current_command}'")
                            for _, pane in ipairs(panes) do
                                local pane_id, cmd = pane:match("^(%S+)%s+(.+)$")
                                if cmd and cmd:match("opencode") then
                                    -- TODO: hide/show instead of kill once tmux supports it
                                    vim.fn.system("tmux select-pane -t " .. pane_id)
                                    return
                                end
                            end
                            -- -h = horizontal split (side by side), -d = don't focus the new pane
                            vim.fn.system("tmux split-window -h -d 'opencode --port 0'")
                        end,
                        start = function()
                            vim.fn.system("tmux split-window -h -d 'opencode --port 0'")
                        end,
                        stop = function()
                            local panes = vim.fn.systemlist("tmux list-panes -F '#{pane_id} #{pane_current_command}'")
                            for _, pane in ipairs(panes) do
                                local pane_id, cmd = pane:match("^(%S+)%s+(.+)$")
                                if cmd and cmd:match("opencode") then
                                    vim.fn.system("tmux kill-pane -t " .. pane_id)
                                    return
                                end
                            end
                        end,
                    }
                end)(),
            }

            -- Required for `opts.events.reload`.
            vim.o.autoread = true

            -- Recommended/example keymaps.
            vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
            vim.keymap.set({ "n", "x" }, "<leader>as", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
            vim.keymap.set({ "n", "t" }, "<leader>at", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

            vim.keymap.set({ "n", "x" }, "<leader>ar",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
            vim.keymap.set("n",          "<leader>al", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

            vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
            vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

            -- -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
            -- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
            -- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
        end,
    }
}

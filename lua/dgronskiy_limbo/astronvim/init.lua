-- vim.g.max_file = {  -- this is read by Aerial.nvim astronvim configuration
--     lines = 10000,
--     size = 3 * 1000 * 1000,
-- }

local config = {
    colorscheme = "pustota",
    lsp = {
        servers = {
            "pyright",
            "gopls",
            "clangd",
        },

        formatting = {
            format_on_save = {
                enable = false,
            },
        },
        config = {
            -- https://github.com/microsoft/pyright/blob/main/docs/settings.md
            pyright = {
                autostart = true,
                -- autostart = false,
                -- autostart = (function ()
                --     local val = os.getenv("NVIM_ENABLE_LSP_PYRIGHT")
                --     return val ~= nil and #val ~= 0
                -- end)(),
                root_dir = require("dgronskiy_nvim.ytils").guarded_pyright_root_directory,
                -- root_ir = function()
                --     return "/home/dgronskiy" -- for some reason large workspace hangs everything
                -- end,
                -- analysis = {
                --     logLevel = "Trace",
                -- },
                capabilities = (function()
                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
                    return capabilities
                end)(),
            },
            gopls = {
                autostart = true,
                -- cmd = { "ya", "tool", "gopls" },
                settings = {
                    gopls = {
                        -- directoryFilters = { "-", "+[ваша папка]" },
                        expandWorkspaceToModule = false,
                    },
                },
            },
            clangd = {
                -- https://github.com/neovim/nvim-lspconfig/tree/b0852218bc5fa6514a71a9da6d5cfa63a263c83d/lua/lspconfig/server_configurations/clangd.lua#L45
                -- disable for .proto files as clang complains about invalid AST
                filetypes = { "c", "cpp" },
            },
        },
    },
}

return config

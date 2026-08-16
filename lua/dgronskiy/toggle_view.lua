local M = {}

local toggles_by_filetype = {}

function M.register(filetypes, toggle)
    for _, filetype in ipairs(filetypes) do
        toggles_by_filetype[filetype] = toggle
    end
end

function M.toggle()
    local toggle = toggles_by_filetype[vim.bo.filetype]

    if toggle then
        toggle()
        return
    end

    vim.notify("No view renderer is registered for filetype: " .. vim.bo.filetype, vim.log.levels.INFO)
end

function M.setup_keymap()
    vim.keymap.set("n", "<leader>uv", M.toggle, { desc = "Toggle [U]i [V]iew" })
end

return M

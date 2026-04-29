vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- TODO: check
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- on * key pressed, hightlight cword, but do not immediately jump
-- https://stackoverflow.com/a/49944815/539570
vim.cmd([[nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>]])

vim.cmd([[nnoremap ]c :cnext<CR>]])
vim.cmd([[nnoremap [c :cprev<CR>]])

-- https://stackoverflow.com/questions/12315612/move-forward-backwards-one-word-in-command-mode
vim.cmd([[cnoremap <C-a> <Home>]])
vim.cmd([[cnoremap <C-e> <End>]])

vim.cmd([[map <Leader>dark :set background=dark<CR>]])
vim.cmd([[map <Leader>light :set background=light<CR>]])

vim.cmd([[ vnoremap > >gv ]])
vim.cmd([[ vnoremap < <gv ]])

-- Commenting
vim.cmd([[ nmap <leader>c<leader> gcc]])
vim.cmd([[ vmap <leader>c<leader> gcgv]])
vim.cmd([[ nmap <C-_> gcc]])  -- this actually means <C-/> !!!!
vim.cmd([[ vmap <C-_> gcgv]])  -- this actually means <C-/> !!!!

vim.cmd([[nnoremap <silent> z. :<C-u>normal! zszH<CR>]]) -- https://unix.stackexchange.com/a/585098

vim.cmd([[vnoremap <leader>p "_dP]])


if true then -- fzf.vim related stuff -- TODO: move into lazy part
    (function()
        vim.cmd([[nnoremap <Leader>b :Buffers<CR>]])
        vim.cmd([[nnoremap <Leader>h :History<CR>]])
        vim.cmd([[nnoremap <leader>t<CR>  :Tags '<C-R><C-W> <CR>]])
        vim.cmd([[vnoremap <leader>t<CR> "vy :Tags '<C-R>v <CR>]])
    end)()
end

-- FROM ASTRONVIM CONFIG

-- vim.keymap.set("n", "<leader>f<CR>", function() require("dgronskiy_nvim.telescope_custom").find_all_files() end, { desc = "Open file" })
vim.keymap.set("n", "<ESC>", function() vim.cmd([[ :noh ]]) end)
vim.keymap.set("n", "<S-K>", ":FindExact <C-R><C-W><CR>", { desc = "FZF: find the word under cursor" })
vim.keymap.set("n", "<leader><S-K>", function()
    local ytils = require("dgronskiy_nvim.ytils")
    local current_file_path = vim.fn.expand("%:p")
    local force_find_all = current_file_path:match("junk") ~= nil or current_file_path:match("contrib") ~= nil
    if ytils.arc_find_find_all or force_find_all then
        return ":ArcFindExactAll <C-R><C-W><CR>"
    else
        return ":ArcFindExact    <C-R><C-W><CR>"
    end
end, { desc = "Arc: find the word under cursor", expr = true })
vim.keymap.set("n", "<leader>/", ":BLines<CR>", { desc = "FZF: Buffer lines" })

-- jump to the tab by its number
vim.keymap.set("n", "<leader>1", "1gt", { desc = "[g]o to [t]ab 1" })
vim.keymap.set("n", "<leader>2", "2gt", { desc = "[g]o to [t]ab 2" })
vim.keymap.set("n", "<leader>3", "3gt", { desc = "[g]o to [t]ab 3" })
vim.keymap.set("n", "<leader>4", "4gt", { desc = "[g]o to [t]ab 4" })

-- buffer navigation
vim.keymap.set("n", "<S-L>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-H>", "<Cmd>bprev<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<C-W><C-T>", "<Cmd>tab split<CR>", { desc = "open current buffer in new tab" })
vim.keymap.set("n", "<leader>fa", ":ArcFiles ", { desc = "Search [F]ile in [A]rc" })
vim.keymap.set("n", "<leader>e", function() MiniFiles.open() end, { noremap = true, desc = "Toggle Explorer" })
vim.keymap.set("n", "<C-q>", "<C-w>q", { desc = "Close window" })

vim.keymap.set("v", "<S-K>", '"vy :FindExact <C-R>v<CR>', { desc = "FZF: find the selection" })
vim.keymap.set("v", "<leader><S-K>", '"vy :ArcFind <C-R>v<CR>', { desc = "Arc: find the selection" })
vim.keymap.set("v", "<leader>cs", '"vy :ArcFind <C-R>v<CR>', { desc = "Arc: find the selection" })
vim.keymap.set("v", "<leader>fa", '"vy :ArcFiles <C-R>v<CR>', { desc = "Search selected [F]ile in [A]rc" })
vim.keymap.set("v", "<leader>/", '"vy :BLines <C-R>v<CR>', { desc = "FZF: buffer lines" })







-- -- Navigate tabs
-- maps.n["]t"] = {
--     function()
--         vim.cmd.tabnext()
--     end,
--     desc = "Next tab",
-- }
-- maps.n["[t"] = {
--     function()
--         vim.cmd.tabprevious()
--     end,
--     desc = "Previous tab",
-- }
--
-- if is_available("Comment.nvim") then
--     maps.n["<leader>c"] = {
--         function()
--             require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
--         end,
--         desc = "Toggle comment line",
--     }
--     maps.v["<leader>c"] = {
--         "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
--         desc = "Toggle comment for selection",
--     }
-- end
--
-- -- GitSigns
-- if is_available("gitsigns.nvim") then
--     -- maps.n["<leader>g"] = sections.g
--     maps.n["]g"] = {
--         function()
--             require("gitsigns").next_hunk()
--         end,
--         desc = "Next Git hunk",
--     }
--     maps.n["[g"] = {
--         function()
--             require("gitsigns").prev_hunk()
--         end,
--         desc = "Previous Git hunk",
--     }
-- end
--
-- -- Smart Splits
-- if is_available("smart-splits.nvim") then
--     maps.n["<C-h>"] = {
--         function()
--             require("smart-splits").move_cursor_left()
--         end,
--         desc = "Move to left split",
--     }
--     maps.n["<C-j>"] = {
--         function()
--             require("smart-splits").move_cursor_down()
--         end,
--         desc = "Move to below split",
--     }
--     maps.n["<C-k>"] = {
--         function()
--             require("smart-splits").move_cursor_up()
--         end,
--         desc = "Move to above split",
--     }
--     maps.n["<C-l>"] = {
--         function()
--             require("smart-splits").move_cursor_right()
--         end,
--         desc = "Move to right split",
--     }
--     maps.n["<C-Up>"] = {
--         function()
--             require("smart-splits").resize_up()
--         end,
--         desc = "Resize split up",
--     }
--     maps.n["<C-Down>"] = {
--         function()
--             require("smart-splits").resize_down()
--         end,
--         desc = "Resize split down",
--     }
--     maps.n["<C-Left>"] = {
--         function()
--             require("smart-splits").resize_left()
--         end,
--         desc = "Resize split left",
--     }
--     maps.n["<C-Right>"] = {
--         function()
--             require("smart-splits").resize_right()
--         end,
--         desc = "Resize split right",
--     }
-- else
--     maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
--     maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
--     maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
--     maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }
--     maps.n["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" }
--     maps.n["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" }
--     maps.n["<C-Left>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" }
--     maps.n["<C-Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" }
-- end
--
-- -- maps.n["<leader>ud"] = { ui.toggle_diagnostics, desc = "Toggle diagnostics" }
-- -- maps.n["<leader>ug"] = { ui.toggle_signcolumn, desc = "Toggle signcolumn" }
-- -- maps.n["<leader>ui"] = { ui.set_indent, desc = "Change indent setting" }
-- -- maps.n["<leader>ul"] = { ui.toggle_statusline, desc = "Toggle statusline" }
-- -- maps.n["<leader>uL"] = { ui.toggle_codelens, desc = "Toggle CodeLens" }
-- -- maps.n["<leader>un"] = { ui.change_number, desc = "Change line numbering" }
-- -- maps.n["<leader>uN"] = { ui.toggle_ui_notifications, desc = "Toggle Notifications" }
-- -- maps.n["<leader>up"] = { ui.toggle_paste, desc = "Toggle paste mode" }
-- -- maps.n["<leader>us"] = { ui.toggle_spell, desc = "Toggle spellcheck" }
-- -- maps.n["<leader>uS"] = { ui.toggle_conceal, desc = "Toggle conceal" }
-- -- maps.n["<leader>ut"] = { ui.toggle_tabline, desc = "Toggle tabline" }
-- -- maps.n["<leader>uu"] = { ui.toggle_url_match, desc = "Toggle URL highlight" }
-- -- maps.n["<leader>uw"] = { ui.toggle_wrap, desc = "Toggle wrap" }
-- -- maps.n["<leader>uy"] = { ui.toggle_syntax, desc = "Toggle syntax highlighting (buffer)" }
-- -- maps.n["<leader>uh"] = { ui.toggle_foldcolumn, desc = "Toggle foldcolumn" }

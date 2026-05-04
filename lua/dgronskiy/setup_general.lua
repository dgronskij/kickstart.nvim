-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  -- underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}


vim.cmd([[ command GitLink :echo gitlink#GitLink() ]])

vim.cmd(
  [[ command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --smart-case  --hidden --follow  --color "always" '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)
vim.cmd(
  [[ command! -bang -nargs=* FindWithLocationList call fzf#vim#grep('dimonrg '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)
vim.cmd(
  [[ command! -bang -nargs=* FindExact call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --smart-case  --hidden --follow  --color "always" '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)
vim.cmd(
  [[ command! -bang -nargs=* FindAll call fzf#vim#grep('rg -uuu --column --line-number --no-heading --smart-case  --hidden --follow  --color "always" '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)

vim.cmd(
  -- + case-insensitive
  [[ command! -bang -nargs=* ArcFind call fzf#vim#grep('ya tool cs -i --current-folder --no-contrib --no-junk --max all  --color "always" -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)
vim.cmd(
  -- + case-insensitive
  [[ command! -bang -nargs=* ArcFindAll call fzf#vim#grep('ya tool cs -i --current-folder --max all  --color "always" -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)
vim.cmd(
  [[ command! -bang -nargs=* ArcFindExact call fzf#vim#grep('ya tool cs --current-folder --no-contrib --no-junk --max all -F --color "always" -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)
vim.cmd(
  [[ command! -bang -nargs=* ArcFindExactAll call fzf#vim#grep('ya tool cs --current-folder --max all -F --color "always" -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)

-- FIXME: this uses grep format (see that period symbol before --file) and corresponding fzf command
-- Unfortunately, fzf#vim#file is not dynamically configurable
-- fzf-lua does
-- edially, this is the case for telescope live-grep fuctionality where on each input update the request to `cs` tool is made (since its pretty fast)
-- TODO: remove `.` search pattern
--       remove -g1 (max match per file)
vim.cmd(
  -- + case-insensitive
  [[ command! -bang -nargs=* ArcFiles call fzf#vim#grep('ya tool cs -i --current-folder --no-contrib --no-junk --max 50000 --color "always" . -g1 --file '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)
vim.cmd(
  -- + case-insensitive
  [[ command! -bang -nargs=* ArcFilesAll call fzf#vim#grep('ya tool cs -i --current-folder --max 50000 --color "always" . -g1 --file '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0) ]]
)

vim.cmd([[ vnoremap <Leader>cat :'<,'>w !tee<CR> ]])

vim.cmd([[ nnoremap <Leader>find :Find ]])
vim.cmd([[ nnoremap <Leader>fd :Find ]])
vim.cmd([[ nnoremap <Leader>floc :FindWithLocationList ]])
vim.cmd([[ nnoremap <Leader>cs :ArcFind ]])

vim.cmd([[ nnoremap <Leader>al :ArcLink<CR> ]])
vim.cmd([[ vnoremap <Leader>al :ArcLink<CR> ]])


-- open dgronskiy_nvim.log ; go to end
vim.cmd(
  [[ command DGronskiyNvimLog :execute "e " .. expand(stdpath("log")) .. "/dgronskiy_nvim.log | normal \<S-G>" ]]
)


vim.api.nvim_create_user_command("Cd", function(args)
  local target_dir = vim.fn.expand("%:p:h")
  vim.cmd.cd(target_dir)
  vim.print(":cd " .. target_dir)
end, { desc = "[C]hange [D]irectory to currently opened file" })
vim.cmd([[nnoremap  <leader>cd    :Cd<CR>]])

vim.api.nvim_create_user_command("Lcd", function(args)
  local target_dir = vim.fn.expand("%:p:h")
  vim.cmd.lcd(target_dir)
  vim.print(":lcd " .. target_dir)
end, { desc = "[L]ocal [C]hange [D]irectory to currently opened file" })
vim.cmd([[nnoremap  <leader>lcd  :Lcd<CR>]])

vim.cmd([[nnoremap  <leader>cda :cd $A \| :pwd<CR>]])
vim.cmd([[nnoremap  <leader>lcda :lcd $A \| :pwd<CR>]])



vim.api.nvim_create_user_command("CopyFileName", function(opts)
  local file_path = vim.fn.expand("%") ---@type string
  vim.fn.setreg("+", file_path) -- copy to system clipboard
  print("Copied filename: ", file_path)
end, { force = true, range = true })
vim.cmd([[nnoremap <leader>cfn <cmd>CopyFileName<CR>]])

vim.api.nvim_create_user_command("CopyFQN", function(opts)
  local word_under_cursor = vim.fn.expand("<cword>")
  local module_path = vim.fn.expand("%:r") ---@type string
  local module_path = require("textcase").api.to_dot_case(module_path)

  local res = module_path .. "." .. word_under_cursor
  vim.fn.setreg("+", res) -- copy to system clipboard
  print("Copied FQN: ", res)
end, { force = true, range = true })
vim.cmd([[nnoremap <leader>cfqn <cmd>CopyFQN<CR>]])



if true then
  (function()
    -- https://github.com/Wansmer/langmapper.nvim
    local function escape(str)
      -- You need to escape these characters to work correctly
      local escape_chars = [[;,."|\]]
      local escape_chars = [[;,"|\]]
      return vim.fn.escape(str, escape_chars)
    end

    -- Recommended to use lua template string
    -- IMPORTANT:
    -- this is still a hack without knowing actual active keyboard layout;
    -- one cannot map e.g. `.` (russian layout) into `/` (corresponding character in english layout)
    -- since that mapping would "work" (= break everything) with english layout too
    local en = [[qwertyuiop[]asdfghjkl;'zxcvbnm,.]]
    local ru = [[йцукенгшщзхъфывапролджэячсмитьбю]]
    local en_shift = [[QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
    local ru_shift = [[ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

    vim.opt.langmap = vim.fn.join({
      -- | `to` should be first     | `from` should be second
      escape(ru_shift)
        .. ";"
        .. escape(en_shift),
      escape(ru) .. ";" .. escape(en),
    }, ",")

    vim.opt.keymap = "russian-jcukenwin" -- https://neovim.io/doc/user/russian.html
    vim.opt.iminsert = 0 -- english by default
  end)()
end

if true then -- TODO toggle
  (function()
    -- stolen from https://github.com/agronskiy/dotfiles/blob/5abdb21325e59180a234b73662cf66edef8edaf1/_verbose/.config/nvim.symlink/lua/mappings.lua#L222-L262


    -- Cycle Obsidian-style task markers:
    -- - [ ] -> - [<] -> - [/] -> - [x] -> - [ ]
    -- If missing, create "- [ ]" (or convert "- item" into "- [ ] item").
    local function cycle_task_marker()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row is 1-based, col is 0-based
      local line = vim.api.nvim_get_current_line()

      -- Already a task checkbox?
      local indent, state, rest = line:match("^(%s*)%-%s*%[([ x/<])%]%s*(.*)$")
      if indent then
        -- local next_state = (state == " " and "<") or (state == "<" and "/") or (state == "/" and "x") or " "
        local next_state = (state == " " and "x") or " "
        vim.api.nvim_set_current_line(("%s- [%s] %s"):format(indent, next_state, rest))
        return
      end

      -- Bullet without checkbox -> convert.
      local b_indent, b_rest = line:match("^(%s*)%-%s+(.*)$")
      if b_indent then
        vim.api.nvim_set_current_line(("%s- [ ] %s"):format(b_indent, b_rest))
        local indent_len = #b_indent
        local new_col
        if col < indent_len + 2 then
          new_col = indent_len + 6
        else
          new_col = col + 4
        end
        vim.api.nvim_win_set_cursor(0, { row, math.max(0, new_col) })
        return
      end

      -- No bullet -> prepend.
      local i = line:match("^(%s*)") or ""
      local content = line:sub(#i + 1)
      vim.api.nvim_set_current_line(("%s- [ ] %s"):format(i, content))
      local indent_len = #i
      local new_col
      if col < indent_len then
        new_col = col
      else
        new_col = col + 6
      end
      vim.api.nvim_win_set_cursor(0, { row, math.max(0, new_col) })
    end

    vim.keymap.set({ "n", "i" }, "<leader><CR>", cycle_task_marker, { desc = "Cycle task marker" })
  end)()
end

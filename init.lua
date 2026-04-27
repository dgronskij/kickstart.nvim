-- vim: ts=2 sts=2 sw=2 et
require 'dgronskiy.setup_opts'
require 'dgronskiy.setup_keymaps'


-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}


require 'dgronskiy.setup_autocmds'
require 'dgronskiy.setup_lazy'

-- The line beneath this is called `modeline`. See `:help modeline`

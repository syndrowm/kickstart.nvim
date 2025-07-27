local capabilities = require('blink.cmp').get_lsp_capabilities()

local config = {
  settings = {
    ['rust-analyzer'] = {
      check = {
        allFeatures = true,
        command = 'clippy',
      },
      cargo = { allFeatures = true, autoreload = true },
      callInfo = { full = true },
      lens = { enable = true, references = true, implementations = true, enumVariantReferences = true, methodReferences = true },
      inlayHints = { enable = true, typeHints = true, parameterHints = true },
      hoverActions = { enable = true },
    },
  },
  capabilities = capabilities,
}
require('lspconfig').rust_analyzer.setup(config)

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>tf', vim.diagnostic.open_float, { desc = '[T]oggle Diagnostic [F]loat' })
-- code action
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode A[c]tion' })

vim.cmd [[
  hi NormalFloat guibg=#1e222a  " Set background color of the floating window
  hi FloatBorder guifg=#56b6c2  " Set border color
]]

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false
    vim.opt_local.list = true
  end,
})

vim.o.winborder = 'single'

return {}

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

require('conform').setup {
  format_after_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return {}
    end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters_by_ft = {
    rust = { 'rustfmt', lsp_format = 'fallback' },
    python = function(bufnr)
      if require('conform').get_formatter_info('ruff_format', bufnr).available then
        return { 'ruff_format' }
      else
        return { 'isort', 'black' }
      end
    end,
  },
}

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>tf', vim.diagnostic.open_float, { desc = '[T]oggle Diagnostic [F]loat' })
-- code action
vim.keymap.set('n', '<leader>cc', vim.lsp.buf.code_action, { desc = '[C]ode A[c]tion' })

vim.cmd [[
  hi NormalFloat guibg=#1e222a  " Set background color of the floating window
  hi FloatBorder guifg=#56b6c2  " Set border color
]]

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

return {}

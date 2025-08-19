local capabilities = require('blink.cmp').get_lsp_capabilities()

local lspconfig = require 'lspconfig'

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
lspconfig.rust_analyzer.setup(config)

local go_config = {
  filetypes = { 'go', 'gomod' },
  root_dir = lspconfig.util.root_pattern('go.work', 'go.mod', '.git'),
  settings = {
    ['gopls'] = {
      gofumpt = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      completeUnimported = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  capabilities = capabilities,
}

lspconfig.gopls.setup(go_config)

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
    vim.opt_local.list = false
  end,
})

vim.o.winborder = 'single'

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }

    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
    for _, res in pairs(result or {}) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, 'utf-16')
        elseif action.command then
          vim.lsp.buf.execute_command(action.command)
        end
      end
    end
  end,
})

return {}

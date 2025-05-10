vim.api.nvim_create_user_command('FormatDisable', function(args)
  notify = require('fidget.notification').notify
  notify 'file format disabled'
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
    vim.cmd 'setlocal nofixendofline'
  else
    vim.g.disable_autoformat = true
    vim.cmd 'set nofixendofline'
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
  notify = require('fidget.notification').notify
  notify 'file format enabled'
  vim.cmd 'set fixendofline'
  vim.cmd 'setlocal fixendofline'
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

return {
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = false,
    format_after_save = function(bufnr)
      notify = require('fidget.notification').notify
      notify 'after save'
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    format_on_save = function(bufnr)
      notify = require('fidget.notification').notify
      notify 'on save'
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
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
  },
}

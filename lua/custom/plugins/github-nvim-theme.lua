return {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 100,
  config = function()
    require('github-theme').setup {
      options = {
        transparent = true,
        styles = {
          functions = 'bold',
        },
      },
    }
    vim.cmd.colorscheme 'github_dark'
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  end,
}

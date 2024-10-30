function RustFeatureInner(feature)
  require('lspconfig').rust_analyzer.setup {
    settings = {
      ['rust-analyzer'] = {
        cargo = { features = { feature } },
        procMacro = {
          ignored = {
            leptos_macro = {
              'server',
            },
          },
        },
      },
    },
  }
end

function RustFeature()
  local current_word = vim.call('expand', '<cword>')
  RustFeatureInner(current_word)
end

function LeptosFormat()
  require('conform').setup {
    formatters = {
      rustfmt = {
        command = 'leptosfmt',
        args = {
          '--stdin',
          '--rustfmt',
        },
      },
    },
  }
  require('conform').format { async = true, lsp_fallback = true }
end

vim.keymap.set('n', '<leader>lf', LeptosFormat, { desc = '[L]eptos [F]ormat' })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

local config = {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        allFeatures = true,
        command = 'clippy',
      },
      cargo = { allFeatures = true, autoreload = true },
      procMacro = {
        enabled = true,
        ignored = {
          leptos_macro = {
            'server',
          },
        },
      },
      callInfo = { full = true },
      lens = { enable = true, references = true, implementations = true, enumVariantReferences = true, methodReferences = true },
      inlayHints = { enable = true, typeHints = true, parameterHints = true },
      hoverActions = { enable = true },
    },
  },
  capabilities = capabilities,
}

require('lspconfig').rust_analyzer.setup(config)

return {}

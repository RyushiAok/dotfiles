return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.keymap.set('n', '<C-e>', ':NvimTreeOpen<CR>', { noremap = true, silent = true })
      require('nvim-tree').setup {
        filters = {
          git_ignored = false,
          dotfiles = false,
          custom = {
            '^\\.git$',
          },
        },
      }
    end,
  },
}

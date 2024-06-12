-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'github/copilot.vim',
    lazy = false,
  },
  {
    'rust-lang/rust.vim',
    lazy = false,
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
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
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  {
    'akinsho/toggleterm.nvim',
    keys = {
      { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = 'ToggleTerm' },
    },
    version = '*',
    config = true,
  },
  {
    'ionide/ionide-vim',
    ft = 'fsharp',
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('ionide').setup {}
      -- require('lspconfig').fsautocomplete.setup {}
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  {
    'windwp/nvim-ts-autotag',
  },
}

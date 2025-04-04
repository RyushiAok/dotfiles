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
    'sindrets/diffview.nvim',
    config = function()
      vim.keymap.set('n', '<leader>hd', '<cmd>DiffviewOpen<CR>', { silent = true })
      vim.keymap.set('n', '<leader>hp', function()
        local base_commit = vim.fn.system('git merge-base main HEAD'):gsub('%s+', '')
        vim.cmd('DiffviewOpen ' .. base_commit .. '..HEAD')
      end, { silent = true, desc = 'DiffviewOpen <base-commit>..HEAD' })
      vim.keymap.set('n', '<leader>hf', '<cmd>DiffviewFileHistory %<CR>', { silent = true })
      vim.keymap.set('n', '<leader>ht', '<cmd>DiffviewToggleFiles<CR>', { silent = true })
    end,
    hooks = {
      diff_buf_read = function(bufnr)
        -- Change local options in diff buffers
        vim.opt_local.wrap = false
        vim.opt_local.list = false
        vim.opt_local.colorcolumn = { 80 }
      end,
      view_opened = function(view)
        print(('A new %s was opened on tab page %d!'):format(view.class:name(), view.tabpage))
      end,
    },
  },
  -- {
  --   'pwntester/octo.nvim',
  --   requires = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-telescope/telescope.nvim',
  --     -- OR 'ibhagwan/fzf-lua',
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --   config = function()
  --     vim.keymap.set('n', '<leader>opl', '<cmd>Octo pr list<CR>', { silent = true })
  --     vim.keymap.set('n', '<leader>opc', '<cmd>Octo pr create<CR>', { silent = true })
  --     vim.keymap.set('n', '<leader>oil', '<cmd>Octo issue list<CR>', { silent = true })
  --     vim.keymap.set('n', '<leader>oic', '<cmd>Octo issue create<CR>', { silent = true })

  --     require('octo').setup {
  --       suppress_missing_scope = {
  --         projects_v2 = true,
  --       },
  --     }
  --   end,
  -- },
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
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ['html'] = {
            enable_close = false,
          },
        },
      }
    end,
  },
  {
    'chomosuke/typst-preview.nvim',
    lazy = false, -- or ft = 'typst'
    version = '1.*',
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  },
}

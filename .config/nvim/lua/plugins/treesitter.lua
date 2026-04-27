return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({})

      local group = vim.api.nvim_create_augroup('vim-treesitter-start', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(ctx)
          pcall(vim.treesitter.start)

          if ctx.match ~= 'ruby' then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
} 

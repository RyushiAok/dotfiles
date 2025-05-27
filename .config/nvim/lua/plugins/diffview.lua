return {
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
        vim.opt_local.wrap = false
        vim.opt_local.list = false
        vim.opt_local.colorcolumn = { 80 }
      end,
      view_opened = function(view)
        print(('A new %s was opened on tab page %d!'):format(view.class:name(), view.tabpage))
      end,
    },
  },
}

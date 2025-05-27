return {
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
}

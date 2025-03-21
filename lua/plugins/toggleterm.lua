return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<C-\>]],
      terminal_mappings = true,
      direction = "horizontal",
      size = 20,
      persist_size = true,
      shell='/bin/zsh',
      winbar = {
        enabled = false,
      },
      actions = {
        open_file = {
          eject = false,
        }
      },
    })

    vim.keymap.set('n', '<leader>t', function()
      local term = require('toggleterm.terminal').get(1)
      term:toggle()
      term:toggle()
      if term:is_open() then
        term:resize(20)
      end
      vim.cmd("wincmd k")
      vim.cmd("wincmd l")
    end, { desc = 'Resizes ToggleTerm.' })
  end
}

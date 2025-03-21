require("core.options")
require("core.remaps")
require("core.autocmds")
require("core.plugins")

-- Makes sure NvimTree is opened regardless of how nvim is invoked
vim.cmd("NvimTreeToggle")
vim.cmd("NvimTreeToggle")
vim.cmd("NvimTreeFocus")
-- Opens the terminal
vim.cmd("ToggleTerm")
-- Moves the cursor to the first line in the tree (not the header)
vim.cmd.stopinsert()
vim.api.nvim_feedkeys("j","n",false)

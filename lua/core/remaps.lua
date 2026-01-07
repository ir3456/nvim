-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-e>', '<cmd>e!<CR>')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("v", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.keymap.set("n", "<C-w>", ":w<CR>")

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR> :e<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")

vim.keymap.set("n", "<C-_>", "?\\v([⚀⚁⚂⚃⚄⚅]{2}|^\\> )<CR>")


function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jj', [[<C-\><C-n>jj]], opts)
  vim.keymap.set('t', 'kk', [[<C-\><C-n>kk]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  vim.keymap.set('t', '<C-q>', [[<C-\><C-n>:qa<CR>]], opts)
end
vim.keymap.set('t', '<C-x>', function()
  local chan = vim.b.terminal_job_id
  if chan then
    vim.api.nvim_chan_send(chan, '\x1b')  -- ESC character
  end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>gc", ":Git commit -m \"\"<Left>");
vim.keymap.set("n", "<leader>ga", ":w <CR> :Git add % <CR>");
vim.keymap.set("n", "<leader>gt", ":Git tag ");
vim.keymap.set("n", "<leader>gp", ":Git push origin ");
vim.keymap.set("n", "<leader>gd", ":Git diff % <CR>");
vim.keymap.set("n", "<leader>gdc", ":Git diff --cached % <CR>");

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
vim.keymap.set('i', '<C-q>', [[<C-c> :qa <CR>]])
vim.keymap.set('n', '<C-q>', [[:qa <CR>]])

vim.keymap.set("n", "<leader>c", function()
  vim.cmd("wincmd k")
  vim.cmd("wincmd l")
  vim.cmd("wincmd l")
  vim.cmd("rightbelow 90vsplit | terminal")
  local job_id = vim.b.terminal_job_id
  if job_id then
    vim.fn.chansend(job_id, "claude -c\n")
  end
  vim.cmd("startinsert")
end, { desc = "Terminal on right (90 cols)" })

vim.keymap.set("n", "<leader>gr", ":Telescope lsp_references<CR>")

local function comment_box()
    -- Prompt the user for input
    local input = vim.fn.input("Text to box: ")

    -- Calculate the box dimensions
    local length = #input
    local border = "    " .. string.rep("#", length + 4)
    local middle = "    # " .. input .. " #"

    -- Insert the box into the buffer
    local lines = {border, middle, border}
    vim.api.nvim_put(lines, "l", true, true)
end

-- Create a command to call the function
vim.api.nvim_create_user_command("CommentBox", comment_box, {})
vim.keymap.set("n", "<leader>cb", ":CommentBox<CR>");


local function param_dict()
  local start_line = vim.fn.search("^ *def ", "bnW")
  if start_line == 0 then
    print("No function definition found above cursor")
    return
  end

  local line = vim.fn.getline(start_line)
  local last_char = line:sub(-1)

  local params = {}

  if last_char == "(" then
    local lnum = start_line + 1

    while true do
      local current = vim.fn.getline(lnum)
      local first_char = current:match("^%s*(%S)")
      if first_char == ")" then
        break
      else
        for param in current:gmatch("[^,]+") do
          local name = param:match("^%s*([^:%s]+)")
          if name then
            table.insert(params, name)
          end
        end
      end

      lnum = lnum + 1
    end

  else
    local inner = line:match("%((.*)%)")
    for param in inner:gmatch("[^,]+") do
      local name = param:match("^%s*([^:%s]+)")
      if name then
        table.insert(params, name)
      end
    end
  end

  local result = "{"
  for i, name in ipairs(params) do
    result = result .. string.format("\"%s\": %s", name, name)
    if i < #params then
      result = result .. ", "
    end
  end
  result = result .. "}"

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()

  local new_line = current_line:sub(1, col) .. result .. current_line:sub(col + 1)
  vim.api.nvim_buf_set_lines(0, row - 1, row, true, { new_line })
end

-- Create a command to call the function
vim.api.nvim_create_user_command("ParamDict", param_dict, {})
vim.keymap.set("n", "<leader>dp", ":ParamDict<CR>");

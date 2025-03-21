-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- Controls tab title
local start_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
vim.o.title = true
vim.o.titlestring = start_dir

-- These are necessary for NVim Tree to work
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "89"

vim.g.omni_sql_no_default_maps = true

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


local function branch_name()
  local branch = io.popen("git rev-parse --abbrev-ref HEAD 2> /dev/null")
  if branch then
    local name = branch:read("*l")
    branch:close()
    if name then
      return "(" .. name .. ") "
    else
      return ""
    end
  end
end

local function file_name()
  local root_path = vim.fn.getcwd()
  local root_dir = root_path:match("[^/]+$")
  local home_path = vim.fn.expand("%:~")
  local overlap, _ = home_path:find(root_dir)
  if home_path == "" then
    return root_path:gsub("/Users/isaac", "~")
  elseif overlap then
    return home_path:sub(overlap)
  else
    return home_path
  end
end

local function progress()
  local p = (vim.fn.line(".") - 1) / (vim.fn.line("$") - 1) * 100
  -- p = p % 1 >= .5 and math.ceil(p) or math.floor(p)
  return string.format("%2d", p) .. "%%"
end

function _G.status_line()
  if string.find(vim.bo.filetype, "NvimTree") then
    local dice = { "⚀", "⚁", "⚂", "⚃", "⚄", "⚅" }
    local randomIndex1 = math.random(#dice) -- or short math.random(#array)
    local randomIndex2 = math.random(#dice) -- or short math.random(#array)
    local d_1 = dice[randomIndex1]
    local d_2 = dice[randomIndex2]
    return d_1 .. d_2
  else
    return " "
      .. "%<"
      .. branch_name()
      .. file_name()
      .. " "
      .. "%h"
      .. "%m"
      .. "%="
      .. "%y"
      .. " "
      .. "%l,%c "
      .. progress()
      .. " "
  end
end

vim.opt.statusline = "%{%v:lua.status_line()%}"

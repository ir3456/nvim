vim.api.nvim_create_augroup("AutoFormat", {})

vim.api.nvim_create_autocmd(
  "BufWritePost",
  {
    pattern = "*.py",
    group = "AutoFormat",
    callback = function()
      vim.cmd("let save_pos = getpos(\".\")")
      vim.cmd("silent !ruff format %")
      vim.cmd("silent !ruff check --fix --select I %")
      vim.cmd("edit")
      vim.cmd("call setpos('.', save_pos)")
    end,
  }
)
vim.api.nvim_create_autocmd(
  "BufWritePost",
  {
    pattern = "*.rs",
    group = "AutoFormat",
    callback = function()
      vim.cmd("let save_pos = getpos(\".\")")
      vim.cmd("silent !rustfmt %")
      vim.cmd("edit")
      vim.cmd("call setpos('.', save_pos)")
    end,
  }
)

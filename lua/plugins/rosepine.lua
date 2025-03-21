return {
    "rose-pine/neovim", name = "rose-pine",
    config = function()
      local nvim_theme = os.getenv("NVIM_THEME")
      if nvim_theme == "light" then
        require("rose-pine").setup({
          --- @usage 'auto'|'main'|'moon'|'dawn'
          variant = "dawn",
          styles = {
            italic = false,
          },
        })
      else
        require("rose-pine").setup({
          --- @usage 'auto'|'main'|'moon'|'dawn'
          variant = "main",
          styles = {
            italic = false,
            transparency = true,
          },

          dim_inactive_windows = false,
          extend_background_behind_borders = false,

          groups = {
            background = "#1b1b1b",
            panel = "#444444",
            panel_nc = "#181818", -- inactive bar color
            border = "#333333",
            comment = "#777777",
            link = "iris",
            punctuation = "subtle",

            error = "love",
            hint = "iris",
            info = "foam",
            warn = "#FF0000",
          },
          -- Change specific vim highlight groups
          -- https://github.com/rose-pine/neovim/wiki/Recipes
          highlight_groups = {
            ColorColumn = { bg = "#181818" },

            -- Blend colours against the "base" background
            CursorLine = { bg = "#2b2b2b", blend = 100 },
            StatusLine = { fg = "#BFD100", bg = "love", blend = 10 },

            -- By default each group adds to the existing config.
            -- If you only want to set what is written in this config exactly,
            -- you can set the inherit option:
            Search = { bg = "#666666", inherit = false },
          },
        })
      end
      vim.cmd("colorscheme rose-pine")
  end
  }

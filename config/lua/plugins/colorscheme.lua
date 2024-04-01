return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { fg = "#f8c8dc", italic = true },
      },
      on_colors = function(colors)
        -- the tokyonight red has no chill, use the red from nord.
        -- (it's a bit too pastel, but better than the default.)
        colors.error = "#bf616a"
        colors.red = "#bf616a"
        colors.red1 = "#bf616a"
      end,
    },
    priority = 1000,
    event = "VeryLazy",
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>uC", false },
    },
  },
}

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

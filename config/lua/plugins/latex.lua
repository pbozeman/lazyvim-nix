return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        tex = { "tex_fmt" },
        latex = { "tex_fmt" },
      },
      formatters = {
        tex_fmt = {
          command = "tex-fmt",
          args = { "--stdin" },
          stdin = true,
        },
      },
    },
  },
}
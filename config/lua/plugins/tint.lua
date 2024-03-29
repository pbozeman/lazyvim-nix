-- FIXME: this isn't working like it did pre-nix
return {
  {
    "levouh/tint.nvim",
    config = function()
      local tint = require("tint")
      tint.setup({
        -- Darken colors, use a positive value to brighten
        tint = -50,
        -- Saturation to preserve
        saturation = 0.6,
        -- Showing default behavior, but value here can be predefined set of transforms
        transforms = require("tint").transforms.SATURATE_TINT,
        -- Tint background portions of highlight groups
        tint_background_colors = false,
      })
    end,
  },
}

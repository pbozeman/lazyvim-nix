return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  opts = function(_, opts)
    -- Remove datetime from all sections
    for section_name, section in pairs(opts.sections or {}) do
      if type(section) == "table" then
        local new_section = {}
        for _, component in ipairs(section) do
          if type(component) == "string" and component ~= "datetime" then
            table.insert(new_section, component)
          elseif type(component) == "table" and component[1] ~= "datetime" then
            table.insert(new_section, component)
          end
        end
        opts.sections[section_name] = new_section
      end
    end

    if not vim.g.trouble_lualine then
      table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
    end
  end,
}

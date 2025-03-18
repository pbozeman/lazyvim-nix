-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.v", "*.sv" },
  callback = function()
    -- Strip trailing whitespace in the current buffer. Verilator doesn't do this for comments
    vim.cmd([[%s/\s\+$//e]])

    local file = vim.fn.expand("<afile>")
    vim.cmd(
      '!verible-verilog-format --inplace --tryfromenv="indentation_spaces,column_limit,wrap_spaces,try_wrap_long_lines,assignment_statement_alignment,case_items_alignment,class_member_variable_alignment,distribution_items_alignment,enum_assignment_statement_alignment,formal_parameters_alignment,formal_parameters_indentation,module_net_variable_alignment,named_parameter_alignment,named_port_alignment,port_declarations_alignment,port_declarations_indentation,struct_union_members_alignment,wrap_end_else_clauses" '
        .. file
    )
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- Disable formatting for these file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp.j2", "java" },
  callback = function()
    vim.b.autoformat = false
  end,
})

local M = {}

M.defaults = {
  position = "bottom_right",
  offset_x = 2,
  offset_y = 1,
  format = "[%s/%s]",
  wrap_message = nil,
  highlight = "Search",
  auto_hide = true,
  enabled = true,
}

M.options = {}

function M.setup(user_config)
  M.options = vim.tbl_deep_extend("force", M.defaults, user_config or {})
end

return M

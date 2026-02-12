local M = {}

M.win_id = nil
M.buf_id = nil

function M.close()
  if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
    vim.api.nvim_win_close(M.win_id, true)
  end
  M.win_id = nil
  M.buf_id = nil
end

function M.get_position(position, offset_x, offset_y)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]
  
  local win_line = vim.fn.winline()
  local win_col = vim.fn.wincol()
  
  local anchor = "NW"
  local rel_row = 0
  local rel_col = 0
  
  if position == "bottom_right" then
    anchor = "NW"
    rel_row = offset_y
    rel_col = offset_x
  elseif position == "bottom_left" then
    anchor = "NE"
    rel_row = offset_y
    rel_col = -offset_x
  elseif position == "top_right" then
    anchor = "SW"
    rel_row = -offset_y
    rel_col = offset_x
  elseif position == "top_left" then
    anchor = "SE"
    rel_row = -offset_y
    rel_col = -offset_x
  elseif position == "above" then
    anchor = "SW"
    rel_row = -offset_y
    rel_col = 0
  elseif position == "below" then
    anchor = "NW"
    rel_row = offset_y
    rel_col = 0
  end
  
  return {
    relative = "cursor",
    anchor = anchor,
    row = rel_row,
    col = rel_col,
  }
end

function M.create_or_update(text, config)
  if not M.buf_id or not vim.api.nvim_buf_is_valid(M.buf_id) then
    M.buf_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(M.buf_id, "bufhidden", "wipe")
  end
  
  vim.api.nvim_buf_set_lines(M.buf_id, 0, -1, false, { text })
  
  local width = #text
  local height = 1
  
  local win_config = M.get_position(config.position, config.offset_x, config.offset_y)
  win_config.width = width
  win_config.height = height
  win_config.style = "minimal"
  win_config.border = "none"
  win_config.focusable = false
  win_config.zindex = 50
  
  if M.win_id and vim.api.nvim_win_is_valid(M.win_id) then
    vim.api.nvim_win_set_config(M.win_id, win_config)
  else
    M.win_id = vim.api.nvim_open_win(M.buf_id, false, win_config)
    vim.api.nvim_win_set_option(M.win_id, "winblend", 0)
    vim.api.nvim_win_set_option(M.win_id, "winhighlight", "Normal:" .. config.highlight)
  end
end

return M

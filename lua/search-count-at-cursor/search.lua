local popup = require("search-count-at-cursor.popup")
local config = require("search-count-at-cursor.config")

local M = {}

M.last_count_info = nil

function M.get_search_count()
  local ok, result = pcall(vim.fn.searchcount, { recompute = 1, maxcount = -1 })
  if not ok or not result or result.total == 0 then
    return nil
  end
  return result
end

function M.is_cursor_on_match()
  local search_pattern = vim.fn.getreg("/")
  if search_pattern == "" then
    return false
  end
  
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local col = cursor[2]
  
  local ok, match_col = pcall(vim.fn.match, line, search_pattern)
  if not ok then
    return false
  end
  
  while match_col >= 0 do
    local match_end = vim.fn.matchend(line, search_pattern, match_col)
    if col >= match_col and col < match_end then
      return true
    end
    match_col = vim.fn.match(line, search_pattern, match_end)
  end
  
  return false
end

function M.format_count(count_info)
  local opts = config.options
  local current = count_info.current
  local total = count_info.total
  
  if count_info.incomplete == 1 then
    return string.format(opts.format, "?", "?")
  end
  
  local text = string.format(opts.format, current, total)
  
  if opts.wrap_message and M.last_count_info then
    if current == 1 and M.last_count_info.current > 1 then
      text = text .. " " .. opts.wrap_message
    elseif current == total and M.last_count_info.current < total then
      text = text .. " " .. opts.wrap_message
    end
  end
  
  return text
end

function M.update_popup()
  if not config.options.enabled then
    popup.close()
    return
  end
  
  local search_pattern = vim.fn.getreg("/")
  if search_pattern == "" then
    popup.close()
    return
  end
  
  if not M.is_cursor_on_match() then
    popup.close()
    return
  end
  
  local count_info = M.get_search_count()
  if not count_info then
    popup.close()
    return
  end
  
  local text = M.format_count(count_info)
  popup.create_or_update(text, config.options)
  
  M.last_count_info = count_info
end

return M

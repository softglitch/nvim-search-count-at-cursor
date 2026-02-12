local config = require("search-count-at-cursor.config")
local search = require("search-count-at-cursor.search")
local popup = require("search-count-at-cursor.popup")

local M = {}

local augroup = nil

function M.setup(user_config)
  config.setup(user_config)
  
  if augroup then
    vim.api.nvim_del_augroup_by_id(augroup)
  end
  
  augroup = vim.api.nvim_create_augroup("SearchCountAtCursor", { clear = true })
  
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = augroup,
    pattern = { "/", "?" },
    callback = function()
      vim.defer_fn(function()
        search.update_popup()
      end, 50)
    end,
  })
  
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = augroup,
    callback = function()
      search.update_popup()
    end,
  })
  
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = augroup,
    callback = function()
      popup.close()
    end,
  })
  
  local function setup_search_mapping(key)
    vim.keymap.set("n", key, function()
      vim.cmd("normal! " .. key)
      vim.defer_fn(function()
        search.update_popup()
      end, 50)
    end, { silent = true })
  end
  
  setup_search_mapping("n")
  setup_search_mapping("N")
  setup_search_mapping("*")
  setup_search_mapping("#")
  setup_search_mapping("g*")
  setup_search_mapping("g#")
end

function M.toggle()
  config.options.enabled = not config.options.enabled
  if not config.options.enabled then
    popup.close()
  else
    search.update_popup()
  end
end

function M.enable()
  config.options.enabled = true
  search.update_popup()
end

function M.disable()
  config.options.enabled = false
  popup.close()
end

return M

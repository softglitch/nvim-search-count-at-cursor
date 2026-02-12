# nvim-search-count-at-cursor

A Neovim plugin that displays search count in a floating window at your cursor instead of the bottom corner, making it easier to track search progress and notice when searches wrap around.

## Features

- Shows `[x/y]` search count in a floating window near your cursor
- Supports all search types: `/`, `?`, `*`, `#`, `n`, `N`, `g*`, `g#`
- Fully configurable position and styling
- Optional wrap indicator when search loops around
- Auto-hides when cursor moves away from matches

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'softglitch/nvim-search-count-at-cursor',
  config = true, -- Runs setup() with default options
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'softglitch/nvim-search-count-at-cursor',
  config = function()
    require('search-count-at-cursor').setup()
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'softglitch/nvim-search-count-at-cursor'
```

Then in your `init.lua`:
```lua
require('search-count-at-cursor').setup()
```

## Usage

The plugin works automatically once installed. Simply search as you normally would:

- `/pattern` - Forward search
- `?pattern` - Backward search
- `*` - Search word under cursor forward
- `#` - Search word under cursor backward
- `n` - Next match
- `N` - Previous match

The search count popup will appear near your cursor showing `[current/total]`.

### Example

Search for a word with `/test`, then press `n` to navigate. The popup `[2/5]` appears at your cursor and follows you as you navigate through matches. Move your cursor away with `j` or `h`, and the popup disappears.

## Configuration

You can customize the behavior by passing options to the `setup` function.

```lua
require('search-count-at-cursor').setup({
  -- Position relative to cursor
  -- Options: "bottom_right", "bottom_left", "top_right", "top_left", "above", "below"
  position = "bottom_right",
  
  -- Offset from cursor position
  offset_x = 2,
  offset_y = 1,
  
  -- Display format (%s = current match, %s = total matches)
  format = "[%s/%s]",
  
  -- Optional wrap indicator message (shown when search wraps around)
  -- Set to nil to disable, or use "↻", "(wrapped)", etc.
  wrap_message = nil,
  
  -- Highlight group for the popup
  highlight = "Search",
  
  -- Auto-hide popup when cursor moves away from matches
  auto_hide = true,
  
  -- Enable/disable plugin
  enabled = true,
})
```

### Commands

```lua
-- Toggle plugin on/off
require('search-count-at-cursor').toggle()

-- Enable plugin
require('search-count-at-cursor').enable()

-- Disable plugin
require('search-count-at-cursor').disable()
```

### Keybinding Example

```lua
vim.keymap.set('n', '<leader>st', function()
  require('search-count-at-cursor').toggle()
end, { desc = 'Toggle search count at cursor' })
```

## Requirements

- Neovim >= 0.7.0

## License

GLWTS

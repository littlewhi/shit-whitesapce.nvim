# Intro
This is a simple plugin which is real shit for trailing whitespace.
The current features:
1. highlight the trailing whitespaces
2. delete the trailing whitespaces
3. not yet

# Install
Like other nvim plugins.

# Usage
After installment, it needs to use require("shit-whitespace").setup({}) to config it.

# Config
Default config:
```lua
{
	-- if true, enable trailing whitespaces highlight when WinNew event up
	enable_highlight = false,
	-- if true, enable automatic deletion when BufWritePre event up
	enable_auto_delete = true,
	-- if true, enable the default keymap of the plugin
	enable_keymap = true,
	-- set the trailing whitespace color
	-- I like yellow, so I set it as the default
	-- You could set it as the nvim way:
	-- 1. color name: red yellow green ...
	-- 2. number format1: #RRGGBB
	-- 3. number format2: rgb{ number1, number2, number3 }
	-- Note: put the color in '' or ""
	-- Please look :h cterm-colors, :h gui-colors
	ws_color = "yellow",
}
```
# Command
Default command:  
`ShitWSDelete`: Delete trailing whitespaces and allow the line address, like %ShitWSDelete, 1,2ShitWSDelete ...  
`ShitWSHighlight`: Enable highlight trailing whitespaces in current window  
`ShitWSNoHighlight`: Disable highlight trailing whitespaces in current window  
`ShitWSToggleHighlight`: Toggle highlight trailing whitespaces in current window  

# Map
| lhs                | rhs              | meaning                                  | mode   |
| :---:              | :---:            | :---:                                    | :---:  |
| \<leader>d\<Space> | ShitWSDelete<CR> | delete current line trailing whitespaces | normal |
| \<leader>h\<Space> | ShitWSToggle<CR> | toggle highlight trailing whitespaces    | normal |

# Note
This is simple and little plugin.

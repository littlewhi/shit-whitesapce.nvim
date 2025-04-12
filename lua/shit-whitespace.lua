local M = {
	config = {
		enable_highlight = false,
		enable_auto_delete = true,
		enable_auto_delte_exist = true,
		enable_keymap = true,
		ws_color = "yellow",
	},
}
-- In setup, it will rewrite it by M.config.ws_color
vim.api.nvim_set_hl(0, "ShitHITrailingWhiteSpace", { ctermbg = "yellow", bg = "yellow", force = true })

local group = vim.api.nvim_create_augroup("ShitTrailingWhiteSpace", { clear = true })

function M.ShitDeleteTrailingWhiteSpace(params)
	local prestr = ""
	local pos = vim.api.nvim_win_get_cursor(0)
	if params.range == 1 then
		prestr = string.format("%d", params.line1)
	elseif params.range == 2 then
		prestr = string.format("%d", params.line1) .. "," .. string.format("%d", params.line2)
	end
	vim.cmd("keepjumps " .. prestr .. "s/\\s\\+$//e")
	vim.api.nvim_win_set_cursor(0, pos)
end

function M.EnableHighlightWin()
	vim.w.ShitWS_state = true
	vim.cmd("match ShitHITrailingWhiteSpace /\\s\\+$/")
end

function M.DisableHighlightWin()
	vim.w.ShitWS_state = false
	vim.cmd("match ShitHITrailingWhiteSpace //")
end

function M.ToggleHighlightWin()
	local res = pcall(vim.api.nvim_win_get_var, 0, "ShitWS_state")
	if res then
		if vim.w.ShitWS_state then
			M.DisableHighlightWin()
			vim.w.ShitWS_state = false
		else
			M.EnableHighlightWin()
			vim.w.ShitWS_state = true
		end
	elseif vim.g.ShitWS_state then
		vim.w.ShitWS_state = false
		M.DisableHighlightWin()
	else
		vim.w.ShitWS_state = true
		M.EnableHighlightWin()
	end
end

function M.EnableAutodelWin()
	vim.w.ShitWS_autodel = true
end

function M.DisableAutodelWin()
	vim.w.ShitWS_autodel = false
end

vim.api.nvim_create_user_command(
	"ShitWSDelete",
	M.ShitDeleteTrailingWhiteSpace,
	{ desc = "shit-whitespace delete trailing whitespace", range = 2 }
)
vim.api.nvim_create_user_command(
	"ShitWSHighlight",
	M.EnableHighlightWin,
	{ desc = "shit-whitespace start highlight trailing whitespace in current window" }
)
vim.api.nvim_create_user_command(
	"ShitWSNoHighlight",
	M.DisableHighlightWin,
	{ desc = "shit-whitespace close highlight trailing whitespace in current window" }
)
vim.api.nvim_create_user_command(
	"ShitWSToggleHighlight",
	M.ToggleHighlightWin,
	{ desc = "shit-whitespace toggle highlight trailing whitespace in current window" }
)
vim.api.nvim_create_user_command(
	"ShitWSEnableAutodel",
	M.EnableAutodelWin,
	{ desc = "shit-whitespace enable auto-delete trailing whitespace in current window" }
)
vim.api.nvim_create_user_command(
	"ShitWSDisableAutodel",
	M.DisableAutodelWin,
	{ desc = "shit-whitespace disable auto-delete trailing whitespace in current window" }
)

function M.setup(config)
	for k, v in pairs(config) do
		M.config[k] = v
	end

	vim.g.ShitWS_state = M.config.enable_highlight
	if M.config.enable_highlight then
		vim.api.nvim_create_autocmd("WinNew", {
			desc = "shit highlight the trailing whtespace",
			group = group,
			pattern = "*",
			callback = function()
				local res, val = pcall(vim.api.nvim_win_get_var, 0, "ShitWS_state")
				if res then
					if val then
						vim.cmd("match ShitHITrailingWhiteSpace /\\s\\+$/")
					end
				elseif vim.g.ShitWS_state then
					vim.cmd("match ShitHITrailingWhiteSpace /\\s\\+$/")
				end
			end,
		})
		M.EnableHighlightWin()
	end

	-- Because highlight can be triggered just by match command,
	-- but the auto-delete realy needs the autocmd to up.
	-- So the autocmd control method is different.
	vim.g.ShitWS_autodel = M.config.enable_auto_delete
	if M.config.enable_auto_delte_exist then
		vim.api.nvim_create_autocmd("BufWritePre", {
			desc = "shit delete the trailing whitespace",
			group = group,
			pattern = "*",
			callback = function()
				local res, val = pcall(vim.api.nvim_win_get_var, 0, "ShitWS_autodel")
				if res then
					if val then
						vim.cmd("%ShitWSDelete")
					end
				elseif vim.g.ShitWS_autodel then
					vim.cmd("%ShitWSDelete")
				end
			end,
		})
	end
	vim.api.nvim_set_hl(
		0,
		"ShitHITrailingWhiteSpace",
		{ ctermbg = M.config.ws_color, bg = M.config.ws_color, force = true }
	)
	if M.config.enable_keymap then
		vim.keymap.set(
			{ "n" },
			"<leader>d ",
			"<Cmd>ShitWSDelete<cr>",
			{ desc = "shit-whitespace delete trailing whitespaces", noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n" },
			"<leader>h ",
			"<Cmd>ShitWSToggleHighlight<cr>",
			{ desc = "shit-whitespace highlight trailing whitespace", noremap = true, silent = true }
		)
		vim.keymap.set(
			{"n"},
			"<leader>  ",
			"<Cmd>%ShitWSDelete<cr>",
			{ desc = "shit-whitespace delete trailing whitespaces" }
		)
	end
end

return M

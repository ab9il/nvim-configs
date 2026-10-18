-- Create/get autocommand group
local augroup = vim.api.nvim_create_augroup
-- Create autocommand
local autocmd = vim.api.nvim_create_autocmd
-- remove trailing whitespaces
autocmd("BufWritePre", {
	pattern = "*",
	command = ":%s/\\s\\+$//e",
})
-- Run xrdb whenever Xdefaults or Xresources are updated.
autocmd("BufWritePost", {
	pattern = "X{resources,defaults}",
	command = ":silent !xrdb %",
})
-- Update binds when sxhkdrc is updated.
autocmd("BufWritePost", {
	pattern = "*sxhkdrc",
	command = ":!pkill -USR1 sxhkd",
})
-- Set filetype syntax and behavior
autocmd({ "BufNewFile", "BufRead" }, {
	pattern = {
		"*.markdown",
		"*.mdown",
		"*.mkd",
		"*.mdwn",
		"*.md",
		"*-outline",
		"*-manuscript",
	},
	command = "set ft=markdown wrap linebreak nolist",
})
local ns_id = vim.api.nvim_create_namespace("vh_markdown_headers")
local function check_markdown_line_extmark(bufnum, linenum, linestr)
	if linestr:match("^#") then
		vim.api.nvim_buf_set_extmark(bufnum, ns_id, linenum, 0, {
			virt_lines = { {} },
			virt_lines_above = true,
		})
	elseif linestr:match("^- ") or linestr:match("^[ ]*- ") then
		vim.api.nvim_buf_set_extmark(bufnum, ns_id, linenum, 0, {
			virt_text = { { " ", "" } },
			virt_text_pos = "inline",
			-- sign_text = "a"
		})
	end
end
autocmd("Filetype", {
	pattern = "markdown",
	callback = function(args)
		vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

		local lines = vim.api.nvim_buf_get_lines(args.buf, 1, -1, false)
		for i, line in ipairs(lines) do
			check_markdown_line_extmark(args.buf, i, line)
		end
	end,
})
autocmd({ "TextChanged", "InsertLeave" }, {
	pattern = {
		"*.markdown",
		"*.mdown",
		"*.mkd",
		"*.mdwn",
		"*.md",
		"*-outline",
		"*-manuscript",
	},
	callback = function(args)
		local curlinenum = vim.api.nvim_win_get_cursor(0)[1]
		vim.api.nvim_buf_clear_namespace(0, ns_id, curlinenum - 1, curlinenum)

		check_markdown_line_extmark(args.buf, curlinenum - 1, vim.fn.getline("."))
	end,
})
autocmd({ "BufNewFile", "BufRead" }, {
	pattern = {
		"*.txt",
		"*.text",
	},
	command = "set ft=text wrap linebreak nolist",
})
autocmd({ "BufNewFile", "BufRead" }, {
	pattern = {
		"*.htm",
		"*.html",
	},
	command = "filetype plugin indent on",
})
autocmd({ "BufNewFile", "BufRead" }, {
	pattern = {
		"conf",
		"config",
		"*.conf",
		"*rc",
		"*.rc",
		"*.strm",
		"*.xspf",
		"*.log",
	},
	command = "set ft=config",
})
-- custom highlight on yank
local function set_yank_highlight()
    vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#9CE342", default = true })
end
set_yank_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_yank_highlight,
})
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.hl_op({ higroup = "YankHighlight", timeout = 200 })
    end,
})

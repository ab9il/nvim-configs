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

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})


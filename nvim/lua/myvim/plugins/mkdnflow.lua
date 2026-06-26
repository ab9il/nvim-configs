return {
	"jakewvincent/mkdnflow.nvim",
	-- Markdown note taking tool
	ft = { "markdown", "md" },
	config = function()
		require("mkdnflow").setup({
			mappings = {
				MkdnNextLink = false,
				MkdnPrevLink = false,
			},
		})
	end,
}

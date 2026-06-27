return {
    {
        "mason-org/mason.nvim",
        config = true,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "lua_ls",
                    "pyright",
                    "ruff",
                    "ts_ls",
                },
                -- Optional: Auto-attach LSPs
                handlers = {
                    function(server_name)
                        require("mason-lspconfig").default_handlers(server_name)
                    end,
                },
            })
        end,
    },
}

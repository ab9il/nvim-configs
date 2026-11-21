return {
    "neovim/nvim-lspconfig",
    opts = {},
    config = function()
        -- Assign the diagnostic signs using vim.diagnostic.config()
        vim.diagnostic.config({
            virtual_text = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.HINT] = "",
                    [vim.diagnostic.severity.INFO] = "",
                },
            },
            update_in_insert = false,
            underline = true,
            severity_sort = true,
        })
        vim.lsp.config("harper_ls", {
            settings = {
                ["harper-ls"] = {
                    userDictPath = "~/.config/harper-ls/dict.txt",
                    linters = {
                        SentenceCapitalization = false,
                        SpellCheck = false,
                    },
                },
            },
        })
        vim.lsp.config("ts_ls", {
            settings = {
                typescript = {
                    inlayHints = { includeInlayParameterNameHints = "all" },
                },
                javascript = {
                    inlayHints = { includeInlayParameterNameHints = "all" },
                },
            },
        })
        vim.lsp.enable({ "bashls", "harper_ls", "lua_ls", "markdown_oxide", "pyright", "taplo", "ts_ls", "yamlls" })
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if client ~= nil and client:supports_method("textDocument/completion") then
                    vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
                end
            end,
        })
    end,
}

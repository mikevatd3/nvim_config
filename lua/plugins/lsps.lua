vim.lsp.config["lua_ls"] = { -- For lua
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

vim.lsp.config["pyright"] = {}
vim.lsp.enable("pyright")

vim.lsp.config["r_language_server"] = {}
vim.lsp.enable("r_language_server")

vim.lsp.config["julials"] = {}
vim.lsp.enable("julials")


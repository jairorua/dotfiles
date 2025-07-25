-- Install servers that we need
return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- These are the LSP servers that mason-lspconfig will ensure are installed.
		-- Mason-lspconfig will then automatically setup most of them with nvim-lspconfig.
		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"pyright",
				"gopls",
				"templ",
				"html",
				"cssls",
				"ts_ls",
				"julials",
				"clangd",
				"tailwindcss",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
			},
			-- Auto-install configured servers (with mason)
			automatic_installation = true,
		})

		-- These are other tools (linters, formatters)
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
				"eslint_d",
				"gofumpt", -- go formatter
				"templ",
			},
			auto_update = true,
			run_on_start = true,
		})
	end,
}

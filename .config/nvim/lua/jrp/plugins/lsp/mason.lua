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
				"html",
				"cssls",
				"vtsls",
				"pyright",
				"gopls",
				"templ",
				"lua_ls",
			},
			-- Auto-install configured servers (with mason)
			automatic_installation = false,
		})

		-- These are other tools (linters, formatters)
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"ruff", -- python formatter
				"eslint_d",
				"gofumpt", -- go formatter
				"templ",
			},
			auto_update = true,
			run_on_start = true,
		})
	end,
}

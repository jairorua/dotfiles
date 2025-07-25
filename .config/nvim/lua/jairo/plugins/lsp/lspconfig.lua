return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local mason_lspconfig = require("mason-lspconfig")

		local keymap = vim.keymap -- for conciseness

		-- Ensure templ filetype is recognized early
		vim.filetype.add({
			extension = {
				templ = "templ",
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1 })
				end, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1 })
				end, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Configure diagnostic symbols in the sign column (gutter)
		vim.diagnostic.config({
			-- Enable signs in the gutter
			signs = {
				active = signs,
				-- You can also specify custom signs here if needed, but the default
				-- icons provided by Neovim or your theme are often good.
				-- Customize them:
				text = {
					[vim.diagnostic.severity.ERROR] = "", -- Error icon
					[vim.diagnostic.severity.WARN] = "", -- Warning icon
					[vim.diagnostic.severity.HINT] = "󰠠", -- Hint icon
					[vim.diagnostic.severity.INFO] = "", -- Info icon
				},
				-- Define highlight groups for these signs
				-- e.g., numhl, linehl, texthl, culhl
				texthl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticError",
					[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
				},
			},
			virtual_text = true, -- Show virtual text diagnostics (inline)
			underline = true, -- Underline diagnostics
			update_in_insert = false, -- Don't update diagnostics while in insert mode (can be distracting)
			severity_sort = true, -- Sort diagnostics by severity
		})

		mason_lspconfig.setup({
			handlers = {
				-- default handler for installed servers
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["pyright"] = function()
					lspconfig["pyright"].setup({
						capabilities = capabilities,
						filetypes = { "python" },
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "basic", -- Adjust this to "strict" for stricter checks
									autoImportCompletions = true,
									useLibraryCodeForTypes = true,
									diagnosticMode = "workspace", -- Can be set to "openFilesOnly" if needed
								},
							},
						},
					})
				end,

				["lua_ls"] = function()
					-- configure lua server (with special settings)
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								-- make the language server recognize "vim" global
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,

				-- Configure gopls for Templ support
				["gopls"] = function()
					lspconfig.gopls.setup({
						capabilities = capabilities,
						settings = {
							gopls = {
								-- Enable experimental support for templ files
								["experimentalFeatures"] = {
									templateExtensions = true,
								},
								-- This is often crucial for gopls to correctly analyze projects using templ
								buildFlags = { "-tags=templ_generated" },
								-- Optional: configure gopls to use gofumpt if you prefer it over goimports/gofmt
								-- ["formatting.gofumpt"] = true, -- Or however gopls exposes this, check gopls docs
								analyses = {
									unusedparams = true,
									shadow = true,
									fieldalignment = true,
									unusedwrite = true,
								},
								staticcheck = true,
							},
						},
						-- Crucial: Tell gopls to also attach to .templ files
						-- filetypes = { "go", "gomod", "gosum", "gowork", "templ" },
						filetypes = { "go", "gomod", "gosum", "gowork" },
					})
				end,

				-- Configure the dedicated templ LSP
				["templ"] = function()
					lspconfig.templ.setup({
						capabilities = capabilities,
						filetypes = { "templ" },
					})
				end,

				["ts_ls"] = function()
					lspconfig.ts_ls.setup({
						capabilities = capabilities,
						filetypes = {
							"javascript",
							"javascriptreact",
							"javascript.jsx",
							"typescript",
							"typescriptreact",
							"typescript.tsx",
						},
						-- Add any tsserver specific settings here
					})
				end,
			},
		})
	end,
}

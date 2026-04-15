-- return {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	branch = "master",
-- 	event = { "BufReadPost", "BufNewFile" },
-- 	build = ":TSUpdate",
-- 	dependencies = {
-- 		"windwp/nvim-ts-autotag",
-- 	},
-- 	config = function()
-- 		-- Setup autotag independently of treesitter
-- 		require("nvim-ts-autotag").setup()
--
-- 		local treesitter = require("nvim-treesitter.configs")
--
-- 		-- Configure treesitter
-- 		treesitter.setup({
-- 			-- Enable syntax highlighting
-- 			highlight = {
-- 				enable = true,
-- 			},
-- 			-- Enable indentation
-- 			indent = { enable = true },
--
-- 			-- autotag = { enable = true }, <-- REMOVE THIS LINE
--
-- 			-- Ensure these language parsers are installed
-- 			ensure_installed = {
-- 				"python",
-- 				"cpp",
-- 				"csv",
-- 				"go",
-- 				"gomod",
-- 				"gosum",
-- 				"gowork",
-- 				"julia",
-- 				"json",
-- 				"javascript",
-- 				"typescript",
-- 				"tsx",
-- 				"yaml",
-- 				"html",
-- 				"css",
-- 				"markdown",
-- 				"markdown_inline",
-- 				"graphql",
-- 				"bash",
-- 				"lua",
-- 				"vim",
-- 				"dockerfile",
-- 				"gitignore",
-- 				"query",
-- 				"vimdoc",
-- 				"c",
-- 				"sql",
-- 				"templ",
-- 			},
-- 			-- Auto-install missing parsers when entering buffer
-- 			auto_install = true,
-- 			incremental_selection = {
-- 				enable = true,
-- 				keymaps = {
-- 					init_selection = "<C-space>",
-- 					node_incremental = "<C-space>",
-- 					scope_incremental = false,
-- 					node_decremental = "<bs>",
-- 				},
-- 			},
-- 		})
-- 	end,
-- }

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- Setup autotag (the new version handles itself)
		require("nvim-ts-autotag").setup()

		local ts = require("nvim-treesitter")

		-- New setup call (module has changed)
		ts.setup({
			-- Options like 'highlight' and 'indent' are no longer
			-- passed here in the same way.
		})

		local languages = {
			"python",
			"cpp",
			"csv",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"julia",
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"vimdoc",
			"c",
			"sql",
			"templ",
		}

		-- Install parsers manually or via this API call
		ts.install(languages)

		-- CRITICAL: Manual activation via Autocmd
		-- In Nvim 0.12, the plugin doesn't auto-start highlighting.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = languages,
			callback = function()
				-- Start the native Neovim treesitter highlighter
				vim.treesitter.start()
				-- Set the treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}

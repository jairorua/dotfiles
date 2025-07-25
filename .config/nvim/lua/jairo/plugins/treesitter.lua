return {
	"nvim-treesitter/nvim-treesitter",
	-- event = { "BufReadPre", "BufNewFile" },
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		-- Configure treesitter
		treesitter.setup({
			-- Enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- Enable indentation
			indent = { enable = true },
			-- Enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- Ensure these language parsers are installed
			ensure_installed = {
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
			},
			-- Auto-install missing parsers when entering buffer
			auto_install = true,
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}

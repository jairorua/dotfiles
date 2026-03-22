-- Forcing synchronous parsing to debug Treesitter async race condition.
-- This is a workaround based on Neovim 0.11 breaking changes.
vim.g._ts_force_sync_parsing = true

require("jrp.core.options")
require("jrp.core.keymaps")

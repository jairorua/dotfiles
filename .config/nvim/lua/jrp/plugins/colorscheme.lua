return {
        'sainnhe/sonokai',
        lazy = false,
        priority = 1000,
        config = function()
                -- Optionally configure and load the colorscheme
                vim.g.sonokai_style = 'maia' -- other options: 'default', 'atlantis', 'andromeda', 'maia', 'espresso'               -- directly inside the plugin declaration.
                vim.g.sonokai_enable_italic = true
                vim.cmd.colorscheme('sonokai')
        end
}

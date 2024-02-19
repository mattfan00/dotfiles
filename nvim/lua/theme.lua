vim.opt.termguicolors = true

require('rose-pine').setup({
    dark_variant = 'moon',
    styles = {
        bold = false,
        italic = false,
        transparency = true,
    },
})

vim.cmd("colorscheme rose-pine")

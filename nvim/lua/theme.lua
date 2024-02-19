vim.opt.termguicolors = true

require('rose-pine').setup({
    disable_italics = true,
    dark_variant = 'moon',
    styles = {
        transparency = true,
    },
})

vim.cmd("colorscheme rose-pine")

vim.opt.termguicolors = true
vim.opt.background = "dark"

require('rose-pine').setup({
    styles = {
        bold = false,
        italic = false,
        transparency = true,
    },
})

require("github-theme").setup({
    options = {
        hide_nc_statusline = false,
        transparent = true,
    }
})

require("no-clown-fiesta").setup({
    transparent = true,
    styles = {
        type = { bold = false },
    },
})

vim.cmd("colorscheme rose-pine")
--vim.cmd("colorscheme github_dark_high_contrast")
--vim.cmd("colorscheme no-clown-fiesta")

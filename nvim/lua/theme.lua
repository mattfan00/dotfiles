vim.opt.termguicolors = true

require('github-theme').setup({
    groups = {
        github_light_high_contrast = {
            StatusLineNC = { fg = "fg1", bg = "bg2" }
        },
    }
})

require('rose-pine').setup({
    disable_background = true,
    disable_italics = true,
    dark_variant = 'moon',
})

require('gruvbox').setup({
    bold = false,
    italic = {
        strings = false,
        emphasis = false,
        comments = false,
    },
    contrast = "hard",
})

local function dark()
    vim.cmd("colorscheme rose-pine")
    --vim.cmd("colorscheme github_dark_high_contrast")
    --vim.cmd("colorscheme kanagawa")
end

local function light()
    vim.o.background = "light"
    vim.cmd("colorscheme github_light_high_contrast")
end

dark()

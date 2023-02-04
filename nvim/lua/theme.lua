vim.opt.termguicolors = true

local function dark()
    vim.o.background = "dark"
    vim.g.monotone_color = {51, 33, 74}
    vim.cmd("colorscheme monotone")
    vim.cmd("hi CursorLine guifg=none guibg=#282828")
    vim.cmd("hi ColorColumn guifg=none guibg=#282828")
end

local function light()
    vim.o.background = "light"

    vim.cmd("colorscheme paper")
end

dark()

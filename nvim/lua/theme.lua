vim.opt.termguicolors = true

local function dark()
    vim.cmd("colorscheme hugo")
end

local function light()
    vim.o.background = "light"
    vim.cmd("colorscheme paper")
end

dark()

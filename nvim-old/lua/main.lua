local autocmd = vim.api.nvim_create_autocmd

vim.g.editorconfig = false

vim.g.mapleader = " "

vim.opt.guicursor = ""
vim.opt.cul = true -- cursorline
-- remove cursorline to indicate insert mode 
autocmd("InsertEnter", {
    pattern = "*",
    callback = function() vim.opt.cul = false end
})
autocmd("InsertLeave", {
    pattern = "*",
    callback = function() vim.opt.cul = true end
})

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.signcolumn = "number"

vim.opt.colorcolumn = "80"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.keymap.set("n", "<leader>h", ":wincmd h<CR>")
vim.keymap.set("n", "<leader>j", ":wincmd j<CR>")
vim.keymap.set("n", "<leader>k", ":wincmd k<CR>")
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>a", "<C-^>") -- switch to alternate (previous) file
vim.keymap.set("n", "<leader>o", "<C-W><C-O>") -- :only (close all windows but the current one)

-- keep cursor in middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- dont replace buffer when pasting over
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank into system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- restart LSP, useful for after go get)
vim.keymap.set("n", "<leader>lr", function()
    vim.cmd("LspRestart")
    print("Restarted LSP")
end)

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})

-- fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gw", vim.cmd.Gwrite) -- git add

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>ha", function()
    mark.add_file()
    print("Added harpoon mark")
end)
vim.keymap.set("n", "<C-h>", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)


-- format go files on save
autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function() vim.lsp.buf.format { async = true } end
})

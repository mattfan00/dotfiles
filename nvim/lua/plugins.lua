-- Install packer automatically
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    use "ellisonleao/gruvbox.nvim"

    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.0",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

    use {
        "nvim-treesitter/nvim-treesitter", 
        run = ":TSUpdate"
    }

    if packer_bootstrap then
        require("packer").sync()
    end
end)

require("gruvbox").setup({
    italic = false,
    contrast = "hard",
})
vim.o.background = "dark"
vim.cmd("colorscheme gruvbox")

require("nvim-treesitter.configs").setup {
    -- A list of parser names, or "all"
    ensure_installed = { 
        "lua", 
        "help",
        "javascript",
        "typescript",
        "go",
        "vim",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

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
    use { "catppuccin/nvim", as = "catppuccin" }
    use "rebelot/kanagawa.nvim"
    use "savq/melange-nvim"
    use "yorickpeterse/vim-paper"
    use "Lokaltog/vim-monotone"
    use "aktersnurra/no-clown-fiesta.nvim"
    use { "rose-pine/neovim", as = "rose-pine" }

    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.0",
        requires = { {"nvim-lua/plenary.nvim"} }
    }
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }
    use "tpope/vim-fugitive"
    use {
        "VonHeikemen/lsp-zero.nvim",
        requires = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-nvim-lua"},

            -- Snippets
            {"L3MON4D3/LuaSnip"},
            {"rafamadriz/friendly-snippets"},
        }
    }
    use "cohama/lexima.vim"

    if packer_bootstrap then
        require("packer").sync()
    end
end)

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
    -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- mason.nvim to install and manage LSPs
-- :MasonInstall <arg>
-- lsp-config add LSPs to nvim
-- nvim-cmp for autocompletion
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  "tsserver",
  "eslint",
  "lua_ls",
  "gopls",
})

lsp.configure("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                -- fix undefined global "vim"
                globals = { "vim" }
            }
        }
    }
})

lsp.configure("cssls", {
    settings = {
        css = {
            lint = {
                -- for tailwind
	            unknownAtRules = "ignore"
	        }
        }
    }
})

lsp.configure("gdscript", {
    force_setup = true -- because LSP is global
})

local cmp = require("cmp")

lsp.setup_nvim_cmp({
    mapping = lsp.defaults.cmp_mappings({
        ["<Tab>"] = cmp.mapping.confirm({select = false}),
        ["<S-Tab>"] = vim.NIL,
        ["<CR>"] = vim.NIL,
    })
})

lsp.setup()

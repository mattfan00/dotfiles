local autocmd = vim.api.nvim_create_autocmd

-- [[ options ]]

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.guicursor = ''
vim.opt.cul = true -- cursorline
-- remove cursorline to indicate insert mode 
autocmd('InsertEnter', {
	pattern = '*',
	callback = function() vim.opt.cul = false end
})
autocmd('InsertLeave', {
	pattern = '*',
	callback = function() vim.opt.cul = true end
})

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.wrap = false

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.opt.incsearch = true

vim.opt.signcolumn = 'number'

vim.opt.colorcolumn = '80'

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

-- format go files on save
autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function() vim.lsp.buf.format { async = false } end
})

vim.o.clipboard = "unnamedplus"

vim.diagnostic.enable(true)
vim.diagnostic.config({
	virtual_text = false,

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = { float = true },
})

-- non case-sensitive when searching lowercase
-- case-sensitive when using uppercase
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- search uses the current selection
vim.keymap.set('v', '/', 'y/\\V<C-r>"<CR>', { noremap = true, silent = true })

-- [[ general keymaps ]]

vim.keymap.set('n', '<leader>h', ':wincmd h<CR>')
vim.keymap.set('n', '<leader>j', ':wincmd j<CR>')
vim.keymap.set('n', '<leader>k', ':wincmd k<CR>')
vim.keymap.set('n', '<leader>l', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>pe', vim.cmd.Ex)

vim.keymap.set('n', '<leader>a', '<C-^>') -- switch to alternate (previous) file
vim.keymap.set('n', '<leader>o', '<C-W><C-O>') -- :only (close all windows but the current one)

-- keep cursor in middle when searching
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', '<leader>p', '<NOP>') -- no-op so that it doesn't accidentally paste


-- [[ lazy.nvim setup ]]

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{
		"ibhagwan/fzf-lua",
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({
				winopts = {
					preview = {
						layout = "vertical",
						vertical = "down:70%",
					},
				},
			})

			vim.keymap.set("n", "<leader>pf", function() 
				fzf.files({ resume = true })
			end, { desc = 'open [p]roject [f]iles' })
			vim.keymap.set("n", "<leader>ps", function()
				fzf.live_grep({ resume = true })
			end, { desc = 'open [p]roject [s]earch' })
			vim.keymap.set("v", "<leader>ps", fzf.grep_visual, { desc = 'open [p]roject [s]earch (using selection)' })
			vim.keymap.set("n", "<leader>pd", fzf.diagnostics_workspace, { desc = 'open [p]roject [d]iagnostics' })
			vim.keymap.set("n", "<leader>pb", function()
				fzf.buffers({
					sort_lastused = true,
					actions = {
						["ctrl-x"] = { fn = fzf.actions.buf_del, reload = true },
					},
				})
			end, { desc = 'open [p]roject [b]uffers' })
			vim.keymap.set("n", "<leader>pm", function()
				fzf.marks({ marks = "[a-zA-Z]" })
			end, { desc = 'open [p]roject [m]arks' })
		end,
	},

	{ 'j-hui/fidget.nvim', opts = {} },

	{
		'neovim/nvim-lspconfig',
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					local map = function(mode, keys, func, desc)
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					map('n', 'gd', require('fzf-lua').lsp_definitions, '[g]oto [d]efinition')
					map('n', 'gr', require('fzf-lua').lsp_references, '[g]oto [r]eferences')
					map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
					map('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature help (shows params when inside parentheses)')

					map('n', '<leader>bs', require('fzf-lua').lsp_document_symbols, 'open [b]uffer [s]ymbols')
				end
			})


			local servers = {
				basedpyright = {},
				solargraph = {},
			}

			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end
		end
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		main = 'nvim-treesitter',
		opts = {
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		},
	},

	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{
				'L3MON4D3/LuaSnip',
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
						return
					end
					return 'make install_jsregexp'
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
			},
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
		},
		config = function()
			-- See `:help cmp`
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			luasnip.config.setup {}

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = 'menu,menuone,noinsert' },
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<Tab>'] = cmp.mapping.confirm { select = true },

					-- Scroll the documentation window [b]ack / [f]orward
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),

					['<C-Space>'] = cmp.mapping.complete {},

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					['<C-l>'] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { 'i', 's' }),
					['<C-h>'] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { 'i', 's' }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				},
			}
		end,
	},
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("monokai-pro").setup({
				filter = "spectrum"
			})
			vim.cmd.colorscheme("monokai-pro")
		end,
	},
	{
		"NeogitOrg/neogit",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gs", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
		}
	},
	{ 
		'ThePrimeagen/harpoon',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set("n", "<leader>ha", function()
				mark.add_file()
				print("Added harpoon mark")
			end)
			vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu)
			vim.keymap.set("n", "<leader>h1", function() ui.nav_file(1) end)
			vim.keymap.set("n", "<leader>h2", function() ui.nav_file(2) end)
			vim.keymap.set("n", "<leader>h3", function() ui.nav_file(3) end)
			vim.keymap.set("n", "<leader>h4", function() ui.nav_file(4) end)
		end
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	}
})

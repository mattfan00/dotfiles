syntax on 

set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set cursorline
set number " Show current line number
set relativenumber " Show relative line numbers

" remove cursorline to indicate insert mode 
:autocmd InsertEnter * set nocul
:autocmd InsertLeave * set cul

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

set splitbelow
set termwinsize=10x0

"  start the plugins
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'pangloss/vim-javascript'
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'maxmellon/vim-jsx-pretty'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tmsvg/pear-tree'

call plug#end()
" end the plugins 

let g:gruvbox_contrast_dark = 'hard'

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

let mapleader = " "
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

let g:ctrlp_use_caching = 0 

map <C-n> :NERDTreeToggle<CR>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <C-p> :GFiles<CR>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"-- AUTOCLOSE --
"autoclose and position cursor to write text inside
"inoremap ' ''<left>
"inoremap ` ``<left>
"inoremap " ""<left>
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
""autoclose with ; and position cursor to write text inside
"inoremap '; '';<left><left>
"inoremap `; ``;<left><left>
"inoremap "; "";<left><left>
"inoremap (; ();<left><left>
"inoremap [; [];<left><left>
"inoremap {; {};<left><left>
""autoclose with , and position cursor to write text inside
"inoremap ', '',<left><left>
"inoremap `, ``,<left><left>
"inoremap ", "",<left><left>
"inoremap (, (),<left><left>
"inoremap [, [],<left><left>
"inoremap {, {},<left><left>
""autoclose and position cursor after
"inoremap '<tab> ''
"inoremap `<tab> ``
"inoremap "<tab> ""
"inoremap (<tab> ()
"inoremap [<tab> []
"inoremap {<tab> {}
""autoclose with ; and position cursor after
"inoremap ';<tab> '';
"inoremap `;<tab> ``;
"inoremap ";<tab> "";
"inoremap (;<tab> ();
"inoremap [;<tab> [];
"inoremap {;<tab> {};
""autoclose with , and position cursor after
"inoremap ',<tab> '',
"inoremap `,<tab> ``,
"inoremap ",<tab> "",
"inoremap (,<tab> (),
"inoremap [,<tab> [],
"inoremap {,<tab> {},
""autoclose 2 lines below and position cursor in the middle 
"inoremap '<CR> '<CR>'<ESC>O
"inoremap `<CR> `<CR>`<ESC>O
"inoremap "<CR> "<CR>"<ESC>O
"inoremap (<CR> (<CR>)<ESC>O
"inoremap [<CR> [<CR>]<ESC>O
"inoremap {<CR> {<CR>}<ESC>O
""autoclose 2 lines below adding ; and position cursor in the middle 
"inoremap ';<CR> '<CR>';<ESC>O
"inoremap `;<CR> `<CR>`;<ESC>O
"inoremap ";<CR> "<CR>";<ESC>O
"inoremap (;<CR> (<CR>);<ESC>O
"inoremap [;<CR> [<CR>];<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O
""autoclose 2 lines below adding , and position cursor in the middle 
"inoremap ',<CR> '<CR>',<ESC>O
"inoremap `,<CR> `<CR>`,<ESC>O
"inoremap ",<CR> "<CR>",<ESC>O
"inoremap (,<CR> (<CR>),<ESC>O
"inoremap [,<CR> [<CR>],<ESC>O
"inoremap {,<CR> {<CR>},<ESC>O

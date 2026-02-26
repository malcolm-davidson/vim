set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Folding
Plugin 'tmhedberg/SimpylFold'

" Python indentation
Plugin 'vim-scripts/indentpython.vim'

" Syntax highlighting / linting
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'

" File Browsing
Plugin 'scrooloose/nerdtree'

" Fuzzy search (files + content)
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

" Git Integration
Plugin 'tpope/vim-fugitive'

" LSP client + auto-install language servers
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'

" Async autocompletion
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'

" Statusbar
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
set laststatus=2

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Enable folding
set foldmethod=indent
set foldlevel=99
let g:SimpylFold_docstring_preview=1

" Enable folding with the spacebar
nnoremap <space> za

" Set up PEP 8 indentation
augroup python_settings
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix
augroup END

" Set up indentation for js, html, css
augroup web_settings
    autocmd!
    autocmd BufNewFile,BufRead *.js,*.html,*.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" Flag trailing whitespace
highlight BadWhitespace ctermbg=red guibg=red
augroup trailing_whitespace
    autocmd!
    " Show on buffer enter and when leaving insert mode
    autocmd BufWinEnter * match BadWhitespace /\s\+$/
    autocmd InsertLeave * match BadWhitespace /\s\+$/
    " While typing, exclude the character under the cursor so it doesn't flicker
    autocmd InsertEnter * match BadWhitespace /\s\+\%#\@<!$/
    " Clear when leaving a buffer's window
    autocmd BufWinLeave * call clearmatches()
augroup END

" fzf key mappings
nnoremap <C-p> :Files<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>b :Buffers<CR>

" Text Encoding
set encoding=utf-8

" Syntax highlighting
let python_highlight_all=1
syntax on

" Line Numbers
set nu

" LSP key mappings (active when a language server attaches to the buffer)
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> K  <plug>(lsp-hover)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
endfunction

augroup lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Autocompletion: Tab to navigate menu, Enter to confirm
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

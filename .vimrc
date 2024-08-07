" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
set cursorcolumn

" vim cursor escape codes for the terminal emulator

" Vim modes:
"  (&t_EI) -> VISUAL
"  (&t_SR) -> REPLACE
"  (&t_SI) -> INSERT
"
"Cursor settings:
"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar

let &t_EI = "\<Esc>[2 q"
let &t_SR = "\<Esc>[4 q"
let &t_SI = "\<Esc>[6 q"

" set cursor to vertical bar when entering cmd line and
" revert cursor back to block when leaving cmd line
autocmd CmdlineEnter * execute 'silent !echo -ne "' . &t_SI . '"'
autocmd CmdlineLeave * execute 'silent !echo -ne "' . &t_EI . '"'

" Make sure you have `vim-plug` installed
" Installation:
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin()

" Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'joshdick/onedark.vim'

call plug#end()

" colorscheme catppuccin_mocha
colorscheme onedark

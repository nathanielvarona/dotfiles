" Set background color to dark.
set background=dark

" Disable compatibility with vi to avoid unexpected issues.
set nocompatible

" Enable file type detection, plugin loading, and indentation settings.
filetype plugin indent on

" Turn on syntax highlighting.
syntax on

" Display line numbers on the left side.
set number

" Highlight the line and column under the cursor.
set cursorline
set cursorcolumn

" Enable true color support in the terminal.
set termguicolors

" Configure cursor shapes for different modes:
" 1 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" 5 -> blinking vertical bar
" 6 -> solid vertical bar

" Cursor shape settings
let &t_EI = "\<Esc>[2 q" " NORMAL/VISUAL mode
let &t_SR = "\<Esc>[4 q" " REPLACE mode
let &t_SI = "\<Esc>[6 q" " INSERT mode

" Configure cursor shape changes for command line mode:
" Set cursor shape when entering command line mode.
autocmd CmdlineEnter * execute 'silent !echo -ne "' . "\<Esc>[1 q" . '"'
" Revert cursor shape when leaving command line mode.
autocmd CmdlineLeave * execute 'silent !echo -ne "' . "\<Esc>[2 q" . '"'

" Ensure you have `vim-plug` installed.
" Installation:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin()
" Add your plugins here.
Plug 'iibe/gruvbox-high-contrast'
call plug#end()

" Plugin settings
" ===============
let g:gruvbox_contrast_dark = 'hard' " Use hard contrast for gruvbox
colorscheme gruvbox-high-contrast " Set colorscheme to gruvbox-high-contrast

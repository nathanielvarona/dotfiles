" Ensure you have `vim-plug` installed.
" Installation:
" curl -fLo ~/.config/vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin()
" Add your plugins here.
Plug 'iibe/gruvbox-high-contrast'
Plug 'wojciechkepka/vim-github-dark'
call plug#end()

" Plugin settings
" ===============
let g:gruvbox_contrast_dark = 'hard' " Use hard contrast for gruvbox
" colorscheme gruvbox-high-contrast " Set colorscheme to gruvbox-high-contrast
colorscheme ghdark

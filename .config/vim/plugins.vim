" Ensure you have `vim-plug` installed.
" Installation:
" curl -fLo ~/.config/vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin()
" Add your plugins here.
Plug 'iibe/gruvbox-high-contrast'
Plug 'wojciechkepka/vim-github-dark'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" Plugin settings
" ===============
let g:gruvbox_contrast_dark = 'hard' " Use hard contrast for gruvbox
" colorscheme gruvbox-high-contrast " Set colorscheme to gruvbox-high-contrast
colorscheme ghdark

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-h> :<C-U>TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :<C-U>TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :<C-U>TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :<C-U>TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :<C-U>TmuxNavigatePrevious<cr>

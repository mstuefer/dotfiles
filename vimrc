call plug#begin("~/.vim/plugged")

Plug 'AndrewRadev/splitjoin.vim'                                  " split or join one-liner in multiline and vice-versa
Plug 'ConradIrwin/vim-bracketed-paste'                            " cmd-v without mess
Plug 'Raimondi/delimitMate'                                       " closes quotes,parenthesis,brackets..
Plug 'ctrlpvim/ctrlp.vim'                                         " full path fuzzy file, buffer, mru, tag, .. finder
Plug 'elzr/vim-json', {'for' : 'json'}                            " syntax-highlighting for json
Plug 'fatih/vim-go'                                               " go magic <3
Plug 'scrooloose/nerdtree'
Plug 't9md/vim-choosewin'                                         " mimics tmuxs display-pane, to choose window
Plug 'tmux-plugins/vim-tmux', {'for' : 'tmux' }                   " tmux.conf editing support
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'                                         " git wrapper
Plug 'altercation/vim-colors-solarized'
Plug 'pangloss/vim-javascript'                                    " js bundle for vim (better highlighting etc)
Plug 'airblade/vim-gitgutter'                                     " show git diff in gutter (sign column)
Plug 'scrooloose/syntastic'
Plug 'shougo/deoplete.nvim', {'do' : ':UpdateRemotePlugins'}      " async keyword completion in current buffer
Plug 'neovim/python-client'                                       " support for py plugins in nvim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " clone fzf in ~/.fzf and run install script
Plug 'junegunn/fzf.vim'                                           " the additional vim plugin
Plug 'junegunn/limelight.vim'

call plug#end()

" 'za' on a section, to fold/unfold it

" General Settings {{{
set nocompatible                " no compatible with old vim
filetype off
filetype plugin indent on
set ttyfast
set laststatus=2                " enable statusline
set encoding=utf-8
set autoindent
set backspace=indent,eol,start
set incsearch
set hlsearch
set mouse=a
set noerrorbells
set showcmd
set noswapfile
set nobackup
set splitright
set splitbelow
set autowrite                   " automatically save before :next, :make ..
set hidden
set fileformats=unix,dos,mac    " prefer unix over win over..
set noshowmatch
set noshowmode
set ignorecase
set smartcase
set completeopt=menu,menuone
set nocursorcolumn
set nocursorline
set updatetime=100
set pumheight=10                " completion window max size
set viminfo='200
set lazyredraw
if has('persistent_undo')
        set undofile
        set undodir=~/.cache/vim
endif
syntax enable
set expandtab
set clipboard=unnamed
set shell=/bin/bash           " vim requires posix compatible shell in fish
set cursorline               " highlight current line
set vb                       " enable visual bell
set ruler                    " show row and column in footer
" show tabs, trailing spaces, and non breaking spaces
set listchars=tab:˛\ ,trail:┈,nbsp:☠
set list
" complete filenames as far as possible
set wildmode=longest,list,full
" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
if !has('gui_running')
        set notimeout
        set ttimeout
        set ttimeoutlen=10
        augroup FastEscape
                autocmd!
                au InsertEnter * set timeoutlen=0
                au InsertLeave * set timeoutlen=1000
        augroup END
endif
" treat all numbers as decimals, not octals, regardless if they r padded with
" zeros
set nrformats=
" display all matching fields when we tab complete
set wildmenu

" }}}

" Colorscheme Solarized {{{
set t_Co=256
set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
colorscheme solarized
" }}}

" Numbertoggle {{{
set number relativenumber       " set relativenumber
augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * set relativenumber " on active tab
        autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber " on non-active tabs
augroup END
" }}}

" Deletion Of Trailing Slashes {{{
autocmd BufWritePre * :%s/\s\+$//e  " del trailing slashes on save
" }}}

" Filetypedetect to set ts, sw, .. {{{
augroup filetypedetect
        autocmd BufNewFile,BufRead *.go setlocal noexpandtab ts=4 sw=4
        autocmd BufNewFile,BufRead *.txt setlocal noexpandtab ts=4 sw=4
        autocmd BufNewFile,BufRead *.md setlocal noexpandtab ts=4 sw=4
        autocmd BufNewFile,BufRead *.vim setlocal expandtab sw=2 ts=2
        autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux

        autocmd FileType json setlocal expandtab sw=2 ts=2
        autocmd FileType ruby setlocal expandtab sw=2 ts=2
        autocmd FileType perl setlocal expandtab sw=4 ts=4
augroup END
" }}}

" StatusLine {{{
let s:modes = {
                \ 'n': 'NORMAL',
                \ 'i': 'INSERT',
                \ 'R': 'REPLACE',
                \ 'v': 'VISUAL',
                \ 'V': 'V-LINE',
                \ "\<C-v>": 'V-BLOCK',
                \ 'c': 'COMMAND',
                \ 's': 'SELECT',
                \ 'S': 'S-LINE',
                \ "\<C-s>": 'S-BLOCK',
                \ 't': 'TERMINAL'
        \}
let s:prev_mode = ""

function! StatusLineMode()
        let cur_mode = get(s:modes, mode(), '')

        " do not update higlight if the mode is the same
        if cur_mode == s:prev_mode
                return cur_mode
        endif

        if cur_mode == "NORMAL"
                exe 'hi! StatusLine ctermfg=236'
                exe 'hi! myModeColor cterm=bold ctermbg=148 ctermfg=22'
        elseif cur_mode == "INSERT"
                exe 'hi! myModeColor cterm=bold ctermbg=23 ctermfg=231'
        elseif cur_mode == "VISUAL" || cur_mode == "V-LINE" || cur_mode == "V_BLOCK"
                exe 'hi! StatusLine ctermfg=236'
                exe 'hi! myModeColor cterm=bold ctermbg=208 ctermfg=88'
        endif

        let s:prev_mode = cur_mode
        return cur_mode
endfunction

function! StatusLineFiletype()
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! StatusLinePercent()
        return (100 * line('.') / line('$')) . '%'
endfunction

function! StatusLineLeftInfo()
        let branch = fugitive#head()
        let filename = '' != expand('%:t') ? expand('%:t') : '¯\_(ツ)_/¯'
        if branch !=# ''
                return printf("%s | %s", branch, filename)
        endif
        return filename
endfunction

exe 'hi! myInfoColor ctermbg=240 ctermfg=252'
autocmd InsertEnter * hi StatusLine cterm=bold ctermbg=23 ctermfg=231
autocmd InsertLeave * hi StatusLine ctermbg=8 ctermfg=236

" start building our statusline
set statusline=

" mode with custom colors
set statusline+=%#myModeColor#
set statusline+=%{StatusLineMode()}
set statusline+=%*"{{{}}}

" left information bar (after mode)
set statusline+=%#myInfoColor#
set statusline+=\ %{StatusLineLeftInfo()}
set statusline+=\ %*

" go command status (requires vim-go)
set statusline+=%#goStatuslineColor#
set statusline+=%{go#statusline#Show()}
set statusline+=%*

" right section seperator
set statusline+=%=

" filetype, percentage, line number and column number
set statusline+=%#myInfoColor#
set statusline+=\ %{StatusLineFiletype()}\ %{StatusLinePercent()}\ %l:%v
set statusline+=\ %*

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" }}}

" Quickfix to the bottom {{{
autocmd FileType qf wincmd J
augroup quickfix
        autocmd!
        autocmd FileType qf setlocal wrap
augroup END
" }}}

" Mappings {{{
let mapleader = "," " Setting leader

" Some useful quickfix shortcuts for quickfix
noremap <C-n> :cn<cr>
noremap <C-m> :cp<cr>
nnoremap <leader>a :cclose<cr>

" center file in window at current cursor position
nnoremap <space> zz

" Remove search highlight
nnoremap <leader><space> :nohlsearch<cr>

" Close all but the current one
nnoremap <leader>o :only<cr>

" Print full path / Info about full path
nnoremap <C-i> :echo expand("%:p")<cr>

" Visual linewise up and down by default (and use gj gk to go quicker)
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk

" Exit on jk
inoremap jk <Esc>

" quickly edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source (reload configuration)
nnoremap <silent> <F5> :source $MYVIMRC<cr>

nnoremap <F6> :setlocal spell! spell?<cr>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when moving up and down
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" Remap H and L (top, bottom of screen to left and right end of line)
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L g_

" Act like D and C
nnoremap Y y$

" Do not show stupid q: window
map q: :q

" Don't move on * I'd use a function for this but Vim clobbers the last search
" when you're in a function so fuck it, practicality beats purity.
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" 'go back' to previous buffer
nnoremap gb :bprevious<cr>
" 'close this' current buffer
nnoremap ct :bd<cr>
" :nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
nnoremap <leader>s :rightbelow split<cr>
nnoremap <leader>v :rightbelow vsplit<cr>
nnoremap <leader>b :buffers<cr>

nnoremap T zt " current cursor line at top of window
" }}}

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " jump to last position on reopening

" Enter automatically into the files directory
autocmd BufEnter * silent! lcd %:p:h

" (DEACTIVATED) Visual Mode */# from Scrooloose {{{
"function! s:VSetSearch()
"        let temp = @@
"        norm! gvy
"        let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
"        let @@ = temp
"endfunction

"vnoremap * :<C-u>call <SID>VSetSearch()<cr>//<cr><c-o>
"vnoremap # :<C-u>call <SID>VSetSearch()<cr>??<cr><c-o>
" }}}

" PLUGINS

" FZF  {{{
nnoremap <C-t> :Files<cr>
nnoremap <C-c> :Commits<cr>
nnoremap <C-a> :Ag<cr>
nnoremap <C-f> :Tags<cr>
" }}}

" Limelight  {{{
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
"nmap <Leader>l <Plug>(Limelight)
" :LimeLight! to leave
" }}}

" Fugitive {{{
vnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gb :Gblame<cr>
" }}}

" Vim-Go  {{{
let g:go_fmt_fail_silently = 0
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_auto_type_info = 0
let g:go_def_mode = "guru"
let g:go_echo_command_info = 1
let g:go_gocode_autobuild = 0
let g:go_gocode_unimported_packages = 1
let g:go_autodetect_gopath = 1
let g:go_info_mode = "guru"
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 0
let g:go_modifytags_transform = 'camelcase'

nnoremap <C-g> :GoDecls<cr>
inoremap <C-g> <esc>:<C-u>GoDecls<cr>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
        let l:file = expand('%')
        if l:file =~# '^\f\+_test\.go$'
                call go#test#Test(0, 1)
        elseif l:file =~# '^\f\+\.go$'
                call go#cmd#Build(0)
        endif
endfunction

augroup go
        autocmd!

        autocmd FileType go nmap <silent> <Leader>v <Plug>(go-def-vertical)
        autocmd FileType go nmap <silent> Leader>s <Plug>(go-def-split)

        autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc-vertical)

        autocmd FileType go nmap <silent> <Leader>i <Plug>(go-info)
        autocmd FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)

        autocmd FileType go nmap <silent> <leader>b :<C-u>call <SID>build_go_files()<cr>
        autocmd FileType go nmap <silent> <leader>t  <Plug>(go-test)
        autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
        autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)

        autocmd FileType go nmap <silent> <Leader>c <Plug>(go-coverage-toggle)

        " I like these more!
        autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
        autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
        autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
        autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END
" }}}

" CtrlP  {{{
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'  " jump to a file if it's open already
let g:ctrlp_mruf_max=450    " number of recently opened files
let g:ctrlp_max_files=0     " do not limit the number of searchable files
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_match_window = 'bottom,order:btt,max:10,results:10'
let g:ctrlp_buftag_types = {'go' : '--language-force=go --golang-types=ftv'}

nmap <C-b> :CtrlPCurWD<cr>
imap <C-b> <esc>:CtrlPCurWD<cr>
" }}}

" delimitMate  {{{
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_smart_quotes = 1
let g:delimitMate_expand_inside_quotes = 0
let g:delimitMate_smart_matchpairs = '^\%(\w\|\$\)'

imap <expr> <cr> pumvisible() ? "\<c-y>" : "<Plug>delimitMateCR"
" }}}

" NerdTree {{{
" For toggling
noremap <Leader>n :NERDTreeToggle<cr>
noremap <Leader>f :NERDTreeFind<cr>

let NERDTreeShowHidden=1
" }}}

" Vim-Json {{{
let g:vim_json_syntax_conceal = 0
" }}}

" UltiSnips {{{
"function! g:UltiSnips_Complete()
"  call UltiSnips#ExpandSnippet()
"  if g:ulti_expand_res == 0
"    if pumvisible()
"      return "\<C-n>"
"    else
"      call UltiSnips#JumpForwards()
"      if g:ulti_jump_forwards_res == 0
"        return "\<TAB>"
"      endif
"    endif
"  endif
"  return ""
"endfunction

"function! g:UltiSnips_Reverse()
"  call UltiSnips#JumpBackwards()
"  if g:ulti_jump_backwards_res == 0
"    return "\<C-P>"
"  endif
"
"  return ""
"endfunction

"if !exists("g:UltiSnipsJumpForwardTrigger")
"  let g:UltiSnipsJumpForwardTrigger = "<tab>"
"endif

"if !exists("g:UltiSnipsJumpBackwardTrigger")
"  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"endif

"au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
"au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
" }}}

" Choosewin {{{
nmap  -  <Plug>(choosewin)
" }}}

" Trigger a highlight in the appropriate direction when pressing these keys:
"let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" improve autocomplete menu color
highlight Pmenu ctermbg=052 ctermfg=255 gui=bold
highlight PmenuSel ctermbg=009 ctermfg=000 gui=bold

" Syntastic {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" }}}

" Deoplete {{{
let g:python_host_prog="/usr/local/bin/python3"
let g:python3_host_prog="/usr/local/bin/python3"
let g:deoplete#enable_at_startup = 1
" }}}

" Perl Shortcuts {{{
augroup perlshortcuts
        autocmd Filetype perl           :iabbrev <buffer> ifor my($i; $i<=?; $i++)<esc>4bf?
        autocmd Filetype perl           :iabbrev <buffer> mfor foreach my $i ($?)<esc>2bf?
augroup END
" }}}

" Vimscript file settings ---------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

autocmd VimEnter * echo '¯\_(ツ)_/¯ :: nvim, what else?'

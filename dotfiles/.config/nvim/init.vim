set background=dark
set clipboard=unnamed
set diffopt+=iwhite
set exrc
set secure
set gdefault
set hidden
set ignorecase
set modelines=10
set noerrorbells
set nofoldenable
set noshowmode
set pastetoggle=<F10>
set scrolloff=1
set shortmess+=s
set showmatch
set smartcase
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround
set timeoutlen=500
set title
set titleold=
set visualbell
set wrap
set linebreak
set nolist
if has('persistent_undo')
    set undodir=$HOME/.local/share/nvim/undo
    set undofile
endif
if has('nvim')
    set shell=fish
    set inccommand=
endif

let g:loaded_python_provider = 1
let g:python3_host_skip_check = 1
let python_highlight_all = 1
let g:pyindent_open_paren = '&sw'
let g:tex_flavor = 'latex'

augroup restore_cursor
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe ":normal! g`\"" | endif
augroup END

highlight MyHighlight ctermfg=0 ctermbg=9

function! HighlightRegion()
    highlight MyHighlight ctermfg=0 ctermbg=9
    let l_start = line("'<")
    let l_end = line("'>") + 1
    execute 'syntax region MyHighlight start=/\%' . l_start . 'l/ end=/\%' . l_end . 'l/'
endfunction

"""
""" bindings
"""

let mapleader = ' '
let maplocalleader = ' '

""" vanilla vim
nnoremap <silent> <Leader>a :xa<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>Q :q!<CR>
nnoremap <silent> <Leader>A :qa!<CR>
nnoremap <silent> <Leader>d :Bdelete<CR>
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>n :nohlsearch<CR>:syntax clear MyHighlight<CR>
nnoremap <silent> <Leader>` :cclose<CR>:lclose<CR>:pclose<CR>
vnoremap <silent> <Leader>hl :<C-U>call HighlightRegion()<CR>
nnoremap <silent> <Leader>hl V:<C-U>call HighlightRegion()<CR>
nnoremap <Leader>, <F10>
nnoremap <silent> <Leader>[ :bprevious<CR>
nnoremap <silent> <Leader>] :bnext<CR>
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
if has('nvim')
    nnoremap <silent> <Leader>1 :belowright 15split<CR>:terminal<CR>
    tnoremap <C-X> <C-\><C-n>
    tnoremap <C-H> <C-\><C-n><C-W>h
    tnoremap <C-J> <C-\><C-n><C-W>j
    tnoremap <C-K> <C-\><C-n><C-W>k
    tnoremap <C-L> <C-\><C-n><C-W>l
endif

""" plugin-related
nmap s <Plug>(SneakStreak)
nmap S <Plug>(SneakStreakBackward)
nnoremap <Leader>mk :Neomake!<CR>
nnoremap <Leader>lmk :Neomake latexmk<CR>
nnoremap <Leader>T :NeomakeSh ctags -R<CR>
xmap ga <Plug>(EasyAlign)
nnoremap \\ :FZFLinesBuffer<Space>
nnoremap \ :FZFLinesAll<Space>
vnoremap \\ y:FZFLinesBuffer<Space><C-R><C-R>"<CR>
vnoremap \ y:FZFLinesAll<Space><C-R><C-R>"<CR>
nnoremap <silent> <Leader>p :FZF<CR>
nnoremap <silent> <Space>f :FZFLinesBuffer<CR>
nnoremap <silent> <Space>gf :FZFLinesAll<CR>
nnoremap <silent> <Leader>t :FZFTagsBuffer<CR>
nnoremap <silent> <Leader>gt :FZFTags<CR>
nnoremap <Leader>s :%s/
vnoremap <Leader>s :s/
vnoremap <Leader>ldf :Linediff<CR>
nnoremap <Leader>ldf :LinediffReset<CR>
nnoremap <silent> <Leader>go :Goyo<CR>

"""
""" session management
"""

function! FindProjectName()
    return substitute(getcwd(), '/', '%', 'g')
endfunction

function! RestoreSession(name)
    if exists('g:my_vim_from_stdin') | return | endif
    if filereadable($HOME . '/.local/share/nvim/sessions/' . a:name)
        execute 'source ~/.local/share/nvim/sessions/' . fnameescape(a:name)
    endif
endfunction

function! SaveSession(name)
    if exists('g:my_vim_from_stdin') || getcwd() == $HOME | return | endif
    execute 'mksession! ~/.local/share/nvim/sessions/' . fnameescape(a:name)
endfunction

if argc() == 0 && v:version >= 704
    augroup session_handler
        autocmd!
        autocmd StdinReadPre * let g:my_vim_from_stdin = 1
        autocmd VimLeave * Goyo!
        autocmd VimLeave * call SaveSession(FindProjectName())
        autocmd VimEnter * nested call RestoreSession(FindProjectName())
    augroup END
end

let g:test = FindProjectName()

"""
""" plugins
"""

" download vim-plug automatically if missing
if !filereadable($HOME . "/.config/nvim/autoload/plug.vim")
    call system("curl -fkLo ~/.config/nvim/autoload/plug.vim --create-dirs "
                \ . "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
endif

filetype off

call plug#begin('~/.local/share/nvim/plugged')
" sort with :'<,'>sort /^[^\/]*\/\(vim-\)\=/

""" colors
Plug 'chriskempson/base16-vim' " base16 for gvim
""" vanilla vim enhancements
" Plug 'Konfekt/FastFold'                 " more sensible fdm=syntax
Plug 'moll/vim-bbye'                    " layout stays as is on buffer close
Plug 'tpope/vim-repeat'                 " makes . accessible to plugins
Plug 'Shougo/vimproc', {'do': 'make'}   " subprocess api for plugins
""" new functionality
Plug 'Raimondi/delimitMate'             " automatic closing of paired delimiters
Plug 'junegunn/vim-easy-align'          " tables in vim
Plug 'terryma/vim-expand-region'        " expand selection key: +/_
Plug 'tpope/vim-fugitive'               " heavy plugin, provides :Gblame
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'airblade/vim-gitgutter'           " git changes
Plug 'junegunn/goyo.vim'                " distraction-free vim, key: <Leader>go
Plug 'itchyny/lightline.vim'            " fast status line
Plug 'AndrewRadev/linediff.vim'         " diffing ranges, key: <Leader>ldf
Plug 'terryma/vim-multiple-cursors'     " key: <C-N> <C-X> <C-P>
Plug 'neomake/neomake'                  " async make/linters
Plug 'reedes/vim-pencil'                " handle single-line paragraphs
Plug 'justinmk/vim-sneak'               " additional movements
Plug 'tpope/vim-surround'               " key: cs, ds, ys
Plug 'tomtom/tcomment_vim'              " automatic comments, key: gc
Plug 'bronson/vim-trailing-whitespace'  " trailing whitespace
if v:version >= 704
    Plug 'bling/vim-bufferline'         " show open buffers in command line
    Plug 'Shougo/deoplete.nvim'         " async autocompletion
endif
""" filetype-specific
Plug 'dag/vim-fish'                     " fish syntax
Plug 'chikamichi/mediawiki.vim'         " wiki file format
Plug 'hynek/vim-python-pep8-indent'     " PEP8 indentation
Plug 'hdima/python-syntax'              " better highlighting
Plug 'rust-lang/rust.vim'

call plug#end()

try
    colorscheme base16-default-dark
catch /^Vim\%((\a\+)\)\=:E185/  " catch error when theme not installed
endtry
" use terminanal background, not theme backround
hi Normal ctermbg=none

filetype plugin indent on

""" filetype autocommands
augroup file_formats
    autocmd!
    autocmd FileType fortran setl cc=80,133 tw=80 com=:!>,:! fo=croq nu
    autocmd FileType python setl nosi cc=80 tw=80 fo=croq nu cino+="(0"
    autocmd FileType javascript setl cc=80 nu
    autocmd FileType cpp setl cc=80 tw=80 fo=croqw cino+="(0"
    autocmd FileType markdown setl tw=80 spell ci pi sts=0 sw=4 ts=4
    autocmd FileType tex setl tw=80 ts=2 sw=2 sts=2 spell
    autocmd FileType yaml setl ts=2 sw=2 sts=2
    autocmd BufRead,BufNewFile *.pyx setl ft=cython
    autocmd BufEnter /private/tmp/crontab.* setl bkc=yes
    autocmd BufEnter term://* startinsert
augroup END

"""
""" plugin configuration
"""

let g:lightline = {
		    \     'active': {
		    \     'left': [ [ 'mode', 'paste' ],
		    \               [ 'filename', 'modified' ] ],
		    \     'right': [ [ 'lineinfo' ],
		    \                [ 'percent' ],
		    \                [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \     },
            \     'colorscheme': 'jellybeans',
            \     'component': {
            \       'lineinfo': ' %3l:%-2v',
            \     },
            \     'component_function': {
            \       'modified': 'LightLineModified',
            \     },
            \     'separator': { 'left': '', 'right': '' },
            \     'subseparator': { 'left': '', 'right': '' }
            \ }

function! LightLineModified()
    return &modified ? '❌' : &readonly ? '🔒' : '✅'
endfunction

au FileType rust let b:delimitMate_quotes = "\""

let g:bufferline_modified = '❌ '
let g:bufferline_active_buffer_left = '📝 '
let g:bufferline_active_buffer_right = ''
let g:bufferline_rotate = 1

let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#input_patterns = {}
if exists("*deoplete#custom#set")
    call deoplete#custom#set('_', 'matchers', ['matcher_length', 'matcher_full_fuzzy'])
endif
if !exists('g:deoplete#omni_patterns')
    let g:deoplete#omni_patterns = {}
endif

let g:sneak#target_labels = "jfkdlsaireohgutwnvmcJFKDLSAIREOHGUTWNVMC"
highlight SneakStreakMask ctermfg=8
highlight clear SneakStreakStatusLine

let g:pencil#wrapModeDefault = 'soft'
let g:pencil#conceallevel = 0
augroup pencil
    autocmd!
    autocmd FileType markdown call pencil#init()
    autocmd FileType tex call pencil#init()
    autocmd FileType rst call pencil#init()
    autocmd FileType text call pencil#init()
augroup END

let g:multi_cursor_exit_from_insert_mode = 0

autocmd! BufWritePost * Neomake
let g:neomake_fortran_enabled_makers = ['gnu']
let g:neomake_rust_enabled_makers = []
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_args = ['--ignore=E501,E226,E402']
let g:neomake_tex_enabled_makers = ['chktex']
let g:neomake_tex_chktex_args = ['--nowarn', '29', '--nowarn', '3']
let g:neomake_open_list = 1

let s:gfortran_maker = {
            \     'exe': 'mpifort',
            \     'args': ['-fsyntax-only', '-fcoarray=single', '-fcheck=all', '-fall-intrinsics'],
            \     'errorformat': '%-C %#,' . '%-C  %#%.%#,' . '%A%f:%l%[.:]%c:,'
            \           . '%Z%\m%\%%(Fatal %\)%\?%trror: %m,' . '%Z%tarning: %m,'
            \           . '%-G%.%#'
            \ }
let g:neomake_fortran_gnu_maker = deepcopy(s:gfortran_maker)
call extend(g:neomake_fortran_gnu_maker.args, [
            \     '-Wall', '-Waliasing', '-Wcharacter-truncation',
            \     '-Wextra', '-Wintrinsics-std', '-Wsurprising',
            \     '-std=gnu', '-ffree-line-length-none'])
let s:gfortran_pedant_maker = deepcopy(s:gfortran_maker)
call extend(s:gfortran_pedant_maker.args, [
            \     '-Wall', '-pedantic', '-Waliasing', '-Wcharacter-truncation',
            \     '-Wextra', '-Wimplicit-procedure', '-Wintrinsics-std', '-Wsurprising'
            \ ])
let g:neomake_fortran_f95_maker = deepcopy(s:gfortran_pedant_maker)
call extend(g:neomake_fortran_f95_maker.args, ['-std=f95'])
let g:neomake_fortran_f03_maker = deepcopy(s:gfortran_pedant_maker)
call extend(g:neomake_fortran_f03_maker.args, ['-std=f2003'])
let g:neomake_fortran_f08_maker = deepcopy(s:gfortran_pedant_maker)
call extend(g:neomake_fortran_f08_maker.args, ['-std=f2008'])

let g:goyo_width = 81
let g:goyo_height = '100%'

function! s:goyo_enter()
    set noshowmode
    set noshowcmd
    au! bufferline
    au! CursorHold
    execute 'GitGutterSignsDisable'
endfunction

function! s:goyo_leave()
    set showmode
    set showcmd
    set background=dark
    syntax off
    syntax on
    call bufferline#init_echo()
    execute 'GitGutterSignsEnable'
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"""
""" FZF support
"""

let $PATH = $PATH . ':' . $HOME . '/.fzf/bin'

command! -nargs=? FZFLinesAll call fzf#run({
            \     'source': printf('ag --nogroup --column --color ' .
            \                      '--ignore "*.nb" --ignore "*.ipynb" --ignore "*.vesta" "%s"',
            \           escape(empty('<args>') ? '^(?=.)' : '<args>', '"\-')),
            \     'sink*': function('s:line_handler'),
            \     'options': '--multi --ansi --delimiter :  --tac --prompt "Ag>" '
            \           . '--bind ctrl-a:select-all,ctrl-d:deselect-all -n 1,4.. --color'
            \ })

function! s:ag_to_qf(line)
    let parts = split(a:line, ':')
    return {
                \     'filename': &acd ? fnamemodify(parts[0], ':p') : parts[0],
                \     'lnum': parts[1],
                \     'col': parts[2],
                \     'text': join(parts[3:], ':')
                \ }
endfunction

function! s:line_handler(lines)
    if len(a:lines) == 0
        return
    endif
    let list = map(a:lines, 's:ag_to_qf(v:val)')
    exec 'edit' list[0].filename
    exec list[0].lnum
    exec 'normal!' list[0].col . '|zz'
    if len(a:lines) > 1
        call setqflist(reverse(list))
        botright copen
    endif
endfunction

command! -nargs=? FZFLinesBuffer call fzf#run({
            \     'source': printf('ag --nogroup --column --color "%s" %s',
            \                      escape(empty('<args>') ? '^(?=.)' : '<args>', '"\-'),
            \                      bufname("")),
            \     'sink*': function('s:buff_line_handler'),
            \     'options': '--multi --ansi --delimiter :  --tac --prompt "Ag>" '
            \           . '--bind ctrl-a:select-all,ctrl-d:deselect-all -n 1,3.. --color'
            \ })

function! s:buff_ag_to_qf(line)
    let parts = split(a:line, ':')
    return {
                \     'filename': bufname(""),
                \     'lnum': parts[0], 'col': parts[1], 'text': join(parts[2:], ':')
                \ }
endfunction

function! s:buff_line_handler(lines)
    if len(a:lines) == 0
        return
    endif
    let list = map(a:lines, 's:buff_ag_to_qf(v:val)')
    exec list[0].lnum
    exec 'normal!' list[0].col . '|zz'
    if len(a:lines) > 1
        call setqflist(reverse(list))
        botright copen
    endif
endfunction

command! -bar FZFTags if !empty(tagfiles()) | call fzf#run({
            \     'source': 'gsed ''/^\!/ d; s/'
            \               . '^\([^\t]*\)\t\([^\t]*\)\t\(.*;"\)\t\(\w\)\t\?\([^\t]*\)\?/'
            \               . '\4\t|..|\1\t|..|\2\t|..|\5|..|\3/'
            \               . '; /^l/ d'' '
            \               . join(tagfiles())
            \               . ' | column -t -s "	" | gsed ''s/|..|/\t/g''',
            \     'options': '-d "\t" -n 2 --with-nth 1..4',
            \     'sink': function('s:tags_sink'),
            \ }) | else | call neomake#Sh('ctags -R') | FZFTags | endif

function! s:tags_sink(line)
    execute "edit" split(a:line, "\t")[2]
    execute join(split(a:line, "\t")[4:], "\t")
endfunction

command! FZFTagsBuffer call fzf#run({
            \     'source': printf('ctags -f - --sort=no --excmd=number --language-force=%s %s',
            \                      &filetype, expand('%:S'))
            \               . ' | gsed ''/^\!/ d; s/'
            \               . '^\([^\t]*\)\t\([^\t]*\)\t\(.*;"\)\t\(\w\)\t\?\([^\t]*\)\?/'
            \               . '\4\t|..|\1\t|..|\2\t|..|\5|..|\3/; /^l/ d'''
            \               . ' | column -t -s "	" | gsed ''s/|..|/\t/g''',
            \     'sink': function('s:buffer_tags_sink'),
            \     'options': '-d "\t" -n 2 --with-nth 1,2 --tiebreak=index --tac',
            \     'left': '40'
            \ })

function! s:buffer_tags_sink(line)
    execute join(split(a:line, "\t")[4:], "\t")
endfunction

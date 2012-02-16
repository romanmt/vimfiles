set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles
" Vundle itself
Bundle 'gmarik/vundle'   
" Explore and manage open buffers
Bundle 'bufexplorer.zip' 
" Switch to last buffer
Bundle 'bufmru.vim'      
" Motion through camelcase and _ notation
Bundle 'camelcasemotion' 
" Shows Nth match out of M matches
Bundle 'IndexedSearch' 
" um, JQuery
Bundle 'jQuery'
" Fuzzy matching
Bundle 'matchit.zip'     
" Javascript tags
Bundle 'taglist-plus'    
" Maintains history of previous yanks
Bundle 'YankRing.vim'
" Fast code commenting
Bundle 'https://github.com/scrooloose/nerdcommenter.git'
" Project folder
Bundle 'https://github.com/scrooloose/nerdtree.git'
" Code snipets
Bundle 'https://github.com/malkomalko/snipmate.vim.git'
" Tab completion
Bundle 'https://github.com/ervandew/supertab.git'
" Text alignment
Bundle 'https://github.com/godlygeek/tabular.git'
" Autoclose parens etc.
Bundle 'https://github.com/Townk/vim-autoclose.git'
" Cucumber
Bundle 'https://github.com/tpope/vim-cucumber.git'
" Easy text motions
Bundle 'https://github.com/Lokaltog/vim-easymotion.git'
" Git command wrapper
Bundle 'https://github.com/tpope/vim-fugitive.git'
" Jade
Bundle 'https://github.com/digitaltoad/vim-jade.git'
" Js
Bundle 'https://github.com/pangloss/vim-javascript.git'
" Date formatting
Bundle 'https://github.com/tpope/vim-speeddating.git'
" Stylus
Bundle 'https://github.com/wavded/vim-stylus.git'
" Quoting and blocking 
Bundle 'https://github.com/tpope/vim-surround.git'
" File finding
Bundle 'https://github.com/rphillips/fuzzyfinder.git'
" Coffee Script
Bundle 'https://github.com/vim-scripts/vim-coffee-script.git'
" Erlang
Bundle 'https://github.com/vim-scripts/Vimerl.git'
" Command-T
Bundle 'https://github.com/wincent/Command-T.git'

syntax on
filetype plugin indent on

" To show current filetype use: set filetype

" Change <Leader> and <LocalLeader>
let mapleader = "'"
let maplocalleader = "'"

" Set temporary directory (don't litter local dir with swp/tmp files)
set directory=/tmp/

" Use the tab complete menu
set wildmenu
set wildmode=list:longest,full

" Don't flick cursor.
set guicursor=a:blinkon0

" Set to auto read when a file is changed from the outside
set autoread

" store lots of :cmdline history
set history=1000

" set autowrite
set hidden

" no wrapping
set nowrap

" window heights/widths
set wmh=0
set wmw=0

set nosol

set showcmd "show incomplete cmds down the bottom
set showmode "show current mode down the bottom
set shortmess=atI

" When scrolling off-screen do so 5 lines at a time, not 1
set scrolloff=5
set sidescrolloff=7
set sidescroll=1

if has("folding")
  set foldmethod=indent   "fold based on indent
  set foldnestmax=10      "deepest fold is 10 levels
  set nofoldenable        "dont fold by default
  set foldlevel=1         "this is just what i use
  set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
endif

set formatoptions-=o "dont continue comments when pushing o/O

" Invisible characters *********************************************************
set listchars=trail:⋅,nbsp:⋅,tab:>-

" Status Line *****************************************************************
set statusline=%f "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
set statusline+=%y "filetype
set statusline+=%r "read only flag
set statusline+=%m "modified flag

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%{StatuslineLongLineWarning()}

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
  if !exists("b:statusline_trailing_space_warning")
    if search('\s\+$', 'nw') != 0
      let b:statusline_trailing_space_warning = '[\s]'
    else
      let b:statusline_trailing_space_warning = ''
    endif
  endif
  return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
  let name = synIDattr(synID(line('.'),col('.'),1),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
  if !exists("b:statusline_tab_warning")
    let tabs = search('^\t', 'nw') != 0
    let spaces = search('^ ', 'nw') != 0

    if tabs && spaces
      let b:statusline_tab_warning = '[mixed-indenting]'
    elseif (spaces && !&et) || (tabs && &et)
      let b:statusline_tab_warning = '[&et]'
    else
      let b:statusline_tab_warning = ''
    endif
  endif
  return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
  if !exists("b:statusline_long_line_warning")
    let long_line_lens = s:LongLines()

    if len(long_line_lens) > 0
      let b:statusline_long_line_warning = "[" .
            \ '#' . len(long_line_lens) . "," .
            \ 'm' . s:Median(long_line_lens) . "," .
            \ '$' . max(long_line_lens) . "]"
    else
      let b:statusline_long_line_warning = ""
    endif
  endif
  return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
  let threshold = (&tw ? &tw : 80)
  let spaces = repeat(" ", &ts)

  let long_line_lens = []

  let i = 1
  while i <= line("$")
    let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
    if len > threshold
      call add(long_line_lens, len)
    endif
    let i += 1
  endwhile

  return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
  let nums = sort(a:nums)
  let l = len(nums)

  if l % 2 == 1
    let i = (l-1) / 2
    return nums[i]
  else
    return (nums[l/2] + nums[(l/2)-1]) / 2
  endif
endfunction

" Tabs ************************************************************************
function! Tabstyle_tabs()
  " Using 4 column tabs
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set noexpandtab
  autocmd User Rails set softtabstop=4
  autocmd User Rails set shiftwidth=4
  autocmd User Rails set tabstop=4
  autocmd User Rails set noexpandtab
endfunction

function! Tabstyle_spaces()
  " Use 2 spaces
  set softtabstop=2
  set shiftwidth=2
  set tabstop=2
  set expandtab
endfunction

call Tabstyle_spaces()

" Indenting *******************************************************************
set ai " Automatically set the indent of a new line (local to buffer)
set si " smartindent	(local to buffer)

" Windows *********************************************************************
set equalalways " Multiple windows, when created, are equal in size
set splitbelow splitright

" Searching *******************************************************************
set hlsearch   " highlight search
set incsearch  " incremental search, search as you type
set ignorecase " Ignore case when searching 
set smartcase  " Ignore case when searching lowercase

" Misc ************************************************************************
set backspace=indent,eol,start
set number  " Show line numbers
set matchpairs+=<:>
set visualbell t_vb=  " Turn off bell
set novb 
set ttimeoutlen=50  " Make Esc work faster

" Gui Setup *******************************************************************
if has("gui_running")
  if has("gui_gnome")
    set term=gnome-256color
    set guifont=Inconsolata\ 16
    set guioptions-=T
    set guioptions-=m
    set guioptions+=c
    set guioptions-=rL
    set lines=100
    set columns=185
  else
    set guitablabel=%M%t
    set lines=100
    set columns=185
  endif

  if has("gui_mac") || has("gui_macvim")
    set guifont=Inconsolata:h18
    set fuoptions=maxvert,maxhorz
    set guioptions-=T
    set guioptions-=m
    set guioptions+=c
    set guioptions-=rL
    " set colorcolumn=81
  endif
endif

colorscheme jellybeans 

" Let's remember somethings, like where the .vim folder is
if has("wind32") || has("wind64")
    let windows=1
    let vimfiles=$HOME . "/vimfiles"
    let sep=";"
else
  let windows=0
  let vimfiles=$HOME . "/.vim"
  let sep=":"
endif

" -----------------------------------------------------------------------------  
" |                              Commands                                     |
" -----------------------------------------------------------------------------

" Add RebuildTagsFile function/command
function! s:RebuildTagsFile()
  !ctags -R --exclude=.svn --exclude=.git --exclude=coverage --exclude=files --exclude=public --exclude=log --exclude=tmp *
endfunction
command! -nargs=0 RebuildTagsFile call s:RebuildTagsFile()

" CleanScript 
function! s:CleanScript()
  :%s/
\+$//
endfunction
command! -nargs=0 CleanScript call s:CleanScript() 

" Align Fit Tables
function! s:alignFitTables()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
command! -nargs=0 AlignFitTables call s:alignFitTables()

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
function! s:HighlightLongLines(width)
  let targetWidth = a:width != '' ? a:width : 79
  if targetWidth > 0
    exec 'match Todo /\%>' . (targetWidth) . 'v/'
  else
    echomsg "Usage: HighlightLongLines [natural number]"
  endif
endfunction
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')

" toggles the quickfix window.
command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
  else
    if exists("g:jah_Quickfix_Win_Height")
      execute "copen " . g:jah_Quickfix_Win_Height
    else
      execute "copen " 
    endif
  endif
endfunction

" used to track the quickfix window
augroup QFixToggle
  autocmd!
  autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
  autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

" Run test files in buffer
function! s:SetTestFile()
  let g:CurrentTestFile = expand("%")
  let g:CurrentTestExt  = expand("%:e")
endfunction
command! -nargs=0 SetTestFile call s:SetTestFile()

function! s:RunTestFile()
  :w
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo

  if !exists("g:CurrentTestFile")
    let g:CurrentTestFile = expand("%")
    let g:CurrentTestExt  = expand("%:e")
  endif

  if g:CurrentTestExt == "rb"
    execute "w\|!spec --color --format nested " . g:CurrentTestFile
  elseif g:CurrentTestExt == "js"
    execute "w\|!TEST=true NODE_PATH=test:lib expresso -t 250 -I test -I lib
      \ -s -b " . g:CurrentTestFile . " >/dev/null"
  endif
endfunction
command! -nargs=0 RunTestFile call s:RunTestFile()

" Execute open rspec buffer
" Thanks to Ian Smith-Heisters
function! RunSpec(args)
 if exists("b:rails_root") && filereadable(b:rails_root . "/script/spec")
   let spec = b:rails_root . "/script/spec"
 else
   let spec = "spec"
 end 
 let cmd = ":! " . spec . " % -cfn " . a:args
 execute cmd 
endfunction
 
" -----------------------------------------------------------------------------  
" |                              Mappings                                     |
" -----------------------------------------------------------------------------

" Mappings

nnoremap ' `
" imap hh <Space>=><Space>"
imap jj <Esc>
" imap uu _

nmap <up> gk
nmap k gk
imap <up> <C-o>gk
nmap <down> gj
nmap j gj
imap <down> <C-o>gj
map E ge

map <C-n> :cn<CR>
map <C-p> :cp<CR>

nnoremap Y y$
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e

omap <silent> iw <Plug>CamelCaseMotion_iw
vmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
vmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
vmap <silent> ie <Plug>CamelCaseMotion_ie

noremap <Leader>ah :Tabularize /=>/<CR>
noremap <Leader>at :AlignFitTables<CR>
nmap <Leader>bd :bd<CR>
nmap <Leader>bn :bn<CR>
nmap <Leader>bp :bp<CR>
map <Leader>cp :CleanScript<CR>
map <Leader>e :e <C-R>=expand("%:p:h") . "/"<CR>
map <Leader>F :Ack<space>
map <Leader>h :set invhls<CR>
noremap <Leader>i :set list!<CR>
noremap <Leader>l :HighlightLongLines<CR>
noremap <Leader>L :HighlightLongLines 1000<CR>
noremap <Leader>n :NERDTreeToggle<CR>
map <silent> <leader>q :QFix<CR>
map <Leader>r :RunTestFile<CR>
map <Leader>; :SetTestFile<CR>
noremap <Leader>R :ConqueTermSplit<space>
noremap <Leader>S :split<cr>
map <Leader>se :split <C-R>=expand("%:p:h") . "/"<CR>
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/"<CR>
noremap <Leader>tl :TlistToggle<CR>
nmap <Leader>tn :tabnext<CR>
nmap <Leader>tp :tabprevious<CR>
nmap <Leader>tt :tabnew<CR>
noremap <Leader>V :vsp<cr>
nmap <Leader>we <C-w><C-=>
nmap <Leader>wm <C-w><C-_>
nmap <Leader>ww <C-w><C-w>
nmap <Leader>wv <C-w><C-v>
nmap <Leader>ws <C-w><C-s>
nmap <Leader>wj <C-w><C-j>
nmap <Leader>wk <C-w><C-k>
nmap <Leader>wh <C-w><C-h>
nmap <Leader>wl <C-w><C-l>
nmap <Leader>wc <C-w><C-c>
nmap <Leader>wr <C-w><C-r>
noremap <Leader>y :YRShow<CR>
noremap <Leader>] :RebuildTagsFile<CR>

nmap <Leader>s :w<cr>
nmap <Leader>q :q<cr>
nmap <Leader>sq :wq<cr>
nmap <Leader>Q :q!<cr>

" -----------------------------------------------------------------------------  
" |                              Plug-ins                                     |
" -----------------------------------------------------------------------------

" NERDTree ********************************************************************

" User instead of Netrw when doing an edit /foobar
let NERDTreeHijackNetrw=1

" Single click for everything
let NERDTreeMouseMode=1

" Ignore
let NERDTreeIgnore=['\.git','\.DS_Store','\.pdf','\.png','\.jpg','\.gif']

" Quit on open
let NERDTreeQuitOnOpen=1

" fuzzyfinder *****************************************************************

" limit number of results shown for performance
let g:fuzzy_matching_limit=60

" ignore stuff that can't be openned, and generated files
let g:fuzzy_ignore = "*.png;*.PNG;*.JPG;*.jpg;*.GIF;*.gif;vendor/**;coverage/**;tmp/**;rdoc/**"

" increate the number of files scanned for very large projects
let g:fuzzy_ceiling=20000

" bufexplorer *****************************************************************
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowDirectories=0
let g:bufExplorerShowRelativePath=1

" taglist *********************************************************************
let g:Tlist_GainFocus_On_ToggleOpen=1
let g:Tlist_Close_On_Select=1
let g:Tlist_WinWidth=50

" yankring
let g:yankring_replace_n_nkey = '<Leader>yn'
let g:yankring_replace_n_pkey = '<Leader>yp'

" zencoding
let g:user_zen_leader_key = '<c-k>'

" rubytest
let g:rubytest_in_quickfix = 0

let g:rubytest_cmd_test = "ruby %p"
let g:rubytest_cmd_testcase = "ruby %p -n '/%c/'"
let g:rubytest_cmd_spec = "spec -f n %p"
let g:rubytest_cmd_example = "spec -f n %p -l '%c'"
let g:rubytest_cmd_feature = "cucumber %p"
let g:rubytest_cmd_story = "cucumber %p -n '%c'"

" rsense
let g:rsenseHome = "~/src/rsense"

" supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

" vimclojure
let vimclojureRoot = vimfiles."/bundles/vimclojure"
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1

" easymotion
let g:EasyMotion_leader_key = '<Leader>m'

augroup custom
  autocmd!

  autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
        \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif

  autocmd BufNewFile,BufRead *.haml             set ft=haml
  autocmd BufNewFile,BufRead *.feature,*.story  set ft=cucumber
  autocmd BufRead * if ! did_filetype() && getline(1)." ".getline(2).
        \ " ".getline(3) =~? '<\%(!DOCTYPE \)\=html\>' | setf html | endif

  autocmd FileType javascript             setlocal et sw=2 sts=2 isk+=$
  autocmd FileType html,xhtml,css         setlocal et sw=2 sts=2
  autocmd FileType eruby,yaml,ruby        setlocal et sw=2 sts=2
  autocmd FileType cucumber               setlocal et sw=2 sts=2
  autocmd FileType gitcommit              setlocal spell
  autocmd FileType ruby                   setlocal comments=:#\  tw=79
  autocmd FileType vim                    setlocal et sw=2 sts=2 keywordprg=:help

  " Turn on language specific omnifuncs
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP

  autocmd Syntax css syn sync minlines=50

  autocmd User Rails Rnavcommand steps features/step_definitions -suffix=_steps.rb -glob=**/* -default=web()
  autocmd User Rails Rnavcommand blueprint spec/blueprints -suffix=_blueprint.rb -glob=**/* -default=model()
  autocmd User Rails Rnavcommand factory spec/factories -suffix=_factory.rb -glob=**/* -default=model()
augroup END

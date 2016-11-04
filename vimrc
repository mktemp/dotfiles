scriptencoding utf-8
" ^^ Please leave the above line at the start of the file.


" Default configuration file for Vim
" $Header: /var/cvsroot/gentoo-x86/app-editors/vim-core/files/vimrc-r4,v 1.3 2010/04/15 19:30:32 darkside Exp $

" Written by Aron Griffis <agriffis@gentoo.org>
" Modified by Ryan Phillips <rphillips@gentoo.org>
" Modified some more by Ciaran McCreesh <ciaranm@gentoo.org>
" Added Redhat's vimrc info by Seemant Kulleen <seemant@gentoo.org>

" You can override any of these settings on a global basis via the
" "/etc/vim/vimrc.local" file, and on a per-user basis via "~/.vimrc". You may
" need to create these.

" {{{ General settings
" The following are some sensible defaults for Vim for most users.
" We attempt to change as little as possible from Vim's defaults,
" deviating only where it makes sense
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time

set viminfo='20,\"500   " Keep a .viminfo file.

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority. You may
" wish to set 'wildignore' to completely ignore files, and 'wildmenu' to enable
" enhanced tab completion. These can be done in the user vimrc file.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
  set numberwidth=3
endif
" }}}

" {{{ Modeline settings
" We don't allow modelines by default. See bug #14088 and bug #73715.
" If you're not concerned about these, you can enable them on a per-user
" basis by adding "set modeline" to your ~/.vimrc file.
set nomodeline
" }}}

" {{{ Locale settings
" Try to come up with some nice sane GUI fonts. Also try to set a sensible
" value for fileencodings based upon locale. These can all be overridden in
" the user vimrc file.
if v:lang =~? "^ko"
  set fileencodings=euc-kr
  set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~? "^ja_JP"
  set fileencodings=euc-jp
  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~? "^zh_TW"
  set fileencodings=big5
  set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~? "^zh_CN"
  set fileencodings=gb2312
  set guifontset=*-r-*
endif

" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
  set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
  " If we have to add this, the default encoding is not Unicode.
  " We use this fact later to revert to the default encoding in plaintext/empty
  " files.
  let g:added_fenc_utf8 = 1
  set fileencodings+=utf-8
endif

" Make sure we have a sane fallback for encoding detection
if &fileencodings !~? "default"
  set fileencodings+=default
endif
" }}}

" {{{ Syntax highlighting settings
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
" }}}

" {{{ Terminal fixes
if &term ==? "xterm"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif

if &term ==? "gnome" && has("eval")
  " Set useful keys that vim doesn't discover via termcap but are in the
  " builtin xterm termcap. See bug #122562. We use exec to avoid having to
  " include raw escapes in the file.
  exec "set <C-Left>=\eO5D"
  exec "set <C-Right>=\eO5C"
endif
" }}}

" {{{ Filetype plugin settings
" Enable plugin-provided filetype settings, but only if the ftplugin
" directory exists (which it won't on livecds, for example).
if isdirectory(expand("$VIMRUNTIME/ftplugin"))
  filetype plugin on

  " Uncomment the next line (or copy to your ~/.vimrc) for plugin-provided
  " indent settings. Some people don't like these, so we won't turn them on by
  " default.
  " filetype indent on
endif
" }}}

" {{{ Fix &shell, see bug #101665.
if "" == &shell
  if executable("/bin/bash")
    set shell=/bin/bash
  elseif executable("/bin/sh")
    set shell=/bin/sh
  endif
endif
"}}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
  let is_bash=1
endif
" }}}

" {{{ Autocommands
if has("autocmd")

augroup gentoo
  au!

  " Gentoo-specific settings for ebuilds.  These are the federally-mandated
  " required tab settings.  See the following for more information:
  " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
  " Note that the rules below are very minimal and don't cover everything.
  " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
  " filetype and indent settings for all things Gentoo.
  au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
  au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

  " In text files, limit the width of text to 78 characters, but be careful
  " that we don't override the user's setting.
  autocmd BufNewFile,BufRead *.txt
        \ if &tw == 0 && ! exists("g:leave_my_textwidth_alone") |
        \     setlocal textwidth=78 |
        \ endif

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if ! exists("g:leave_my_cursor_position_alone") |
        \     if line("'\"") > 0 && line ("'\"") <= line("$") |
        \         exe "normal g'\"" |
        \     endif |
        \ endif

  " When editing a crontab file, set backupcopy to yes rather than auto. See
  " :help crontab and bug #53437.
  autocmd FileType crontab set backupcopy=yes

  " If we previously detected that the default encoding is not UTF-8
  " (g:added_fenc_utf8), assume that a file with only ASCII characters (or no
  " characters at all) isn't a Unicode file, but is in the default encoding.
  " Except of course if a byte-order mark is in effect.
  autocmd BufReadPost *
        \ if exists("g:added_fenc_utf8") && &fileencoding == "utf-8" && 
        \    ! &bomb && search('[\x80-\xFF]','nw') == 0 && &modifiable |
        \       set fileencoding= |
        \ endif

augroup END

endif " has("autocmd")
" }}}

" {{{ vimrc.local
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
" }}}

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :


" ---- User settings ---- "

"set cursorline
"hi CursorLineNr ctermfg=red
"hi clear CursorLine
"hi CursorLine ctermbg=102 ctermfg=15 term=bold cterm=bold "8 = dark gray, 15 = white
"hi CursorLine term=bold cterm=bold "8 = dark gray, 15 = white
"hi Cursor ctermbg=15 ctermfg=8
"hi CursorLine term=bold cterm=bold guibg=Grey40

"set colorcolumn=110
"highlight ColorColumn ctermbg=gray

set linebreak
set nowrap
set number
set tabstop=4
set softtabstop=4  "easy unindentation on backspace
set smartindent
set shiftwidth=4
set expandtab
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
set langmap=йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj,лk,дl,э',яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.,ё',ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х\{,Ъ\},ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж\:,Э\",ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б\<,Ю\>,Ё~
set secure
set exrc
colorscheme jellybeans  " + molokai, badwolf
"set t_Co=256  "256 colors mode, not using it
autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window 'vim: " . expand("%:t") . "'")
autocmd VimLeave,FocusLost * call system("tmux setw automatic-rename")
autocmd FocusLost * exec "try | w | catch | echom '' | endtry"
"au BufNewFile * start
set title
set display=lastline,uhex
set incsearch  
set autoread  " works in tmux only with vim-tmux-focus-events
set updatetime=500
set laststatus=2
let g:airline#extensions#whitespace#enabled = 0
set textwidth=0

" For mouse drag&dropping
set mouse+=a
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

"" Bindings

" Gundo plugin
inoremap <F3> <C-o>:GundoToggle<CR><ESC>
nnoremap <F3>      :GundoToggle<CR><ESC>

" Invoke shell
inoremap <F4> <C-o>:shell<CR>
nnoremap <F4>      :shell<CR>

" Compile're & run're
" FIXME: unwanted keypress occurs after <F6> execution
imap <F5> <ESC><F7>:exec (len(getqflist()) == 0) ? "call feedkeys(\"\<F6>\")" : "" <CR>  
nmap <F5>      <F7>:exec (len(getqflist()) == 0) ? "call feedkeys(\"\<F6>\")" : "" <CR>

" Run
inoremap <F6> <C-o>:!echo -e "\\n\| executing '%:t:r.bin' \|\n" && cd %:h && %:t:r.bin <CR>
nnoremap <F6>      :!echo -e "\\n\| executing '%:t:r.bin' \|\n" && cd %:h && %:t:r.bin <CR>

" Save're & compile
set makeprg=clang++\ -std=c++11\ -Weverything\ -Wno-c++98-compat\ -Wno-c++98-compat-pedantic\ %\ -o\ %:r.bin
set errorformat=%f:%l:%c:\ %trror:\ %m
imap <F7> <ESC><F8>:silent! exec "!echo -e '\\n\| compiling \'%:t\' \|'" \| make <CR>:redraw! \| try \| clist \| catch \| echo "> compiling completed" \| endtry <CR>
nmap <F7>      <F8>:silent! exec "!echo -e '\\n\| compiling \'%:t\' \|'" \| make <CR>:redraw! \| try \| clist \| catch \| echo "> compiling completed" \| endtry <CR>

" Save
inoremap <F8> <ESC>:w<CR>
nnoremap <F8>      :w<CR>

" Toggle wrapping
inoremap <F9> <C-o>:set wrap!<CR>
nnoremap <F9>      :set wrap!<CR>

" For competitive programming 
autocmd FileType cpp imap <F12> <ESC><F12>
autocmd FileType cpp nnoremap <F12> :0r ~/.template.cc<CR>Gdd/STARTHERE<CR>zt6<C-y>S

" For adequate pasting (thanks https://coderwall.com/p/if9mda/)
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
       set pastetoggle=<Esc>[201~
          set paste
      return ""
endfunction

nnoremap mi :try \| lnext \| catch \| lfirst \| endtry<CR>
nnoremap mo :try \| lprev \| catch \| llast  \| endtry<CR>
nnoremap mf :YcmCompleter FixIt<CR>

"imap <M-j> <C-g>j
"imap <M-k> <C-g>k
inoremap <C-l> <ESC>Go<CR><ESC>zti

"" Keys workarounds
" Navigation within a wrapped line
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nmap о j
nmap л k
vmap о j
vmap л k

nnoremap <Down> gj
nnoremap <Up> gk
nnoremap <Home> g<Home>
nnoremap <End>  g<End>
vnoremap <Down> gj
vnoremap <Up> gk
vnoremap <Home> g<Home>
vnoremap <End>  g<End>
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
inoremap <Home> <C-o>g<Home>
inoremap <End>  <C-o>g<End>

" Do not unindent empty lines
inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>


" No more typos
cmap W w
cmap ц w
cmap Ц w
cmap w1 w!
cmap W1 w!
cmap ц1 w!
cmap Ц1 w!

cmap Q q
cmap й q
cmap Й q
cmap q1 q!
cmap Q1 q!
cmap й1 q!
cmap Й1 q!

cmap qw wq
cmap Wq wq
cmap WQ wq
cmap Qw wq
cmap QW wq
cmap wq1 wq!
cmap qw1 wq!
cmap Wq1 wq!
cmap WQ1 wq!
cmap Qw1 wq!
cmap QW1 wq!

cmap цй wq
cmap йц wq
cmap Цй wq
cmap ЦЙ wq
cmap Йц wq
cmap ЙЦ wq
cmap цй1 wq!
cmap йц1 wq!
cmap Цй1 wq!
cmap ЦЙ1 wq!
cmap Йц1 wq!
cmap ЙЦ1 wq!


filetype detect
if &ft == "cpp" || &ft == "c"
  set matchpairs+=<:>
endif

"TODO
"1. Bind key ai si / noai nosi
"2. Bind key to highlight 81th column
"3. Bind key for unhighlighting search
"4. Unidentation on backspace
"x. Commenting lines by hotkey
"6. english / vs russian .
"
"Some useful tips: https://habrahabr.ru/post/265441/
"
"7.  Visual buffers & tabs; nice hotkeys for them
"       https://habrahabr.ru/post/102373/#comment_3179620
"       https://habrahabr.ru/post/102373/#comment_3181848
"8.  Better parens/braces/brackets/quotes autocompletion (this one does not recognize ^W); Surrounding
"x.  Insertion with no crazy autoindentation
"10. Syntax-based blocks folding
"11. Semantic and keywords based autocompletion (C++ at least, Python ideally)
"xx. No softtab unindentation after any non-space symbols
"13. Look at abilities of git integration plugins
"14. Live diff hotkey
"
"15. Set up hex editing environment http://vim.wikia.com/wiki/Improved_hex_editing
"
"16. Bind <C-CR> to newline; standard emacs/readline hotkeys; <C-j> <C-k>
"17. Set option for leaving some strings between cursor and screen edge
"18. For sport programming, write a plugin that adds the three comment lines to the file:
"    a. creation time
"    b. last saving time
"    c. diff

" newline

" Load plugins

"let g:ycm_server_python_interpreter='/usr/bin/python3'  "seemed to be needed to start ycm in archlinux
"let g:AutoPairsFlyMode = 1
filetype off

" Clang Complete Settings
let g:clang_auto_select=1
let g:clang_restore_cr_imap=1
let g:clang_use_library=1
let g:clang_library_path='/usr/lib/libclang.so'
let g:clang_debug=1
let g:clang_complete_copen=1
let g:clang_complete_macros=1
let g:clang_complete_patterns=0
let g:ycm_allow_changing_updatetime = 0
let g:clang_memory_percent=70
let g:clang_user_options=' || exit 0'
let g:ycm_confirm_extra_conf=0
let g:ycm_auto_trigger=0
let g:ycm_enable_diagnostic_signs=0
let g:ycm_always_populate_location_list=1
let g:ycm_collect_identifiers_from_tags_files=1
set previewheight=1
set pumheight=1
set completeopt=menu,longest
map <F2> <C-]>
"imap <C-Space> <C-X><C-U>

" Supertab settings
let g:SuperTabDefaultCompletionType = "<c-n>"

call vundle#rc()
Plugin 'sickill/vim-pasta'
""Plugin 'clang_complete'
"Plugin 'vim-inccomplete'
"Plugin 'supertab'
if (&ft == "cpp" || &ft == "c")
    " Plugin 'Valloric/YouCompleteMe'  " it takes so much memory
    Plugin 'octol/vim-cpp-enhanced-highlight'
endif
"Plugin 'rust-lang/rust.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tmux-plugins/vim-tmux-focus-events'  " focus-events must be set to 'on' in .tmux.conf
Plugin 'godlygeek/tabular'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'tomtom/tcomment_vim'
Plugin 'sjl/gundo.vim'
Plugin 'chrisbra/Recover.vim'
"Plugin 'tpope/vim-surround'  " crazy keybindings?
"Plugin 'xolox/vim-misc'  " some plugins by this author look attractive
"Plugin 'svermeulen/vim-easyclip'

filetype plugin indent on  "what is this?


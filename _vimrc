" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2014 Feb 05
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set smartcase

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
set background=dark
set nois
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  "filetype plugin indent on
  set cindent

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"use clipboard for os
set clipboard=unnamed

"keymapping
nnoremap [ %
nnoremap ] %
nnoremap <Space>l $
nnoremap <Space>o o<Esc>
nnoremap <Space>u i# -*- coding: utf-8 -*-<Esc>
nnoremap <Space>i iif __name__=="__main__":<Return>
inoremap <C-d> <C-c><C-d>
inoremap <C-u> <C-c><C-u>
inoremap <C-j> <C-g><C-j>
inoremap <C-k> <C-g><C-k>
vnoremap * "zy:let @/ = @z<CR>n


set fileencoding=utf-8

"sÔÌÇÁ
set number

"tab setting
set tabstop=4
set shiftwidth=4
set expandtab

"Neobundle setting
"mkdir ~/.vim/bundle
"git clone https://github.com/Shougo/neobundle.vim
if isdirectory(expand("~/.vim/bundle/neobundle.vim"))
    if has('vim_starting')
        set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif
    
    call neobundle#begin(expand('~/.vim/bundle/'))
    
    "add scripts here
    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/vimfiler'
"   neocomplete need lua
"    NeoBundle 'Shougo/neocomplete'
    NeoBundle 'davidhalter/jedi-vim'
    NeoBundle 'nathanaelkane/vim-indent-guides'
    NeoBundle 'nanotech/jellybeans.vim'
    NeoBundle 'tomasr/molokai'
    NeoBundle 'vim-scripts/taglist.vim'
    NeoBundle 'szw/vim-tags'
    
    call neobundle#end()

endif

filetype plugin indent on

let s:is_cygwin  =  has('win32unix')
let s:is_windows =  has('win32') || has('win64')
let s:is_linux   =  has('unix')
let s:is_mac     =  has('mac')

"set backupfile and undofile
if s:is_cygwin || s:is_linux 
    "cygwin
    if isdirectory(expand("~/.vim/back_undo"))
        "undofile directory
        set undodir=~/.vim/back_undo
        
        "backupfile directory
        set backupdir=~/.vim/back_undo
    elseif
        echo 'not exist backup directory.'
    endif
elseif s:is_windows
    "not cygwin setting
    if isdirectory(expand("D:/active/work/tech/99_textbkup/"))
        "undofile directory
        set undodir=D:\active\work\tech\99_textbkup
        
        "backupfile directory
        set backupdir=D:\active\work\tech\99_textbkup
    elseif
        echo 'not exist backup directory.'
    endif
endif

"set colorscheme
if s:is_cygwin || s:is_linux 
    if &term =~# '^xterm' && &t_Co < 256
        set t_Co=256  " Extend terminal color of xterm
    endif
    if &term !=# 'cygwin'  " not in command prompt
        " Change cursor shape depending on mode
        let &t_ti .= "\e[1 q"
        let &t_SI .= "\e[5 q"
        let &t_EI .= "\e[1 q"
        let &t_te .= "\e[0 q"
    endif
    colorscheme molokai
    set background=dark
elseif s:is_windows
    colorscheme darkblue
    set background=dark
endif

"vim-indent-guides setting
if s:is_cygwin || s:is_linux
    let g:indent_guides_auto_colors=0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=85
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=73
    let g:indent_guides_enable_on_vim_startup=1
    let g:indent_guides_guide_size=1
endif

" taglist setting
if s:is_cygwin || s:is_linux
    set tags = tags
    let Tlist_Ctags_Cmd = "/usr/bin/ctags"
    let Tlist_Show_One_File = 1
    let Tlist_Use_Right_Window = 1
    let Tlist_Exit_OnlyWindow = 1
endif

""neocomplete setting
"if s:is_cygwin || s:is_linux
"    let g:neocomplete#enable_at_startup = 1
"    let g:neocomplete#enable_ignore_case = 1
"    let g:neocomplete#enable_smart_case = 1
"    if !exists('g:neocomplete#keyword_patterns')
"        let g:neocomplete#keyword_patterns = {}
"    endif
"    let g:neocomplete#keyword_patterns._ = '\h\w*'
"    
"    highlight Pmenu ctermbg=248 guibg=#606060
"    highlight PmenuSel ctermbg=159 guifg=#dddd00 guibg=#1f82cd
"    highlight PmenuSbar ctermbg=0 guibg=#d6d6d6
"endif
"
""jedi-vim with neocomplete setting
"if s:is_cygwin || s:is_linux
"	autocmd FileType python setlocal omnifunc=jedi#completions
"	let g:jedi#completions_enabled = 0
"	let g:jedi#auto_vim_configuration = 0
"	let g:jedi#smart_auto_mappings = 0
"	if !exists('g:neocomplete#force_omni_input_patterns')
"	  let g:neocomplete#force_omni_input_patterns = {}
"	endif
"	let g:neocomplete#force_omni_input_patterns.python =
"	\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
"	" alternative pattern: '\h\w*\|[^. \t]\.\w*'
"endif

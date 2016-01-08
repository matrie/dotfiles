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
  filetype plugin indent on
  set cindent

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

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
  NeoBundle 'davidhalter/jedi-vim'
  NeoBundle 'nathanaelkane/vim-indent-guides'
  NeoBundle 'nanotech/jellybeans.vim'
  NeoBundle 'tomasr/molokai'
  
  call neobundle#end()
  
  filetype plugin indent on

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


set fileencoding=utf-8

"sÔÌÇÁ
set number

"tab setting
set tabstop=4
set shiftwidth=4
set expandtab

"vim-indent-guides
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=85
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=73
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1

let s:is_cygwin  =  has('win32unix')
let s:is_windows =  has('win32') || has('win64')
let s:is_linux   =  has('unix')
let s:is_mac     =  has('mac')

"set backupfile and undofile
if s:is_cygwin || s:is_linux 
  "cygwin
  if isdirectory(expand("~/.vim"))
    "undofile directory
    set undodir=~/.vim/back_undo
    
    "backupfile directory
    set backupdir=~/.vim/back_undo
  endif
elseif s:is_windows
  "not cygwin setting
  if isdirectory(expand("D:/active/work/tech/99_textbkup/"))
    "undofile directory
    set undodir=D:\active\work\tech\99_textbkup
    
    "backupfile directory
    set backupdir=D:\active\work\tech\99_textbkup
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

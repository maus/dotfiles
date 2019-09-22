set nocompatible
set encoding=utf-8
set fileencoding=utf-8

filetype plugin on
syntax enable
set showmatch
set t_Co=256

set splitright
set splitbelow

set wildmenu
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*.map,*.min.css
set wildignore+=node_modules/*,bower_components/*

set hidden

filetype plugin indent on
" 2 spaces please
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
" Round indent to nearest multiple of 2
set shiftround
" No line-wrapping
set nowrap
" Spell-check always on
set spell
" Underline spelling mistakes
highlight SpellBad cterm=underline
" Underscores denote words
set iskeyword-=_
" No extra spaces when joining lines
set nojoinspaces
" Interpret numbers with leading zeroes as decimal, not octal
set nrformats-=octal
" Auto-format comments
set formatoptions+=jroqn1


" Show status line
set laststatus=2
" Show what mode you’re currently in
set showmode
" Show what commands you’re typing
set showcmd
" Allow modelines
set modeline
" Show current line and column position in file
set ruler
" Show file title in terminal tab
set title
" Show invisibles
set list
set listchars=tab:»-,trail:·
" Set relative line numbers...
set relativenumber
" ...but absolute numbers on the current line (hybrid numbering)
set number
" Force the cursor onto a new line after 80 characters
set textwidth=80
" However, in Git commit messages, let’s make it 72 characters
autocmd FileType gitcommit set textwidth=72
" Colour the column just after our line limit so that we don’t type over it
set colorcolumn=+1
" In Git commit messages, also colour the 51st column (for titles)
autocmd FileType gitcommit set colorcolumn+=51
" Highlight current line
set cursorline

" Don’t keep results highlighted after searching...
set nohlsearch
" ...just highlight as we type
set incsearch
" Ignore case when searching...
set ignorecase
" ...except if we input a capital letter
set smartcase

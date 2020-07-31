" 定义快捷键的前缀，即<Leader>
let mapleader=" "


" 当文件在外部被改变时自动重新载入
set autoread

filetype on
" 根据侦测到的不同类型加载对应的插件
filetype plugin on
" 定义快捷键到行首和行尾 nmap LB 0 nmap LE $
nnoremap <C-]> <esc>
" 设置快捷键将选中文本块复制至系统剪贴板
vnoremap <Leader>y "+y
" 设置快捷键将系统剪贴板内容粘贴至 vim
nmap <Leader>p "+p
" 定义快捷键关闭当前分割窗口
nmap <Leader>q :q<CR>
" 定义快捷键保存当前窗口内容
nmap <Leader>w :w<CR>
" 定义快捷键保存所有窗口内容并退出 vim
nmap <Leader>WQ :wa<CR>:qa<CR>
" 不做任何保存，直接退出 vim
nmap <Leader>Q :qa!<CR>
" 依次遍历子窗口
nnoremap nw <C-W><C-W>
" 定义快捷键在结对符之间跳转
nmap <Leader>M %
" 开启实时搜索功能
set incsearch
" 搜索时大小写不敏感
set ignorecase
" 关闭兼容模式
set nocompatible
" vim 自身命令行模式智能补全
set wildmenu
" 自适应不同语言的智能缩进
filetype indent on
set autoindent
" 将制表符扩展为空格
set expandtab
" 设置编辑时制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=4
" 启动时不显示信息
set shortmess=atI
" 禁止光标闪烁
set gcr=a:block-blinkon0
" 禁止显示滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
" 禁止显示菜单和工具条
set guioptions-=m
set guioptions-=T
" 显示光标当前位置
set ruler
" 开启行号显示
set nu
set relativenumber
" 高亮显示当前行/列
set cursorline
" set cursorcolumn
" 高亮显示搜索结果
set hlsearch
" 禁止折行
" 支持滚动
set mouse=a
set nowrap
" 开启语法高亮
syntax enable
" 允许用指定语法高亮配色方案替换默认方案
syntax on
" 设置退格键可用
set backspace=indent,eol,start
" 设置匹配模式，类似当输入一个左括号时会匹配相应的右括号
set showmatch


" 基于缩进或语法进行代码折叠
"set foldmethod=indent
set foldmethod=syntax
" 启动 vim 时关闭折叠代码
set nofoldenable

nnoremap <C-h> <C-w>h " goto the left window <
nnoremap <C-j> <C-w>j " goto the next window V
nnoremap <C-k> <C-w>k " goto the preivous windows ^
nnoremap <C-l> <C-w>l " goto the right window >
nnoremap <C-=> <C-w>= " let all windows have the same width
nnoremap <C-x> <C-w>x " switch window's position
nnoremap <C-q> <C-w>q " quit current window
nnoremap <C-c> <C-w>c " close current window

" golang
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage)
autocmd FileType go nmap <Leader>gd <Plug>(go-doc)

" python
autocmd FileType python nnoremap <Leader>r :exec '!python' shellescape(@%, 1)<cr>
autocmd FileType python nnoremap <Leader>cr :exec '!clear;python' shellescape(@%, 1)<cr>

let $PLUG_DIR = expand("$HOME/.vim")
let $PLUG_FILE = expand("$PLUG_DIR/plug.vim")
let $BUNDLE = expand("$PLUG_DIR/plugged")

if empty(glob(expand("$PLUG_FILE")))
  silent !curl -fLo $PLUG_FILE --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif
source $PLUG_FILE

call plug#begin(expand($BUNDLE))

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }
Plug 'nsf/gocode', {'rtp': 'nvim/'} " Install plugin from https://github.com/nsf/gocode
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'NLKNguyen/papercolor-theme'
Plug 'jiangmiao/auto-pairs'

call plug#end()

" theme
" set t_Co=256
set background=dark
colorscheme PaperColor

" vim-gitgutter
set updatetime=100

" nerdtree
let NERDTreeShowHidden = 1
function! ToggleNERDTreeOnStartup()
    if @% == ""
        NERDTree
    endif
endfunction
au VimEnter * call ToggleNERDTreeOnStartup()
map <C-n> :NERDTreeToggle<CR>
" close vim if the only window left open is a NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=238
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236
:nmap <silent> <Leader>i <Plug>IndentGuidesToggle

" vim-airline
let g:airline#extensions#tabline#enabled = 1

" vim-go
" let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_template_autocreate = 0

let g:go_metalinter_command = "golangci-lint"
let g:go_metalinter_enabled = ['govet', 'golint', 'errcheck', 'gocyclo', 'deadcode', 'gosimple', 'staticcheck']
let g:go_metalinter_autosave_enabled = ['govet', 'golint', 'errcheck', 'gocyclo', 'deadcode', 'gosimple', 'staticcheck']
let g:go_metalinter_deadline = "60s"

let g:go_auto_sameids = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

let g:go_auto_type_info = 1
let g:go_metalinter_autosave = 1

let g:go_addtags_transform = "snakecase"

" set rtp+=$GOPATH/src/golang.org/x/lint/misc/vim
" autocmd BufWritePost,FileWritePost *.go execute 'lint' | cwindow

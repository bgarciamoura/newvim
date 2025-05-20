let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/.config/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +21 ~/.config/nvim/init.lua
badd +40 ~/.config/nvim/lua/plugins/blink.lua
badd +15 ~/.config/nvim/lua/plugins/hardtime.lua
badd +181 ~/.config/nvim/lua/plugins/lsp.lua
badd +11 lua/plugins/lazydev.lua
badd +29 health://
badd +1 ~/.config/nvim/lua/core/keymaps/hardtime_spec.lua
badd +1 ~/.config/nvim/lua/core/keymaps/engine.lua
badd +1 ~/.config/nvim/lua/core/keymaps/insert_spec.lua
badd +193 ~/.config/nvim/lua/core/autocmds.lua
badd +22 ~/.config/nvim/lua/core/lsp-completion-fix.lua
badd +1 lua/plugins/bl
badd +80 ~/.config/nvim/lua/core/keymaps/lsp_spec.lua
badd +1 ~/.config/nvim/lua/core/lsp-enhanced-capabilities.lua
badd +39 ~/.config/nvim/lua/core/keymaps/telescope_spec.lua
badd +508 ~/.config/nvim/lua/plugins/blink-snippets.lua
argglobal
%argdel
edit ~/.config/nvim/lua/plugins/blink-snippets.lua
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt ~/.config/nvim/lua/plugins/blink.lua
setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
let s:l = 508 - ((34 * winheight(0) + 20) / 40)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 508
normal! 06|
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :

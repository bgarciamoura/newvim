" Detect macro files by pattern or manual command
autocmd BufRead,BufNewFile *.macro set filetype=macrolang
autocmd BufRead,BufNewFile macros.txt set filetype=macrolang
autocmd BufRead,BufNewFile eventMacros.txt set filetype=macrolang

" Detect OpenKore config files
autocmd BufRead,BufNewFile config.txt set filetype=okconfig
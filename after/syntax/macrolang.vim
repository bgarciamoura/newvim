" Vim syntax file for Perl-like macro language
" Language: MacroLang (Perl-style automation macros)
" Maintainer: Auto-generated
" Last Change: 2025

if exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword macroKeyword sub my return if elsif else for while foreach unless
syn keyword macroKeyword automacro macro call timeout priority exclusive run-once
syn keyword macroKeyword BaseLevel JobLevel InInventory Zeny ConfigKeyNot
syn keyword macroBuiltin do conf log error warning stop pause exists defined

" Operators
syn match macroOperator "[-+*/%=<>!&|^~]"
syn match macroOperator "[-+*/%=<>!&|^~]="
syn match macroOperator "=="
syn match macroOperator "!="
syn match macroOperator "<="
syn match macroOperator ">="
syn match macroOperator "&&"
syn match macroOperator "||"
syn match macroOperator "++"
syn match macroOperator "--"
syn match macroOperator "=\~"
syn match macroOperator "!\~"

" Variables
syn match macroVariable "\$[a-zA-Z_][a-zA-Z0-9_]*"
syn match macroVariable "@[a-zA-Z_][a-zA-Z0-9_]*"
syn match macroVariable "%[a-zA-Z_][a-zA-Z0-9_]*"
syn match macroVariable "\$\$"

" Special variables
syn match macroSpecialVar "\$\(char\|config\|lvl\)\>"
syn match macroSpecialVar "\$\.\(lvl\|weight\|weightpercent\)\>"

" Numbers
syn match macroNumber "\<\d\+\>"
syn match macroNumber "\<\d\+\.\d*\>"
syn match macroNumber "\<\.\d\+\>"

" Strings
syn region macroString start=+"+ skip=+\\"+ end=+"+ contains=macroVariable
syn region macroString start=+'+ skip=+\\'+ end=+'+ contains=macroVariable

" Comments (both # style and // style)
syn match macroComment "#.*$" contains=macroTodo
syn match macroComment "//.*$" contains=macroTodo

" Section headers (lines starting with #---- and ending with ----# or similar)
syn match macroSection "^#-\+$"
syn match macroSection "^#-\+.*-\+#\?$"

" Regex patterns
syn region macroRegex start="/" end="/" skip="\\/" contains=macroRegexSpecial
syn match macroRegexSpecial contained "\\[nrtbfav\\]"
syn match macroRegexSpecial contained "\\[0-9]\+"
syn match macroRegexSpecial contained "[\[\](){}.*+?^$|]"

" Hash/Array access
syn match macroHashAccess "{[^}]*}" contains=macroString,macroVariable
syn match macroArrayAccess "\[[^\]]*\]" contains=macroString,macroVariable,macroNumber

" Function calls
syn match macroFunction "\w\+\s*("me=e-1

" Config commands
syn match macroConfigCmd "do\s\+conf\s\+\w\+"
syn match macroConfigCmd "do\s\+\(move\|talknpc\|buy\|eq\|store\|i\|autosell\|rodex\|ai\)\>"

" Map names and coordinates
syn match macroMapName "'[a-zA-Z0-9_]\+'" contains=macroString
syn match macroCoords "\<\d\+,\s*\d\+\>"

" Item names in square brackets
syn region macroItemName start=+\[+ end=+\]+ contains=macroString

" Percentages
syn match macroPercent "\<\d\+%"

" Conditions in automacro
syn match macroCondition "^\s*\(BaseLevel\|JobLevel\|InInventory\|Zeny\|ConfigKeyNot\|BusMsg\)\>"

" Todo in comments
syn keyword macroTodo TODO FIXME XXX NOTE contained

" Highlighting
hi def link macroKeyword         Keyword
hi def link macroBuiltin         Function
hi def link macroOperator        Operator
hi def link macroVariable       Identifier
hi def link macroSpecialVar     Special
hi def link macroNumber         Number
hi def link macroString         String
hi def link macroComment        Comment
hi def link macroSection        PreProc
hi def link macroRegex          String
hi def link macroRegexSpecial   Special
hi def link macroHashAccess     Special
hi def link macroArrayAccess    Special
hi def link macroFunction       Function
hi def link macroConfigCmd      Statement
hi def link macroMapName        Constant
hi def link macroCoords         Number
hi def link macroItemName       Constant
hi def link macroPercent        Number
hi def link macroCondition      Conditional
hi def link macroTodo           Todo

let b:current_syntax = "macrolang"
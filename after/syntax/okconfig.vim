" OpenKore Configuration Syntax Highlighting
" For config.txt files in OpenKore bot system

if exists("b:current_syntax")
  finish
endif

" Comments - lines starting with #
syn match okConfigComment "#.*$" contains=okConfigTodo
syn match okConfigTodo contained "\<\(TODO\|FIXME\|NOTE\|XXX\|HACK\)\>"

" Section headers - multiple # symbols
syn match okConfigSectionHeader "^#\{3,\}.*#\{3,\}$"
syn match okConfigSectionHeader "^#[-=]\+.*[-=]\+#*$"

" Key-value configuration pairs
syn match okConfigKey "^\s*\w\+\s*\ze[0-9a-zA-Z_@./%{]" 
syn match okConfigKeyword "^\s*\(server\|username\|password\|char\|serverType\|master\|loginPinCode\)\s\+\ze"
syn match okConfigKeyword "^\s*\(XKore\|attackAuto\|itemsTakeAuto\|lockMap\|saveMap\)\s\+\ze"

" OpenKore skill names and identifiers
syn match okConfigSkill "\<MG_\w\+\>"
syn match okConfigSkill "\<AL_\w\+\>"
syn match okConfigSkill "\<WZ_\w\+\>"
syn match okConfigSkill "\<PR_\w\+\>"
syn match okConfigSkill "\<TF_\w\+\>"
syn match okConfigSkill "\<MC_\w\+\>"
syn match okConfigSkill "\<AC_\w\+\>"

" Block structures
syn region okConfigBlock start="{" end="}" contains=ALL fold transparent

" Special configuration blocks
syn match okConfigBlockName "^\s*\(attackSkillSlot\|useSelf_skill\|partySkill\|buyAuto\|sellAuto\|autoBreakTime\|doCommand\)\>\s*\w*\s*{"me=e-1
syn match okConfigBlockName "^\s*\(attackComboSlot\|monsterSkill\|useSelf_item\|getAuto\|autoConfChange\)\>\s*\w*\s*{"me=e-1

" Numbers and boolean values
syn match okConfigNumber "\<\d\+\>"
syn match okConfigFloat "\<\d\+\.\d\+\>"
syn match okConfigBoolean "\<\(0\|1\|yes\|no\|true\|false\|on\|off\)\>"
syn match okConfigPercentage "\<\d\+%\>"

" Operators and comparison
syn match okConfigOperator "[<>=!]"
syn match okConfigOperator "[<>=!]="
syn match okConfigOperator "\<\(and\|or\|not\)\>"

" URLs and network addresses  
syn match okConfigURL "https\?://[^\s]\+"
syn match okConfigIP "\<\d\+\.\d\+\.\d\+\.\d\+\>"
syn match okConfigPort ":\d\+\>"

" String values (quoted and unquoted)
syn region okConfigString start='"' end='"' skip='\\"' contains=okConfigSpecial
syn region okConfigString start="'" end="'" skip="\\'" contains=okConfigSpecial
syn match okConfigSpecial contained "\\."

" Monster and item names
syn match okConfigMonster "\<\(Spore\|Poring\|Drops\|Ancient Willow\|Worm Tail\|Boa\)\>"
syn match okConfigItem "\<\d\+\>" contained

" Map names
syn match okConfigMap "\<\w\+_\w\+\d*\>"
syn match okConfigMap "\<\(payon\|izlude\|prontera\|geffen\|alberta\|morroc\)\>"

" Coordinate patterns
syn match okConfigCoordinate "\<\d\+\s\+\d\+\>"

" Email addresses  
syn match okConfigEmail "\<[a-zA-Z0-9._%+-]\+@[a-zA-Z0-9.-]\+\.[a-zA-Z]\{2,\}\>"

" Define highlighting groups
hi def link okConfigComment        Comment
hi def link okConfigTodo          Todo
hi def link okConfigSectionHeader  Title
hi def link okConfigKey           Identifier
hi def link okConfigKeyword       Keyword
hi def link okConfigSkill         Function
hi def link okConfigBlock         Normal
hi def link okConfigBlockName     Special
hi def link okConfigNumber        Number
hi def link okConfigFloat         Number
hi def link okConfigBoolean       Boolean
hi def link okConfigPercentage    Number
hi def link okConfigOperator      Operator
hi def link okConfigURL           Underlined
hi def link okConfigIP            Constant
hi def link okConfigPort          Number
hi def link okConfigString        String
hi def link okConfigSpecial       SpecialChar
hi def link okConfigMonster       Type
hi def link okConfigItem          Number
hi def link okConfigMap           Constant
hi def link okConfigCoordinate    Number
hi def link okConfigEmail         Underlined

let b:current_syntax = "okconfig"
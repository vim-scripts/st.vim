" Vim syntax file
" Language:     Smalltalk
" Maintainer:   Jānis Rūcis <parasti@gmail.com>
" Last Change:  2007-03-24
" Remark:       Probably contains a lot of GNU Smalltalk-specific stuff.

if exists("b:current_syntax")
    finish
endif

" Letters and digits only.
setlocal iskeyword=a-z,A-Z,48-57

" Still not perfect.
syn sync minlines=300

syn case match

" -----------------------------------------------------------------------------

syn match stError /\S/ contained
syn match stBangError /!/ contained

syn match stDelimError /)/
syn match stDelimError /\]/
syn match stDelimError /}/

" stMethodMembers holds groups that can appear in a method.
syn cluster stMethodMembers contains=stDelimError

" -----------------------------------------------------------------------------

syn keyword stTodo FIXME TODO XXX contained
syn region stComment
    \ start=/"/ end=/"/
    \ contains=stTodo
    \ fold

syn cluster stMethodMembers add=stComment

" -----------------------------------------------------------------------------

syn keyword stNil nil
syn keyword stBoolean true false
syn keyword stKeyword self super

syn cluster stMethodMembers add=stNil,stBoolean,stKeyword

" -----------------------------------------------------------------------------

syn region stMethods
    \ matchgroup=stMethodDelims
    \ start=/!\%(\K\k*\.\)*\K\k*\s\+\%(class\s\+\)\?methodsFor:[^!]\+!/
    \ end=/\_s\@<=!/
    \ contains=stError,stMethod,stComment
    \ transparent fold

" -----------------------------------------------------------------------------

" Unary messages
syn region stMethod
    \ matchgroup=stMessagePattern
    \ start=/\K\k*\%(\_s\+\)\@=/
    \ end=/!/
    \ contains=@stMethodMembers
    \ contained transparent fold

" Binary messages
syn region stMethod
    \ matchgroup=stMessagePattern
    \ start=/[-+*/~|,<>=&@?\\%]\{1,2}\s\+\K\k*/
    \ end=/!/
    \ contains=@stMethodMembers
    \ contained transparent fold

" Keyword messages
syn region stMethod
    \ matchgroup=stMessagePattern
    \ start=/\%(\K\k*:\s\+\K\k*\_s\+\)*\K\k*:\s\+\K\k*/
    \ end=/!/
    \ contains=@stMethodMembers
    \ contained transparent fold

" -----------------------------------------------------------------------------

" Format spec, yeah right.  :)
syn match stFormatSpec /%\d/ contained

syn match stSpecialChar /''/ contained

syn region stString
    \ matchgroup=stString
    \ start=/'/ skip=/''/ end=/'/
    \ contains=stSpecialChar,stFormatSpec

syn match stCharacter /$./

" stLiterals holds all, uh. literals.
syn cluster stLiterals contains=stString,stCharacter
syn cluster stMethodMembers add=stString,stCharacter

" -----------------------------------------------------------------------------

syn region stSymbol
    \ matchgroup=stSymbol
    \ start=/#'/ skip=/''/ end=/'/
    \ contains=stSpecialChar
syn match stSymbol /#\%(\K\k*\|:\)\+/
syn match stSymbol /#[-+*/~|,<>=&@?\\%]\{1,2}/

syn cluster stLiterals add=stSymbol
syn cluster stMethodMembers add=stSymbol

" -----------------------------------------------------------------------------

" Mainly for highlighting mismatched parentheses
syn region stUnit matchgroup=stUnitDelims start=/(/ end=/)/ transparent

syn cluster stMethodMembers add=stUnit

" -----------------------------------------------------------------------------

" Its ugly look is entirely stEval's fault.
syn match stArrayConst /\%(#\[\|#\@<!#(\)/me=e-1 nextgroup=stArray,stByteArray

syn region stArray
    \ matchgroup=stArrayDelims
    \ start=/(/ end=/)/
    \ contains=@stLiterals,stArray,stByteArray,stNil,stBoolean,stError
    \ contained transparent fold
syn region stByteArray
    \ matchgroup=stByteArrayDelims
    \ start=/\[/ end=/\]/
    \ contains=stNumber,stError
    \ contained transparent fold

syn cluster stLiterals add=stArrayConst
syn cluster stMethodMembers add=stArrayConst

" -----------------------------------------------------------------------------

syn match stBindingDelims /[{}]/ contained
syn match stBinding /#{\s*\%(\K\k*\.\)*\K\k*\s*}/ contains=stBindingDelims

syn region stEval
    \ matchgroup=stEvalDelims
    \ start=/##(/ end=/)/
    \ contains=@stMethodMembers
    \ transparent

syn cluster stLiterals add=stBinding,stEval
syn cluster stMethodMembers add=stBinding,stEval

" -----------------------------------------------------------------------------

" These two patterns are built based on the assumption that if there's
" no radix, there are no letters in the number.  Otherwise it quickly
" turns into a nightmare with no way to tell the difference between a
" word in all-caps and a number.  Perhaps there's a better way.
syn match stNumber
    \ /-\?\<\d\+\%(\.\d\+\)\?\%([deqs]\%(-\?\d\+\)\?\)\?\>/
    \ display
syn match stNumber
    \ /\<\d\+r-\?[0-9A-Z]\+\%(\.[0-9A-Z]\+\)\?\%([deqs]\%(-\?\d\+\)\?\)\?\>/
    \ display

syn cluster stLiterals add=stNumber
syn cluster stMethodMembers add=stNumber

" -----------------------------------------------------------------------------

" You should FIXME because I, as a region, start at any less-than sign.
"
" syn region stPragma
"     \ matchgroup=stPragma
"     \ start=/</ end=/>/
"     \ contains=stString,stArrayConst,stSymbol
"     \ contained
" 
" syn cluster stMethodMembers add=stPragma

" -----------------------------------------------------------------------------

" Pretty-printing for various groups.
syn match stDelimiter /|/ contained display
syn match stIdentifier /\K\k*/ contained display

" -----------------------------------------------------------------------------

" To FIXME or not to FIXME?  I will match at "boolean | boolean | boolean".
syn region stTemps
    \ matchgroup=stTempDelims
    \ start=/|/ end=/|/
    \ contains=stIdentifier,stError

syn cluster stMethodMembers add=stTemps

" -----------------------------------------------------------------------------

" Blocks

" I made up the name.
syn match stBlockConditional /\<whileTrue\>:\?/ contained
syn match stBlockConditional /\<whileFalse\>:\?/ contained

syn match stBlockTemps
    \ /\[\@<=\_s*\%(:\K\k*\s\+\)*:\K\k*\s*|/
    \ contains=stIdentifier,stDelimiter
    \ contained transparent

syn region stBlock
    \ matchgroup=stBlockDelims
    \ start=/\[/ end=/\]/
    \ contains=@stMethodMembers,stBlockTemps,stBangError
    \ nextgroup=stBlockConditional skipempty skipwhite
    \ transparent fold

syn cluster stMethodMembers add=stBlock

" -----------------------------------------------------------------------------

syn match stAssign /:=/
syn match stAnswer /\^/

syn cluster stMethodMembers add=stAssign,stAnswer

" -----------------------------------------------------------------------------

syn region stCollect
    \ matchgroup=stCollectDelims
    \ start=/{/ end=/}/
    \ contains=@stLiterals,stCollect,stBlock,stNil,stKeyword,stBoolean,stAssign,stComment,stBangError
    \ transparent fold

syn cluster stMethodMembers add=stCollect

" -----------------------------------------------------------------------------

syn match stConditional /\<ifTrue:/
syn match stConditional /\<ifFalse:/
syn match stConditional /\<and:/
syn match stConditional /\<eqv:/
syn match stConditional /\<or:/
syn match stConditional /\<xor:/
syn match stConditional /\<not\>/

syn cluster stMethodMembers add=stConditional

" -----------------------------------------------------------------------------

hi def link stAnswer           Statement
hi def link stArrayConst       Constant
hi def link stArrayDelims      Delimiter
hi def link stAssign           Operator
hi def link stBangError        Error
hi def link stBinding          Constant
hi def link stBindingDelims    Delimiter
hi def link stBlockConditional Conditional
hi def link stBlockDelims      Delimiter
hi def link stBoolean          Boolean
hi def link stByteArrayDelims  Delimiter
hi def link stCharacter        Character
hi def link stCollectDelims    Delimiter
hi def link stComment          Comment
hi def link stConditional      Conditional
hi def link stDelimError       Error
hi def link stDelimiter        Delimiter
hi def link stError            Error
hi def link stEvalDelims       PreProc
hi def link stFormatSpec       Special
hi def link stIdentifier       Identifier
hi def link stKeyword          Keyword
hi def link stMessagePattern   Function
hi def link stMethodDelims     Statement
hi def link stNil              Keyword
hi def link stNumber           Number
hi def link stSpecialChar      SpecialChar
hi def link stString           String
hi def link stSymbol           Constant
hi def link stTempDelims       Delimiter
hi def link stTodo             Todo

" -----------------------------------------------------------------------------

let b:current_syntax = "st"

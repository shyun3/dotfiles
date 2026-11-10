" Taken from:
" https://gist.github.com/emilien-jegou/4792b9cd54800a165c15e50ee06f5b8b

" Rune vim syntax file
" Language:    Rune
" Last Change:  2026

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" ===========================================================================
" Keywords {{{1
" ===========================================================================

" Control flow {{{2
syn keyword   runeConditional  match if else
syn keyword   runeRepeat       loop while
" `for` needs syn match so it takes priority over plain identifiers
syn match     runeRepeat       /\<for\>/
syn keyword   runeRepeat       in

" Core keywords {{{2
syn keyword   runeKeyword      break
syn keyword   runeKeyword      continue
syn keyword   runeKeyword      crate
syn keyword   runeKeyword      default
syn keyword   runeKeyword      fn         nextgroup=runeFuncName skipwhite skipempty
syn keyword   runeKeyword      impl
syn keyword   runeKeyword      let
syn keyword   runeKeyword      mod        nextgroup=runeIdentifier skipwhite skipempty
syn keyword   runeKeyword      pub        nextgroup=runePubScope skipwhite skipempty
syn keyword   runeKeyword      return
syn keyword   runeKeyword      select
syn keyword   runeKeyword      use        nextgroup=runeModPath skipwhite skipempty
syn keyword   runeKeyword      yield
syn keyword   runeKeyword      const
syn keyword   runeKeyword      move

" Type-definition keywords {{{2
syn keyword   runeStructure    struct enum  nextgroup=runeIdentifier skipwhite skipempty

" Async keywords {{{2
" `async` only acts as a keyword before `fn`, `|`, `{`, or a space/newline
syn match     runeAsync        "\<async\%(\s\|\n\)\@="
syn keyword   runeAwait        await

" Operator keywords {{{2
" `as`  – type coercion / import renaming
" `is`  – runtime type test:     value is Foo
" `not` – negation / compound:   value is not Foo
syn keyword   runeOperator     as is not

" Self / super / path keywords {{{2
syn keyword   runeSelf         self
syn keyword   runeSuper        super

" Booleans {{{2
syn keyword   runeBoolean      true false

" Reserved (not yet active) keywords {{{2
" These are parsed by the compiler but have no semantic meaning yet.
" Highlighting them as errors helps authors avoid using them as identifiers.
syn keyword   runeReservedKeyword  abstract alignof become do offsetof
syn keyword   runeReservedKeyword  override sizeof typeof unsafe virtual where
syn keyword   runeReservedKeyword  ref static type

" ===========================================================================
" Visibility scope  pub(crate), pub(super), etc. {{{1
" ===========================================================================
syn keyword   runePubScopeCrate  crate   contained
syn match     runePubScopeDelim  /[()]/  contained
syn match     runePubScope       /([^()]*)/ contained transparent
    \ contains=runePubScopeDelim,runePubScopeCrate,runeSuper,
    \           runeModPath,runeModPathSep,runeSelf

" ===========================================================================
" Identifiers and function names {{{1
" ===========================================================================
syn match  runeIdentifier  contains=runeIdentifierPrime
    \ "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"
    \ display contained

syn match  runeFuncName
    \ "\%(r#\)\=\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"
    \ display contained

syn match  runeRawIdent "\<r#\h\w*" contains=NONE

" ===========================================================================
" Macros {{{1
" ===========================================================================
syn match  runeAssert  "\<assert\(\w\)*!"  contained
syn match  runePanic   "\<panic\(\w\)*!"   contained
syn match  runeMacro   '\w\(\w\)*!'        contains=runeAssert,runePanic
syn match  runeMacro   '#\w\(\w\)*'        contains=runeAssert,runePanic

" Macro variable/repetition (used inside macro_rules! bodies)
syn region runeUnsupported matchgroup=runeMacroRepeatDelimiters
    \ start="$(" end="),\=[*+]" contains=TOP
syn match  runeMacroVariable "$\w\+"

" ===========================================================================
" Attributes   #[...] and #![...] {{{1
" ===========================================================================
syn region  runeAttribute
    \ start="#!\?\[" end="\]"
    \ contains=@runeAttributeContents,
    \           runeAttributeParenthesizedParens,
    \           runeAttributeParenthesizedCurly,
    \           runeAttributeParenthesizedBrackets,
    \           runeDerive

syn region  runeAttributeParenthesizedParens
    \ matchgroup=runeAttribute start="\w\%(\w\)*("rs=e end=")"re=s
    \ transparent contained
    \ contains=runeAttributeBalancedParens,@runeAttributeContents

syn region  runeAttributeParenthesizedCurly
    \ matchgroup=runeAttribute start="\w\%(\w\)*{"rs=e end="}"re=s
    \ transparent contained
    \ contains=runeAttributeBalancedCurly,@runeAttributeContents

syn region  runeAttributeParenthesizedBrackets
    \ matchgroup=runeAttribute start="\w\%(\w\)*\["rs=e end="\]"re=s
    \ transparent contained
    \ contains=runeAttributeBalancedBrackets,@runeAttributeContents

syn region  runeAttributeBalancedParens
    \ matchgroup=runeAttribute start="("rs=e end=")"re=s
    \ transparent contained
    \ contains=runeAttributeBalancedParens,@runeAttributeContents

syn region  runeAttributeBalancedCurly
    \ matchgroup=runeAttribute start="{"rs=e end="}"re=s
    \ transparent contained
    \ contains=runeAttributeBalancedCurly,@runeAttributeContents

syn region  runeAttributeBalancedBrackets
    \ matchgroup=runeAttribute start="\["rs=e end="\]"re=s
    \ transparent contained
    \ contains=runeAttributeBalancedBrackets,@runeAttributeContents

syn cluster runeAttributeContents
    \ contains=runeString,runeTemplateLiteral,
    \           runeCommentLine,runeCommentBlock,
    \           runeCommentLineDocError,runeCommentBlockDocError

" #[derive(...)] – list the common derivable traits
syn region   runeDerive      start="derive(" end=")"  contained  contains=runeDeriveTrait
syn keyword  runeDeriveTrait contained
    \ Clone Debug Default PartialEq Eq PartialOrd Ord Hash
    \ FromValue ToValue Any

" ===========================================================================
" Object literals   #{  key: value, ...  } {{{1
" ===========================================================================
" The opening  #{  is a distinct token in Rune (not an attribute).
" We highlight just the brace pair so regular block braces are unaffected.
syn match  runeObjectOpen  "#{" display

" ===========================================================================
" String literals {{{1
" ===========================================================================
syn match   runeEscapeError        display contained /\\./
syn match   runeEscape             display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match   runeEscapeUnicode      display contained /\\u{\%(\x_*\)\{1,6}}/
syn match   runeStringContinuation display contained /\\\n\s*/

" Byte strings  b"..."
syn region  runeString  matchgroup=runeStringDelimiter
    \ start=+b"+ skip=+\\\\\|\\"+ end=+"+
    \ contains=runeEscape,runeEscapeError,runeStringContinuation

" Regular strings  "..."
syn region  runeString  matchgroup=runeStringDelimiter
    \ start=+"+ skip=+\\\\\|\\"+ end=+"+
    \ contains=runeEscape,runeEscapeUnicode,runeEscapeError,
    \           runeStringContinuation,@Spell

" Raw strings  r#"..."#  /  r"..."
syn region  runeString  matchgroup=runeStringDelimiter
    \ start='b\?r\z(#*\)"' end='"\z1'
    \ contains=@Spell

" ===========================================================================
" Template literals   `Hello ${expr}!` {{{1
" ===========================================================================
" Rune's template strings use backticks.  ${...} sections contain
" arbitrary Rune expressions and are highlighted distinctly.
syn region  runeTemplateLiteral  matchgroup=runeTemplateDelimiter
    \ start=+`+ end=+`+
    \ contains=runeTemplateInterp,runeEscape,runeEscapeUnicode,
    \           runeEscapeError,@Spell

syn region  runeTemplateInterp  matchgroup=runeTemplateInterpDelim
    \ start=+${+ end=+}+
    \ contained contains=TOP

" ===========================================================================
" Character literals {{{1
" ===========================================================================
syn match  runeCharacterInvalid
    \ display contained /b\?'\zs[\n\r\t']\ze'/
syn match  runeCharacterInvalidUnicode
    \ display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/

syn match  runeCharacter
    \ /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/
    \ contains=runeEscape,runeEscapeError,
    \          runeCharacterInvalid,runeCharacterInvalidUnicode

syn match  runeCharacter
    \ /'\([^\\]\|\\\(.\|x\x\{2}\|u{\%(\x_*\)\{1,6}}\)\)'/
    \ contains=runeEscape,runeEscapeUnicode,runeEscapeError,
    \          runeCharacterInvalid

" ===========================================================================
" Labels   'outer: loop { break 'outer; } {{{1
" ===========================================================================
" Labels look like lifetimes in Rust but Rune has no lifetimes.
" A label is either a loop label declaration ('label:) or a break/continue
" target.  We match it after runeCharacter so char literals win.
syn match  runeLabel
    \ display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*:"
syn match  runeLabel
    \ display "\%(\<\%(break\|continue\)\s*\)\@<=\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"

" ===========================================================================
" Number literals {{{1
" ===========================================================================
syn match  runeDecNumber  display "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match  runeHexNumber  display "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match  runeOctNumber  display "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match  runeBinNumber  display "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="

" Floats – the integer-ending-in-dot form must come first so later
" patterns (with explicit exponents / suffixes) can take priority.
syn match  runeFloat  display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!"
syn match  runeFloat  display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match  runeFloat  display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match  runeFloat  display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

" ===========================================================================
" Operators and punctuation {{{1
" ===========================================================================
syn match  runeOperator      display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"
syn match  runeOperator      display "&&\|||"
syn match  runeArrowCharacter display "->"
syn match  runeRocket        display "=>"
syn match  runeQuestionMark  display "?\([a-zA-Z]\+\)\@!"
syn match  runeModPath       "\w\(\w\)*::[^<]"he=e-3,me=e-3
syn match  runeModPathSep    "::"
syn match  runeFuncCall      "\w\(\w\)*("he=e-1,me=e-1
syn match  runeFuncCall      "\w\(\w\)*::<"he=e-3,me=e-3

" ===========================================================================
" Prelude types and variants {{{1
" ===========================================================================
" Rune is dynamically typed, but these standard names get highlighted
" because they appear frequently in `is` type-test expressions and
" as return values.
syn keyword  runeEnum         Option Result
syn keyword  runeEnumVariant  Some None Ok Err
syn keyword  runeType         Vec String Object Bytes Tuple

" ===========================================================================
" Comments {{{1
" ===========================================================================
syn keyword  runeTodo  contained TODO FIXME XXX NB NOTE SAFETY

syn region  runeCommentLine
    \ start="//" end="$"
    \ contains=runeTodo,@Spell

syn region  runeCommentLineDoc
    \ start="//\%(//\@!\|!\)" end="$"
    \ contains=runeTodo,@Spell

syn region  runeCommentLineDocError
    \ start="//\%(//\@!\|!\)" end="$"
    \ contains=runeTodo,@Spell contained

syn region  runeCommentBlock
    \ matchgroup=runeCommentBlock
    \ start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/"
    \ contains=runeTodo,runeCommentBlockNest,@Spell

syn region  runeCommentBlockDoc
    \ matchgroup=runeCommentBlockDoc
    \ start="/\*\%(!\|\*[*/]\@!\)" end="\*/"
    \ contains=runeTodo,runeCommentBlockDocNest,runeCommentBlockDocRuneCode,@Spell

syn region  runeCommentBlockDocError
    \ matchgroup=runeCommentBlockDocError
    \ start="/\*\%(!\|\*[*/]\@!\)" end="\*/"
    \ contains=runeTodo,runeCommentBlockDocNestError,@Spell contained

syn region  runeCommentBlockNest
    \ matchgroup=runeCommentBlock
    \ start="/\*" end="\*/"
    \ contains=runeTodo,runeCommentBlockNest,@Spell contained transparent

syn region  runeCommentBlockDocNest
    \ matchgroup=runeCommentBlockDoc
    \ start="/\*" end="\*/"
    \ contains=runeTodo,runeCommentBlockDocNest,@Spell contained transparent

syn region  runeCommentBlockDocNestError
    \ matchgroup=runeCommentBlockDocError
    \ start="/\*" end="\*/"
    \ contains=runeTodo,runeCommentBlockDocNestError,@Spell contained transparent

" ===========================================================================
" Doc-comment code fences   ```rune ... ``` {{{1
" ===========================================================================
if !exists("b:current_syntax_embed")
    let b:current_syntax_embed = 1
    syntax include @RuneCodeInComment <sfile>:p:h/rune.vim
    unlet b:current_syntax_embed

    " Non-Rune fenced blocks – just find the closing fence.
    syn region  runeCommentLinesDocNonRuneCode
        \ matchgroup=runeCommentDocCodeFence
        \ start='^\z(\s*//[!/]\s*```\).\+$' end='^\z1$'
        \ keepend contains=runeCommentLineDoc

    " Rune fenced blocks in line-doc comments
    syn region  runeCommentLinesDocRuneCode
        \ matchgroup=runeCommentDocCodeFence
        \ start='^\z(\s*//[!/]\s*```\)[^A-Za-z0-9_-]*\%(\%(should_panic\|no_run\|ignore\|allow_fail\|rune\|test_harness\|compile_fail\|E\d\{4}\)\%([^A-Za-z0-9_-]\+\|$\)\)*$'
        \ end='^\z1$' keepend
        \ contains=@RuneCodeInComment,runeCommentLineDocLeader

    " Rune fenced blocks in block-doc comments
    syn region  runeCommentBlockDocRuneCode
        \ matchgroup=runeCommentDocCodeFence
        \ start='^\z(\%(\s*\*\)\?\s*```\)[^A-Za-z0-9_-]*\%(\%(should_panic\|no_run\|ignore\|allow_fail\|rune\|test_harness\|compile_fail\|E\d\{4}\)\%([^A-Za-z0-9_-]\+\|$\)\)*$'
        \ end='^\z1$' keepend
        \ contains=@RuneCodeInComment,runeCommentBlockDocStar

    syn match  runeCommentBlockDocStar  /^\s*\*\s\?/  contained
    syn match  runeCommentLineDocLeader "^\s*//\%(//\@!\|!\)" contained
endif

" ===========================================================================
" Folding {{{1
" ===========================================================================
syn region runeFoldBraces start="{" end="}" transparent fold

" ===========================================================================
" Default highlighting links {{{1
" ===========================================================================

" Numbers
hi def link runeDecNumber       runeNumber
hi def link runeHexNumber       runeNumber
hi def link runeOctNumber       runeNumber
hi def link runeBinNumber       runeNumber
hi def link runeNumber          Number
hi def link runeFloat           Float

" Strings and characters
hi def link runeString          String
hi def link runeStringDelimiter String
hi def link runeCharacter       Character
hi def link runeEscape          Special
hi def link runeEscapeUnicode   runeEscape
hi def link runeEscapeError     Error
hi def link runeStringContinuation Special
hi def link runeCharacterInvalid        Error
hi def link runeCharacterInvalidUnicode runeCharacterInvalid

" Template literals
hi def link runeTemplateLiteral    String
hi def link runeTemplateDelimiter  Delimiter
hi def link runeTemplateInterpDelim Special

" Booleans and constants
hi def link runeBoolean         Boolean
hi def link runeEnum            runeType
hi def link runeEnumVariant     Constant
hi def link runeSelf            Constant

" Types
hi def link runeType            Type
hi def link runeTrait           runeType
hi def link runeDeriveTrait     runeTrait
hi def link runeIdentifierPrime runeIdentifier

" Keywords and control flow
hi def link runeKeyword         Keyword
hi def link runeConditional     Conditional
hi def link runeRepeat          Repeat
hi def link runeStructure       Keyword
hi def link runeAsync           runeKeyword
hi def link runeAwait           runeKeyword
hi def link runeSuper           runeKeyword
hi def link runePubScopeCrate   runeKeyword
hi def link runeStorage         StorageClass

" Operators
hi def link runeOperator        Operator
hi def link runeArrowCharacter  runeOperator
hi def link runeRocket          runeOperator
hi def link runeQuestionMark    Special

" Object literal
hi def link runeObjectOpen      Operator

" Pub scope
hi def link runePubScopeDelim   Delimiter

" Module paths
hi def link runeModPath         Include
hi def link runeModPathSep      Delimiter

" Functions and identifiers
hi def link runeIdentifier      Identifier
hi def link runeFunction        Function
hi def link runeFuncName        Function
hi def link runeFuncCall        Function

" Macros
hi def link runeMacroRepeatDelimiters   Macro
hi def link runeMacroVariable   Define
hi def link runeMacro           Macro
hi def link runeAssert          PreCondit
hi def link runePanic           PreCondit

" Attributes
hi def link runeAttribute       PreProc
hi def link runeDerive          PreProc

" Labels
hi def link runeLabel           Label

" Comments
hi def link runeCommentLine     Comment
hi def link runeCommentBlock    runeCommentLine
hi def link runeCommentLineDoc  SpecialComment
hi def link runeCommentBlockDoc runeCommentLineDoc
hi def link runeCommentLineDocLeader    runeCommentLineDoc
hi def link runeCommentBlockDocStar     runeCommentBlockDoc
hi def link runeCommentLineDocError     Error
hi def link runeCommentBlockDocError    Error
hi def link runeCommentDocCodeFence     runeCommentLineDoc

" Reserved / error
hi def link runeReservedKeyword Error

" Todos
hi def link runeTodo            Todo

" ===========================================================================

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "rune"

" vim: set et sw=4 sts=4 ts=8:

" What is this script?
" --------------------
" 
" Lisp/Scheme family languages use an indentation convention that (when
" combined with the abundance of nested delimiters they contain) can
" make it very difficult to see the corresponding matches parentheses, square
" brackets, and squiggly brackets. A 'rainbow highlighter' is simply
" any script or plugin that changes the colors of matching delimiters 
" so that each level of delimiters is colored differently for clarity.
" 
" Such highlighting can be very useful for Lisp/Scheme family programming
" languages especially, but is also useful in many other contexts too, such
" as unknown/obscure programming languages and even plain text (when nested).
" 
" 
" History and provenance
" ----------------------
" 
" This modified script was built upon the 'RainbowParenth[eses].vim' script 
" created and released by John Gilmore on 2005-03-12.
" 
" I (internet alias: WraithGlade, website: WraithGlade.com) created this
" modified form (starting on 2024-09-20) out of frustration with luochen1990's
" more recent but more bloated and overengineered rainbow highlighting script.
" 
" This script also doesn't make any use of any 3rd party plugin systems, etc.
" It is designed to have few moving parts and to be easy to understand.
" 
" Gilmore's original can be found at https://www.vim.org/scripts/script.php?script_id=1230
" 
" I've modified Gilmore's script to be more intuitive to use and modify
" and to have better default colors and such. I've added a lot of documentation too.
" 
" Thus, this script provides an alternative for anyone having trouble with
" some of the other rainbow highlighters out there or who want a simpler system.
"
"
" How to use:
" -----------
"
" If you drop this file (rainbow.vim) into your ~/.vim/plugin (on Linux/BSD) or 
" %USERPROFILE%/vimfiles/plugin (on Windows) directory, it should autoload anytime 
" Vim starts, regardless of file type or language. If it doesn't, then perhaps try adding
" `filetype plugin on` somewhere to your `.vimrc` file (your user pref/config file).
" 
" Vim's `:source <filename>` command can alternatively be used to load the script manually.
" 
" (PS: `:so` can be used as shorthand for `:source`, which is more covenient.)
" 
" I have organized the script into functions to enable simpler usage and customization.
" 
" You can also call those functions manually when using Vim via `:call FuncName()`.
" I have also provided 'command' versions of the safe-to-reuse functions for shorthand,
" which enables you to write just `:FuncName` in Vim instead of `:call FuncName()`.
" 
" (PS: I have occasionally encountered things breaking when calling the functions manually.)
" 
" (PS: Global function names must always begin with a capital letter in Vimscript.)
"
" The plugin can be restricted to only run for specific file types by
" modifying the `autocmd` lines at the very end of this script.
" 
" Indeed, many things in this script are intended to be easily modifiable.
" I have added many comments to clarify what things are and alert you of pitfalls.
" 
" 
" To customize the behavior of the script:
" ----------------------------------------
"  
" The most common user modifications will likely be as follows:
" 
" Jump to the section labeled BASIC SETUP in the below Vimscript code.
" (Just type `/BASIC SETUP<Enter>` in Vim and you'll get there.)
"  
" Modify the script to call either `RbDarkTheme()` or `RbLightTheme()` by default according to
" whether you are using a dark or light color theme. That way, it'll be more readable.
" 
" Likewise, choose either `RbCustomColors()` or `RbNamedColors()`, whichever you prefer,
" and then ensure it is the one called in BASIC SETUP section below. Only one applies.
" `RbCustomColors()` is more flexible though, is the default, and is what I recommend.
" 
" You can also call any of this script's functions at runtime by writing just `:FuncName` 
" during normal Vim use. There are also other shorthand versions and alt names available 
" (search for `command -narg` declarations to see what shorthand commands are already included).
" 
" You can also modify the individual color assignments within `RbLight` and/or `RbDark`
" to suit your prefrences, or create your own named color theme functions and call them.



" KNOWN BUGS:
" -----------
" 
" - At nesting levels above 16 the syntax highlighting of closing delimiters 
"   may become mismatched! Such deep nesting is hard to understand regardless though.
"   
"   (Vim's console color implementation appears to have some baked-in 
"   assumptions about 16 console colors max existing too though, partially.)
" 
" - If `:syntax off` is used and then followed by `:syntax on` later,
"   then the rainbow highlighter may not turn back on. So, as a workaround,
"   use the provided rainbow commands such as `:RbToggle`, `:RbOff`, and `:RbOn` instead.
"   
" - The color theme functions (`RbCustomColors` and `RbNamedColors`) break
"   things sometimes when called during normal Vim use outside of this script.



" Color modes (named vs custom):
" ------------------------------

function RbCustomColors()
  set termguicolors
  " Makes arbitrary colors (via `guifg=#hexcode`) active if TrueColor is supported.
  " 
  " See https://stackoverflow.com/questions/61832656/where-to-find-list-of-colors-for-vim 
  " (specifically https://stackoverflow.com/a/61833431) for more info.
  "
  " I've set the default colors for `guifg` mode to have approximately
  " equal luminosity via the HSLuv color model, which (unlike HSL) accounts for
  " human eyesight. I've evenly divided such colors 8x by hue, conserving luminosity.
endfunction
" Calling this function outside this script is known to break things sometimes.
" Thus, no shorthand `command` version is provided, to discourage errors.

function RbNamedColors()
  set termguicolors&
  " Tells the highlighter to use the named (`ctermfg`) colors instead of the `guifg`s.
  " 
  " Only one set (`ctermfg` or `guifg`) applies at a given time!
endfunction
" Calling this function outside this script is known to break things sometimes.
" Thus, no shorthand `command` version is provided, to discourage errors.



" For understanding what the 'levels' are:
" ----------------------------------------
"
" IMPORTANT: 'level16c' is actually the FIRST (i.e. outermost) level of
" delimiters and hence will be the FIRST color to appear in use.
" 
" The numbering of levels is backwards relative to one's intuition.
" 
" Thus, a nested pair 16 levels deep is actually set by 'level1c', etc.
" The highest numbered levels are the *outermost* delimiter pairs.

" For choosing custom colors:
" ---------------------------
"
" `guifg` uses standard hexidecimal codes for red, green, and blue: `#RRGGBB`.
" Thus `#ff0000` is full red, `#00ff00` is full green, `#808080` is mid grey, etc.
" 
" 
" The higher the contrast between foreground and background and between successive
" color hues, saturations, and lightnesses, the easier it'll be to
" distinguish deeply nested adjacent delimiters' matching pairs.

function RbDarkTheme()
  " Intended for dark backgrounds, thus assigns *light* foreground (fg) colors:
  highlight level16c   ctermfg=Red         guifg=#ffb25c
  highlight level15c   ctermfg=Green       guifg=#c1cb00
  highlight level14c   ctermfg=Blue        guifg=#00df66
  highlight level13c   ctermfg=Cyan        guifg=#00d9c9
  highlight level12c   ctermfg=Magenta     guifg=#3fd1ff
  highlight level11c   ctermfg=Yellow      guifg=#c3baff
  highlight level10c   ctermfg=Red         guifg=#ffa3f2
  highlight level9c    ctermfg=Green       guifg=#ffabbb
  highlight level8c    ctermfg=Blue        guifg=#ffb25c
  highlight level7c    ctermfg=Cyan        guifg=#c1cb00
  highlight level6c    ctermfg=Magenta     guifg=#00df66
  highlight level5c    ctermfg=Yellow      guifg=#00d9c9
  highlight level4c    ctermfg=Red         guifg=#3fd1ff
  highlight level3c    ctermfg=Green       guifg=#c3baff
  highlight level2c    ctermfg=Blue        guifg=#ffa3f2
  highlight level1c    ctermfg=Cyan        guifg=#ffabbb
endfunction
command -nargs=0 RbDarkTheme :call RbDarkTheme()
command -nargs=0 RbDarkBg :call RbDarkTheme()
command -nargs=0 RbLightFg :call RbDarkTheme()
" 'Fg' stands for 'foreground' color. 'Bg' stands for 'background' color.
" `:RbLightFg` is useful if you find the dark/light theme names confusing.

function RbLightTheme()
  " Intended for light backgrounds, thus assigns *dark* foreground (fg) colors:
  highlight level16c   ctermfg=DarkRed         guifg=#4b2d00
  highlight level15c   ctermfg=DarkGreen       guifg=#343600
  highlight level14c   ctermfg=DarkBlue        guifg=#003d17
  highlight level13c   ctermfg=DarkCyan        guifg=#003b36
  highlight level12c   ctermfg=DarkMagenta     guifg=#003949
  highlight level11c   ctermfg=DarkYellow      guifg=#3500a3
  highlight level10c   ctermfg=DarkRed         guifg=#63005a
  highlight level9c    ctermfg=DarkGreen       guifg=#6d002b
  highlight level8c    ctermfg=DarkBlue        guifg=#4b2d00
  highlight level7c    ctermfg=DarkCyan        guifg=#343600
  highlight level6c    ctermfg=DarkMagenta     guifg=#003d17
  highlight level5c    ctermfg=DarkYellow      guifg=#003b36
  highlight level4c    ctermfg=DarkRed         guifg=#003949
  highlight level3c    ctermfg=DarkGreen       guifg=#3500a3
  highlight level2c    ctermfg=DarkBlue        guifg=#63005a
  highlight level1c    ctermfg=DarkCyan        guifg=#6d002b
endfunction
command -nargs=0 RbLightTheme :call RbLightTheme()
command -nargs=0 RbLightBg :call RbLightTheme()
command -nargs=0 RbDarkFg :call RbLightTheme()
" 'FG' stands for 'foreground' color. 'BG' stands for 'background' color.
" `:RbDarkFg` is useful if you find the dark/light theme names confusing.



let g:RbActive = 0
" This variable is (and should be) set to 1 whenever any rainbow syntax is applied.
" Otherwise, if you don't do that, then the `:Rb` toggle will need to be called 
" twice sometimes due to its state tracking getting out of sync with reality.
" Likewise is true (in reverse) for any functions that *clear* all rainbow syntax.
" I've 'coded defensively' in this respect, intentionally setting `g:RbActive` 
" redundantly in every relevant function. This also improves readability slightly.

function RbParen()
  " The order of these declations matters. If you reverse them, it will break.
  syntax region level1 matchgroup=level1c start=/(/ end=/)/ contains=TOP,level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level2 matchgroup=level2c start=/(/ end=/)/ contains=TOP,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level3 matchgroup=level3c start=/(/ end=/)/ contains=TOP,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level4 matchgroup=level4c start=/(/ end=/)/ contains=TOP,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level5 matchgroup=level5c start=/(/ end=/)/ contains=TOP,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level6 matchgroup=level6c start=/(/ end=/)/ contains=TOP,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level7 matchgroup=level7c start=/(/ end=/)/ contains=TOP,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level8 matchgroup=level8c start=/(/ end=/)/ contains=TOP,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level9 matchgroup=level9c start=/(/ end=/)/ contains=TOP,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level10 matchgroup=level10c start=/(/ end=/)/ contains=TOP,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level11 matchgroup=level11c start=/(/ end=/)/ contains=TOP,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level12 matchgroup=level12c start=/(/ end=/)/ contains=TOP,level12,level13,level14,level15, level16,NoInParens
  syntax region level13 matchgroup=level13c start=/(/ end=/)/ contains=TOP,level13,level14,level15, level16,NoInParens
  syntax region level14 matchgroup=level14c start=/(/ end=/)/ contains=TOP,level14,level15, level16,NoInParens
  syntax region level15 matchgroup=level15c start=/(/ end=/)/ contains=TOP,level15, level16,NoInParens
  syntax region level16 matchgroup=level16c start=/(/ end=/)/ contains=TOP,level16,NoInParens
  let g:RbActive = 1
endfunction
command -nargs=0 RbParen :call RbParen()

function RbSquare()
  " The order of these declations matters. If you reverse them, it will break.
  syntax region level1 matchgroup=level1c start=/\[/ end=/\]/ contains=TOP,level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level2 matchgroup=level2c start=/\[/ end=/\]/ contains=TOP,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level3 matchgroup=level3c start=/\[/ end=/\]/ contains=TOP,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level4 matchgroup=level4c start=/\[/ end=/\]/ contains=TOP,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level5 matchgroup=level5c start=/\[/ end=/\]/ contains=TOP,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level6 matchgroup=level6c start=/\[/ end=/\]/ contains=TOP,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level7 matchgroup=level7c start=/\[/ end=/\]/ contains=TOP,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level8 matchgroup=level8c start=/\[/ end=/\]/ contains=TOP,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level9 matchgroup=level9c start=/\[/ end=/\]/ contains=TOP,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level10 matchgroup=level10c start=/\[/ end=/\]/ contains=TOP,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level11 matchgroup=level11c start=/\[/ end=/\]/ contains=TOP,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level12 matchgroup=level12c start=/\[/ end=/\]/ contains=TOP,level12,level13,level14,level15, level16,NoInParens
  syntax region level13 matchgroup=level13c start=/\[/ end=/\]/ contains=TOP,level13,level14,level15, level16,NoInParens
  syntax region level14 matchgroup=level14c start=/\[/ end=/\]/ contains=TOP,level14,level15, level16,NoInParens
  syntax region level15 matchgroup=level15c start=/\[/ end=/\]/ contains=TOP,level15, level16,NoInParens
  syntax region level16 matchgroup=level16c start=/\[/ end=/\]/ contains=TOP,level16,NoInParens
  let g:RbActive = 1
endfunction
command -nargs=0 RbSquare :call RbSquare()

function RbSquiggle()
  " The order of these declations matters. If you reverse them, it will break.
  syntax region level1 matchgroup=level1c start=/{/ end=/}/ contains=TOP,level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level2 matchgroup=level2c start=/{/ end=/}/ contains=TOP,level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level3 matchgroup=level3c start=/{/ end=/}/ contains=TOP,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level4 matchgroup=level4c start=/{/ end=/}/ contains=TOP,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level5 matchgroup=level5c start=/{/ end=/}/ contains=TOP,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level6 matchgroup=level6c start=/{/ end=/}/ contains=TOP,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level7 matchgroup=level7c start=/{/ end=/}/ contains=TOP,level7,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level8 matchgroup=level8c start=/{/ end=/}/ contains=TOP,level8,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level9 matchgroup=level9c start=/{/ end=/}/ contains=TOP,level9,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level10 matchgroup=level10c start=/{/ end=/}/ contains=TOP,level10,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level11 matchgroup=level11c start=/{/ end=/}/ contains=TOP,level11,level12,level13,level14,level15, level16,NoInParens
  syntax region level12 matchgroup=level12c start=/{/ end=/}/ contains=TOP,level12,level13,level14,level15, level16,NoInParens
  syntax region level13 matchgroup=level13c start=/{/ end=/}/ contains=TOP,level13,level14,level15, level16,NoInParens
  syntax region level14 matchgroup=level14c start=/{/ end=/}/ contains=TOP,level14,level15, level16,NoInParens
  syntax region level15 matchgroup=level15c start=/{/ end=/}/ contains=TOP,level15, level16,NoInParens
  syntax region level16 matchgroup=level16c start=/{/ end=/}/ contains=TOP,level16,NoInParens
  let g:RbActive = 1
endfunction
command -nargs=0 RbSquiggle :call RbSquiggle()


function RbOn()
  call RbParen()
  call RbSquare()
  call RbSquiggle()
  let g:RbActive = 1
endfunction
command -nargs=0 RbOn :call RbOn()

function RbOff()
  syntax clear level16
  syntax clear level15
  syntax clear level14
  syntax clear level13
  syntax clear level12
  syntax clear level11
  syntax clear level10
  syntax clear level9
  syntax clear level8
  syntax clear level7
  syntax clear level6
  syntax clear level5
  syntax clear level4
  syntax clear level3
  syntax clear level2
  syntax clear level1
  let g:RbActive = 0
endfunction
command -nargs=0 RbOff :call RbOff()

" In order for delimiter coloring to be based on nesting levels instead of
" being separate per delimiter type, the various delimiters must share the
" same syntax groups. Thus, though (), [], and {} can be *enabled* separately
" they cannot be *disabled* separately (without employing workarounds).
" 
" However, here are the workarounds anyway, for your convenience:

function RbOnlyParen()
  call RbOff()
  call RbParen()
  let g:RbActive = 1
endfunction
command -nargs=0 RbOnlyParen :call RbOnlyParen()
command -nargs=0 RbOParen :call RbOnlyParen()

function RbOnlySquare()
  call RbOff()
  call RbSquare()
  let g:RbActive = 1
endfunction
command -nargs=0 RbOnlySquare :call RbOnlySquare()
command -nargs=0 RbOSquare :call RbOnlySquare()

function RbOnlySquiggle()
  call RbOff()
  call RbSquiggle()
  let g:RbActive = 1
endfunction
command -nargs=0 RbOnlySquiggle :call RbOnlySquiggle()
command -nargs=0 RbOSquiggle :call RbOnlySquiggle()

function RbOnlyParenSquare()
  call RbOff()
  call RbParen()
  call RbSquare()
  let g:RbActive = 1
endfunction
command -nargs=0 RbOnlyParenSquare :call RbOnlyParenSquare()
command -nargs=0 RbOParenSquare :call RbOnlyParenSquare()

function RbOnlyParenSquiggle()
  call RbOff()
  call RbParen()
  call RbSquiggle()
  let g:RbActive = 1
endfunction
command -nargs=0 RbOnlyParenSquiggle :call RbOnlyParenSquiggle()
command -nargs=0 RbOParenSquiggle :call RbOnlyParenSquiggle()

function RbOnlySquareSquiggle()
  call RbOff()
  call RbSquare()
  call RbSquiggle()
  let g:RbActive = 1
endfunction
command -nargs=0 RbOnlySquareSquiggle :call RbOnlySquareSquiggle()
command -nargs=0 RbOSquareSquiggle :call RbOnlySquareSquiggle()



" Function for toggling rainbow highlighting of delimiters on and off easily:
function Rb()
  if g:RbActive == 0
    call RbOn()
    let g:RbActive = 1
  elseif g:RbActive == 1
    call RbOff()
    let g:RbActive = 0
  endif
endfunction
command -nargs=0 Rb :call Rb()
command -nargs=0 RbToggle :call Rb()
command -nargs=0 Rainbow :call Rb()
command -nargs=0 RainbowToggle :call Rb()
" Command names (like functions) must always start with capital letters, unfortunately.
" Thus, we can't shorten the rainbow toggle even more to `:rb`.



" ======================================================================================
"   BASIC SETUP
" ======================================================================================
" 
" Below is where everything is actually put into effect:

" These are the default settings for the script essentially. 
" Change which functions are called to suit your preferences:

call RbCustomColors()
call RbDarkTheme()

call RbOn()



" Set up file-type associations (or the lack thereof):
" ----------------------------------------------------

" Look for text of the form `*.file_extension` below.
" 
" Uncomment the lines for the file associations that you want to apply this script to.
" You may uncomment multiple this way. They apply separately.
" 
" Using just `*` causes the script to run for all file types.
" 
" `BufNewFile` means apply the script to new (unsaved) files.
" `BufRead` means apply the script to existing (saved) files.


" For ALL files types (including unspecified and/or unknown ones):
autocmd BufNewFile,BufRead * source <sfile>
" The below will have NO USEFUL EFFECT if the above line isn't commented out.

" For Common Lisp:
"autocmd BufNewFile,BufRead *.lisp so <sfile>
"autocmd BufNewFile,BufRead *.cl so <sfile>

" For Racket (the most popular Scheme-like language):
"autocmd BufNewFile,BufRead *.rkt so <sfile>

" For various 'Scheme language standard' adhering languages or uses:
"autocmd BufNewFile,BufRead *.scm so <sfile>
"autocmd BufNewFile,BufRead *.ss so <sfile>
"autocmd BufNewFile,BufRead *.sc so <sfile>
"autocmd BufNewFile,BufRead *.sps so <sfile>
"autocmd BufNewFile,BufRead *.sls so <sfile>
"autocmd BufNewFile,BufRead *.sld so <sfile>
"autocmd BufNewFile,BufRead *.scr so <sfile>
"autocmd BufNewFile,BufRead *.sps7 so <sfile>
"autocmd BufNewFile,BufRead *.scrbl so <sfile>

" For Clojure:
"autocmd BufNewFile,BufRead *.clj so <sfile>
"autocmd BufNewFile,BufRead *.cljs so <sfile>
"autocmd BufNewFile,BufRead *.cljc so <sfile>

" For Janet:
"autocmd BufNewFile,BufRead *.janet so <sfile>


" More file association implementation info:
" ----------------------------------------------
"  
" `<sfile>` is the current script file (`rainbow.vim` in this case).
" 
" `so` loads and applies whatever `.vim` script is passed to it.
"
" See https://vimdoc.sourceforge.net/htmldoc/autocmd.html
" 
" When I tried to put the above `autocmd` lines into a separate
" function, it caused loading errors whenever I loaded
" `rainbow.vim` itself, and so I decided against that.



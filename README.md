# WraithGlade's Rainbow Delimiter Highlighter for Vim

## Purpose and History

This is a script for highlighting successive levels of nested delimiters (parentheses, square brackets, and squiggle brackets) with different colors, so that it is easier to see which matching pairs are associated with which levels of nesting in code. 

It is especially useful for highly nested programming languages and/or those that don't have any/many precedence rules (such as Lisp/Scheme family languages of *any* kind, including even obscure and unknown ones and those not yet created), but it is also useful for *any* kind of text or programming language that uses nested `()` and/or `[]` and/or `{}`. Those are the only delimiters it recolors.

It is overlaid on whatever other syntax highlighting you use and will leave other things untouched.

The script was based/built upon John Gilmore's original "Rainbow Parenthesis" *[sic]* (aka "RainbowParenthsis.vim" *[sic]*) script (one of the very first rainbow syntax highlighter scripts ever made as far as I can tell), which can be found on [John Gilmore's Vim.org page for it](https://www.vim.org/scripts/script.php?script_id=1230), but my script has now significantly diverged from it, has many more features, is much more practical, and is much easier to use and customize.

This rainbow highlighter (unlike some others) uses only Vim's built-in plugin system and therefore doesn't require a bunch of brittle or trendy (hence unreliable) 3rd party dependencies. It doesn't muck around with anything on your system. It is strictly **a simple one-file plain Vimscript-based plugin, using only Vim's provided built-in features without overengineering anything.**

The core guiding principle of this script is to make it as easy to use as possible *without overengineering it* and *without requiring any third party dependencies*. Imperfect but reliable pragmatism is better than polluting the user's system or imposing needless tedium on them. Reliability and ease of use matter more than ideology!

## Script Usage

I have included very extensive documentation throughout the entire Vimscript file and you can learn everything you need to know from reading the `rainbow.vim` file. That way, the necessary info is all self-contained, even if you lose this `README.md` document. It doesn't contain the exact same info as this `README.md`, but it is similar. Either way, the script is very easy to use and modify.

To use this script ("plugin"), all you have to do is place the script into your `%userprofile%/vimfiles/plugin` (on Windows) or `~/.vim/plugin` (on Linux/BSD/Unix) folder and it will load itself automatically whenever you use Vim. Running `Windows_install.bat` or `Linux_etc_install.sh` will try to do this automatically for you (like an installer).

(Alternatively, like most scripts, you can load it manually at will by using `:so path/to/rainbow.vim` and placing a copy of `rainbow.vim` wherever you find it convenient to write the path to.)

Modify the `autocmd` lines inside of `rainbow.vim` if you don't want it to apply to all file types (i.e. if you prefer only specific file types to be highlighted by `rainbow.vim`). By default, for maximum convenience and ease of setup and testing, the script applies to *everything*, even to unknown file types!

A wide range of useful shorthand commands are included. The most useful are:

- `:Rb` (or `:RbToggle` or `:Rainbow` or `:RainbowToggle`): disable/enable (flipping back and forth) the rainbow highlighting (without disabling other syntax highlighting)
- `:RbOff`: disable all rainbow highlighting (without disabling other syntax highlighting)
- `:RbOn`: enable all rainbow highlighting (without enabling other syntax highlighting)
- `:RbDark` (or `RbDarkTheme` or `:RbDarkBg` or `:RbLightFg`): applies a dark color theme to the rainbow highlighter (i.e. tells the rainbow highlighter to use *light* foreground colors)
- `:RbLight` (or `:RbLightTheme` or `:RbLightBg` or `:RbDarkFg`): applies a light color theme to the rainbow highlighter (i.e. tells the rainbow highlighter to use *dark* foreground colors)
- `:RbHi` (or `:RbHighContrast` or `:RbHiContrast` or `:RbHiCon` or `:RbHigh`): applies a high contrast color theme to the rainbow highlighter (one with huge gaps in color contrast between successive nested delimiter highlighting colors, but also tweaked for broader usability and more pleasing aesthetics than true max contrast would have)
- `:RbWh` (or `:RbWhiteStrobe` or `:RbWhite`): applies *lightened* greyscale-only delimiter highlighting, which results in *much worse contrast* but may be somewhat useful if your code already has way too much syntax color
- `:RbBl` (or `:RbBlackStrobe` or `:RbBlack`): applies *darkened* greyscale-only delimiter highlighting, which results in *much worse contrast* but may be somewhat useful if your code already has way too much syntax color

The following less commonly used commands are also included:

- `:RbParen`: enable rainbow highlighting for parentheses (already on by default)
- `:RbSquare`: enable rainbow highlighting for square brackets (already on by default)
- `:RbSquiggle`: enable rainbow highlighting for squiggle brackets (already on by default)
- `:RbOnlyParen`: enable rainbow highlighting for parentheses *only*, disabling  the others
- `:RbOnlySquare`: enable rainbow highlighting for square brackets *only*, disabling  the others
- `:RbOnlySquiggle`: enable rainbow highlighting for squiggle brackets *only*, disabling  the others
- `:RbOnlyParenSquare`: enable rainbow highlighting for parentheses and square brackets *only*, disabling  the others
- `:RbOnlyParenSquiggle`: enable rainbow highlighting for parentheses and squiggle brackets *only*, disabling  the others
- `:RbOnlySquareSquiggle`: enable rainbow highlighting for square brackets and squiggle brackets *only*, disabling  the others
- `:RbSync`: corrects highlighting to match internal tracked state (shouldn't ever need to be used unless there is a bug, but it could be useful if there is and it is also used internally by the implementation)

**Type any of the above commands into Vim to use them anytime you want!**

**All these commands are all designed to be reusable and you can call them as often as you want during a Vim session.**

The script is cleanly organized into named functions, extensively commented, and is very easy to read. Feel free to add functions and command shortcuts of your own to your copy!

If you use `:syntax off` at any point then the script may stop working and you may need to close and reopen your Vim. Use `:RbOff` instead when you want to just disable the rainbow highlighting. `:RbOn` will likewise re-enable it.

## Known Bugs and Limitations

- At nesting levels above 18, the syntax highlighting of closing delimiters 
  may become mismatched! Such deep nesting is hard to understand regardless though.

- If `:syntax off` is used and then followed by `:syntax on` later,
  then the rainbow highlighter may not turn back on. So, as a workaround, use 
  the provided rainbow commands such as `:RbToggle`, `:RbOff`, and `:RbOn` instead.
  I've often seen `:syntax off` followed by `:RbOn` work, but not `:syntax on`!
  If you call `:syntax on` you may need to close and reopen the Vim editor to fix it.
  
- The color mode functions (`RbCustomColors` and `RbNamedColors`) break
  things sometimes when called during normal Vim use *outside of this script*.
  This is not much of a problem though: Color *themes* can still be switched easily.
  There's not much reason why you'd want to change the color mode once you pick it.
  The color themes (in contrast to the two color *modes*) can be applied at any time and as often as you want! Thus, feel free to use `:RbDark`, `:RbLight`, or `:RbHi` (etc) at any time and as often as you like... but be wary of ever running `:call RbCustomColors()` or `:call RbNamedColors()` outside of `rainbow.vim`.
  

- The rainbow script/plugin currently seems to sometimes cause a rapid
  screen-flickering when loading or reloading files it seems. I am currently
  new to plugin design, so I suspect I have some kind of loading bug. I 
  will try to fix this. I have a feeling some aspect of how I am managing
  the loading (such as `autocmd` or just basic plugin loading) needs to be tweaked.
  The bug doesn't seem to happen when Vim is run with `vim --noplugin filename.ext`.

## Miscellaneous Utilities

The Git repo also includes very small shell scripts for more easily/quickly installing the rainbow script and/or synchronizing the Git repo's `rainbow.vim` with Vim's per-user config file directory contents. (This make sit possible to keep the `rainbow.vim` source repo entirely separate from your Vim config folders to prevent junking them up.)

You don't need to concern yourself with that though if you intend to just drag and drop `rainbow.vim` to your Vim `plugin` folder. All these extra scripts do is perform the copying for you automatically:

- `Windows_install.bat`: just copies `rainbow.vim` from the current directory to `%userprofile%\vimfiles\plugin`
- `Linux_etc_install.sh`: just copies `rainbow.vim` from the current directory to `~\.vim\plugin`

On Windows, double-clicking a Batch/CMD (`.bat`) file will run it automatically, like an installer or EXE.

There are also now corresponding uninstall scripts that undo the installs:

- `Windows_uninstall.bat`: deletes `rainbow.vim` from `%userprofile%\vimfiles\plugin`
- `Linux_etc_uninstall.sh`: deletes `rainbow.vim` from `~\.vim\plugin`

All of the scripts will ask for confirmations and will tell you what they ended up actually doing to the files (whenever possible for the corresponding operating system commands).

These scripts together enable a faster workflow for managing changes to `rainbow.vim`.

Anything that aids the user's experience using software (no matter how slightly) is usually worth doing! 

## Extras (Bonus)

The `rainbow.vim` file's comments also contain a section giving recommendations on what Lisp/Scheme-like languages you may want to use or explore and what their most salient advantages and disadvantages are. 

Search `rainbow.vim` for the section titled "If you're having trouble deciding what language to use" if you want to read those recommendations and potentially broaden your awareness of some related s-expression based programming languages.

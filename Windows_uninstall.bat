@echo off

rem  This attempts to delete the rainbow scipt from Vim's
rem  `plugin` directory, so that it is no longer applied to Vim.
rem  
rem  Any changes you've made there will be destroyed! Check your work!
rem  The script assumes that *this* folder is where you edit rainbow.
rem  
rem  It is intended for use with Windows operating systems.

del /p "%userprofile%\vimfiles\plugin\rainbow.vim"

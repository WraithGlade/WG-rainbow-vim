@echo off

rem  This attempts to copy the rainbow scipt from here to 
rem  where it will be applied to the user's Vim settings.
rem  
rem  It will warn users about overwrites and ask for confirmation.
rem  
rem  It is intended for use with Windows.

xcopy /e /i "rainbow.vim" "%userprofile%\vimfiles\plugin"

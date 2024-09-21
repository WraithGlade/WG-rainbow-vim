@echo off

rem  This attempts to copy the rainbow scipt from here to 
rem  where it will be applied to the user's Vim settings.
rem  
rem  It is intended for use with Windows.
rem  
rem  It will warn users about overwrites and ask for confirmation.

xcopy /s /e /i "rainbow.vim" "%userprofile%\vimfiles\plugins"

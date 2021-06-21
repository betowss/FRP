@echo off
if exist flashfile.xml (goto startconvert) else (goto noflashfilexml)
:noflashfilexml
find "flashfile" flashfile.xml
pause
exit
:startconvert
findstr "\<software_version\>" flashfile.xml > software_version.txt
for /f delims^=^"^ tokens^=2 %%a in (software_version.txt) do set title=%%a
del software_version.txt
title %title%
(echo @title %title%
echo mfastboot getvar max-sparse-size
echo mfastboot oem fb_mode_set) > flashfile.cmd
findstr "\<flash\>" flashfile.xml > flash.txt
findstr "\<erase\>" flashfile.xml | findstr /v "modem" > erase.txt
for /F delims^=^"^ tokens^=4^,6^,8 %%a in (flash.txt) do @echo mfastboot %%b %%c %%a >> flashfile.cmd
del flash.txt
for /F delims^=^"^ tokens^=2^,4^,6 %%a in (erase.txt) do @echo mfastboot %%a %%b >> flashfile.cmd
del erase.txt
(echo mfastboot oem fb_mode_clear
echo mfastboot reboot
echo @cmd) >> flashfile.cmd
findstr /v "@title" flashfile.cmd > "FLASHFILE COMMANDS %title%.txt"
if exist mfastboot.exe (goto startflash) else (goto nomfastbootexe)
:nomfastbootexe
exit
:startflash
pause
echo on
cls
@flashfile.cmd
exit

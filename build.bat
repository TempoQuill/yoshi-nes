@echo off

echo Assembling...
tools\asm6f.exe yoshi.asm -n -c -L %* bin\yoshi.nes > bin\assembler.log
if %ERRORLEVEL% neq 0 goto buildfail
move /y yoshi.lst bin > nul
move /y yoshi.cdl bin > nul
echo Done.
echo.

echo SHA1 hash check:
echo A82EBB3CBD0F10B36DAF9F3C2FAD7BD9F316A7213992DB3E482BF15892B26589 PRG0
echo Yours:
certutil -hashfile bin\yoshi.nes SHA256 | findstr /V ":"


goto end

:buildfail
echo The build seems to have failed.
goto end

:buildsame
echo Your built ROM and the original are the same.
goto end

:builddifferent
echo Your built ROM and the original differ.
echo If this is intentional, don't worry about it.
goto end


:end
echo on

@echo off
setlocal enabledelayedexpansion
if "%2" == "" (
  set section=*
  set sectionlist=1 1p 8 2 3 3p 4 5 6 7 9 0p n l p o 1x 2x 3x 4x 5x 6x 7x 8x
  set page=%1
) else (
  set section=%1
  set sectionlist=%1
  set page=%2
)

if "%MANPATH%" == "" (
  for /f "tokens=1,2,*" %%a in ('reg query HKLM\SOFTWARE\Wow6432Node\GnuWin32 /v InstallPath') do (
    set pathlist=%%c\man
  )
) else (
  set pathlist=%MANPATH%
)
REM echo pathlist=!pathlist!

:loop
for /f "delims=; tokens=1,*" %%p in ("!pathlist!") do (

  pushd %%p
  REM echo Searching directory %%p
  for %%s in (!sectionlist!) do (
    REM echo Trying subdir man%%s
    for %%f in (man%%s\!page!.%%s*.gz) do (
      call :setcolor %%p
      call :display 0 %%f gzip
      popd
      call :setcolor
      goto :eof
    )
    for %%f in (man%%s\!page!.%%s*) do (
      call :setcolor %%p
      call :display 0 %%f
      popd
      call :setcolor
      goto :eof
    )
  )
  popd

  set pathlist=%%q
)
if not "!pathlist!" == "" goto :loop

if !section! == * (
  echo No manual entry for %1
) else (
  echo No manual entry for %1 in section !section!
)
goto :eof

REM ====== :display ======
:display

echo Displaying file %CD%\%2
REM First ungzip man file
if "%3" == "gzip" (
  gzip -d -c %2 > %TMP%\man%1.tmp
  set file=%TMP%\man%1.tmp
) else (
  set file=%2
)
REM Check if redirection
for /f "tokens=1,*" %%t in (!file!) do (
  if "%%t" == ".so" (
    set r=%%u
  ) else (
    set r=
  )
)
REM If no redirection then display it
if "!r!" == "" (
  if "%SHELL%" == "" (
    groff -Tascii -man !file! | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" - 2>NUL | less
  ) else (
    REM My emacs sets this variable to: G:/emacs-24.5/libexec/emacs/24.5/i686-pc-mingw32/cmdproxy.exe
    groff -Tascii -man !file!
  )
) else (
  REM If redirection then recursive call
  if exist !r!.gz (
    call :display 1 !r!.gz gzip
  ) else (
    call :display 1 !r!
  )
)
if "%3" == "gzip" (
  rm %TMP%\man%1.tmp
)
goto :eof


REM ====== :setcolor ======
:setcolor

if "%1" == "" (
  color 07
  goto :eof
)
if exist "%~d1\System Volume Information" (
  color 07
) else (
  color 1E
)

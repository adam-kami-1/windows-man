@echo off
setlocal enabledelayedexpansion

set debug=false
if "%1" == "-d" set debug=true & shift /1
if "%1" == "--debug" set debug=true & shift /1
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

  set "plist=%PATH%"
  :loop
  for /f "delims=; tokens=1,*" %%p in ("!plist!") do (

    if %debug% == true echo Checking %%p
    call :Check %%p
    if not "!RES!" == "" set pathlist=!pathlist!;!RES!
    REM echo pathlist=!pathlist!
    set plist=%%q
  )
  if not "!plist!" == "" goto :loop

  set pathlist=%pathlist:~1%
)
if not "%MANPATH%" == "" (
  set pathlist=%MANPATH%

)
if %debug% == true echo pathlist=!pathlist!

:man_dir_loop
for /f "delims=; tokens=1,*" %%p in ("!pathlist!") do (

  pushd %%p
  if %debug% == true echo Searching directory %%p
  for %%s in (!sectionlist!) do (
    if exist man%%s (
      if %debug% == true echo Trying subdir man%%s
      if exist man%%s\!page!.%%s.gz (
        call :display 0 man%%s\!page!.%%s.gz gzip
        popd
        goto :eof
      )
      if exist man%%s\!page!.%%s (
        call :display 0 man%%s\!page!.%%s
        popd
        goto :eof
      )
      if not "!sectionlist!" == "!section!" (
        if exist man%%s\!page!.gz (
          call :display 0 man%%s\!page!.gz gzip
          popd
          goto :eof
        )
        if exist man%%s\!page! (
          call :display 0 man%%s\!page!
          popd
          goto :eof
        )
      )
    )
  )
  popd

  set pathlist=%%q
)
if not "!pathlist!" == "" goto :man_dir_loop

if !section! == * (
  echo No manual entry for %1
) else (
  echo No manual entry for %1 in section !section!
)
goto :eof

REM ============================================================================
REM ====== :Check ======
:Check
setlocal
set VAR=%1

set RES=%VAR:\MinGW\=%
if not "%RES%" == "%VAR%" set RES=%VAR:\bin=\share\man%
if not "%RES%" == "%VAR%" endlocal &set RES=%RES%& exit /b

set RES=%VAR:\GnuWin32\=%
if not "%RES%" == "%VAR%" set RES=%VAR:\bin=\man%
if not "%RES%" == "%VAR%" endlocal &set RES=%RES%& exit /b

set RES=%VAR:\emacs-=%
if not "%RES%" == "%VAR%" set RES=%VAR:\bin=\share\man%
if not "%RES%" == "%VAR%" endlocal &set RES=%RES%& exit /b

endlocal &set RES=
goto :eof


REM ============================================================================
REM ====== :display ======
:display

if %debug% == true echo Displaying file %CD%\%2
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
  if "%TERM%" == "emacs" (
    set TERM=dumb
  )
  if "!TERM!" == "dumb" (
    if %debug% == true echo Dumb terminal
    if %debug% == true echo SHELL=[%SHELL%]
    if %debug% == true echo TERM=[%TERM%]
    groff -T ascii -man !file!
    if %debug% == true echo File displayed
    REM  sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" - 2>NUL
  ) else (
    if %debug% == true echo Other terminal
    if %debug% == true echo SHELL=[%SHELL%]
    if %debug% == true echo TERM=[%TERM%]
    call :Version
    if "!VERSION_MAJOR!" == "10" (
      REM Windows 10
      groff -Tascii -man !file! | sed -r "s/\x1B\[2[24]m/\x1B\[0m/g" - 2>NUL | less
    ) else (
      REM Below Windows 10
      groff -Tascii -man !file! | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" - 2>NUL | less
    )
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


REM ============================================================================
:Version
REM ===========
setlocal
REM %1 - Result variable name
set RESULT=%1
if [%RESULT%] == [] set RESULT=VERSION
REM ===========
for /f "tokens=1,2,3,4,5 delims=. " %%A in ('ver') do (
  set MAJOR=%%D& set MINOR=%%E
)
endlocal & set %RESULT%=%MAJOR%.%MINOR%& set %RESULT%_MAJOR=%MAJOR%& set %RESULT%_MINOR=%MINOR%& exit /b

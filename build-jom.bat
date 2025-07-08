@echo off
setlocal enabledelayedexpansion

set batdir=%~dp0
set curdir=%CD%

set generator="NMake Makefiles JOM"
set makeprg=jom
set builddir=%curdir%\build
set dllsfile=%builddir%\dlls.list
set lasttestlog=%builddir%\lasttestlog

REM echo %%~dp0 = %~dp0
REM echo %%~p0 = %~p0
REM echo %%~d0 = %~d0
REM echo %%~n0 = %~n0
REM echo %%~nx0 = %~nx0

REM default action
if "x%1" EQU "x" (
    call :do_compile
    exit /b 0
)

:loop_commands
if "x%1" EQU "xclean" (
    call :do_clean
) else if "x%1" EQU "xpurge" (
    call :do_purge
) else if "x%1" EQU "xbuild" (
    call :do_compile
) else if "x%1" EQU "xcompile" (
    call :do_compile
) else if "x%1" EQU "xall" (
    call :do_compile
) else if "x%1" EQU "xrebuild" (
    call :do_clean
    call :do_compile
) else if "x%1" EQU "xrecompile" (
    call :do_clean
    call :do_compile
) else if "x%1" EQU "xtest" (
    call :do_test
) else if "x%1" EQU "x" (
    exit /b 0
)
shift
goto loop_commands

:do_compile
REM echo do compiling
if not exist %curdir%\CMakeLists.txt exit /b 127
if not exist %builddir% (
    mkdir !builddir!
    if !errorlevel! NEQ 0 exit /b !errorlevel!
)
pushd %builddir% >NUL
if not exist CMakeCache.txt (
    cmake -G !generator! ..
    if !errorlevel! NEQ 0 (
        del /f /q CMakeCache.txt
        exit /b 1
    )
)
%makeprg% all
popd >NUL
goto :return

:do_test
REM echo do testing
if not exist %curdir%\CMakeLists.txt goto :return
if not exist %builddir%\CMakeCache.txt goto :return
if exist %builddir%\CMakeCache.txt (
    pushd %builddir% >NUL
    dir /b /s ..\*.dll > %dllsfile% 2>NUL
    for /f %%a in (%dllsfile%) do (
        xcopy /Y %%a .\tests\ >NUL 2>NUL
    )
    ctest --output-on-failure
    del /s /q %dllsfile% >NUL
    popd >NUL
)
goto :return

:do_clean
REM echo do cleaning
if exist %builddir% (
    pushd %builddir%
    %makeprg% clean
)
goto :return

:do_purge
REM echo do cleaning
if exist %builddir% rmdir /s /q %builddir%
goto :return

:return

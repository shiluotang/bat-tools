@echo off

if "x%PYTHON_HOME%" EQU "x" set PYTHON_HOME=C:\Python\Python312
REM Override the windows apps
call :do_prepend_path %PYTHON_HOME%

if "x%DEVCPP_HOME%" EQU "x" set DEVCPP_HOME=C:\Dev-Cpp
call :do_append_path %DEVCPP_HOME%\MinGW64\bin

if "x%RIPGREP_HOME%" EQU "x" set RIPGREP_HOME=C:\portable\ripgrep-14.1.1-x86_64-pc-windows-msvc
call :do_append_path %RIPGREP_HOME%

if "x%AG_HOME%" EQU "x" set AG_HOME=C:\portable\ag-2021-11-14-2.2.5-amd64
call :do_append_path %AG_HOME%

if "x%CMAKE_HOME%" EQU "x" set CMAKE_HOME=C:\portable\cmake-3.31.7-windows-x86_64
call :do_append_path %CMAKE_HOME%\bin

if "x%JOM_HOME%" EQU "x" set JOM_HOME=C:\portable\jom
call :do_append_path %JOM_HOME%

if "x%NVM_HOME%" EQU "x" set NVM_HOME=C:\PORTABLE\nvm-noinstall
call :do_append_path %NVM_HOME%

if "x%GNUWIN32_HOME%" EQU "x" set GNUWIN32_HOME=C:\portable\GetGnuWin32_legacy_install_archive\gnuwin32
call :do_append_path %GNUWIN32_HOME%\bin

if "x%BAT_TOOLS_HOME%" EQU "x" set BAT_TOOLS_HOME=C:\portable\bat-tools
call :do_append_path %BAT_TOOLS_HOME%

DOSKEY viclean=del /s /q *~

call :do_set_vcenv
call :do_set_dxenv
goto :do_finish

:do_set_vcenv
    set __vcvarsall_arg_arch=%PROCESSOR_ARCHITECTURE%
    if "x%1" NEQ "x" set __vcvarsall_arg_arch=%1
    set | findstr /c:"COMNTOOLS=" >NUL
    if %ERRORLEVEL% NEQ 0 call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" %__vcvarsall_arg_arch%
    set __vcvarsall_arg_arch=
    goto :do_return
:do_set_dxenv
    if exist %DXSDK_DIR% call :do_set_dxenv
    echo %PATH% | findstr /c:"%DXSDK_DIR:~0,-1%" >NUL
    if %ERRORLEVEL% NEQ 0 call "%DXSDK_DIR%\Utilities\bin\dx_setenv.cmd"
    goto :do_return
:do_append_path
    set __arg=%1
    set __path_without_trailing_slash=%1
    if %__arg:~-1% EQU "\\" set __path_without_trailing_slash=%__arg:~0,-1%
    echo %PATH% | findstr /i /c:"%__path_without_trailing_slash%" >NUL
    if %ERRORLEVEL% NEQ 0 set PATH=%PATH%;%1
    set __path_without_trailing_slash=
    set __arg=
    goto :do_return
:do_prepend_path
    set __arg=%1
    set __path_without_trailing_slash=%1
    if %__arg:~-1% EQU "\\" set __path_without_trailing_slash=%__arg:~0,-1%
    echo %PATH% | findstr /i /c:"%__path_without_trailing_slash%" >NUL
    if %ERRORLEVEL% NEQ 0 set PATH=%1;%PATH%
    set __path_without_trailing_slash=
    set __arg=
    goto :do_return
:do_return
:do_finish

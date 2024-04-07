@echo off

rem Check what Visual Studio version is installed and use the newest one
reg query "HKEY_CLASSES_ROOT\VisualStudio.DTE.14.0" >> nul 2>&1
if %ERRORLEVEL% NEQ 1 (set VSVersion=2015)
reg query "HKEY_CLASSES_ROOT\VisualStudio.DTE.15.0" >> nul 2>&1
if %ERRORLEVEL% NEQ 1 (set VSVersion=2017)
reg query "HKEY_CLASSES_ROOT\VisualStudio.DTE.16.0" >> nul 2>&1
if %ERRORLEVEL% NEQ 1 (set VSVersion=2019)
rem reg query "HKEY_CLASSES_ROOT\VisualStudio.DTE.17.0" >> nul 2>&1
rem if %ERRORLEVEL% NEQ 1 (set VSVersion=2022)

echo **********************************************************************
echo Initialization of x64 Native Command Prompt for VS %VSVersion% with ROS2
echo.

rem Initialize console with Visual Studio environment
echo ^>^> Setting up Visual Studio environment...
if %VSVersion% leq 2019 (
    call "%ProgramFiles(x86)%\Microsoft Visual Studio\%VSVersion%\Community\VC\Auxiliary\Build\vcvars64.bat" > NUL
) else (
    call "%ProgramFiles%\Microsoft Visual Studio\%VSVersion%\Community\VC\Auxiliary\Build\vcvars64.bat" > NUL
)
echo Visual Studio %VSVersion% Developer Command Prompt v%VSCMD_VER%
echo.

rem Run setup script for ROS Foxy
echo ^>^> Sourcing ROS2 Foxy...
echo Sourcing c:\opt\ros\foxy\x64\setup.bat
call c:\opt\ros\foxy\x64\setup.bat
echo Sourcing c:\opt\install\setup.bat
call c:\opt\install\setup.bat
echo.

echo ^>^> Setting ROS2 to localhost...
setx ROS_LOCALHOST_ONLY 1 > NUL
echo ROS_LOCALHOST_ONLY = %ROS_LOCALHOST_ONLY%
echo.

echo ^>^> ROS2 environment variables...
set | findstr -i ROS_
echo.

echo ^>^> Initialization complete...
echo **********************************************************************
echo.
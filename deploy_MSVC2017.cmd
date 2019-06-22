@echo off

SETLOCAL EnableDelayedExpansion
set BATCHDIR=%~dp0.
set EXEPATH=%~dpnx1

for %%G in ("%path:;=" "%") do (
	echo %%G | find "\msvc2017\bin" > NUL
	if ERRORLEVEL 0 (if not ERRORLEVEL 1 (set TMPVAR=%%G))
	)

IF NOT DEFINED TMPVAR (SET TMPVAR=*)

SET QTENVPATH=%TMPVAR:"=%

if [%2] NEQ [] (
	SET TMPVAR=%2
	SET QTENVPATH=!TMPVAR:"=!
	if exist "!QTENVPATH!\qtenv2.bat" (
		(call "!QTENVPATH!\qtenv2.bat")
	) else (
		echo Error: Invalid path to qtenv2.bat specified.
		pause & exit /B 1
	)
) else (
	if %QTENVPATH% NEQ %TMPVAR% (
		if exist "%QTENVPATH%\qtenv2.bat" (
			call "%QTENVPATH%\qtenv2.bat"
		) else (
			echo Error: Qtenv2.bat does not exist at path %QTENVPATH%.
			pause & exit /B 2
		)
	) else (
		echo Error: Failed to find path to qtenv2.bat
		pause & exit /B 3
	)
)

call "%VCINSTALLDIR%\Auxiliary\Build\vcvarsall.bat" x86

if "%EXEPATH%"=="" (set EXEPATH=%BATCHDIR%\SirOcelot.exe)

echo "%EXEPATH%"
if not exist "%EXEPATH%" (echo "Error: executable file does not exist." & pause & exit /B 4)

mkdir .\build32

copy "%EXEPATH%"  .\build32

copy "%BATCHDIR%\icon.ico" .\build32

windeployqt --dir .\build32 --qmldir "%BATCHDIR%" "%EXEPATH%"

move .\build32 "%BATCHDIR%"

pause
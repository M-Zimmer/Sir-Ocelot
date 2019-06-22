@echo off

SETLOCAL EnableDelayedExpansion
set BATCHDIR=%~dp0.
set EXEPATH=%~dpnx1

for %%G in ("%path:;=" "%") do (
	echo %%G | find "\msvc2017_64\bin" > NUL
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
		echo Invalid path to qtenv2.bat specified.
		pause & exit /B 1
	)
) else (
	if %QTENVPATH% NEQ %TMPVAR% (
		if exist "%QTENVPATH%\qtenv2.bat" (
			call "%QTENVPATH%\qtenv2.bat"
		) else (
			echo Qtenv2.bat does not exist at path %QTENVPATH%.
			pause & exit /B 2
		)
	) else (
		echo Failed to find path to qtenv2.bat
		pause & exit /B 3
	)
)

call "%VCINSTALLDIR%\Auxiliary\Build\vcvarsall.bat" x64

if "%EXEPATH%"=="" (set EXEPATH=%BATCHDIR%\SirOcelot.exe)

if not exist "%EXEPATH%" (echo "The exe file does not exist." & pause & exit /B 4)

mkdir .\build64

copy "%EXEPATH%"  .\build64

copy "%BATCHDIR%\icon.ico" .\build64

windeployqt --dir .\build64 --qmldir "%BATCHDIR%" "%EXEPATH%"

move .\build64 "%BATCHDIR%"

pause
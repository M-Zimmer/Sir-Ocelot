:: 	  Copyright 2018-2019 Max Mazur
::
::    This file is part of Sir Ocelot File Manager.
::
::    Sir Ocelot File Manager is free software: you can redistribute it and/or modify
::    it under the terms of the GNU Lesser General Public License as published by
::    the Free Software Foundation, either version 3 of the License, or
::    (at your option) any later version.
::
::    Sir Ocelot File Manager is distributed in the hope that it will be useful,
::    but WITHOUT ANY WARRANTY; without even the implied warranty of
::    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
::    GNU Lesser General Public License for more details.
::
::    You should have received a copy of the GNU Lesser General Public License
::    along with Sir Ocelot File Manager.  If not, see <https://www.gnu.org/licenses/>.

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

copy "%BATCHDIR%\LICENSE" .\build64
copy "%BATCHDIR%\COPYING" .\build64
copy "%BATCHDIR%\icon.ico" .\build64

windeployqt --dir .\build64 --qmldir "%BATCHDIR%" "%EXEPATH%"

move .\build64 "%BATCHDIR%"

pause
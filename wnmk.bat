call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
nmake
if %ERRORLEVEL% GEQ 1 EXIT /B 1
nmake install
if %ERRORLEVEL% GEQ 1 EXIT /B 1

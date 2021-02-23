@ECHO OFF
CD OliveXNAL/NAL_X/

make all
IF NOT %ERRORLEVEL%==0 GOTO END
main.exe
IF NOT %ERRORLEVEL%==0 GOTO END
make clean
IF NOT %ERRORLEVEL%==0 GOTO END
CD ../../

CD Vertification_python/src/

python main.py
IF NOT %ERRORLEVEL%==0 GOTO END

:END
CD ../..

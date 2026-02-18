@echo off
setlocal EnableExtensions

set "DIR=%~dp0"
if "%DIR:~-1%"=="\" (set "ROOT=%DIR:~0,-1%") else (set "ROOT=%DIR%")

set "SERVER_EXE=%ROOT%\CSBroadcastServer.exe"
if not exist "%SERVER_EXE%" set "SERVER_EXE=%ROOT%\CSBroadcastServer\CSBroadcastServer.exe"

if not exist "%SERVER_EXE%" (
  echo [ERROR] CSBroadcastServer.exe not found in "%ROOT%" or "%ROOT%\CSBroadcastServer"
  exit /b 1
)

set "GUI_EXE=%ROOT%\CSBroadcast.exe"
if not exist "%GUI_EXE%" set "GUI_EXE=%ROOT%\CSBroadcast\CSBroadcast.exe"

if not exist "%GUI_EXE%" (
  echo [ERROR] CSBroadcast.exe not found in "%ROOT%" or "%ROOT%\CSBroadcast"
  exit /b 1
)

start "" /min "%SERVER_EXE%" --bind 127.0.0.1 --port 8324 --root "%ROOT%"

start "" powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command ^
 "$env:SOWB_ROOT='%ROOT%'; $p = Start-Process -FilePath '%GUI_EXE%' -PassThru; ^
  $p.WaitForExit(); Start-Process -WindowStyle Hidden cmd -ArgumentList '/c taskkill /IM CSBroadcastServer.exe /F >nul 2>&1'"

exit /b

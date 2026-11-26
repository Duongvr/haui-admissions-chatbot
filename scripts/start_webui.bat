
@echo off
title HAUI Admissions Chatbot - Open WebUI

call D:\anoconda\Scripts\activate.bat haui_env
cd /d "%~dp0.."

echo Dang khoi dong Open WebUI...

start "Open WebUI" cmd /k "open-webui serve --host 127.0.0.1 --port 8088"

echo Doi Open WebUI khoi dong...

set /a COUNT=0
set /a MAX_WAIT=120

:WAIT_LOOP

powershell -NoProfile -Command "try { $r = Invoke-WebRequest -Uri 'http://127.0.0.1:8088' -TimeoutSec 2; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1

if not errorlevel 1 goto READY

if %COUNT% GEQ %MAX_WAIT% goto TIMEOUT

timeout /t 1 /nobreak >nul
set /a COUNT+=1

goto WAIT_LOOP

:READY
echo.
echo Open WebUI da san sang!
echo Dang mo trinh duyet...

start "" "http://127.0.0.1:8088"

exit /b 0

:TIMEOUT
echo.
echo ERROR: Open WebUI khoi dong qua thoi gian cho phep!
echo Vui long kiem tra cua so Open WebUI.

exit /b 1

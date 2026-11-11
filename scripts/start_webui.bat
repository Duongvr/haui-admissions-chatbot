@echo off
title HAUI Admissions Chatbot - Open WebUI

call D:\anoconda\Scripts\activate.bat haui_env
cd /d "%~dp0.."

echo Dang khoi dong Open WebUI...

start "Open WebUI" cmd /k "open-webui serve --host 127.0.0.1 --port 8088"

echo Doi Open WebUI khoi dong...
timeout /t 15 /nobreak >nul

start http://127.0.0.1:8088

exit
@echo off
title HAUI Admissions Chatbot - Open WebUI

:: Kich hoat môi truong Conda haui_env
call D:\anoconda\Scripts\activate.bat haui_env

:: Tro ve thu muc goc du an
cd /d "%~dp0.."

:: Dat thu muc luu du lieu
set DATA_DIR=./open-webui/data

echo Dang khoi chay Open WebUI tai dia chi: http://127.0.0.1:8088
open-webui serve --host 127.0.0.1 --port 8088

pause
@echo off
REM Script khởi động Ollama với models cho HAUI Admissions Chatbot
REM Windows 10/11

setlocal enabledelayedexpansion

echo ============================================
echo HAUI Admissions - Ollama Startup
echo ============================================
echo.

REM Kiểm tra Ollama đã cài chưa
where ollama >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Ollama chưa được cài đặt hoặc không trong PATH
    echo Tải từ: https://ollama.ai
    pause
    exit /b 1
)

echo [OK] Ollama found at:
ollama --version
echo.

REM Đợi một chút trước khi kiểm tra
timeout /t 2 /nobreak

REM Kiểm tra Ollama có đang chạy không
echo Checking Ollama service...
curl -s http://localhost:11434/api/tags >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] Ollama is already running on port 11434
    echo.
    echo Available models:
    ollama list
) else (
    echo [INFO] Starting Ollama service...
    echo.
    
    REM Khởi động Ollama
    start "Ollama Server" ollama serve
    
    REM Đợi Ollama khởi động
    echo Waiting for Ollama to start...
    for /L %%i in (1,1,30) do (
        timeout /t 1 /nobreak >nul
        curl -s http://localhost:11434/api/tags >nul 2>&1
        if !errorlevel! equ 0 (
            echo.
            echo [OK] Ollama started successfully!
            goto :pull_models
        )
    )
    
    echo [ERROR] Ollama failed to start
    pause
    exit /b 1
)

:pull_models

echo.
echo ============================================
echo Setting up models...
echo ============================================
echo.

REM Tải models (tuỳ chọn)
set MODELS=qwen2.5:1.5b nomic-embed-text

for %%M in (%MODELS%) do (
    echo Checking for %%M...
    ollama list | findstr /R "%%M" >nul
    if !errorlevel! equ 0 (
        echo [OK] %%M already available
    ) else (
        echo [INFO] Pulling %%M (this may take a few minutes)...
        ollama pull %%M
    )
    echo.
)

echo.
echo ============================================
echo Setup complete!
echo ============================================
echo.
echo Ollama is running on:
echo   - API: http://localhost:11434
echo   - Web: (Open WebUI on port 3000)
echo.
echo Available models:
ollama list
echo.
echo Press any key to continue monitoring...
pause

REM Hiển thị monitoring
:monitor
echo.
echo [Monitoring Ollama]
ollama list
timeout /t 5 /nobreak
goto monitor

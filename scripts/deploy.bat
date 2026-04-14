@echo off
echo ========================================
echo  Building release APK...
echo ========================================
call flutter build apk --release
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [FAIL] Build failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo  Installing on device...
echo ========================================
call flutter install -d 45b29d2b --release
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [FAIL] Install failed - is phone connected?
    echo  Try: flutter devices
    pause
    exit /b 1
)

echo.
echo ========================================
echo  DEPLOYED SUCCESSFULLY
echo ========================================
pause

@echo off
echo ========================================
echo  FULL CHECK: analyze + test + build
echo ========================================
echo.

echo [1/4] flutter analyze...
call flutter analyze
if %ERRORLEVEL% NEQ 0 (
    echo [FAIL] Analyze failed
    pause
    exit /b 1
)
echo [PASS] analyze

echo.
echo [2/4] Unit + widget tests...
call flutter test
if %ERRORLEVEL% NEQ 0 (
    echo [FAIL] Unit tests failed
    pause
    exit /b 1
)
echo [PASS] unit tests

echo.
echo [3/4] Integration tests (device required)...
flutter devices | findstr /i "mobile" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [SKIP] No mobile device connected - skipping integration tests
) else (
    call flutter test integration_test/ -d 45b29d2b
    if %ERRORLEVEL% NEQ 0 (
        echo [FAIL] Integration tests failed
        pause
        exit /b 1
    )
    echo [PASS] integration tests
)

echo.
echo [4/4] Building release APK...
call flutter build apk --release
if %ERRORLEVEL% NEQ 0 (
    echo [FAIL] Build failed
    pause
    exit /b 1
)
echo [PASS] release build

echo.
echo ========================================
echo  ALL CHECKS PASSED
echo ========================================
pause

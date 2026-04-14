@echo off
echo ========================================
echo  Running flutter analyze...
echo ========================================
call flutter analyze
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [FAIL] flutter analyze found issues
    pause
    exit /b 1
)

echo.
echo ========================================
echo  Running unit + widget tests...
echo ========================================
call flutter test
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [FAIL] Some tests failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo  ALL TESTS PASSED
echo ========================================
pause

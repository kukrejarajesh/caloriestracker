@echo off
setlocal enabledelayedexpansion
REM =========================================================================
REM  release-check.bat — Pre-release safety gate
REM
REM  Catches two classes of bugs before they reach users:
REM    1. Schema version bumped without a matching drift_schema snapshot
REM    2. assets/foods.db changed without bumping currentSeedVersion (or v.v.)
REM
REM  Also runs the migration tests that verify _upgradeToVN correctness.
REM
REM  Usage:  scripts\release-check.bat          (from project root)
REM  Exit:   0 = all checks pass, 1 = at least one failed
REM =========================================================================

echo ============================================================
echo  RELEASE CHECK — seed/schema consistency + migration tests
echo ============================================================
echo.

set FAIL=0

REM ------------------------------------------------------------------
REM  1. Migration tests — does _upgradeToV2 produce the correct shape?
REM ------------------------------------------------------------------
echo [1/4] Running migration tests...
call flutter test test/data/database/calorie_tracker/migration_test.dart
if !ERRORLEVEL! NEQ 0 (
    echo [FAIL] Migration tests failed
    set FAIL=1
) else (
    echo [PASS] Migration tests
)
echo.

REM ------------------------------------------------------------------
REM  2. Schema snapshot exists for current schemaVersion
REM ------------------------------------------------------------------
echo [2/4] Checking schema snapshot...

REM Extract schemaVersion from app_database.dart
for /f "tokens=4 delims=; " %%v in ('findstr /r "schemaVersion.*=>" lib\data\database\app_database.dart') do set SCHEMA_VER=%%v

if "!SCHEMA_VER!"=="" (
    echo [FAIL] Could not parse schemaVersion from app_database.dart
    set FAIL=1
    goto :check3
)

echo        schemaVersion = !SCHEMA_VER!

REM Check both legacy and make-migrations locations
set SNAPSHOT_FOUND=0
if exist "drift_schemas\drift_schema_v!SCHEMA_VER!.json" set SNAPSHOT_FOUND=1
if exist "drift_schemas\calorie_tracker\drift_schema_v!SCHEMA_VER!.json" set SNAPSHOT_FOUND=1

if !SNAPSHOT_FOUND!==0 (
    echo [FAIL] No schema snapshot for v!SCHEMA_VER!
    echo        Expected: drift_schemas\drift_schema_v!SCHEMA_VER!.json
    echo        Run: dart run drift_dev schema dump lib\data\database\app_database.dart drift_schemas\
    set FAIL=1
) else (
    echo [PASS] Schema snapshot exists for v!SCHEMA_VER!
)

:check3
echo.

REM ------------------------------------------------------------------
REM  3. Seed version consistency: foods.db changed ↔ currentSeedVersion bumped
REM ------------------------------------------------------------------
echo [3/4] Checking seed version consistency...

REM Extract currentSeedVersion from db_seeder.dart
for /f "tokens=6 delims=; " %%v in ('findstr "currentSeedVersion" lib\data\seed\db_seeder.dart ^| findstr /r "= [0-9]"') do set SEED_VER=%%v

if "!SEED_VER!"=="" (
    echo [FAIL] Could not parse currentSeedVersion from db_seeder.dart
    set FAIL=1
    goto :check4
)

echo        currentSeedVersion = !SEED_VER!

REM Check if assets/foods.db has uncommitted changes (staged or unstaged)
git diff --name-only HEAD -- assets/foods.db 2>nul | findstr "foods.db" >nul 2>&1
set FOODS_CHANGED_UNSTAGED=!ERRORLEVEL!

git diff --cached --name-only -- assets/foods.db 2>nul | findstr "foods.db" >nul 2>&1
set FOODS_CHANGED_STAGED=!ERRORLEVEL!

REM Also check if db_seeder.dart has changes (meaning seed version was bumped)
git diff --name-only HEAD -- lib/data/seed/db_seeder.dart 2>nul | findstr "db_seeder" >nul 2>&1
set SEEDER_CHANGED_UNSTAGED=!ERRORLEVEL!

git diff --cached --name-only -- lib/data/seed/db_seeder.dart 2>nul | findstr "db_seeder" >nul 2>&1
set SEEDER_CHANGED_STAGED=!ERRORLEVEL!

REM foods.db changed = either staged or unstaged diff contains it
set FOODS_CHANGED=1
if !FOODS_CHANGED_UNSTAGED!==0 set FOODS_CHANGED=0
if !FOODS_CHANGED_STAGED!==0 set FOODS_CHANGED=0

set SEEDER_CHANGED=1
if !SEEDER_CHANGED_UNSTAGED!==0 set SEEDER_CHANGED=0
if !SEEDER_CHANGED_STAGED!==0 set SEEDER_CHANGED=0

if !FOODS_CHANGED!==0 if !SEEDER_CHANGED!==1 (
    echo [FAIL] assets/foods.db changed but db_seeder.dart did NOT
    echo        You must bump currentSeedVersion when shipping new foods.
    echo        Both changes must be in the same commit.
    set FAIL=1
    goto :check4
)

if !FOODS_CHANGED!==1 if !SEEDER_CHANGED!==0 (
    echo [WARN] db_seeder.dart changed but assets/foods.db did NOT
    echo        If you bumped currentSeedVersion, the asset must also change.
    echo        If the seeder change is unrelated to seed content, ignore this.
)

if !FOODS_CHANGED!==0 if !SEEDER_CHANGED!==0 (
    echo [PASS] Both foods.db and currentSeedVersion changed together
    goto :check4
)

if !FOODS_CHANGED!==1 if !SEEDER_CHANGED!==1 (
    echo [PASS] Neither foods.db nor currentSeedVersion changed — no seed update
)

:check4
echo.

REM ------------------------------------------------------------------
REM  4. Schema snapshot freshness — re-dump and compare
REM ------------------------------------------------------------------
echo [4/4] Verifying schema snapshot is up-to-date...

REM Dump current schema to a temp location
set TEMP_SCHEMA_DIR=%TEMP%\drift_schema_check
if exist "!TEMP_SCHEMA_DIR!" rmdir /s /q "!TEMP_SCHEMA_DIR!"
mkdir "!TEMP_SCHEMA_DIR!"

call dart run drift_dev schema dump lib\data\database\app_database.dart "!TEMP_SCHEMA_DIR!" >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo [FAIL] Could not dump current schema
    set FAIL=1
    goto :done
)

REM Compare the freshly-dumped v<N>.json with the committed one
set FRESH=!TEMP_SCHEMA_DIR!\drift_schema_v!SCHEMA_VER!.json
set COMMITTED=drift_schemas\drift_schema_v!SCHEMA_VER!.json

if not exist "!FRESH!" (
    echo [FAIL] Schema dump did not produce v!SCHEMA_VER! snapshot
    set FAIL=1
    goto :done
)

if not exist "!COMMITTED!" (
    REM Try the make-migrations location
    set COMMITTED=drift_schemas\calorie_tracker\drift_schema_v!SCHEMA_VER!.json
)

if not exist "!COMMITTED!" (
    echo [FAIL] No committed snapshot to compare against
    set FAIL=1
    goto :done
)

fc /b "!FRESH!" "!COMMITTED!" >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo [FAIL] Committed schema snapshot is STALE
    echo        The current code produces a different schema than what's committed.
    echo        Run: dart run drift_dev schema dump lib\data\database\app_database.dart drift_schemas\
    echo        Then re-run: dart run drift_dev make-migrations
    set FAIL=1
) else (
    echo [PASS] Schema snapshot is current
)

REM Cleanup temp
rmdir /s /q "!TEMP_SCHEMA_DIR!" 2>nul

:done
echo.
if !FAIL!==1 (
    echo ============================================================
    echo  RELEASE CHECK FAILED — fix issues above before releasing
    echo ============================================================
    pause
    exit /b 1
)

echo ============================================================
echo  ALL RELEASE CHECKS PASSED
echo ============================================================
pause
exit /b 0

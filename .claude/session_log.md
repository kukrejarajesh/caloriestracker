# Session Log

Append-only log of completed work and the handoff state for the next session.
Most recent session at the top.

---

## 2026-04-17 — Migration Strategy Session 5 (first real seed data update)

### What was completed

**Added 50 new Indian foods to the seed database, bumped `currentSeedVersion`
from 1 → 2, and verified the entire seed/migration pipeline end-to-end.**

This is the first real use of the reconciliation infrastructure built in
Sessions 1–4: existing users upgrading from seed v1 will get 50 new foods
inserted additively via `DbSeeder.reconcileInto()` on their next app launch,
without losing any existing data or custom foods.

#### New foods added (50 items across 10 categories)

| Category | Count | Examples |
|---|---|---|
| Vegetables | 10 | Ash Gourd, Snake Gourd, Tindora, Parwal, Cluster Beans, Yam, Arbi, Raw Banana, Drumstick, Lotus Stem |
| Fruits | 5 | Jamun, Bael, Star Fruit, Amla, Custard Apple |
| Legumes/Pulses | 5 | Horse Gram, Moth Bean sprouts, Rajma canned, Green Peas frozen, Val Dal |
| Dairy | 5 | Lassi, Chaas, Shrikhand, Mishti Doi, Mawa/Khoya |
| Fish/Seafood | 5 | Bangda, Surmai, Catla, Bombay Duck dried, Squid |
| Meat/Poultry | 5 | Mutton Liver, Chicken Drumstick, Pork Belly, Duck, Quail |
| Beverages | 5 | Nimbu Pani, Jal Jeera, Thandai, Kokum Sharbat, Sattu Drink |
| Snacks | 5 | Makhana roasted, Kurmura Chivda, Sabudana Vada, Rice Murukku, Roasted Chana |
| Sweets/Desserts | 5 | Kalakand, Sandesh, Coconut Barfi, Phirni, Til Ladoo |

**Totals:** 271 → 321 foods. Gluten distribution: 283 gluten_free, 24
contains_gluten, 14 may_contain (all 50 new foods are gluten-free).

#### Tool/schema updates

- `tools/schema.sql` — added `seed_key TEXT` column + index to foods table DDL.
- `tools/seed_foods_db.py` —
  - Added `_slugify()` and `_make_seed_key()` (mirrors `seed_key.dart` exactly).
  - Computes `seed_key` for every food before insert.
  - Added duplicate `seed_key` detection — script exits with error if any key
    collides (caught 3 collisions during development).
  - INSERT statement now includes `seed_key` column.
  - Updated docstring header.
- `assets/foods.db` — regenerated with 321 foods, all with `seed_key` column
  populated. File size: 104 KB.
- `lib/data/seed/db_seeder.dart` — bumped `currentSeedVersion` from 1 to 2.

#### How reconciliation works for this update

When an existing user on seed v1 (271 foods) launches the updated app:

1. `beforeOpen` → `DbSeeder.reconcileInto(db)` is called.
2. Reads `metadata.seed_version` → finds `1`.
3. Since `1 < 2` (currentSeedVersion), opens `assets/foods.db` as raw sqlite3.
4. Loads all existing `seed_key` values from the device's `foods` table.
5. Iterates asset rows — the 271 original rows are skipped (seed_key already
   exists on device). The 50 new rows are inserted.
6. Writes `metadata.seed_version = 2` inside the same transaction.
7. Next launch: `1 < 2` check → device is now at 2 → short-circuits immediately.

Custom foods (is_custom=1, seed_key=NULL) are never touched.

### Verification

| Step | Command | Result |
|---|---|---|
| Analyze | `flutter analyze` | `No issues found!` · exit 0 |
| Test | `flutter test` | 199/199 pass · exit 0 |
| Release check | `dart run scripts/release_check.dart --ci` | All 3 checks passed · exit 0 |
| Seed key check | `seed_foods_db.py` | 321 unique seed_keys, 0 duplicates |

The release check script specifically confirmed: **"Both foods.db and
currentSeedVersion changed together"** — the exact scenario it was built to
catch in Session 4.

### Files modified

```
 M assets/foods.db                            (271 → 321 foods, +seed_key column)
 M lib/data/seed/db_seeder.dart               (currentSeedVersion 1 → 2)
 M tools/schema.sql                           (+seed_key column + index)
 M tools/seed_foods_db.py                     (+seed_key gen, +50 foods, +dup check)
```

### Migration strategy — complete

All 5 sessions of the migration strategy are now done:

| Session | What | Status |
|---|---|---|
| 1 | Schema v2 foundation (seed_key + metadata table) | ✅ |
| 2 | Reconciliation (reconcileInto + beforeOpen) | ✅ |
| 3 | Automated migration tests (drift_dev make-migrations) | ✅ |
| 4 | Release checklist automation (release-check script + CI) | ✅ |
| 5 | First real seed data update (50 new foods, v1→v2) | ✅ |

The full pipeline — from adding new foods in Python, through seed_key generation,
asset DB regeneration, version bumping, to runtime additive reconciliation — is
now proven end-to-end. Future food additions follow the same pattern:
1. Add entries to `FOODS` list in `seed_foods_db.py`
2. Run `py seed_foods_db.py`
3. Bump `currentSeedVersion` in `db_seeder.dart`
4. Run `scripts/release-check.bat` or `dart run scripts/release_check.dart --ci`
5. Ship

---

## 2026-04-17 — Migration Strategy Session 4 (release checklist automation)

### What was completed

**Pre-release safety gate** that catches seed/schema version mismatches before
they reach users. Implemented as both a Windows `.bat` script and a
cross-platform Dart script (for CI).

#### Files added

- `scripts/release-check.bat` — Windows-native version with 4 checks:
  1. Runs migration tests (`flutter test test/data/database/calorie_tracker/`)
  2. Verifies `drift_schema_v<N>.json` snapshot exists for current `schemaVersion`
  3. Cross-checks `assets/foods.db` changes against `currentSeedVersion` changes
     (both must change together or neither)
  4. Re-dumps schema and byte-compares against committed snapshot to catch staleness

- `scripts/release_check.dart` — Cross-platform Dart version with 3 checks
  (same as above minus the flutter-test step, since CI runs that separately):
  1. Schema snapshot existence for current `schemaVersion`
  2. Seed version consistency (`foods.db` ↔ `currentSeedVersion` co-change)
  3. Schema snapshot freshness (re-dump + byte-compare)
  Supports `--ci` flag for non-interactive mode (no stdin prompt on exit).

#### CI integration

- `.github/workflows/ci.yml` — added `Release check (seed/schema consistency)`
  step after `Run unit & widget tests`, running
  `dart run scripts/release_check.dart --ci`.

### How the checks work

**Seed version consistency** uses `git diff` to detect whether `assets/foods.db`
and `lib/data/seed/db_seeder.dart` have pending changes relative to HEAD:

| foods.db | db_seeder.dart | Result |
|---|---|---|
| changed | changed | PASS — both updated together |
| changed | unchanged | FAIL — forgot to bump `currentSeedVersion` |
| unchanged | changed | WARN — seeder changed but asset didn't (may be harmless) |
| unchanged | unchanged | PASS — no seed update this release |

**Schema snapshot freshness** runs `dart run drift_dev schema dump` to a temp dir,
then byte-compares the output against the committed snapshot. Catches:
- Adding a column but forgetting to re-dump
- Editing a table definition after the last dump

### Verification

| Step | Command | Result |
|---|---|---|
| Analyze | `flutter analyze` | `No issues found!` · exit 0 |
| Test | `flutter test` | 199/199 pass · exit 0 |
| Release check | `dart run scripts/release_check.dart --ci` | All checks passed · exit 0 |

### Files modified

```
 M .github/workflows/ci.yml                   (added release-check step)
?? scripts/release-check.bat                  (Windows version)
?? scripts/release_check.dart                 (cross-platform Dart version)
```

### What the next session should start with

1. **Session 5: First real seed data update** — add new foods to `assets/foods.db`,
   bump `currentSeedVersion` from 1 to 2, run `make-migrations` if schema changed,
   run migration tests + release check, verify reconciler inserts new rows on
   existing installs.

---

## 2026-04-17 — Migration Strategy Session 3 (automated migration tests)

### What was completed

**Automated snapshot-driven migration tests using `drift_dev make-migrations`.**
These tests verify that `_upgradeToV2` correctly transforms a real v1 SQLite DB
into the v2 schema shape, and that pre-existing user data survives the migration.

#### Setup & generation

1. Created `build.yaml` at project root — configures `drift_dev` with the
   `calorie_tracker` database entry pointing at `app_database.dart`, plus
   `schema_dir: drift_schemas/` and `test_dir: test/data/database/`.
2. Copied `drift_schema_v1.json` into `drift_schemas/calorie_tracker/`
   (the db-namespaced subfolder that `make-migrations` expects).
3. Ran `dart run drift_dev make-migrations` which generated:
   - `lib/data/database/app_database.steps.dart` — step-by-step migration helper
     (generated, informational — our `app_database.dart` already has the manual
     migration in `_upgradeToV2`; we kept our existing approach).
   - `test/data/database/calorie_tracker/generated/schema.dart` —
     `GeneratedHelper` implementing `SchemaInstantiationHelper` for v1 and v2.
   - `test/data/database/calorie_tracker/generated/schema_v1.dart` — full v1
     schema as generated Drift tables + data classes.
   - `test/data/database/calorie_tracker/generated/schema_v2.dart` — same for v2.
   - `test/data/database/calorie_tracker/migration_test.dart` — template test
     (we rewrote this with real data integrity assertions — see below).

#### Migration test file: `test/data/database/calorie_tracker/migration_test.dart`

**4 tests across 2 groups:**

- **simple database migrations** (1 test):
  - `from 1 to 2` — starts at schema v1, runs migration, validates result
    matches the v2 snapshot via `SchemaVerifier.migrateAndValidate`.

- **v1 to v2 data integrity** (3 tests):
  - `seeded food rows survive migration and gain null seed_key` — inserts 3 foods
    (2 seeded, 1 custom) + 1 food_log + 1 user_profile into a v1 DB, migrates,
    then verifies:
    - All 3 foods survive.
    - Seeded foods get `seed_key` backfilled (not null).
    - Custom food keeps `seed_key = null`.
    - Nutritional data (calories, protein, gluten_status) preserved exactly.
    - food_logs preserved (foodId, calories, glutenStatus).
    - user_profile preserved (name, isGlutenFree, onboardingComplete).
    - `metadata` table created with `seed_version = '1'`.
  - `empty v1 database migrates to v2 cleanly` — edge case: no rows at all,
    just verifies schema shape and `seed_version = 1` in metadata.
  - `food_logs with gluten data survive migration` — specifically tests that
    `may_contain` gluten status on both the food and its log entry is preserved.
    Critical for the user's strict gluten-free diet tracking.

#### Cleanup

- **Deleted** `test/migrations/schema_v1_to_v2_test.dart` — a stale hand-written
  migration test from a previous attempt that referenced non-existent columns
  (`age`, `goal`, `tdee`) and stale generated schema files. Was the sole
  pre-existing test failure (compilation error). Superseded by the new
  `make-migrations`-based tests.
- **Deleted** `test/generated_migrations/` — old schema files from the manual
  `drift_dev schema steps` approach; superseded by
  `test/data/database/calorie_tracker/generated/`.
- **Deleted** `test/data/database/generated_migrations/` — intermediate artifact
  from this session's initial `schema steps` run, before switching to
  `make-migrations`.

### Files added

```
?? build.yaml
?? drift_schemas/calorie_tracker/drift_schema_v1.json
?? drift_schemas/calorie_tracker/drift_schema_v2.json
?? lib/data/database/app_database.steps.dart              (generated)
?? test/data/database/calorie_tracker/generated/schema.dart
?? test/data/database/calorie_tracker/generated/schema_v1.dart
?? test/data/database/calorie_tracker/generated/schema_v2.dart
?? test/data/database/calorie_tracker/migration_test.dart  (hand-written)
```

### Files deleted

```
D  test/migrations/schema_v1_to_v2_test.dart              (stale, broken)
D  test/generated_migrations/schema.dart                  (superseded)
D  test/generated_migrations/schema_v1.dart               (superseded)
D  test/generated_migrations/schema_v2.dart               (superseded)
D  test/data/database/generated_migrations/schema_versions.dart  (superseded)
```

### Verification

| Step | Command | Result |
|---|---|---|
| Analyze | `flutter analyze` | `No issues found!` · exit 0 (23.2s) |
| Test | `flutter test` | 199/199 pass · exit 0 |
| Migration only | `flutter test test/data/database/calorie_tracker/migration_test.dart` | 4/4 pass · exit 0 |

4 new tests added on top of the 195 already passing. Net change: +4 tests,
-0 (the stale broken test was already failing compilation and never ran).

### Design decisions

- **Used `drift_dev make-migrations` (not manual `schema steps`).** This is the
  newer, recommended approach. Generates the `SchemaInstantiationHelper`, typed
  schema classes per version, and a test template — less manual boilerplate.
- **Kept our existing manual `_upgradeToV2` migration.** The generated
  `app_database.steps.dart` is informational but we don't import it from
  production code. Our `onUpgrade` in `app_database.dart` remains the source
  of truth for migration logic. Tests just verify its output.
- **`AppDatabase.forTesting(schema.newConnection(), skipSeeding: true)`** — the
  existing test-constructor pattern slots right in. The drift_dev template
  expected `AppDatabase(e)` but we adapted it to our constructor.
- **`import 'package:drift/drift.dart' hide isNull, isNotNull`** — avoids name
  collision between Drift's expression helpers and `package:matcher` matchers.
- **`build.yaml` uses `test_dir: test/data/database/`** to keep generated test
  scaffolding under the same `test/data/` tree as DAO tests.

### What the next session should start with

1. **Session 4: `scripts/release-check.bat`** — a CI-ready script that fails
   fast if `assets/foods.db` changed without bumping `currentSeedVersion`
   (or vice versa). Prevents shipping mismatched seed data.
2. **Session 5: First real seed data update** to exercise the whole pipeline
   end-to-end: new asset DB → bump `currentSeedVersion` → `make-migrations`
   to re-dump schema if needed → run migration tests → reconciler inserts new
   rows on launch.

---

## 2026-04-16 — Migration Strategy Session 2 (reconcileInto + beforeOpen)

### What was completed

**The additive reconciliation path that Session 1 prepared the ground for.**
`DbSeeder.reconcileInto(db)` now runs on every launch via the Drift `beforeOpen`
hook and inserts newly-shipped seeded foods into existing installs — without
modifying any existing row, seeded or custom.

Files modified:
- `lib/data/seed/db_seeder.dart` —
  - Added `reconcileInto(AppDatabase db)` as the public entry point. Reads
    `metadata.seed_version`, short-circuits when device is already at or above
    `currentSeedVersion`, otherwise copies `assets/foods.db` to a temp file,
    opens it with raw sqlite3, and delegates to the testable path.
  - Added `@visibleForTesting reconcileFoodsFromRawDb(db, seedDb, {targetSeedVersion})`
    — this is where the actual logic lives. Returns a `ReconcileReport` record
    (inserted / skipped / skippedByShortCircuit). Wraps batch-insert + metadata
    stamp in a single `db.transaction(...)` so a crash mid-reconcile cannot
    leave `seed_version` ahead of the actual row set.
  - Extracted `_companionFromRow(raw.Row)` — previously duplicated between
    `_seedFoods` and the new reconciliation path. Single source of truth for
    nullable-column handling and the asset-seed_key-or-compute fallback.
  - Introduced `ReconcileReport` value class for test assertions without
    scraping logs.
- `lib/data/database/app_database.dart` —
  - Added `beforeOpen: (OpeningDetails details)` branch of `MigrationStrategy`.
    Skips when `details.wasCreated` (fresh install already seeded via `onCreate`),
    skips when `_skipSeeding` (tests), otherwise calls `DbSeeder.reconcileInto(this)`.
  - Extended `_skipSeeding` docstring + field comment to reflect its new double
    duty (suppresses both `onCreate` seeding AND `beforeOpen` reconciliation).
    Semantics change, no signature change — all 5 existing DAO tests keep working
    unchanged.
- `test/data/seed/db_seeder_test.dart` — NEW, 10 tests across 5 groups:
  - **short-circuit** — three tests: device at target, device ahead of target
    (must never roll back), device with no metadata row (treated as 0).
  - **additive inserts** — three tests: pre-existing seeded row untouched +
    new rows inserted, `seed_version` only bumped after success, zero-insert
    pass still bumps version.
  - **custom-row safety** — one test proving a custom "Apple" (seed_key = NULL,
    is_custom = 1) does NOT block insertion of an asset "Apple" with a
    seed_key — different identity.
  - **idempotency** — two tests: second run after first is a short-circuit no-op;
    asset with duplicate seed_keys inserts each key once.
  - **legacy asset compatibility** — one test: asset DB without the `seed_key`
    column falls back to `makeSeedKey(name, brand)` correctly.

### Scope boundaries (what Session 2 explicitly does NOT do)

- **Exercises are not reconciled.** `exercises` table has no `seed_key` column.
  Adding one would require a schema v2→v3 migration + Python tool update. Left
  as a future session. The comment in `reconcileInto` flags this.
- **`currentSeedVersion` is still 1.** Production reconciliation is a no-op
  until the first real asset update ships (Session 5). Tests simulate v2 via
  the `targetSeedVersion` parameter on the testable entry point.
- **No manual migration test of the v1→v2 schema transition.** That's
  Session 3 territory — drift_schemas snapshot-based migration tests.

### Verification

| Step | Command | Result |
|---|---|---|
| Analyze | `flutter analyze` | `No issues found!` · exit 0 (97.9s) |
| Test | `flutter test` | 195/195 pass · exit 0 (27s) |

10 new tests added on top of the 185 already passing.

### Design decisions worth preserving

- **Testable seam at raw.Database, not at List<Map>.** Tests build an in-memory
  raw sqlite3 DB that mimics the asset schema. This exercises the actual SQL
  path (column names, NULL handling, `_tryReadString`) rather than a mock
  data structure that could drift from the real asset format. Cost: ~30 lines
  of fixture helpers; benefit: bug-for-bug parity with production I/O.
- **`targetSeedVersion` is a parameter, not `DbSeeder.currentSeedVersion`**
  on the testable entry point. Lets tests simulate progressive updates
  (v1→v2, v2→v3) without rebuilding the app or mutating a `const`.
- **Transaction wraps inserts + metadata write.** If the batch fails partway,
  the metadata row does NOT get stamped — next launch retries the same
  reconciliation. If we wrote metadata first or outside the transaction, a
  crash would leave `seed_version = 2` with only half the v2 rows inserted,
  and the next launch would short-circuit and never fix it.
- **Short-circuit on device version >= target (not ==).** Protects against a
  downgraded build from clobbering a device that already saw a newer seed
  set. Never write a smaller version over a larger one.
- **Duplicate-key defense inside the loop.** If the Python tool ever emits
  two rows with the same `seed_key`, we insert the first and skip the rest.
  Documented in the idempotency test.

### Working tree state at end of session

All Session 1 + Session 2 work is uncommitted (per user request — no git push
yet). Ready for the logical-piece commits outlined below when user decides.

New/modified this session:
```
 M lib/data/database/app_database.dart        (beforeOpen hook + docstring)
 M lib/data/seed/db_seeder.dart               (reconcileInto + helpers + ReconcileReport)
?? test/data/seed/db_seeder_test.dart         (10 new tests)
```

Still carried over from Session 1 and the DAO-test-fix session (unchanged):
```
 M CLAUDE.md
 M integration_test/food_log_test.dart
 M integration_test/weight_test.dart
 M lib/data/database/app_database.g.dart
 M lib/data/tables/foods_table.dart
 M lib/features/food_log/food_search_screen.dart
 M test/data/daos/foods_dao_test.dart
 M test/data/daos/food_logs_dao_test.dart
 M test/data/daos/user_profile_dao_test.dart
 M test/data/daos/water_logs_dao_test.dart
 M test/data/daos/weight_logs_dao_test.dart
 M test/widget_test.dart
 M windows/flutter/generated_plugin_registrant.cc   <- stray, unrelated
 M windows/flutter/generated_plugins.cmake          <- stray, unrelated
?? .claude/decisions/
?? drift_schemas/
?? lib/core/utils/seed_key.dart
?? lib/data/daos/metadata_dao.dart
?? lib/data/daos/metadata_dao.g.dart
?? lib/data/tables/metadata_table.dart
```

### What the next session should start with

1. **Commit & push** (when user is ready). Suggested logical pieces — now
   extended from last session's list:
   - Commit A — schema v2 foundation (unchanged from prior plan).
   - Commit B — test-seeding opt-out + DAO test fixes (unchanged).
   - Commit C — CI cleanup (unchanged).
   - **NEW Commit D** — Session 2: reconciliation path
     (`lib/data/seed/db_seeder.dart`, `lib/data/database/app_database.dart`,
     `test/data/seed/db_seeder_test.dart`).
   - Commit E — docs: `CLAUDE.md` migration-strategy additions +
     `.claude/decisions/database-schema.md` + this session log entry.
   - Stray `windows/flutter/` files: verify and commit or revert.
2. **Watch CI turn green** on both `analyze-and-test` and `build-apk`. First
   post-Session-2 push.
3. **Then start Migration Strategy Session 3** — automated migration tests
   driven from the `drift_schemas/drift_schema_vN.json` snapshots. This is
   the safety net that catches "does `_upgradeToV2` actually produce the v2
   shape from a real v1 DB?" Approach: use `drift_dev schema steps` +
   `package:drift_dev/api/migrations.dart` helpers to verify every snapshot
   transition. Add a CI step once the local tests are green.

Further out (unchanged):
- Session 4: `scripts/release-check.bat` — fail fast if `assets/foods.db`
  changed without bumping `currentSeedVersion` (or vice versa).
- Session 5: First real seed data update to exercise the whole pipeline
  end-to-end.

---

## 2026-04-16 — DAO test fix + full CI unblock

### What was completed

**Fixed the pre-existing DAO test failures that blocked `analyze-and-test` CI job.**
This is the side-task handed off from the previous session (same day). All five DAO test files under `test/data/daos/*.dart` were dying at `setUp` with `Binding has not yet been initialized` because `AppDatabase.forTesting(NativeDatabase.memory())` triggered `onCreate` → `DbSeeder.seedInto` → `getApplicationDocumentsDirectory()` + `rootBundle.load(...)`, neither of which work under a plain `flutter test` binding.

Approach taken: **opt-out seeding flag on the test constructor**, as suggested in the handoff prompt. Alternative (seeder-as-callback injection) was rejected as noisier — the flag reads cleaner at call sites and keeps production behavior identical.

Files modified:
- `lib/data/database/app_database.dart` —
  - `AppDatabase.forTesting(super.e, {bool skipSeeding = false})` (super-parameter form; initializes new private `_skipSeeding` field).
  - No-arg production constructor sets `_skipSeeding = false`.
  - `onCreate` early-returns after `createAll()` when `_skipSeeding == true`, bypassing both `DbSeeder.seedInto(this)` and the `metadataDao.setInt(seedVersionKey, currentSeedVersion)` write.
  - `schemaVersion`, `_upgradeToV2`, and all other Session 1 migration code were **not touched**.
- Five DAO test files — `test/data/daos/{foods,food_logs,user_profile,water_logs,weight_logs}_dao_test.dart` — each `setUp` now passes `skipSeeding: true`.
- Same five DAO test files — removed spurious `show FoodsCompanion, FoodLogsCompanion, UserProfileCompanion` clauses (these companions come from `app_database.g.dart` via the `part` directive, not from `package:drift/drift.dart`), and removed the 5 now-unused `tables/*.dart` imports that propped them up. Required to keep `flutter analyze` clean.

**Scope note re: Session 1 prompt.** The handoff listed 5 DAO test files including `exercise_logs_dao_test.dart`, but that file does not exist in the repo. The actual 5 are foods / food_logs / user_profile / water_logs / weight_logs. `exercise_logs_dao_test.dart` is simply absent — not overlooked, not skipped.

**Also fixed remaining CI blockers so the full workflow turns green.**
After the DAO fix, `flutter analyze` was still exiting 1 (info-level diagnostics are fatal by default in this Flutter), and `flutter test` still failed on an unrelated smoke test. Rather than kicking those down the road, cleared both:

- `integration_test/food_log_test.dart` — removed unused `gluten_badge.dart` import (the only reference was a test-name string literal, not the widget).
- `integration_test/weight_test.dart` — deleted unused `enterAndLogWeight` helper and its orphan `field` local. All four test bodies already inlined the same logic.
- `test/widget_test.dart` — replaced the broken boilerplate smoke test. New version overrides `appDatabaseProvider` with `AppDatabase.forTesting(NativeDatabase.memory(), skipSeeding: true)` via `ProviderScope`, so the test doesn't need `path_provider` / real on-disk Drift. Asserts `MaterialApp` + `CircularProgressIndicator` on initial frame (the router's loading state while `onboardingCompleteProvider` resolves). Intentionally no `pumpAndSettle` — downstream Drift streams never complete. `addTearDown(db.close)` for cleanup. The old test asserted `find.text('Calorie Tracker')` which never matched because the app boots into Onboarding.
- `lib/data/database/app_database.dart` — `forTesting` constructor uses `super.e` (info: `use_super_parameters` cleared).
- `lib/features/food_log/food_search_screen.dart:441` — `&& mounted` → `&& context.mounted` (info: `use_build_context_synchronously` cleared). Line is inside a `ConsumerState`'s `build` method, so both forms refer to the same state; `context.mounted` is what the lint actually prefers.

### Verification (mirrors CI workflow exactly)

| Step | Command | Result |
|---|---|---|
| Analyze | `flutter analyze` | `No issues found!` · exit 0 |
| Test | `flutter test` | 185/185 pass · exit 0 |

Local Flutter is 3.41.5; CI pins 3.29.3. Confirmed via `flutter analyze --no-fatal-infos` that info-level diagnostics drive the exit code, so fixing both infos was the safer bet regardless of which Flutter version CI ends up with.

`build-apk` job not run locally (Windows lacks Android toolchain). Should succeed on CI since no desktop-only APIs were added; watch the first post-push run.

### Working tree state at end of session

All Session 1 migration work is still uncommitted and now joined by this session's test fixes. Ready for the logical-piece commits outlined below.

New/modified since previous session end:
```
 M integration_test/food_log_test.dart
 M integration_test/weight_test.dart
 M lib/data/database/app_database.dart        (now with skipSeeding flag)
 M lib/features/food_log/food_search_screen.dart
 M test/data/daos/foods_dao_test.dart
 M test/data/daos/food_logs_dao_test.dart
 M test/data/daos/user_profile_dao_test.dart
 M test/data/daos/water_logs_dao_test.dart
 M test/data/daos/weight_logs_dao_test.dart
 M test/widget_test.dart
```

Carried over from Session 1 (unchanged since):
```
 M CLAUDE.md
 M lib/data/database/app_database.g.dart
 M lib/data/seed/db_seeder.dart
 M lib/data/tables/foods_table.dart
 M windows/flutter/generated_plugin_registrant.cc   <- stray, unrelated
 M windows/flutter/generated_plugins.cmake          <- stray, unrelated
?? drift_schemas/
?? lib/core/utils/seed_key.dart
?? lib/data/daos/metadata_dao.dart
?? lib/data/daos/metadata_dao.g.dart
?? lib/data/tables/metadata_table.dart
```

### What the next session should start with

1. **Commit & push.** Suggested logical pieces:
   - Commit A — schema v2 foundation: `lib/data/tables/{foods,metadata}_table.dart`, `lib/data/daos/metadata_dao*`, `lib/core/utils/seed_key.dart`, `lib/data/database/app_database.*` (the migration parts), `lib/data/seed/db_seeder.dart`, `drift_schemas/`.
   - Commit B — test-seeding opt-out + DAO test fixes: the `skipSeeding` addition on `forTesting` + all 5 DAO test files + `test/widget_test.dart`.
   - Commit C — CI cleanup: the two `integration_test/*.dart` tidies + `food_search_screen.dart` `context.mounted` fix.
   - Commit D — docs: `CLAUDE.md` migration-strategy additions.
   - Decide on the stray `windows/flutter/` files separately (verify harmless, then commit or revert).
2. **Watch CI turn green** on both `analyze-and-test` and `build-apk`. First-ever green run on this repo.
3. **Then start Migration Strategy Session 2** — implement `DbSeeder.reconcileInto()` + `beforeOpen` hook as previously planned. Nothing about that plan changed.

Further out (unchanged from previous session):
- Session 3: Automated migration tests driven from `drift_schemas/drift_schema_vN.json` snapshots.
- Session 4: `scripts/release-check.bat` — fail fast if `assets/foods.db` changed without bumping `currentSeedVersion` (or vice versa).
- Session 5: First real seed data update to exercise the whole pipeline end-to-end.

---

## 2026-04-16 — Migration Strategy Session 1 + CI/CD Workflow

### What was completed

**GitHub Actions CI/CD workflow** (`calorie_tracker/.github/workflows/ci.yml`)
- Committed as `15dea64 Add GitHub Actions CI workflow`, pushed to `origin/main`.
- Two jobs on `ubuntu-latest`:
  - `analyze-and-test` — runs on every push + PR to `main`. Steps: checkout → `subosito/flutter-action@v2` (Flutter 3.29.3 stable) → `flutter pub get` → `flutter analyze` → `flutter test`.
  - `build-apk` — depends on `analyze-and-test`, runs only on push to `main`. Steps: checkout → `actions/setup-java@v4` (temurin 17) → flutter-action (3.29.3) → `flutter pub get` → `flutter build apk --release` → `actions/upload-artifact@v4` (release-apk, 7-day retention).
- No `working-directory` needed — git root is `calorie_tracker/` itself.
- Intentionally **not** included: `build_runner` step (`.g.dart` files are committed), integration tests (need emulator), coverage reporting, release signing.

**Schema v2 migration foundation — additive seed reconciliation groundwork**
Lays the runtime plumbing for shipping new seeded foods in future releases without overwriting user data. Staged but **not yet committed**.

Files added:
- `lib/data/tables/metadata_table.dart` — key/value table (PK on `key`) for infrastructure state like `seed_version`.
- `lib/data/daos/metadata_dao.dart` (+ generated `.g.dart`) — `getString`/`getInt`/`setString`/`setInt`.
- `lib/core/utils/seed_key.dart` — `makeSeedKey(name, brand)` → `slugify(name) + "__" + slugify(brand || "generic")`. Deterministic stable ID for seeded foods; must stay in lock-step with `tools/seed_foods_db.py`.
- `drift_schemas/drift_schema_v1.json` — pre-change snapshot.
- `drift_schemas/drift_schema_v2.json` — post-change snapshot.

Files modified:
- `lib/data/tables/foods_table.dart` — added nullable `TextColumn seedKey`. Custom user rows keep it NULL.
- `lib/data/database/app_database.dart` —
  - Added `Metadata` table and `MetadataDao` to `@DriftDatabase`.
  - Bumped `schemaVersion` → `2`.
  - `onCreate`: after `m.createAll()` + `DbSeeder.seedInto(this)`, writes `metadata.seed_version = DbSeeder.currentSeedVersion`.
  - `onUpgrade` with cascading `if (from < N)` pattern; `_upgradeToV2(Migrator m)` adds the column, creates the metadata table, backfills `seed_key` on every `is_custom = 0` row via per-row update, and writes `seed_version = 1`.
- `lib/data/seed/db_seeder.dart` —
  - New constants: `seedVersionKey = 'seed_version'`, `currentSeedVersion = 1`.
  - `_seedFoods` now reads an optional `seed_key` column from the asset DB (via `_tryReadString` helper for backward compatibility) and falls back to computing it from `(name, brand)`. Populates `seedKey:` in the insert companion.

`build_runner` regenerated 127 outputs. `flutter analyze lib/` reports only the 2 pre-existing, unrelated warnings (`use_super_parameters` in app_database.dart line 53, `use_build_context_synchronously` in food_search_screen.dart line 442).

**CLAUDE.md updated** (`calorie_tracker/CLAUDE.md`)
Added **Migration Strategy** section documenting:
- The two-version model (`schemaVersion` for table shape, `DbSeeder.currentSeedVersion` for seed content).
- Step-by-step checklist for bumping each version.
- Forbidden operations: changing `makeSeedKey()` output after a release ships, editing a shipped `_upgradeToVN`, deleting rows from `assets/foods.db`, running `seedInto` outside `onCreate`, hand-editing `drift_schemas/`.

### Known issues handed off

**Pre-existing DAO test failures block the new CI.**
`flutter test` fails on the 5 DAO tests under `test/data/daos/*.dart` with `Binding has not yet been initialized`. Confirmed via `git stash` round-trip that this failure is **pre-existing** — not introduced by Session 1. Root cause: tests use `AppDatabase.forTesting(NativeDatabase.memory())` which triggers `onCreate` → `DbSeeder.seedInto` → `getApplicationDocumentsDirectory()` + `rootBundle.load(...)`, both of which require a Flutter binding that `flutter test` doesn't set up without `TestWidgetsFlutterBinding.ensureInitialized()`.

This will make the first run of the new `analyze-and-test` CI job red.

A side-task has been spawned (chip visible to user) with a self-contained prompt to fix it — suggested approach is adding `skipSeeding: bool` to `AppDatabase.forTesting` and passing `true` from all 5 DAO test files.

### Working tree state at end of session

Uncommitted (Session 1 migration work, ready to commit after the DAO test fix lands):
```
 M lib/data/database/app_database.dart
 M lib/data/database/app_database.g.dart
 M lib/data/seed/db_seeder.dart
 M lib/data/tables/foods_table.dart
 M windows/flutter/generated_plugin_registrant.cc   <- stray, unrelated
 M windows/flutter/generated_plugins.cmake          <- stray, unrelated
?? drift_schemas/
?? lib/core/utils/seed_key.dart
?? lib/data/daos/metadata_dao.dart
?? lib/data/daos/metadata_dao.g.dart
?? lib/data/tables/metadata_table.dart
```

The CLAUDE.md migration-strategy update is also uncommitted and should go in the same commit or immediately after.

### What the next session should start with

1. **Let the spawned side-task finish first** (or run it now if not yet launched) — it adds `skipSeeding` to `AppDatabase.forTesting` and updates the 5 DAO test files. After it merges, `flutter test` should be green.
2. **Commit Session 1 work** in logical pieces:
   - Commit A: schema v2 foundation — `lib/data/tables/*`, `lib/data/daos/metadata_dao*`, `lib/core/utils/seed_key.dart`, `lib/data/database/app_database.*`, `lib/data/seed/db_seeder.dart`, `drift_schemas/`.
   - Commit B: `CLAUDE.md` migration strategy docs.
   - The two `windows/flutter/` files are stray auto-generated artifacts from an earlier Widgetbook experiment — verify they're harmless and either commit or revert.
3. **Push and verify the CI turns green** on both `analyze-and-test` and `build-apk`.
4. **Then start Session 2 of the migration strategy** — implement `DbSeeder.reconcileInto()` + `beforeOpen` hook. This is the piece that actually uses the `seed_key` + `metadata.seed_version` plumbing Session 1 put in place: on each launch, if `device.seed_version < DbSeeder.currentSeedVersion`, open the asset DB and insert any `seed_key` values not already present in the live `foods` table (additive only — existing rows, custom or seeded, are never touched). Then update `metadata.seed_version`. Needs tests that spin up a v1 seed, then re-run reconcile with a larger v2 asset DB and assert only the new rows land.

Further out (not next session):
- Session 3: Automated migration tests driven from `drift_schemas/drift_schema_vN.json` snapshots.
- Session 4: `scripts/release-check.bat` — fail fast if `assets/foods.db` changed without bumping `currentSeedVersion` (or vice versa).
- Session 5: First real seed data update to exercise the whole pipeline end-to-end.

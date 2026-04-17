# CLAUDE.md — Calorie Tracker Flutter App

## Project Overview
A fully standalone Android Calorie Tracker app inspired by HealthifyMe. All data resides
on-device in SQLite via Drift. No external API calls. Supports food logging, exercise 
logging, water tracking, weight trends, and TDEE-based goal setting.

## Important — User Dietary Requirement
The user is on a STRICT gluten-free diet. This must be reflected everywhere:
- Food search defaults to gluten-free filter ON at all times
- Show gluten warning badge on any food detail screen where gluten_status is 
  'contains_gluten' or 'may_contain'
- Never allow logging a food without showing its gluten status clearly
- Dashboard flags any logged item with gluten risk in red
- Onboarding sets is_gluten_free = 1 in user_profile by default

## Tech Stack
- Flutter (latest stable)
- Drift 2.x — local SQLite ORM (type-safe, migrations, streams)
- Riverpod 2.x — state management (StreamProvider for reactive UI)
- fl_chart — charts for trends and dashboard rings
- path_provider — locate device DB path
- sqflite_common_ffi — Drift backend
- google_fonts — typography

## Folder Structure
lib/
  main.dart
  app.dart                    # MaterialApp, theme, router
  core/
    theme/
      app_theme.dart          # light + dark ThemeData
      app_colors.dart         # color constants
    utils/
      tdee_calculator.dart    # Mifflin-St Jeor formula
      met_calculator.dart     # exercise calorie burn (MET × weight × hours)
      gluten_utils.dart       # gluten status helpers, badge colors
  data/
    database/
      app_database.dart       # Drift DB class, all tables
      app_database.g.dart     # generated — do not edit
    tables/
      foods_table.dart
      food_logs_table.dart
      exercise_logs_table.dart
      water_logs_table.dart
      weight_logs_table.dart
      user_profile_table.dart
    daos/
      foods_dao.dart          # includes gluten filter on search
      food_logs_dao.dart
      exercise_logs_dao.dart
      water_logs_dao.dart
      weight_logs_dao.dart
      user_profile_dao.dart
    seed/
      db_seeder.dart          # copies pre-seeded foods.db from assets on first launch
  features/
    onboarding/
      onboarding_screen.dart
      onboarding_provider.dart
    dashboard/
      dashboard_screen.dart   # shows gluten risk flag on logged items
      dashboard_provider.dart
    food_log/
      food_search_screen.dart # gluten filter toggle (default ON)
      food_detail_screen.dart # gluten warning badge
      food_log_provider.dart
    exercise_log/
      exercise_search_screen.dart
      exercise_log_screen.dart
      exercise_log_provider.dart
    water/
      water_screen.dart
      water_provider.dart
    weight/
      weight_screen.dart
      weight_provider.dart
    history/
      history_screen.dart
      history_provider.dart
    profile/
      profile_screen.dart
      profile_provider.dart
  widgets/
    calorie_ring.dart
    macro_bar.dart
    meal_section.dart
    exercise_card.dart
    water_tracker.dart
    gluten_badge.dart         # reusable gluten status badge widget

assets/
  foods.db                    # pre-seeded food database (bundled asset)
  exercises.db                # pre-seeded exercise database (bundled asset)

tools/
  seed_foods_db.py            # one-time script — run on laptop only
  seed_exercises_db.py        # one-time script — run on laptop only
  tag_gluten.py               # rule-based gluten tagger — run before seeding

## Gluten Status Values
- gluten_free     — confirmed safe, no restriction
- contains_gluten — never log without explicit user override
- may_contain     — cross-contamination risk, show warning
- unknown         — treat as may_contain, show warning

## Key Conventions
- One feature per folder under features/
- Each feature has a screen + provider file only
- Providers use Riverpod @riverpod annotation (code gen style)
- All DB access via DAOs only — never query Drift tables directly from UI
- Streams from DAOs feed directly into StreamProvider
- Run flutter pub run build_runner build after any Drift table change
- Never modify *.g.dart files manually
- gluten_badge.dart is used on every food detail and dashboard meal item

## Asset DB Strategy
- foods.db and exercises.db are bundled in assets/
- On first launch, db_seeder.dart copies them to app's writable storage
- Check onboarding_complete flag in user_profile to detect first launch
- Foods table is READ ONLY — users cannot edit pre-seeded foods
- Custom user-added foods go into foods table with is_custom = 1
- Gluten status must be set for all custom foods — default to 'unknown'

## Migration Strategy
The app uses **two independent version numbers** so schema shape and seed content
can evolve separately without overwriting user data:

| Version | Where | What it tracks |
|---|---|---|
| `schemaVersion` (int) | `app_database.dart` | Table shape — columns, indexes, constraints |
| `DbSeeder.currentSeedVersion` (int) | `db_seeder.dart` | Content of `assets/foods.db` + `assets/exercises.db` |

The device stores its current seed version in the `metadata` table under key
`seed_version` (see `DbSeeder.seedVersionKey`). Foods shipped via the asset DB
are identified by a stable `seed_key` column (`slugify(name) + "__" + slugify(brand)`,
computed by `core/utils/seed_key.dart`). Custom user rows have `seed_key = NULL`.

### When to bump schemaVersion (table shape changes)
1. Edit the table in `lib/data/tables/*.dart`
2. Bump `schemaVersion` by 1 in `app_database.dart`
3. Add a new `if (from < N)` block in `onUpgrade` — additive only, never touch
   user-entered columns (food_logs, exercise_logs, water_logs, weight_logs, user_profile)
4. Run `flutter pub run build_runner build --delete-conflicting-outputs`
5. Dump the new schema: `dart run drift_dev schema dump lib/data/database/app_database.dart drift_schemas/`
6. Test migration from every prior `drift_schemas/drift_schema_vN.json` snapshot

### When to bump currentSeedVersion (seed content changes)
1. Regenerate `assets/foods.db` via `tools/seed_foods_db.py` (and/or `assets/exercises.db`)
2. Bump `DbSeeder.currentSeedVersion` by 1
3. **Both steps must happen in the same commit** — the seed version is a claim
   about the asset bytes. Updating one without the other silently breaks reconciliation.
4. On next app launch the reconciler (Session 2) inserts missing `seed_key`s
   additively. Existing rows — whether seeded or custom — are never modified.

### Forbidden
- DO NOT change the output of `makeSeedKey()` once a release has shipped — existing
  devices would see every row as "new" and duplicate them all.
- DO NOT edit an already-shipped `_upgradeToVN` migration. Write a new one.
- DO NOT delete rows from `assets/foods.db` to "remove" a food — reconciliation
  is additive. Mark it inactive at the DAO layer instead.
- DO NOT run `DbSeeder.seedInto()` outside `onCreate`. It is for fresh installs only.
- DO NOT commit changes to `drift_schemas/` by hand — only `drift_dev schema dump` writes them.

## Theme
- System-aware: ThemeMode.system in MaterialApp
- Light and dark ThemeData defined in app_theme.dart
- Never hardcode colors — always reference AppColors or Theme.of(context)
- Gluten warning color: red (#D32F2F light, #EF9A9A dark)
- Gluten safe color: green (#388E3C light, #A5D6A7 dark)
- Gluten may-contain color: amber (#F57C00 light, #FFCC80 dark)

## Build Order
Follow steps sequentially — one Claude Code session per step.

## Project Agents
Specialist agents are defined in `.claude/agents/`. Delegate to them when the task falls within their domain.

| Agent | When to Use |
|---|---|
| `frontend-agent` | Building or modifying screens, widgets, navigation, theming, Riverpod providers in the UI layer |
| `database-agent` | Schema changes, DAO queries, Drift migrations, asset DB seeding, TDEE/MET utility logic |
| `qa-agent` | Writing or updating unit tests, widget tests, integration tests — especially gluten safety test cases |
| `gluten-compliance-agent` | Auditing any screen, DAO, widget, or provider for correct gluten handling — read-only reviewer |

**Gluten compliance agent should be run after any change that touches food display, search, logging flow, or the foods DAO.**

## Do NOT
- Make any HTTP calls anywhere in the app
- Modify *.g.dart generated files
- Query Drift tables directly from widgets — always go through DAOs
- Store user data in SharedPreferences — use user_profile table instead
- Run seed scripts as part of app startup
- Allow food logging without displaying gluten status
- Default gluten filter to OFF — it must always default to ON
- Bypass gluten-compliance-agent review when modifying food search, food detail, dashboard meal items, or foods_dao
- Set gluten_status to null on any food row — use 'unknown' as the minimum
- Render a food detail screen without the GlutenBadge widget
- Treat 'unknown' gluten status as safe — always show amber warning
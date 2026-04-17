# ADR: Database Schema

Status: **Accepted**
Last updated: 2026-04-16

Scope: Decisions governing the on-device SQLite schema, migrations, and seed data
distribution for the Calorie Tracker Flutter app. Implemented across
`lib/data/database/`, `lib/data/tables/`, `lib/data/daos/`, `lib/data/seed/`,
and `lib/core/utils/seed_key.dart`.

This document is a reference for future contributors (human or agent). Each
decision lists its rationale, the alternatives rejected, and the consequences
callers must respect.

---

## 1. Drift 2.x as the ORM

**Decision.** All persistence goes through Drift 2.x. No raw `sqflite`, no
SharedPreferences for user-facing data, no remote stores.

**Why.**
- Type-safe query builder catches schema/query drift at compile time — critical
  because the app is offline-only and bugs ship as data corruption on user
  devices with no server-side safety net.
- First-class migration support (`MigrationStrategy.onCreate` / `onUpgrade`) and
  `drift_dev schema dump` for snapshot-based migration tests.
- Streams feed `StreamProvider` directly — core to the reactive UI pattern.

**Rejected alternatives.**
- `sqflite` raw SQL — no type safety, migration handling is hand-rolled.
- Hive / Isar — non-SQL, harder to evolve schema, no SQLite familiarity for
  ad-hoc debugging via `sqlite3` CLI against the on-device file.

**Consequences.**
- UI never imports from `lib/data/tables/` — always goes through a DAO.
- `*.g.dart` files are committed and MUST NOT be hand-edited. Regenerate via
  `flutter pub run build_runner build --delete-conflicting-outputs`.

---

## 2. Two independent version numbers: schema vs seed

**Decision.** Table shape and seed content have separate version counters that
evolve on independent cadences.

| Counter | Location | What it tracks |
|---|---|---|
| `schemaVersion` (int) | `lib/data/database/app_database.dart` | Columns, indexes, constraints — the shape of the tables |
| `DbSeeder.currentSeedVersion` (int) | `lib/data/seed/db_seeder.dart` | Contents of `assets/foods.db` + `assets/exercises.db` |
| `metadata.seed_version` (text value) | row in `metadata` table, key = `DbSeeder.seedVersionKey` | Which seed version the device has on disk |

**Why.**
- Shipping a new food does not require a schema migration. Conflating them would
  force a Drift migration on every seed-content-only release, inflating risk.
- Skipping releases (v1 → v5) must still work. Each counter advances linearly
  and reconciles independently.

**Rejected alternatives.**
- Single combined version number — coupling forces either a pointless migration
  per content release or a pointless seed-content bump per schema release.
- Per-row version stamps in `foods` — explodes storage and gives nothing the
  two-counter model can't express.

**Consequences.**
- Bumping `currentSeedVersion` and regenerating `assets/foods.db` MUST happen in
  the same commit. Either one alone silently breaks reconciliation.
- Bumping `schemaVersion` MUST come with a new `if (from < N) _upgradeToVN(m)`
  block and a new `drift_schemas/drift_schema_vN.json` snapshot.

---

## 3. `seed_key` as the stable identity of seeded rows

**Decision.** Every seeded food row carries a `seed_key TEXT` computed by
`makeSeedKey(name, brand)` in `lib/core/utils/seed_key.dart`:

```
seed_key = slugify(name) + "__" + slugify(brand || "generic")
slugify  = lowercase, trim, [^a-z0-9]+ → "_", strip leading/trailing "_"
```

Custom user rows have `seed_key = NULL`.

**Why.**
- The auto-increment `id` is device-local — it cannot identify a row across
  different installs or across releases of the app.
- A deterministic key derived from `(name, brand)` lets the reconciler match
  "is this row already on-device?" in O(n) with a single SQL `IN` clause.
- Keeping it NULL for custom rows ensures the reconciler cannot accidentally
  overwrite user-entered data even if a custom entry collides with a seeded
  name.

**Rejected alternatives.**
- UUIDs baked into `assets/foods.db` — opaque, require tool changes to keep
  stable, no benefit over slug-based keys for this dataset.
- `(name, brand)` compound lookup without a stored column — forces the reconciler
  to match on mutable display text; risky if display copy ever changes.

**Consequences (forbidden operations).**
- DO NOT change the `makeSeedKey()` algorithm after a release has shipped. Every
  existing device would see every row as "new" and duplicate the entire catalog.
- DO NOT let the Python tool (`tools/seed_foods_db.py`) and the Dart helper
  drift apart. They must produce byte-identical keys for the same inputs.
- DO NOT populate `seed_key` on rows where `is_custom = 1`.

---

## 4. Migrations are additive only

**Decision.** `onUpgrade` never drops columns, renames tables, or mutates
user-entered data. User-entered tables are:
`food_logs`, `exercise_logs`, `water_logs`, `weight_logs`, `user_profile`,
and any `foods` row with `is_custom = 1`.

Cascading pattern:
```dart
onUpgrade: (m, from, to) async {
  if (from < 2) await _upgradeToV2(m);
  if (from < 3) await _upgradeToV3(m);
  // ...
}
```

**Why.**
- Users with multi-release gaps (v1 → v5) must pass through every `if` block in
  order without special-casing.
- Destructive changes on a user's only copy of their data are unrecoverable —
  there is no server backup. Additive-only is the only safe default.

**Rejected alternatives.**
- `drop and recreate` style migrations — acceptable for seed tables but
  catastrophic on user-entered tables, and mixing the two policies invites
  mistakes.
- Compound `onUpgrade` dispatch (switch on exact `from`) — breaks on skipped
  releases.

**Consequences.**
- DO NOT edit an already-shipped `_upgradeToVN`. Write a new migration.
- Renaming a column = add new column + backfill + deprecate old reads. Never
  `DROP COLUMN` in a shipped migration.
- Removing a seeded food from the catalog = mark inactive at the DAO layer,
  never delete the row (would break `seed_key` reconciliation invariants).

---

## 5. `metadata` as a key/value infrastructure table

**Decision.** A single table with schema:

```dart
class Metadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override Set<Column> get primaryKey => {key};
}
```

holds infrastructure-level state that isn't user data — currently just
`seed_version`, but expected to grow (e.g. last-reconcile timestamps, feature
flags set by onboarding).

**Why.**
- Avoids adding a dedicated table per piece of metadata.
- Avoids SharedPreferences — CLAUDE.md forbids it for user-facing data, and
  splitting infrastructure state between SharedPreferences and the DB creates
  atomicity holes (e.g. seed_version could drift from the actual DB contents
  after a crash).

**Rejected alternatives.**
- Dedicated typed tables per metadata key — overkill for scalar values.
- SharedPreferences — loses transactional consistency with the rest of the DB.

**Consequences.**
- `MetadataDao` exposes typed helpers (`getInt`/`setInt`/`getString`/`setString`).
  All values are stored as `TEXT` — helpers parse.
- `insertOnConflictUpdate` is the correct upsert primitive (PK is `key`).

---

## 6. Asset DB seeding on first launch only

**Decision.** `assets/foods.db` and `assets/exercises.db` are bundled SQLite
files. `DbSeeder.seedInto()` runs inside `MigrationStrategy.onCreate` ONLY. The
reconciler (Session 2) runs on later launches via `beforeOpen`.

**Why.**
- SQL batch insert from a bundled file is 10× faster than shipping the same
  data as a Dart constant list.
- Keeping the fresh-install path and the upgrade path separate makes the
  cognitive model simple: `onCreate` = first install, `onUpgrade` = schema
  change, `beforeOpen` = seed reconciliation.

**Rejected alternatives.**
- Seed from JSON/CSV at runtime — slower, no type checks, painful to diff.
- Call `seedInto` from `beforeOpen` every launch — wasteful and error-prone.

**Consequences.**
- DO NOT call `DbSeeder.seedInto()` from anywhere other than `onCreate`.
- Tests that use `AppDatabase.forTesting()` MUST pass `skipSeeding: true` if
  they don't need the seed data (see decision 9).

---

## 7. `is_custom` flag on `foods`

**Decision.** The `foods` table mixes seeded and user-created rows, distinguished
by `is_custom INTEGER` (0 = seeded, 1 = custom).

**Why.**
- Food search and logging hit one table — simpler DAO and faster queries than
  union'ing two tables.
- Custom foods need all the same columns (macros, gluten status) as seeded
  ones — a separate table would duplicate the entire schema.

**Rejected alternatives.**
- Separate `custom_foods` table — doubles schema surface, complicates search.

**Consequences.**
- Seeded rows: `is_custom = 0`, `seed_key` non-null.
- Custom rows: `is_custom = 1`, `seed_key = NULL`.
- Reconciler must scope all writes to `is_custom = 0` rows to preserve user
  invariant. Never touch custom rows in migrations or reconciliation.

---

## 8. Gluten status is a first-class, non-nullable constraint

**Decision.** Every row in `foods` and `food_logs` carries a `gluten_status` TEXT
column with a CHECK constraint:

```
CHECK(gluten_status IN ('gluten_free','contains_gluten','may_contain','unknown'))
```

Default is `'unknown'`, never NULL. The UI treats `'unknown'` as a warning
state (amber), not as safe.

**Why.**
- User is on a strict gluten-free diet (see CLAUDE.md). A NULL or unchecked
  status is a safety bug, not a data-quality issue.
- Encoding the constraint at the SQL layer means even a malformed seed DB or a
  future migration cannot silently admit bad values.

**Rejected alternatives.**
- Application-layer validation only — bypassed by any direct SQL (tools,
  tests, migrations).
- Dedicated enum table with FK — more moving parts without adding safety that
  a CHECK constraint can't already provide.

**Consequences.**
- Custom foods entered via UI default to `'unknown'` (amber warning shown).
- `gluten-compliance-agent` (see `.claude/agents/`) must review any PR that
  touches food display, search, logging, or `foods_dao`.
- `food_logs.gluten_status` is copied from `foods.gluten_status` at log time
  (denormalized) — so historical logs stay accurate even if a food's status
  is later corrected.

---

## 9. Test isolation via `skipSeeding` opt-out

**Decision.** `AppDatabase.forTesting(QueryExecutor e, {bool skipSeeding = false})`
lets tests bypass the seed step. When `skipSeeding = true`, `onCreate` runs
`createAll()` but skips `DbSeeder.seedInto(this)` and the `seed_version` write.

**Why.**
- Plain `flutter test` doesn't initialize the Flutter binding, so
  `getApplicationDocumentsDirectory()` and `rootBundle.load()` (both used by
  seeding) crash in test context.
- Having a dedicated flag on the constructor keeps the production path
  (no-arg `AppDatabase()`) byte-identical to what ships to users.

**Rejected alternatives.**
- Mock `path_provider` + `rootBundle` in every test — heavyweight and couples
  unrelated tests to seeding internals.
- Injection via optional seeder callback — readable but noisier at every call
  site than a bool flag.
- Set up `TestWidgetsFlutterBinding.ensureInitialized()` in every DAO test —
  still leaves the asset-load path fragile and makes tests slower.

**Consequences.**
- Every DAO unit test under `test/data/daos/` passes `skipSeeding: true`.
- `test/widget_test.dart` overrides `appDatabaseProvider` with a skip-seeded
  in-memory DB.
- Tests that legitimately need seed data (none today) must either load a tiny
  fixture DB or call seed logic explicitly — do NOT re-enable production
  seeding in tests without re-reviewing this decision.

---

## Related files

- `lib/data/database/app_database.dart` — `@DriftDatabase`, schemaVersion,
  onCreate/onUpgrade, `_upgradeToV2`.
- `lib/data/seed/db_seeder.dart` — `seedInto`, `currentSeedVersion`,
  `seedVersionKey`. (Future: `reconcileInto`.)
- `lib/data/tables/foods_table.dart` — `seed_key`, `is_custom`, gluten CHECK.
- `lib/data/tables/metadata_table.dart` — key/value store.
- `lib/data/daos/metadata_dao.dart` — typed accessors.
- `lib/core/utils/seed_key.dart` — `makeSeedKey()`.
- `tools/seed_foods_db.py` — Python counterpart of `makeSeedKey` (must stay
  byte-identical).
- `drift_schemas/drift_schema_vN.json` — frozen schema snapshots for migration
  tests.
- `.claude/SESSION_LOG.md` — chronological log of schema-related sessions.
- `CLAUDE.md` → **Migration Strategy** section — the operational checklist
  derived from these decisions.

# Migration Strategy — Plan

Two distinct problems that share infrastructure but need different solutions:

| Problem | What changes | Frequency | Risk |
|---|---|---|---|
| **Schema migrations** | Columns/tables added, renamed, or dropped | Rare (every few releases) | HIGH — can corrupt data |
| **Seed data updates** | More foods added to `assets/foods.db` | Frequent (every release) | MEDIUM — can duplicate rows or wipe user edits |

Right now your app handles **neither**. `onCreate` runs once and `schemaVersion = 1` never changes. Let me walk through the plan for each.

---

## Part 1 — The Problem with Your Current Setup

### Two gotchas waiting to bite

**Gotcha #1: New foods in `assets/foods.db` will never reach existing users.**

```dart
// app_database.dart (current)
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
    await DbSeeder.seedInto(this);   // ← runs ONLY on fresh install
  },
);
```

A user on v1.0.0 has 271 foods baked in. You release v1.1.0 with 350 foods in the asset. When they open the app: `schemaVersion = 1` already applied → `onCreate` skipped → they still see 271 foods. Forever. Unless they uninstall.

**Gotcha #2: No schema migration path.**

If you add a `barcode` column to `foods_table.dart` tomorrow, every existing user's app **crashes on startup** because Drift generated SQL expects a column that doesn't exist in their database. You need `schemaVersion = 2` + an `onUpgrade` handler.

---

## Part 2 — Recommended Architecture

### Three-layer strategy

```
┌─────────────────────────────────────────────────────┐
│ 1. SCHEMA VERSION   (Drift)                         │
│    Handles table/column changes.                    │
│    Mechanism: schemaVersion int + onUpgrade         │
├─────────────────────────────────────────────────────┤
│ 2. SEED VERSION     (App-level, separate)           │
│    Handles "more foods available."                  │
│    Mechanism: metadata table + reconciliation       │
├─────────────────────────────────────────────────────┤
│ 3. USER DATA        (Sacred — never modified)       │
│    foods WHERE is_custom=1                          │
│    all food_logs / exercise_logs / water / weight   │
└─────────────────────────────────────────────────────┘
```

---

## Part 3 — Schema Migrations (layer 1)

### The rules

1. **Never edit an old schema file** once a release is published. Always add a new migration step.
2. **Bump `schemaVersion`** by exactly 1 for each published release that changes schema.
3. **Handle the full range** in `onUpgrade`: if user jumps from v1 → v5, run steps 1→2, 2→3, 3→4, 4→5.
4. **Commit schema snapshots** (`drift_schemas/`) for automated migration tests.

### Drift pattern

```dart
@override
int get schemaVersion => 2;   // bump on every schema change

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
    await DbSeeder.seedInto(this);
    await _setSeedVersion(currentSeedVersion);
  },
  onUpgrade: (Migrator m, int from, int to) async {
    // Handle each step individually — cascading upgrades are safest.
    if (from < 2) {
      // Example: adding a barcode column to foods
      await m.addColumn(foods, foods.barcode);
    }
    if (from < 3) {
      // Example: new metadata table
      await m.createTable(metadata);
    }
    // ... one `if (from < N)` block per version
  },
  beforeOpen: (details) async {
    // Runs on EVERY app launch, after schema is ready.
    // Good place to reconcile seed data (see Part 4).
    if (details.wasCreated || details.hadUpgrade) {
      await _reconcileSeedData();
    }
  },
);
```

### Types of schema changes and how to handle them

| Change | Difficulty | Technique |
|---|---|---|
| **Add nullable column** | Easy | `m.addColumn(foods, foods.barcode)` |
| **Add non-null column with default** | Easy | Use `.withDefault(const Constant(...))` in table + `m.addColumn` |
| **Add new table** | Easy | `m.createTable(newTable)` |
| **Add index** | Easy | `m.createIndex(...)` |
| **Rename column** | Medium | Drift: `m.renameColumn(...)` or custom SQL |
| **Change column type** | Hard | Create new table, copy data, drop old — Drift has `m.alterTable(TableMigration)` |
| **Drop a column** | Medium | `m.alterTable(TableMigration(foods, columnTransformer: {...}))` |
| **Rename a table** | Medium | `m.renameTable(...)` |
| **Add CHECK constraint** | Hard | Requires alterTable + data validation first |

### Testing migrations — mandatory

Drift has a built-in tester. Run this before every release that changes schema:

```bash
# 1. Dump the current schema (commit this file)
dart run drift_dev schema dump lib/data/database/app_database.dart drift_schemas/

# 2. Write a migration test
dart run drift_dev schema generate drift_schemas/ test/data/generated/
```

Then in `test/data/migration_test.dart`:

```dart
import 'package:drift_dev/api/migrations.dart';

void main() {
  late SchemaVerifier verifier;
  setUp(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('migrates v1 to v2 cleanly', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase.forTesting(connection);
    await verifier.migrateAndValidate(db, 2);
    await db.close();
  });
}
```

This **catches migration bugs before they reach users**. Add to your pre-push hook.

---

## Part 4 — Seed Data Updates (layer 2)

This is the heart of your question. The answer is **additive reconciliation with a stable natural key**.

### The design

**Step A: Add a `seed_key` column to `foods` table** (schema change → v2)

```dart
class Foods extends Table {
  // ... existing columns ...
  TextColumn get seedKey => text().nullable()();   // e.g. "dosa__mtr" or null for custom
}
```

`seed_key` is a **stable, deterministic string** produced by `tools/seed_foods_db.py`. It never changes for a given seed entry across versions. Example: `slugify(name) + "::" + slugify(brand ?? "generic")`.

Rules:
- `is_custom = 0` rows → always have a `seed_key`
- `is_custom = 1` rows → `seed_key` is NULL (user-added foods have no seed identity)
- Add a unique index: `UNIQUE(seed_key) WHERE is_custom = 0` (partial index — SQLite supports this)

**Step B: Add a `metadata` table** (schema change → v2)

```dart
class Metadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}
```

Used for: `seed_version`, `last_seed_run_at`, future flags.

**Step C: Bump `SEED_VERSION` const whenever you ship new foods**

```dart
// lib/data/seed/db_seeder.dart
class DbSeeder {
  static const int currentSeedVersion = 2;   // bump each release with new foods
  ...
}
```

**Step D: Reconciliation logic in `beforeOpen`**

```dart
Future<void> _reconcileSeedData() async {
  final installed = await _getInstalledSeedVersion();    // from metadata table
  if (installed >= DbSeeder.currentSeedVersion) return;  // nothing to do

  await DbSeeder.reconcileInto(this);                    // adds new foods only
  await _setSeedVersion(DbSeeder.currentSeedVersion);
}
```

**Step E: `DbSeeder.reconcileInto` — the additive logic**

```dart
static Future<void> reconcileInto(AppDatabase db) async {
  final tempPath = await _assetToTempFile(_foodsAsset);
  final seedDb = raw.sqlite3.open(tempPath);
  final rows = seedDb.select('SELECT * FROM foods');

  // Load existing seed keys in one query
  final existingKeys = await (db.select(db.foods)
        ..where((f) => f.seedKey.isNotNull()))
      .map((f) => f.seedKey)
      .get()
      .then((l) => l.toSet());

  await db.batch((batch) {
    for (final row in rows) {
      final key = row['seed_key'] as String;
      if (existingKeys.contains(key)) continue;   // already have it — skip

      batch.insert(db.foods, FoodsCompanion.insert(
        name: row['name'],
        // ... all other fields ...
        seedKey: Value(key),
        isCustom: const Value(0),
      ));
    }
  });

  seedDb.dispose();
  await File(tempPath).delete();
}
```

### What this gives you

| Scenario | Result |
|---|---|
| User on v1.0.0 upgrades to v1.1.0 with 80 new foods | Only the 80 new rows get inserted. Existing 271 untouched. |
| User added a custom food named "Ragi Dosa" | Their `is_custom=1` entry stays. If a seed "Ragi Dosa" ships later, it's a separate row (different `seed_key` vs NULL). |
| User logged 50 meals referencing food_id=42 | `food_id=42` is never renumbered or deleted. Logs still resolve. |
| You fix a calorie value on existing food #42 | By default: **not propagated** (rows with matching seed_key are skipped). See "Policy decisions" below. |
| User reinstalls the app | `onCreate` runs, seeds v1's initial set via the same seed_key mechanism. |

### Policy decisions you need to make

These are product choices, not technical:

1. **If I fix a calorie value on an existing seeded food, should existing users see the fix?**
   - **Option A (recommended): No — historical logs use snapshotted nutrition, so the fix only benefits future logs. Low-value, adds complexity.** Keep skip-on-existing.
   - **Option B:** Yes — update non-identity fields (`caloriesPer100g`, `gluten_status`, etc.) on matching `seed_key`. Don't touch `name`, `id`, or `is_custom`.
   - My recommendation: **A now, B later if ever needed.** Simpler, safer.

2. **If I remove a food from the seed in a future version, what happens?**
   - Don't delete from user DBs — their logs may reference it. Just stop shipping it. User's row stays as an orphaned seed entry.
   - Alternative: add a `is_deprecated` flag, hide from search but keep for historical log display.

3. **Can I change a food's `seed_key` later?**
   - No. Once shipped, it's frozen. Breaking this = duplicate rows for existing users.

---

## Part 5 — Ordered Implementation Plan

Break into 5 small sessions (tokens ≈ ₹₹):

### Session 1 — Foundation (schema v2)
- Add `seed_key` column to `Foods` table (nullable, no default)
- Add `Metadata` table
- Set `schemaVersion = 2`, write `onUpgrade` handler
- Update `tools/seed_foods_db.py` to emit a `seed_key` column (backfill existing rows deterministically from `slugify(name, brand)`)
- Regenerate `assets/foods.db`
- Commit Drift schema snapshot (`drift_dev schema dump`)
- **Manual migration test**: install v1.0.0 APK, upgrade in-place to v1.1.0, verify no crash

### Session 2 — Reconciliation
- Refactor `DbSeeder` into two methods:
  - `seedInto()` — full seed (used in `onCreate`)
  - `reconcileInto()` — additive (used in `beforeOpen`)
- Wire `beforeOpen` → `_reconcileSeedData`
- Add `currentSeedVersion` constant

### Session 3 — Automated migration tests
- `dart run drift_dev schema generate` for v1 and v2
- Add migration test that starts at v1 schema and validates upgrade to v2
- Add a test that asserts: pre-existing custom food survives upgrade + new seed foods appear + user's food_logs still resolve

### Session 4 — Release checklist automation
- Pre-push hook already runs analyze + test
- Add a manual `scripts\release-check.bat`:
  - Runs migration tests
  - Verifies schema snapshot is committed
  - Verifies `currentSeedVersion` matches a bumped `pubspec.yaml` version if `assets/foods.db` changed

### Session 5 — Add 50 new foods (first real use)
- Update `tools/seed_foods_db.py` with new entries
- Bump `currentSeedVersion` from 1 to 2
- Regenerate `assets/foods.db`
- Install on device over existing app → verify new foods appear, old ones unchanged, custom foods survive
- Release

---

## Part 6 — "Do NOT" checklist

Things to never do once published:

- ❌ Change `schemaVersion` without bumping it (users stuck with old schema)
- ❌ Delete a food row during reconciliation (breaks log foreign keys)
- ❌ Renumber `foods.id` or reassign primary keys
- ❌ Modify `seed_key` for a food that's already shipped
- ❌ Touch rows where `is_custom = 1`
- ❌ Run the full `seedInto` on existing users (would duplicate or clobber)
- ❌ Ship a release changing `assets/foods.db` without bumping `currentSeedVersion`
- ❌ Ship a schema change without a migration test covering it

---

## Next Steps

This plan can be implemented incrementally in 5 focused sessions. Start with **Session 1** to build the foundation, then stack each subsequent session on top.

Each session is designed to be atomic and testable before moving forward.

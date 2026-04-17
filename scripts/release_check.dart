// ignore_for_file: avoid_print
/// Cross-platform release check script.
///
/// Verifies seed/schema version consistency before a release:
///   1. Schema snapshot exists for the current schemaVersion.
///   2. If assets/foods.db changed (vs HEAD), currentSeedVersion must change too.
///   3. Schema snapshot is fresh (re-dump matches committed copy).
///
/// Migration tests are run separately via `flutter test`.
///
/// Usage:
///   dart run scripts/release_check.dart         (from project root)
///   dart run scripts/release_check.dart --ci     (non-interactive, for CI)
///
/// Exit codes:
///   0 — all checks pass
///   1 — at least one check failed
library;

import 'dart:io';

// ── Helpers ──────────────────────────────────────────────────────────────────

int _failures = 0;

void pass(String label) => print('  [PASS] $label');

void fail(String label, [String? hint]) {
  print('  [FAIL] $label');
  if (hint != null) print('         $hint');
  _failures++;
}

void warn(String label, [String? hint]) {
  print('  [WARN] $label');
  if (hint != null) print('         $hint');
}

/// Extracts a simple `int` value from a Dart source line matching [pattern].
/// Example pattern: `schemaVersion => 2;` → returns 2.
int? extractInt(File file, RegExp pattern) {
  for (final line in file.readAsLinesSync()) {
    final match = pattern.firstMatch(line);
    if (match != null) {
      final digits = RegExp(r'\d+').firstMatch(match.group(0)!);
      if (digits != null) return int.tryParse(digits.group(0)!);
    }
  }
  return null;
}

/// Runs a process synchronously and returns (exitCode, stdout).
(int, String) run(String exe, List<String> args, {String? workingDirectory}) {
  final result = Process.runSync(
    exe,
    args,
    workingDirectory: workingDirectory,
    runInShell: Platform.isWindows,
  );
  return (result.exitCode, (result.stdout as String).trim());
}

/// True if `git diff` shows the given [path] has changes (staged or unstaged).
bool gitDiffContains(String path) {
  final (_, unstaged) = run('git', ['diff', '--name-only', 'HEAD', '--', path]);
  final (_, staged) = run('git', ['diff', '--cached', '--name-only', '--', path]);
  return unstaged.contains(path.split('/').last) ||
      staged.contains(path.split('/').last);
}

// ── Main ─────────────────────────────────────────────────────────────────────

void main(List<String> args) {
  final ci = args.contains('--ci');

  print('');
  print('============================================================');
  print(' RELEASE CHECK — seed/schema consistency');
  print('============================================================');
  print('');

  // -- 1. Parse schemaVersion ------------------------------------------
  print('[1/3] Checking schema snapshot...');

  final dbFile = File('lib/data/database/app_database.dart');
  if (!dbFile.existsSync()) {
    fail('Cannot find app_database.dart');
    _exit(ci);
    return;
  }

  final schemaVersion = extractInt(
    dbFile,
    RegExp(r'schemaVersion\s*=>\s*\d+'),
  );
  if (schemaVersion == null) {
    fail('Could not parse schemaVersion from app_database.dart');
    _exit(ci);
    return;
  }
  print('       schemaVersion = $schemaVersion');

  // Check both legacy and make-migrations snapshot locations.
  final snapshotName = 'drift_schema_v$schemaVersion.json';
  final legacyPath = File('drift_schemas/$snapshotName');
  final mmPath = File('drift_schemas/calorie_tracker/$snapshotName');

  if (!legacyPath.existsSync() && !mmPath.existsSync()) {
    fail(
      'No schema snapshot for v$schemaVersion',
      'Run: dart run drift_dev schema dump '
          'lib/data/database/app_database.dart drift_schemas/',
    );
  } else {
    pass('Schema snapshot exists for v$schemaVersion');
  }
  print('');

  // -- 2. Seed version consistency -------------------------------------
  print('[2/3] Checking seed version consistency...');

  final seederFile = File('lib/data/seed/db_seeder.dart');
  if (!seederFile.existsSync()) {
    fail('Cannot find db_seeder.dart');
    _exit(ci);
    return;
  }

  final seedVersion = extractInt(
    seederFile,
    RegExp(r'currentSeedVersion\s*=\s*\d+'),
  );
  if (seedVersion == null) {
    fail('Could not parse currentSeedVersion from db_seeder.dart');
    _exit(ci);
    return;
  }
  print('       currentSeedVersion = $seedVersion');

  // Check git diff for assets/foods.db and db_seeder.dart.
  final foodsChanged = gitDiffContains('assets/foods.db');
  final seederChanged = gitDiffContains('lib/data/seed/db_seeder.dart');

  if (foodsChanged && !seederChanged) {
    fail(
      'assets/foods.db changed but db_seeder.dart did NOT',
      'You must bump currentSeedVersion when shipping new foods.\n'
          '         Both changes must be in the same commit.',
    );
  } else if (!foodsChanged && seederChanged) {
    warn(
      'db_seeder.dart changed but assets/foods.db did NOT',
      'If you bumped currentSeedVersion, the asset must also change.\n'
          '         If the seeder change is unrelated to seed content, ignore this.',
    );
  } else if (foodsChanged && seederChanged) {
    pass('Both foods.db and currentSeedVersion changed together');
  } else {
    pass('Neither foods.db nor currentSeedVersion changed — no seed update');
  }
  print('');

  // -- 3. Schema snapshot freshness ------------------------------------
  print('[3/3] Verifying schema snapshot is up-to-date...');

  final tempDir = Directory.systemTemp.createTempSync('drift_schema_check_');
  try {
    final (dumpExit, dumpOut) = run('dart', [
      'run',
      'drift_dev',
      'schema',
      'dump',
      'lib/data/database/app_database.dart',
      tempDir.path,
    ]);

    if (dumpExit != 0) {
      fail('Could not dump current schema', dumpOut);
    } else {
      final fresh = File('${tempDir.path}/$snapshotName');
      if (!fresh.existsSync()) {
        fail('Schema dump did not produce $snapshotName');
      } else {
        // Compare against whichever committed file exists.
        final committed = legacyPath.existsSync() ? legacyPath : mmPath;
        if (!committed.existsSync()) {
          fail('No committed snapshot to compare against');
        } else {
          final freshBytes = fresh.readAsBytesSync();
          final committedBytes = committed.readAsBytesSync();
          if (_bytesEqual(freshBytes, committedBytes)) {
            pass('Schema snapshot is current');
          } else {
            fail(
              'Committed schema snapshot is STALE',
              'The current code produces a different schema.\n'
                  '         Run: dart run drift_dev schema dump '
                  'lib/data/database/app_database.dart drift_schemas/\n'
                  '         Then: dart run drift_dev make-migrations',
            );
          }
        }
      }
    }
  } finally {
    tempDir.deleteSync(recursive: true);
  }

  _exit(ci);
}

bool _bytesEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

void _exit(bool ci) {
  print('');
  if (_failures > 0) {
    print('============================================================');
    print(' RELEASE CHECK FAILED — $_failures issue(s) found');
    print('============================================================');
    exit(1);
  }
  print('============================================================');
  print(' ALL RELEASE CHECKS PASSED');
  print('============================================================');
  if (!ci) {
    // Interactive mode — let user read output before terminal closes.
    print('');
    print('Press Enter to exit...');
    stdin.readLineSync();
  }
  exit(0);
}

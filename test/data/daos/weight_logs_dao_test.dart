// ignore_for_file: lines_longer_than_80_chars

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/data/database/app_database.dart';

Future<int> _insertLog(AppDatabase db,
    {required String date, required double weightKg}) {
  return db.weightLogsDao.insertLog(
    WeightLogsCompanion.insert(
      date: date,
      weightKg: weightKg,
      loggedAt: DateTime.now().toIso8601String(),
    ),
  );
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(),
      skipSeeding: true,
    );
  });

  tearDown(() async {
    await db.close();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // getAllLogs
  // ═══════════════════════════════════════════════════════════════════════════

  group('getAllLogs', () {
    test('returns empty list when no weight logs exist', () async {
      final logs = await db.weightLogsDao.getAllLogs();
      expect(logs, isEmpty);
    });

    test('returns all inserted logs', () async {
      await _insertLog(db, date: '2024-01-01', weightKg: 75.0);
      await _insertLog(db, date: '2024-01-08', weightKg: 74.5);
      await _insertLog(db, date: '2024-01-15', weightKg: 74.0);

      final logs = await db.weightLogsDao.getAllLogs();
      expect(logs, hasLength(3));
    });

    test('logs are returned in ascending date order', () async {
      await _insertLog(db, date: '2024-03-10', weightKg: 73.0);
      await _insertLog(db, date: '2024-01-01', weightKg: 76.0);
      await _insertLog(db, date: '2024-02-15', weightKg: 74.5);

      final logs = await db.weightLogsDao.getAllLogs();
      final dates = logs.map((l) => l.date).toList();
      expect(dates, equals(['2024-01-01', '2024-02-15', '2024-03-10']));
    });

    test('weight values are stored with decimal precision', () async {
      await _insertLog(db, date: '2024-04-01', weightKg: 68.35);

      final logs = await db.weightLogsDao.getAllLogs();
      expect(logs.first.weightKg, closeTo(68.35, 0.001));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // watchAllLogs
  // ═══════════════════════════════════════════════════════════════════════════

  group('watchAllLogs', () {
    test('stream emits current logs sorted by date ascending', () async {
      await _insertLog(db, date: '2024-06-10', weightKg: 71.0);
      await _insertLog(db, date: '2024-05-01', weightKg: 72.5);

      final logs = await db.weightLogsDao.watchAllLogs().first;
      expect(logs.first.date, equals('2024-05-01'));
      expect(logs.last.date, equals('2024-06-10'));
    });

    test('stream emits empty list when no entries exist', () async {
      final logs = await db.weightLogsDao.watchAllLogs().first;
      expect(logs, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // insertLog
  // ═══════════════════════════════════════════════════════════════════════════

  group('insertLog', () {
    test('returns a positive auto-generated id', () async {
      final id = await _insertLog(db, date: '2024-07-01', weightKg: 70.0);
      expect(id, greaterThan(0));
    });

    test('two separate logs have distinct ids', () async {
      final id1 = await _insertLog(db, date: '2024-08-01', weightKg: 69.5);
      final id2 = await _insertLog(db, date: '2024-08-08', weightKg: 69.0);
      expect(id1, isNot(equals(id2)));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // deleteLog
  // ═══════════════════════════════════════════════════════════════════════════

  group('deleteLog', () {
    test('deletes the correct log and leaves others intact', () async {
      final idToDelete = await _insertLog(db, date: '2024-09-01', weightKg: 80.0);
      await _insertLog(db, date: '2024-09-08', weightKg: 79.5);

      final deletedCount = await db.weightLogsDao.deleteLog(idToDelete);
      expect(deletedCount, equals(1));

      final remaining = await db.weightLogsDao.getAllLogs();
      expect(remaining, hasLength(1));
      expect(remaining.first.weightKg, closeTo(79.5, 0.001));
    });

    test('deleting a non-existent id affects zero rows', () async {
      final count = await db.weightLogsDao.deleteLog(99999);
      expect(count, equals(0));
    });

    test('deleting all logs leaves the table empty', () async {
      final id1 = await _insertLog(db, date: '2024-10-01', weightKg: 75.0);
      final id2 = await _insertLog(db, date: '2024-10-08', weightKg: 74.5);

      await db.weightLogsDao.deleteLog(id1);
      await db.weightLogsDao.deleteLog(id2);

      final logs = await db.weightLogsDao.getAllLogs();
      expect(logs, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Weight trend helpers (computed from log data)
  // ═══════════════════════════════════════════════════════════════════════════

  group('weight trend computation', () {
    test('latest weight is the last entry in ascending date order', () async {
      await _insertLog(db, date: '2024-01-01', weightKg: 80.0);
      await _insertLog(db, date: '2024-01-15', weightKg: 79.0);
      await _insertLog(db, date: '2024-02-01', weightKg: 78.5);

      final logs = await db.weightLogsDao.getAllLogs();
      final latest = logs.last.weightKg;
      expect(latest, closeTo(78.5, 0.001));
    });

    test('weight change over period is first minus last in sorted list', () async {
      await _insertLog(db, date: '2024-01-01', weightKg: 85.0);
      await _insertLog(db, date: '2024-03-01', weightKg: 82.0);

      final logs = await db.weightLogsDao.getAllLogs();
      final change = logs.last.weightKg - logs.first.weightKg;
      // 82 - 85 = -3, indicating weight loss
      expect(change, closeTo(-3.0, 0.001));
    });
  });
}

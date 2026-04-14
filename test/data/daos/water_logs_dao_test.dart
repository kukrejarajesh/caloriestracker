// ignore_for_file: lines_longer_than_80_chars

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_tracker/data/database/app_database.dart';
import 'package:calorie_tracker/data/tables/water_logs_table.dart';

Future<int> _insertLog(AppDatabase db,
    {required String date, required int amountMl}) {
  return db.waterLogsDao.insertLog(
    WaterLogsCompanion.insert(
      date: date,
      amountMl: amountMl,
      loggedAt: DateTime.now().toIso8601String(),
    ),
  );
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // getLogsForDate
  // ═══════════════════════════════════════════════════════════════════════════

  group('getLogsForDate', () {
    test('returns only water logs for the specified date', () async {
      await _insertLog(db, date: '2024-01-10', amountMl: 250);
      await _insertLog(db, date: '2024-01-10', amountMl: 350);
      await _insertLog(db, date: '2024-01-11', amountMl: 500);

      final logs = await db.waterLogsDao.getLogsForDate('2024-01-10');
      expect(logs, hasLength(2));
      expect(logs.every((l) => l.date == '2024-01-10'), isTrue);
    });

    test('returns empty list when no water logged for date', () async {
      final logs = await db.waterLogsDao.getLogsForDate('2024-12-31');
      expect(logs, isEmpty);
    });

    test('total water consumed equals sum of individual log amounts', () async {
      await _insertLog(db, date: '2024-02-01', amountMl: 200);
      await _insertLog(db, date: '2024-02-01', amountMl: 500);
      await _insertLog(db, date: '2024-02-01', amountMl: 300);

      final logs = await db.waterLogsDao.getLogsForDate('2024-02-01');
      final total = logs.fold<int>(0, (sum, l) => sum + l.amountMl);
      expect(total, equals(1000));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // watchLogsForDate
  // ═══════════════════════════════════════════════════════════════════════════

  group('watchLogsForDate', () {
    test('stream emits correct entries for the date', () async {
      await _insertLog(db, date: '2024-03-05', amountMl: 400);

      final logs = await db.waterLogsDao.watchLogsForDate('2024-03-05').first;
      expect(logs, hasLength(1));
      expect(logs.first.amountMl, equals(400));
    });

    test('stream does not include entries from other dates', () async {
      await _insertLog(db, date: '2024-03-05', amountMl: 400);
      await _insertLog(db, date: '2024-03-06', amountMl: 600);

      final logs = await db.waterLogsDao.watchLogsForDate('2024-03-05').first;
      expect(logs.every((l) => l.date == '2024-03-05'), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // insertLog
  // ═══════════════════════════════════════════════════════════════════════════

  group('insertLog', () {
    test('inserted log has a positive auto-generated id', () async {
      final id = await _insertLog(db, date: '2024-04-01', amountMl: 300);
      expect(id, greaterThan(0));
    });

    test('multiple logs are inserted independently', () async {
      final id1 = await _insertLog(db, date: '2024-05-01', amountMl: 200);
      final id2 = await _insertLog(db, date: '2024-05-01', amountMl: 350);
      expect(id1, isNot(equals(id2)));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // deleteLog
  // ═══════════════════════════════════════════════════════════════════════════

  group('deleteLog', () {
    test('deletes the correct log entry', () async {
      const date = '2024-06-10';
      final idToDelete = await _insertLog(db, date: date, amountMl: 200);
      await _insertLog(db, date: date, amountMl: 500);

      final deletedCount = await db.waterLogsDao.deleteLog(idToDelete);
      expect(deletedCount, equals(1));

      final remaining = await db.waterLogsDao.getLogsForDate(date);
      expect(remaining, hasLength(1));
      expect(remaining.first.amountMl, equals(500));
    });

    test('deleting a non-existent id affects zero rows', () async {
      final count = await db.waterLogsDao.deleteLog(9999);
      expect(count, equals(0));
    });

    test('after deletion the remaining total is correct', () async {
      const date = '2024-07-01';
      final id1 = await _insertLog(db, date: date, amountMl: 300);
      await _insertLog(db, date: date, amountMl: 700);

      await db.waterLogsDao.deleteLog(id1);

      final logs = await db.waterLogsDao.getLogsForDate(date);
      final total = logs.fold<int>(0, (sum, l) => sum + l.amountMl);
      expect(total, equals(700));
    });
  });
}

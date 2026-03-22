import 'package:flutter_test/flutter_test.dart';
import 'package:reminder_app/utils/app_constants.dart';

void main() {
  group('AppConstants Tests', () {
    test('logic keys should be correct and unique', () {
      expect(AppConstants.keyNone, 'none');
      expect(AppConstants.keyDaily, 'daily');
      expect(AppConstants.keyWeekdays, 'weekdays');
      expect(AppConstants.keyWeekends, 'weekends');
      expect(AppConstants.keyCustom, 'custom');

      final keys = [
        AppConstants.keyNone,
        AppConstants.keyDaily,
        AppConstants.keyWeekdays,
        AppConstants.keyWeekends,
        AppConstants.keyCustom
      ];
      expect(keys.toSet().length, keys.length, reason: 'Duplicate logic keys found');
    });

    test('category strings should be correct', () {
      expect(AppConstants.today, 'Today');
      expect(AppConstants.scheduled, 'Scheduled');
      expect(AppConstants.all, 'All');
      expect(AppConstants.flagged, 'Flagged');
    });

    test('database table and columns should be defined', () {
      expect(AppConstants.tableReminders, isNotEmpty);
      expect(AppConstants.colId, isNotEmpty);
      expect(AppConstants.colTitle, isNotEmpty);
      expect(AppConstants.colDateTime, isNotEmpty);
    });
  });
}

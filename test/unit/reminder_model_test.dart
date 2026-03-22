import 'package:flutter_test/flutter_test.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/utils/app_constants.dart';

void main() {
  group('Reminder Model Tests', () {
    final testDate = DateTime(2023, 10, 27, 10, 30);
    
    test('should create Reminder instance', () {
      final reminder = Reminder(
        id: 1,
        title: 'Test Reminder',
        content: 'Test Content',
        dateTime: testDate,
        isAlarmEnabled: true,
        repeatType: AppConstants.keyDaily,
      );

      expect(reminder.id, 1);
      expect(reminder.title, 'Test Reminder');
      expect(reminder.content, 'Test Content');
      expect(reminder.dateTime, testDate);
      expect(reminder.isAlarmEnabled, true);
      expect(reminder.repeatType, AppConstants.keyDaily);
    });

    test('fromMap and toMap should be consistent', () {
      final reminder = Reminder(
        id: 1,
        title: 'Test Reminder',
        content: 'Test Content',
        dateTime: testDate,
        isAlarmEnabled: true,
        repeatType: AppConstants.keyCustom,
        customDays: [1, 3, 5],
      );

      final map = reminder.toMap();
      final fromMap = Reminder.fromMap(map);

      expect(fromMap.id, reminder.id);
      expect(fromMap.title, reminder.title);
      expect(fromMap.content, reminder.content);
      expect(fromMap.dateTime, reminder.dateTime);
      expect(fromMap.isAlarmEnabled, reminder.isAlarmEnabled);
      expect(fromMap.repeatType, reminder.repeatType);
      expect(fromMap.customDays, reminder.customDays);
    });

    test('copyWith should only update specified fields', () {
      final reminder = Reminder(
        title: 'Original Title',
        dateTime: testDate,
      );

      final updated = reminder.copyWith(title: 'New Title');

      expect(updated.title, 'New Title');
      expect(updated.dateTime, reminder.dateTime);
      expect(updated.content, reminder.content);
    });

    test('fromMap should handle null content', () {
      final map = {
        'id': 1,
        'title': 'Test',
        'content': null,
        'date_time': testDate.toIso8601String(),
        'is_alarm_enabled': 1,
        'repeat_type': 'none',
        'custom_days': null,
      };

      final reminder = Reminder.fromMap(map);
      expect(reminder.content, isNull);
    });
  });
}

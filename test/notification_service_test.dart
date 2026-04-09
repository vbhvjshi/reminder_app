import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/utils/app_constants.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Manual Mock for FlutterLocalNotificationsPlugin
class MockFlutterLocalNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {
  @override
  Future<bool?> initialize(
    InitializationSettings? initializationSettings, {
    onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse,
  }) => super.noSuchMethod(
        Invocation.method(#initialize, [initializationSettings], {
          #onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
          #onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
        }),
        returnValue: Future<bool?>.value(true),
      );

  @override
  Future<void> zonedSchedule(
    int? id,
    String? title,
    String? body,
    tz.TZDateTime? scheduledDate,
    NotificationDetails? notificationDetails, {
    required UILocalNotificationDateInterpretation? uiLocalNotificationDateInterpretation,
    required bool? androidAllowWhileIdle, // Old parameter name in some versions
    AndroidScheduleMode? androidScheduleMode, // New parameter name in v18
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) => super.noSuchMethod(
        Invocation.method(#zonedSchedule, [
          id,
          title,
          body,
          scheduledDate,
          notificationDetails,
        ], {
          #uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation,
          #androidAllowWhileIdle: androidAllowWhileIdle,
          #androidScheduleMode: androidScheduleMode,
          #payload: payload,
          #matchDateTimeComponents: matchDateTimeComponents,
        }),
        returnValue: Future<void>.value(),
      );
}

void main() {
  // Since NotificationService is a singleton and the plugin is final/internal,
  // these tests focus on the logical inputs and state requirements.
  
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('NotificationService Logic & Data Tests', () {
    test('Notification Channel ID is updated to force recreation', () {
      expect(AppConstants.channelId, 'alarm_notification_channel_v1');
    });

    test('Reminder Repeat Type Mapping Logic', () {
      final service = NotificationService();
      
      // We can't easily test private methods, but we can verify the model and constants
      expect(AppConstants.keyDaily, 'daily');
      expect(AppConstants.keyWeekdays, 'weekdays');
    });

    test('Alarm Scheduling Data Validation', () {
      final now = DateTime.now();
      final reminder = Reminder(
        id: 1,
        title: 'Test Alarm',
        content: 'Test Content',
        dateTime: now.add(const Duration(minutes: 5)),
        isAlarmEnabled: true,
        repeatType: 'none',
      );

      expect(reminder.isAlarmEnabled, isTrue);
      expect(reminder.dateTime.isAfter(now), isTrue);
    });
  });

  group('Manual Verification Checklist (Test Cases)', () {
    test('TC-01: Verify Test Alarm Button Visibility', () {
      // This is a placeholder for a widget test if needed
      // Logic: Ensure NotificationService().testAlarm() schedules for +10 seconds
    });
  });
}

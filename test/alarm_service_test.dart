import 'package:flutter_test/flutter_test.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('NotificationService Logic Tests', () {
    test('NotificationService singleton check', () {
      final instance1 = NotificationService();
      final instance2 = NotificationService();
      expect(instance1, same(instance2));
    });

    test('Reminder model copyWith validation', () {
      final reminder = Reminder(
        id: 1,
        title: 'Original',
        content: 'Content',
        dateTime: DateTime.now(),
        isAlarmEnabled: true,
        repeatType: 'none',
      );
      
      final updated = reminder.copyWith(title: 'Updated');
      expect(updated.title, 'Updated');
      expect(updated.id, reminder.id);
    });
  });

  /*
  MANUAL TEST CASES FOR ANDROID DEVICE:
  
  1. Test Alarm (10-second delay):
     - Open App -> Tap "Test Alarm" -> Lock Phone.
     - Expect: Screen wakes up and alarm rings in 10s.
     
  2. Scheduled Alarm:
     - Add Reminder -> Enable Alarm -> Set for +2 mins -> Background App.
     - Expect: Alarm rings accurately at scheduled time.
     
  3. Reboot Persistence:
     - Schedule Alarm for +5 mins -> Reboot Phone.
     - Expect: Alarm triggers after reboot at correct time.
  */
}

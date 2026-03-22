import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/utils/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(AppConstants.icLauncher);
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notificationsPlugin.initialize(settings);
  }

  Future<void> scheduleNotification(Reminder reminder) async {
    if (!reminder.isAlarmEnabled) return;

    final scheduleDate = tz.TZDateTime.from(reminder.dateTime, tz.local);
    if (scheduleDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _notificationsPlugin.zonedSchedule(
      reminder.id ?? 0,
      reminder.title,
      reminder.content,
      scheduleDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.channelId,
          AppConstants.channelName,
          channelDescription: AppConstants.channelDesc,
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound(AppConstants.soundAlarm),
          playSound: true,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          audioAttributesUsage: AudioAttributesUsage.alarm,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: AppConstants.soundAlarmIOS,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: _getMatchComponents(reminder.repeatType),
    );
  }

  DateTimeComponents? _getMatchComponents(String repeatType) {
    if (repeatType == AppConstants.keyDaily) return DateTimeComponents.time;
    if (repeatType == AppConstants.keyWeekdays || 
        repeatType == AppConstants.keyWeekends || 
        repeatType == AppConstants.keyCustom) {
      return DateTimeComponents.dayOfWeekAndTime;
    }
    return null;
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}

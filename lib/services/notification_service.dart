import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/utils/app_constants.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/views/alarm_screen.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:reminder_app/services/database_service.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    // Request critical permission for Alarms to show over lockscreen
    if (await Permission.systemAlertWindow.isDenied) {
      await Permission.systemAlertWindow.request();
    }
    
    // Listen for alarm ring globally to show AlarmScreen
    Alarm.ringStream.stream.listen((settings) async {
       developer.log('Alarm ringing: ${settings.id}');
       
       // Optional: Fetch reminder from DB for better UI
       // For now, we'll navigate to AlarmScreen. 
       // We can pass a dummy reminder if we don't have the full one, 
       // or fetch it from DB.
       final reminder = await DatabaseService.instance.getReminder(settings.id);
       if (reminder != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => AlarmScreen(reminder: reminder),
            ),
          );
       }
    });

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(AppConstants.icLauncher);
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );
    
    // Check if app was launched from a notification
    final NotificationAppLaunchDetails? launchDetails = 
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _handleNotificationTap(launchDetails?.notificationResponse?.payload);
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(payload);
        final reminder = Reminder.fromMap(data);
        
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => AlarmScreen(reminder: reminder),
          ),
        );
      } catch (e) {
        debugPrint('Error handling notification tap: $e');
      }
    }
  }

  Future<void> scheduleNotification(Reminder reminder) async {
    if (!reminder.isAlarmEnabled) return;

    final scheduleDate = reminder.dateTime;
    if (scheduleDate.isBefore(DateTime.now())) return;

    // Use 'alarm' package for persistent ringing and background trigger
    final alarmSettings = AlarmSettings(
      id: reminder.id ?? DateTime.now().millisecondsSinceEpoch % 10000,
      dateTime: scheduleDate,
      assetAudioPath: 'assets/sounds/alarm_ringtone.mp3',
      volumeSettings: VolumeSettings.fixed(volume: 0.8),
      notificationSettings: NotificationSettings(
        title: reminder.title,
        body: reminder.content ?? 'Alarm triggered!',
        stopButton: 'Stop',
      ),
      loopAudio: true,
      vibrate: true,
      androidFullScreenIntent: true,
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<void> testAlarm() async {
    final now = DateTime.now();
    final testDate = now.add(const Duration(seconds: 10));
    
    final testReminder = Reminder(
      id: 999,
      title: 'Alarm Package Test',
      content: 'This is a test of the simplified alarm package.',
      dateTime: testDate,
      isAlarmEnabled: true,
    );

    // Save test reminder to DB so the listener can find it
    await DatabaseService.instance.insertReminder(testReminder);

    final alarmSettings = AlarmSettings(
      id: testReminder.id!,
      dateTime: testDate,
      assetAudioPath: 'assets/sounds/alarm_ringtone.mp3',
      volumeSettings: VolumeSettings.fixed(volume: 0.8),
      notificationSettings: NotificationSettings(
        title: testReminder.title,
        body: testReminder.content ?? 'Test alarm!',
        stopButton: 'Stop',
      ),
      loopAudio: true,
      vibrate: true,
      androidFullScreenIntent: true,
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<void> cancelNotification(int id) async {
    await Alarm.stop(id);
    await _notificationsPlugin.cancel(id);
  }
}

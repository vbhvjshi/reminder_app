import 'package:flutter/material.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/services/database_service.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:reminder_app/utils/app_constants.dart';

class ReminderViewModel extends ChangeNotifier {
  List<Reminder> _reminders = [];
  bool _isLoading = false;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;

  ReminderViewModel() {
    loadReminders();
  }

  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();
    final list = await DatabaseService.instance.getAllReminders();
    // Sort by latest first
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    _reminders = list;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    final id = await DatabaseService.instance.insertReminder(reminder);
    final newReminder = reminder.copyWith(id: id);
    _reminders.insert(0, newReminder); // Insert at the top
    if (newReminder.isAlarmEnabled) {
      await NotificationService().scheduleNotification(newReminder);
    }
    notifyListeners();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await DatabaseService.instance.updateReminder(reminder);
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
      if (reminder.isAlarmEnabled) {
        await NotificationService().scheduleNotification(reminder);
      } else {
        await NotificationService().cancelNotification(reminder.id!);
      }
      notifyListeners();
    }
  }

  Future<void> deleteReminders(List<int> ids) async {
    for (var id in ids) {
      await DatabaseService.instance.deleteReminder(id);
      _reminders.removeWhere((r) => r.id == id);
      await NotificationService().cancelNotification(id);
    }
    notifyListeners();
  }

  List<Reminder> getRemindersByCategory(String category) {
    final now = DateTime.now();
    if (category == AppConstants.today) {
      return _reminders.where((r) => 
        r.dateTime.year == now.year && 
        r.dateTime.month == now.month && 
        r.dateTime.day == now.day).toList();
    } else if (category == AppConstants.scheduled) {
      return _reminders.where((r) => r.dateTime.isAfter(now)).toList();
    } else if (category == AppConstants.all) {
      return _reminders;
    } else if (category == AppConstants.flagged) {
      return _reminders.where((r) => r.isAlarmEnabled).toList(); // Assuming flagged means alarm enabled for now
    }
    return [];
  }
}

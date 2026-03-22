import 'package:reminder_app/utils/app_constants.dart';

class Reminder {
  final int? id;
  final String title;
  final String? content;
  final DateTime dateTime;
  final bool isAlarmEnabled;
  final String repeatType; // daily, weekdays, weekends, custom, none
  final List<int>? customDays; // 0=Sun, 6=Sat

  Reminder({
    this.id,
    required this.title,
    this.content,
    required this.dateTime,
    this.isAlarmEnabled = false,
    this.repeatType = AppConstants.keyNone,
    this.customDays,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.colId: id,
      AppConstants.colTitle: title,
      AppConstants.colContent: content,
      AppConstants.colDateTime: dateTime.toIso8601String(),
      AppConstants.colIsAlarmEnabled: isAlarmEnabled ? 1 : 0,
      AppConstants.colRepeatType: repeatType,
      AppConstants.colCustomDays: customDays?.join(AppConstants.comma),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map[AppConstants.colId],
      title: map[AppConstants.colTitle],
      content: map[AppConstants.colContent],
      dateTime: DateTime.parse(map[AppConstants.colDateTime]),
      isAlarmEnabled: map[AppConstants.colIsAlarmEnabled] == 1,
      repeatType: map[AppConstants.colRepeatType],
      customDays: map[AppConstants.colCustomDays] != null && (map[AppConstants.colCustomDays] as String).isNotEmpty
          ? (map[AppConstants.colCustomDays] as String).split(AppConstants.comma).map((e) => int.parse(e)).toList()
          : null,
    );
  }

  Reminder copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? dateTime,
    bool? isAlarmEnabled,
    String? repeatType,
    List<int>? customDays,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      dateTime: dateTime ?? this.dateTime,
      isAlarmEnabled: isAlarmEnabled ?? this.isAlarmEnabled,
      repeatType: repeatType ?? this.repeatType,
      customDays: customDays ?? this.customDays,
    );
  }
}

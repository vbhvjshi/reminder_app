import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/utils/app_colors.dart';
import 'package:reminder_app/utils/app_constants.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;
  final bool isSelected;
  final VoidCallback onCircleTap;
  final VoidCallback onTileTap;
  final bool isSelectionMode;

  const ReminderTile({
    super.key,
    required this.reminder,
    this.isSelected = false,
    required this.onCircleTap,
    required this.onTileTap,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? AppColors.themeColor : AppColors.secondaryText,
        ),
        onPressed: onCircleTap,
      ),
      title: Text(
        reminder.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reminder.content != null && reminder.content!.isNotEmpty)
            Text(reminder.content!, style: const TextStyle(color: AppColors.secondaryText)),
          Row(
            children: [
              Text(
                '${DateFormat(AppConstants.formatShort).format(reminder.dateTime)}${AppConstants.at}${DateFormat(AppConstants.formatTime).format(reminder.dateTime)}',
                style: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
              ),
            ],
          ),
          if (reminder.repeatType != AppConstants.keyNone)
            Text(
              '${AppConstants.repeat}${AppConstants.colonSeparator}${_getRepeatString()}',
              style: const TextStyle(color: AppColors.themeColor, fontSize: 12),
            ),
        ],
      ),
      trailing: reminder.isAlarmEnabled
          ? Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Icon(
                Icons.alarm,
                size: 30,
                color: AppColors.themeColor,
              ),
            )
          : null,
      onTap: onTileTap,
      isThreeLine: reminder.content != null && reminder.content!.isNotEmpty,
    );
  }

  String _getRepeatString() {
    switch (reminder.repeatType) {
      case AppConstants.keyDaily: return AppConstants.daily;
      case AppConstants.keyWeekdays: return AppConstants.weekdays;
      case AppConstants.keyWeekends: return AppConstants.weekends;
      case AppConstants.keyCustom:
        if (reminder.customDays == null || reminder.customDays!.isEmpty) return AppConstants.custom;
        return reminder.customDays!.map((i) => AppConstants.daysOfWeek[i]).join(AppConstants.separator);
      default: return AppConstants.none;
    }
  }
}

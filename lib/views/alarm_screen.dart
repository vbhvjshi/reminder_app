import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/utils/app_colors.dart';

class AlarmScreen extends StatefulWidget {
  final Reminder reminder;

  const AlarmScreen({super.key, required this.reminder});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _dismissAlarm() async {
    final id = widget.reminder.id;
    if (id != null) {
      await Alarm.stop(id);
      debugPrint('Alarm stopped for ID: $id');
    }
    
    // Safety check for test alarm ID
    if (id != 999) {
      await Alarm.stop(999);
    }
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                   const Icon(
                    Icons.alarm,
                    size: 80,
                    color: AppColors.themeColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.reminder.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.reminder.content ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _dismissAlarm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.themeColor,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(
                      'DISMISS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _dismissAlarm, // Temporarily same as dismiss for now
                    child: const Text(
                      'SNOOZE',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

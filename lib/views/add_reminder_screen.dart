import 'package:flutter/material.dart';
import 'package:reminder_app/main.dart'; // To access messengerKey
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/utils/app_colors.dart';
import 'package:reminder_app/utils/app_constants.dart';
import 'package:reminder_app/viewmodels/reminder_viewmodel.dart';

class AddEditReminderScreen extends StatefulWidget {
  final Reminder? reminder;
  const AddEditReminderScreen({super.key, this.reminder});

  @override
  State<AddEditReminderScreen> createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late bool _isAlarmEnabled;
  late String _repeatType;
  late List<int> _customDays;

  bool get _isEditMode => widget.reminder != null;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder?.title ?? '');
    _notesController = TextEditingController(text: widget.reminder?.content ?? '');
    _selectedDate = widget.reminder?.dateTime ?? DateTime.now();
    _selectedTime = widget.reminder != null 
        ? TimeOfDay.fromDateTime(widget.reminder!.dateTime) 
        : TimeOfDay.now();
    _isAlarmEnabled = widget.reminder?.isAlarmEnabled ?? false;
    _repeatType = widget.reminder?.repeatType ?? AppConstants.keyNone;
    _customDays = widget.reminder?.customDays != null ? List.from(widget.reminder!.customDays!) : [];

    _titleController.addListener(_checkDirty);
    _notesController.addListener(_checkDirty);
  }

  void _checkDirty() {
    final isDirty = _calculateDirty();
    if (isDirty != _isDirty) {
      setState(() => _isDirty = isDirty);
    }
  }

  bool _calculateDirty() {
    if (!_isEditMode) {
      return true;
    }
    
    final r = widget.reminder!;
    if (_titleController.text != r.title) {
      return true;
    }
    if (_notesController.text != (r.content ?? '')) {
      return true;
    }
    if (_isAlarmEnabled != r.isAlarmEnabled) {
      return true;
    }
    
    if (_isAlarmEnabled) {
      if (_selectedDate.year != r.dateTime.year || 
          _selectedDate.month != r.dateTime.month || 
          _selectedDate.day != r.dateTime.day) {
        return true;
      }
      if (_selectedTime.hour != r.dateTime.hour || 
          _selectedTime.minute != r.dateTime.minute) {
        return true;
      }
      if (_repeatType != r.repeatType) {
        return true;
      }
      // Check custom days if both are custom
      if (_repeatType == AppConstants.keyCustom) {
        if (_customDays.length != (r.customDays?.length ?? 0)) {
          return true;
        }
        for (var day in _customDays) {
          if (!(r.customDays?.contains(day) ?? false)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.secondaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.themeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isEditMode ? AppConstants.edit : AppConstants.newReminder,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
            ),
            if (_isAlarmEnabled) ...[
              const SizedBox(width: 10),
              const Icon(Icons.alarm, size: 20, color: AppColors.themeColor),
            ],
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: (!_isEditMode || _isDirty) ? _saveReminder : null,
            child: Text(
              _isEditMode ? AppConstants.done : AppConstants.add, 
              style: TextStyle(
                color: (!_isEditMode || _isDirty) ? AppColors.themeColor : AppColors.secondaryText, 
                fontWeight: FontWeight.bold
              )
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _buildInputFields(),
              const SizedBox(height: 24),
              _buildAlarmToggle(),
              if (_isAlarmEnabled) ...[
                _buildDateTimePickers(),
                _buildRepeatOptions(),
              ],
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInputFields() {
    return Container(
      decoration: BoxDecoration(color: AppColors.gray.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12)),
      child: _buildTextFields(),
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: AppConstants.title,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintStyle: TextStyle(color: AppColors.secondaryText.withValues(alpha: 0.5)),
          ),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          onChanged: (_) => _checkDirty(),
        ),
        const Divider(height: 1),
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: AppConstants.notes,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintStyle: TextStyle(color: AppColors.secondaryText.withValues(alpha: 0.5)),
          ),
          maxLines: null,
          onChanged: (_) => _checkDirty(),
        ),
      ],
    );
  }

  Widget _buildAlarmToggle() {
    return ListTile(
      title: const Text(AppConstants.alarm),
      trailing: Switch(
        value: _isAlarmEnabled,
        onChanged: (val) {
          setState(() => _isAlarmEnabled = val);
          _checkDirty();
        },
        activeColor: AppColors.themeColor,
      ),
      tileColor: AppColors.gray.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      children: [
        const SizedBox(height: 12),
        ListTile(
          title: const Text(AppConstants.date),
          trailing: Text(DateFormat(AppConstants.formatFull).format(_selectedDate), style: const TextStyle(color: AppColors.themeColor)),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
              _checkDirty();
            }
          },
        ),
        ListTile(
          title: const Text(AppConstants.time),
          trailing: Text(_selectedTime.format(context), style: const TextStyle(color: AppColors.themeColor)),
          onTap: () async {
            final picked = await showTimePicker(context: context, initialTime: _selectedTime);
            if (picked != null) {
              setState(() => _selectedTime = picked);
              _checkDirty();
            }
          },
        ),
      ],
    );
  }

  Widget _buildRepeatOptions() {
    return Column(
      children: [
        const SizedBox(height: 12),
        ListTile(
          title: const Text(AppConstants.repeat),
          trailing: DropdownButton<String>(
            value: _repeatType,
            dropdownColor: AppColors.secondaryBackground,
            items: [
              const DropdownMenuItem(value: AppConstants.keyNone, child: Text(AppConstants.none)),
              const DropdownMenuItem(value: AppConstants.keyDaily, child: Text(AppConstants.daily)),
              const DropdownMenuItem(value: AppConstants.keyWeekdays, child: Text(AppConstants.weekdays)),
              const DropdownMenuItem(value: AppConstants.keyWeekends, child: Text(AppConstants.weekends)),
              const DropdownMenuItem(value: AppConstants.keyCustom, child: Text(AppConstants.custom)),
            ],
            onChanged: (val) {
              if (val == AppConstants.keyCustom) {
                _showCustomDaysPicker();
              } else {
                setState(() => _repeatType = val!);
                _checkDirty();
              }
            },
          ),
        ),
        if (_getRepeatDescription() != null)
          Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _getRepeatDescription()!,
                style: const TextStyle(color: AppColors.themeColor, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }

  String? _getRepeatDescription() {
    if (!_isEditMode && _repeatType == AppConstants.keyNone) return null;

    switch (_repeatType) {
      case AppConstants.keyNone:
        return AppConstants.none;
      case AppConstants.keyDaily:
        return AppConstants.daily;
      case AppConstants.keyWeekdays:
        return '${AppConstants.weekdays}${AppConstants.openBracket}${AppConstants.weekdaysList}${AppConstants.closeBracket}';
      case AppConstants.keyWeekends:
        return '${AppConstants.weekends}${AppConstants.openBracket}${AppConstants.weekendsList}${AppConstants.closeBracket}';
      case AppConstants.keyCustom:
        if (_customDays.isEmpty) return null;
        final daysStr = _customDays.map((i) => AppConstants.daysOfWeek[i]).join(AppConstants.separator);
        return '${AppConstants.custom}${AppConstants.openBracket}$daysStr${AppConstants.closeBracket}';
      default:
        return null;
    }
  }

  void _showCustomDaysPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.secondaryBackground,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    AppConstants.custom,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(7, (i) {
                        return CheckboxListTile(
                          title: Text(AppConstants.daysOfWeek[i]),
                          value: _customDays.contains(i),
                          onChanged: (val) {
                            setModalState(() {
                              if (val!) {
                                _customDays.add(i);
                              } else {
                                _customDays.remove(i);
                              }
                            });
                            setState(() {});
                          },
                          activeColor: AppColors.themeColor,
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.themeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        AppConstants.done,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          );
        },
      ),
    ).then((_) {
      if (_customDays.isNotEmpty) {
        setState(() => _repeatType = AppConstants.keyCustom);
        _checkDirty();
      }
    });
  }

  void _saveReminder() {
    if (_titleController.text.isEmpty) {
      messengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(AppConstants.titleRequired),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final reminder = Reminder(
      id: widget.reminder?.id,
      title: _titleController.text,
      content: _notesController.text,
      dateTime: dateTime,
      isAlarmEnabled: _isAlarmEnabled,
      repeatType: _repeatType,
      customDays: _repeatType == AppConstants.keyCustom ? _customDays : null,
    );

    _showSaveConfirmation(context, reminder);
  }

  void _showSaveConfirmation(BuildContext context, Reminder reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.saveChanges),
        content: const Text(AppConstants.saveConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Discard
            child: const Text(AppConstants.discard, style: TextStyle(color: AppColors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Save
            child: const Text(AppConstants.save, style: TextStyle(color: AppColors.themeColor)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      if (_isEditMode) {
        context.read<ReminderViewModel>().updateReminder(reminder);
      } else {
        context.read<ReminderViewModel>().addReminder(reminder);
      }
      Navigator.pop(context);
    } else if (confirmed == false) {
      if (!context.mounted) return;
      // User said discard
      Navigator.pop(context);
    }
  }
}

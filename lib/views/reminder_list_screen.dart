import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/utils/app_colors.dart';
import 'package:reminder_app/utils/app_constants.dart';
import 'package:reminder_app/viewmodels/reminder_viewmodel.dart';
import 'package:reminder_app/views/add_reminder_screen.dart';
import 'package:reminder_app/views/widgets/reminder_tile.dart';

class ReminderListScreen extends StatefulWidget {
  final String category;

  const ReminderListScreen({super.key, required this.category});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  final Set<int> _selectedIds = {};

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _deleteSelectedReminders(BuildContext context) async {
    final viewModel = context.read<ReminderViewModel>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.delete),
        content: const Text(AppConstants.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppConstants.cancel, style: TextStyle(color: AppColors.themeColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppConstants.delete, style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      await viewModel.deleteReminders(_selectedIds.toList());

      setState(() {
        _selectedIds.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category, style: TextStyle(color: _getCategoryColor(), fontSize: 16)),
        iconTheme: IconThemeData(color: _getCategoryColor()),
        actions: [
          if (_selectedIds.isNotEmpty)
            TextButton(
              onPressed: () => _deleteSelectedReminders(context),
              child: Text(AppConstants.delete, style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Consumer<ReminderViewModel>(
        builder: (context, viewModel, child) {
          final reminders = viewModel.getRemindersByCategory(widget.category);
          
          if (reminders.isEmpty) {
            return const Center(
              child: Text(
                AppConstants.noReminders,
                style: TextStyle(color: AppColors.secondaryText, fontSize: 18),
              ),
            );
          }

          return ListView.separated(
            itemCount: reminders.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.gray, indent: 56),
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return ReminderTile(
                reminder: reminder,
                isSelected: _selectedIds.contains(reminder.id),
                isSelectionMode: _selectedIds.isNotEmpty,
                onCircleTap: () => _toggleSelection(reminder.id!),
                onTileTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditReminderScreen(reminder: reminder),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Color _getCategoryColor() {
    if (widget.category == AppConstants.today) return AppColors.blue;
    if (widget.category == AppConstants.scheduled) return AppColors.red;
    if (widget.category == AppConstants.flagged) return AppColors.themeColor;
    return AppColors.blue;
  }
}

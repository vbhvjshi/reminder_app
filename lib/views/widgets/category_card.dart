import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/utils/app_colors.dart';
import 'package:reminder_app/viewmodels/reminder_viewmodel.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReminderViewModel>();
    final count = viewModel.getRemindersByCategory(title).length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(backgroundColor: color, radius: 15, child: Icon(icon, size: 18, color: Colors.white)),
                Text(
                  count.toString(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(title, style: const TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

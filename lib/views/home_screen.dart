import 'package:flutter/material.dart';
import 'package:reminder_app/utils/app_colors.dart';
import 'package:reminder_app/utils/app_constants.dart';
import 'package:reminder_app/views/reminder_list_screen.dart';
import 'package:reminder_app/views/add_reminder_screen.dart';
import 'package:reminder_app/views/widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 120.0,
            backgroundColor: AppColors.background,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(AppConstants.appTitle, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 16),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 48.0),
              child: _buildCategoryGrid(context),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        CategoryCard(
          icon: Icons.calendar_today,
          color: AppColors.blue,
          title: AppConstants.today,
          onTap: () => _navigateToListView(context, AppConstants.today),
        ),
        CategoryCard(
          icon: Icons.calendar_month,
          color: AppColors.red,
          title: AppConstants.scheduled,
          onTap: () => _navigateToListView(context, AppConstants.scheduled),
        ),
        CategoryCard(
          icon: Icons.all_inbox,
          color: AppColors.gray,
          title: AppConstants.all,
          onTap: () => _navigateToListView(context, AppConstants.all),
        ),
        CategoryCard(
          icon: Icons.flag,
          color: AppColors.themeColor,
          title: AppConstants.flagged,
          onTap: () => _navigateToListView(context, AppConstants.flagged),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.background,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
             GestureDetector(
              onTap: () => _showAddReminder(context),
              child: Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: AppColors.themeColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToListView(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReminderListScreen(category: category),
      ),
    );
  }

  void _showAddReminder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditReminderScreen(),
      ),
    );
  }
}

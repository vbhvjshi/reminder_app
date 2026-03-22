import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:reminder_app/utils/app_colors.dart';
import 'package:reminder_app/utils/app_constants.dart';
import 'package:reminder_app/viewmodels/reminder_viewmodel.dart';
import 'package:reminder_app/views/home_screen.dart';

final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderViewModel()),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: messengerKey,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.themeColor,
          hintColor: AppColors.secondaryText,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: AppColors.primaryText,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.primaryText),
            bodyMedium: TextStyle(color: AppColors.primaryText),
          ),
          iconTheme: const IconThemeData(color: AppColors.iconColor),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

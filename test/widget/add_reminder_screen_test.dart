import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/viewmodels/reminder_viewmodel.dart';
import 'package:reminder_app/views/add_reminder_screen.dart';
import 'package:reminder_app/utils/app_constants.dart';
import 'package:reminder_app/services/database_service.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/main.dart';
import 'package:sqflite/sqflite.dart';

// Fake DatabaseService to avoid sqflite errors in tests
class FakeDatabaseService implements DatabaseService {
  @override
  Future<List<Reminder>> getAllReminders() async => [];
  @override
  Future<int> insertReminder(Reminder reminder) async => 1;
  @override
  Future<int> updateReminder(Reminder reminder) async => 1;
  @override
  Future<int> deleteReminder(int id) async => 1;
  @override
  Future<Database> get database async => throw UnimplementedError();
  @override
  Future close() async {}
}

void main() {
  setUpAll(() {
    DatabaseService.instance = FakeDatabaseService();
  });

  testWidgets('AddEditReminderScreen shows validation error for empty title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ReminderViewModel()),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: messengerKey,
          home: const AddEditReminderScreen(),
        ),
      ),
    );

    // Initial state: Title is empty. Click Add.
    final addButton = find.widgetWithText(TextButton, AppConstants.add);
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Should show validation SnackBar
    expect(find.text(AppConstants.titleRequired), findsOneWidget);
  });

  testWidgets('Recurrence description is right-aligned when daily enabled', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ReminderViewModel()),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: messengerKey,
          home: const AddEditReminderScreen(),
        ),
      ),
    );

    // Enable Alarm
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Select "Daily" from Dropdown
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppConstants.daily).last); // Use .last as it might be in multiple places
    await tester.pumpAndSettle();

    // Verify "Daily" description appears in Align
    final alignFinder = find.byWidgetPredicate(
      (widget) => widget is Align && 
                  widget.alignment == Alignment.centerRight && 
                  widget.child is Text && 
                  (widget.child as Text).data == AppConstants.daily
    );
    
    expect(alignFinder, findsOneWidget);
  });

  testWidgets('Custom Days Picker has fixed Done button and scrollable list', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ReminderViewModel()),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: messengerKey,
          home: const AddEditReminderScreen(),
        ),
      ),
    );

    // Enable Alarm
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Select "Custom" to open picker
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppConstants.custom).last);
    await tester.pumpAndSettle();

    // Verify "Custom" title is visible
    expect(find.text(AppConstants.custom), findsWidgets);

    // Verify structure: Done button should NOT be inside a SingleChildScrollView
    final doneButtonFinder = find.widgetWithText(ElevatedButton, AppConstants.done);
    expect(doneButtonFinder, findsOneWidget);

    final scrollFinder = find.byType(SingleChildScrollView);
    expect(scrollFinder, findsOneWidget);

    // Ensure the Done button is NOT a descendant of the scroll view
    expect(find.descendant(of: scrollFinder, matching: doneButtonFinder), findsNothing);
    
    // Ensure the scroll view is a Flexible widget (to allow list to scroll)
    expect(find.ancestor(of: scrollFinder, matching: find.byType(Flexible)), findsOneWidget);
  });
}

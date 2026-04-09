class AppConstants {
  // App Titles
  static const String appTitle = 'Reminders';
  static const String myLists = 'My Lists';
  static const String reminders = 'Reminders';
  static const String newReminder = 'New Reminder';
  static const String addList = 'Add List';
  
  // Actions
  static const String cancel = 'Cancel';
  static const String add = 'Add';
  static const String done = 'Done';
  static const String noReminders = 'No Reminders';
  static const String delete = 'Delete';
  static const String deleteConfirmation = 'Are you sure you want to delete these items?';
  static const String saveChanges = 'Save Changes';
  static const String saveConfirmation = 'Do you want to save the changes?';
  static const String discard = 'Discard';
  static const String save = 'Save';
  
  // Labels
  static const String title = 'Title';
  static const String notes = 'Notes';
  static const String date = 'Date';
  static const String time = 'Time';
  static const String alarm = 'Alarm';
  static const String repeat = 'Repeat';
  static const String custom = 'Custom';
  
  // Repeat Options
  static const String daily = 'Daily';
  static const String weekdays = 'Weekdays';
  static const String weekends = 'Weekends';
  static const String none = 'None';
  static const String edit = 'Edit';
  static const String info = 'Info';
  
  // Repeat Options Descriptions
  static const String weekdaysList = 'Mon | Tue | Wed | Thu | Fri';
  static const String weekendsList = 'Sat | Sun';

  // Date Formats & Joiners
  static const String formatFull = 'EEE, MMM d, yyyy';
  static const String formatTime = 'jm';
  static const String formatShort = 'MMM d, yyyy';
  static const String at = ' at ';
  static const String separator = ' | ';
  static const String colonSeparator = ': ';
  static const String comma = ',';
  static const String openBracket = ' ( ';
  static const String closeBracket = ' )';

  // Logic Keys
  static const String keyNone = 'none';
  static const String keyDaily = 'daily';
  static const String keyWeekdays = 'weekdays';
  static const String keyWeekends = 'weekends';
  static const String keyCustom = 'custom';

  // Lists
  static const List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  // Notifications
  static const String channelId = 'alarm_notification_channel_v1';
  static const String channelName = 'Alarms';
  static const String channelDesc = 'Persistent alarm notifications';
  static const String soundAlarm = 'alarm_sound';
  static const String soundAlarmIOS = 'alarm_sound.wav';
  static const String icLauncher = '@mipmap/ic_launcher';

  // Database
  static const String dbName = 'reminders.db';
  
  // Validation
  static const String titleRequired = 'Title is required';
  
  // Categories
  static const String today = 'Today';
  static const String scheduled = 'Scheduled';
  static const String all = 'All';
  static const String flagged = 'Flagged';
  static const String completed = 'Completed';
  
  // DB Table & Columns
  static const String tableReminders = 'reminders';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colContent = 'content';
  static const String colDateTime = 'date_time';
  static const String colIsAlarmEnabled = 'is_alarm_enabled';
  static const String colRepeatType = 'repeat_type'; // daily, weekdays, weekends, custom
  static const String colCustomDays = 'custom_days'; // e.g. "0,2,4" for Sun, Tue, Thu
}

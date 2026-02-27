import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

void main() {
  //! https://www.fluttermapp.com/articles/local-notifications

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FlutterLocalNotificationsPlugin notificationsPlugin = 
    FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    initializeTimeZones();

    //! https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    setLocalLocation(getLocation('Africa/Luanda'));

    const androidSettings = 
      AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = 
      DarwinInitializationSettings();

    const InitializationSettings initializationSettings = 
      InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      await notificationsPlugin.initialize(settings: initializationSettings);

      // --- ADICIONE ESTE BLOCO AQUI ---
      // Isso solicita a permissão especificamente para Android 13+
      final androidImplementation = notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
      // --------------------------------
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails:  const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notifications',
          channelDescription: 'Instant notification channel',
          importance: Importance.max,
          priority: Priority.high
        ),
        iOS: DarwinNotificationDetails(),
      )
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduledDate = now.add(
      Duration(seconds: 3),
    );

    await notificationsPlugin.zonedSchedule(
      id: id, 
      scheduledDate: scheduledDate, 
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel_id', // A unique ID to group notifications together.
          'Dailt Reminders',
          channelDescription: 'Reminder to complete daily habits',
          importance: Importance.max,
          priority: Priority.high
        ),
        iOS: DarwinNotificationDetails()
      ), 
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // or dateAndTime, ou ainda outros valores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Flutter Pro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FilledButton(
              onPressed: () {
                showInstantNotification(id: 0, title: 'Instant notif', body: 'body');
              }, 
              child: Text('Instant notif')
            ),
            FilledButton(
              onPressed: () {
                scheduleReminder(id: 1, title: 'Schedule notify', body: 'body');
              }, 
              child: Text('Scheduled notif')
            ),
          ],
        ),
      )
    );
  }
}

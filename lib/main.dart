import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
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
  }

  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("ola")
    );
  }
}

import 'package:_12sale_app/data/service/requestPremission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int count = 0;

  @override
  void initState() {
    super.initState();

    // Initialize the FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification interaction here
        print("Notification clicked: ${response.payload}");
      },
    );
  }

  // Show a simple notification
  Future<void> _showNotification() async {
    // Create AndroidNotificationDetails with the dynamic count
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id', // Unique channel ID
      'channel_name', // Channel name for display
      color: const Color(0xFF123456), // Custom color
      largeIcon: const DrawableResourceAndroidBitmap(
          '@mipmap/ic_launcher'), // Your large icon resource
      importance: Importance.high, // Importance level
      priority: Priority.high, // Priority level
      ticker: 'Custom Notification', // Ticker text displayed briefly
      styleInformation: BigTextStyleInformation(
        'This is a long notification message. Count: $count', // Dynamically include count
        contentTitle: '<b>Dynamic Count: $count</b>', // Use count in title
        summaryText:
            'Notification Summary with Count: $count', // Include count in summary
        htmlFormatContent: true, // Enable HTML formatting for content
        htmlFormatContentTitle: true, // Enable HTML formatting for title
      ),
    );

    final NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await requestNotificationPermission();

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Hello! 1', // Notification title
      'This is a test notification.', // Notification body
      platformDetails,
      payload: 'Custom Payload', // Optional data to pass
    );
    setState(() {
      count++;
    });
    await flutterLocalNotificationsPlugin.show(
      1, // Notification ID
      'Hello! 2', // Notification title
      'This is a test notification.', // Notification body
      platformDetails,
      payload: 'Custom Payload', // Optional data to pass
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Local Notifications")),
      body: Center(
        child: ElevatedButton(
          onPressed: _showNotification,
          child: Text("Show Notification"),
        ),
      ),
    );
  }
}

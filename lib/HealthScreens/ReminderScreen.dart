import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final TextEditingController _messageController = TextEditingController();
  TimeOfDay? _selectedTime;
  bool _isRepeating = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification() async {
    final String message = _messageController.text;
    if (message.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uzupełnij wszystkie pola!')),
      );
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
    );
    final iOSDetails = DarwinNotificationDetails();
    final notificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    final now = tz.TZDateTime.now(tz.local);
    final notificationTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (_isRepeating) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Przypomnienie',
        message,
        notificationTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Przypomnienie',
        message,
        notificationTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Powiadomienie ustawione!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Przypomnienia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Treść powiadomienia'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Godzina: ${_selectedTime?.format(context) ?? 'Nie wybrano'}'),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Text('Wybierz godzinę'),
                ),
              ],
            ),
            Row(
              children: [
                Text('Powtarzaj codziennie'),
                Switch(
                  value: _isRepeating,
                  onChanged: (bool value) {
                    setState(() {
                      _isRepeating = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text('Ustaw powiadomienie'),
            ),
          ],
        ),
      ),
    );
  }
}

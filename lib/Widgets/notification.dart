import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {

  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);

    await _notifications.initialize(
      settings,
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
      ),
    );
  }

  static void scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    required DateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,);
  }

//   static Future<void> scheduleNotification(Termin termin) async {
//     var scheduledNotificationDateTime = termin.datumOd;
//     await _notifications.zonedSchedule(
//       0,
//       termin.predmet,
//       'Your exam for the subject ${termin.predmet} is starting in 30 minutes',
//       tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
//       await _notificationDetails(),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,);
//   }
}

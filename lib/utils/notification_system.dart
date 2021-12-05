import 'package:anecdate_app/utils/globals.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationSystem {
  static final _notifcations = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    await _notifcations.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );

    tz.initializeTimeZones();
    final locationName = await  FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName));

    if(Globals.activeNotif) {
      subscribeNotification();
    }

  }

  static void subscribeNotification() {
    print(Globals.nameApp);
    print(Globals.appMessage);
    print("${Globals.hourNotif}:${Globals.minuteNotif}");
    print(Globals.getDaysNotifications());
    showScheduledNotification(
        title: Globals.nameApp,
        body: Globals.appMessage,
        time: Time(Globals.hourNotif, Globals.minuteNotif), days: Globals.getDaysNotifications(),
    );
  }

  static Future showScheduledNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payload,required Time time,
        required List<int> days}) async =>
      _notifcations.zonedSchedule(
          id,
          title,
          body,
          _scheduleWeekly(time, days),
          await _notificationDetails(),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: payload);

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now) ? scheduledDate.add(Duration(days: 1)) : scheduledDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, List<int> days) {
    tz.TZDateTime scheduledTime = _scheduleDaily(time);

    while (!days.contains(scheduledTime.weekday)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }
    return scheduledTime;
  }

  static void cancelAll() {
    print("cancel");
    _notifcations.cancelAll();
  }
}

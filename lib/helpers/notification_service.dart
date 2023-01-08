import 'package:bitky/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


/*
class NotificationService {
  late final BuildContext? context;
  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    //Initializing settings for both platforms (Android & iOS)
     InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context!,
      MaterialPageRoute<void>(builder: (context) => const SplashScreen()),
    );
  }
  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<NotificationDetails> _notificationDetails() async{
    const AndroidNotificationDetails('channel_id', 'channel_name',
    channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true
    );
    return _notificationDetails();
  }

  requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }




  Future<void> scheduleNotifications({id, title, body, time}) async {
    try{
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(time, tz.local),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'channel_id', 'channel_name',
                  channelDescription: 'description')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
    }catch(e){
      print(e);
    }
  }
}

 */

class LocalNotificationService{
  LocalNotificationService();
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async{
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings(
    'ic_stat_alarm'
    );
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    final InitializationSettings settings = InitializationSettings(android: androidInitializationSettings,
    iOS: initializationSettingsDarwin
    );

    await _localNotificationService.initialize(
      settings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,);


  }



  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('id');
  }

Future<void> showNotification({required int id, required String title, required String body}) async{
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('channel_id', 'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);

  await _localNotificationService.show(id, title, body, notificationDetails);
}

  Future<void> showSchelduledNotificationDaily({
    required int id,
    required String title,
    required tz.TZDateTime time,
    required String body}) async{
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var tzTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour,time.minute);
    print(tzTime.hour.toString() + tzTime.minute.toString());
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: DarwinNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ) );
    await _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    matchDateTimeComponents:DateTimeComponents.time
    );
    print("burası çalıştı");
  }

  Future<void> showSchelduledNotificationWeakly({
    required int id,
    required String title,
    required tz.TZDateTime time,
    required int day,
    required String body}) async{
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var tzTime = tz.TZDateTime(tz.local, now.year, now.month, day, time.hour,time.minute);
    print("Service:: "+tzTime.toString());
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: DarwinNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ));
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents:DateTimeComponents.dayOfWeekAndTime

    );
  }


  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  /*  await Navigator.push(
      context!,
      MaterialPageRoute<void>(builder: (context) => const SplashScreen()),
    );*/
  }
}
// import 'dart:ffi';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
import 'dart:io' show Platform; //File, Platform
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:verse/models/recieved_notification.dart';
import 'package:rxdart/subjects.dart';
import 'dart:math';

NotificationPlugin notificationPlugin = NotificationPlugin._();

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  Future<void> showDailyAtTime() async {
    var time = Time(7, 0, 0);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 4',
      'CHANNEL_NAME 4',
      "CHANNEL_DESCRIPTION 4",
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Test Title at ${time.hour}:${time.minute}.${time.second}',
      'Test Body', //null
      time,
      platformChannelSpecifics,
      payload: 'Test Payload',
    );
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );

    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> repeatNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 3',
      'CHANNEL_NAME 3',
      "CHANNEL_DESCRIPTION 3",
      importance: Importance.Max,
      priority: Priority.High,
      styleInformation: DefaultStyleInformation(true, true),
      playSound: true,
      color: Colors.lightBlueAccent,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    print('hi');
    int x = 0;
    List<String> verses = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      '0',
      'p',
      'q'
    ];
    await flutterLocalNotificationsPlugin.periodicallyShow(
      ++x,
      'Some title',
      '${verses[new Random().nextInt(verses.length - 1)]}',
      RepeatInterval.EveryMinute,
      platformChannelSpecifics,
      payload: 'I hate myself',
    );
  }

  Future<void> showNotification() async {
    List<String> verses = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'];
    var randomVerse = new Random();
    String _data = verses[randomVerse.nextInt(verses.length - 1)];
    String data = _data;
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      styleInformation: DefaultStyleInformation(true, true),
      color: Colors.red,
      ledColor: Colors.blue,
      ledOnMs: 1000,
      ledOffMs: 500,
      enableVibration: true,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Title',
      '$data ', //null
      platformChannelSpecifics,
      payload: 'New Payload',
    );
  }

  // Future<void> showWeeklyAtDayTime() async {
  //   var time = Time(21, 5, 0);
  //   var androidChannelSpecifics = AndroidNotificationDetails(
  //     'CHANNEL_ID 5',
  //     'CHANNEL_NAME 5',
  //     "CHANNEL_DESCRIPTION 5",
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //   );
  //   var iosChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics =
  //       NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
  //     0,
  //     'Test Title at ${time.hour}:${time.minute}.${time.second}',
  //     'Test Body', //null
  //     Day.Saturday,
  //     time,
  //     platformChannelSpecifics,
  //     payload: 'Test Payload',
  //   );
  // }

  // Future<void> scheduleNotification() async {
  //   var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
  //   var androidChannelSpecifics = AndroidNotificationDetails(
  //     'CHANNEL_ID 1',
  //     'CHANNEL_NAME 1',
  //     "CHANNEL_DESCRIPTION 1",
  //     icon: 'secondary_icon',
  //     sound: RawResourceAndroidNotificationSound('my_sound'),
  //     largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
  //     enableLights: true,
  //     color: const Color.fromARGB(255, 255, 0, 0),
  //     ledColor: const Color.fromARGB(255, 255, 0, 0),
  //     ledOnMs: 1000,
  //     ledOffMs: 500,
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //     playSound: true,
  //     timeoutAfter: 5000,
  //     styleInformation: DefaultStyleInformation(true, true),
  //   );
  //   var iosChannelSpecifics = IOSNotificationDetails(
  //     sound: 'my_sound.aiff',
  //   );
  //   var platformChannelSpecifics = NotificationDetails(
  //     androidChannelSpecifics,
  //     iosChannelSpecifics,
  //   );
  //   await flutterLocalNotificationsPlugin.schedule(
  //     0,
  //     'Test Title',
  //     'Test Body',
  //     scheduleNotificationDateTime,
  //     platformChannelSpecifics,
  //     payload: 'Test Payload',
  //   );
  // }

  // Future<void> showNotificationWithAttachment() async {
  //   var attachmentPicturePath = await _downloadAndSaveFile(
  //       'https://via.placeholder.com/800x200', 'attachment_img.jpg');
  //   var iOSPlatformSpecifics = IOSNotificationDetails(
  //     attachments: [IOSNotificationAttachment(attachmentPicturePath)],
  //   );
  //   var bigPictureStyleInformation = BigPictureStyleInformation(
  //     FilePathAndroidBitmap(attachmentPicturePath),
  //     contentTitle: '<b>Attached Image</b>',
  //     htmlFormatContentTitle: true,
  //     summaryText: 'Test Image',
  //     htmlFormatSummaryText: true,
  //   );
  //   var androidChannelSpecifics = AndroidNotificationDetails(
  //     'CHANNEL ID 2',
  //     'CHANNEL NAME 2',
  //     'CHANNEL DESCRIPTION 2',
  //     importance: Importance.High,
  //     priority: Priority.High,
  //     styleInformation: bigPictureStyleInformation,
  //   );
  //   var notificationDetails =
  //       NotificationDetails(androidChannelSpecifics, iOSPlatformSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Title with attachment',
  //     'Body with Attachment',
  //     notificationDetails,
  //   );
  // }

  // _downloadAndSaveFile(String url, String fileName) async {
  //   var directory = await getApplicationDocumentsDirectory();
  //   var filePath = '${directory.path}/$fileName';
  //   var response = await http.get(url);
  //   var file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }

}

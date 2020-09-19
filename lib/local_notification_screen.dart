import 'package:flutter/material.dart';
import 'models/recieved_notification.dart';
import 'notification_plugin.dart';
import 'notification_screen.dart';

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  //

  int count = 0;

  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    waitingDestiny();
    }

  void waitingDestiny()async{
      await notificationPlugin.repeatNotification();
    // await notificationPlugin.showDailyAtTime();
  }

  @override
  Widget build(BuildContext context) {
    waitingDestiny();
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Notifications'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: () async {
            await notificationPlugin.showNotification();
            // await notificationPlugin.scheduleNotification();
            // await notificationPlugin.showNotificationWithAttachment();
            // await notificationPlugin.repeatNotification();
            // await notificationPlugin.showDailyAtTime();
            // await notificationPlugin.showWeeklyAtDayTime();
            // count = await notificationPlugin.getPendingNotificationCount();
            // print('Count $count');
            // await notificationPlugin.cancelNotification();
            // count = await notificationPlugin.getPendingNotificationCount();
            // print('Count $count');
          },
          child: Text('Send Notification'),
        ),
      ),
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NotificationScreen(
        payload: payload,
      );
    }));
  }
}

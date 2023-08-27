//import 'dart:html';

import 'package:chat/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'Screens/ChatScreen.dart';

Future<void>handleBackgroundMessage(RemoteMessage message)async{
print('title:${message.notification?.title}');
print('body: ${message.notification?.body}');
print('paylod: ${message.data}');

}

void handMessage(RemoteMessage? message){
  if(message ==null)return;
  navigatorKey.currentState?.pushNamed(
      ChatScreen .route,
    arguments:  message,

  );
}

Future initPushNotification()async{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert:true,
      badge:true,
      sound:true
  );

FirebaseMessaging.instance.getInitialMessage().then(handMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);
}


class FirebaseApi{
  final fbm =   FirebaseMessaging.instance;

  Future<void>initNotifications()async{
    await fbm.requestPermission() as NotificationSettings;
    final fcmToken= await fbm.getToken();
    print('Tokenkey : $fcmToken');

    initPushNotification();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);


  }


}
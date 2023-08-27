import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:chat/firebase_options.dart';
import 'package:chat/firebaseapi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/Splash.dart';
import 'Screens/introsplash.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // await FirebaseApi().initNotifications();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
 // Timer timer = Timer(Duration(seconds: 5),(){});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
      theme:ThemeData(
        primarySwatch: Colors.lightBlue,//Color.fromRGBO(0, 33, 175,1) ,
        canvasColor:  Colors.lightBlue,
        secondaryHeaderColor: Colors.yellow,
       floatingActionButtonTheme:FloatingActionButtonThemeData(backgroundColor: Colors.deepPurple) ,
         buttonTheme: ButtonTheme.of(context).copyWith(
           buttonColor: Colors.pink,
           textTheme: ButtonTextTheme.primary,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(20),
           )
         )

        // scaffoldBackgroundColor:Colors.deepPurple,
        //brightness: Brightness.dark,


      ),
      home: IntroSplashScreen()

    );
  }
}
//IntroSplashScreen(),
/*
         StreamBuilder(stream: FirebaseAuth.instance.authStateChanges()
        ,builder:(ctx , snapShot)
          {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }



          if(snapShot.hasData){
          return ChatScreen() ;
          }else{
          return
            AuthScreen();
          }






          }),

 */
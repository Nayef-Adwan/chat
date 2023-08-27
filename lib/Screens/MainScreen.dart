









import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'AuthScreen.dart';
import 'ChatScreen.dart';
import 'Splash.dart';


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  StreamBuilder(stream: FirebaseAuth.instance.authStateChanges()
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
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../chat/messeges.dart';
import '../chat/new_messeges.dart';

class ChatScreen extends StatefulWidget {
//final message=ModalRoute.of(context as BuildContext)!.settings.arguments;
static const route = '/chatscreen';




  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))
        ),
        title: Text('chat'),
        actions: [
          DropdownButton(
            underline: Container(),
            dropdownColor: Colors.white,
              icon:
                  Icon(Icons.more_vert, color:Colors.white),
              items: [
                DropdownMenuItem(

                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ),
                  value: 'logout',
                )
              ],
              onChanged: (itemIdentifier){
                if(itemIdentifier =='logout'){
               FirebaseAuth.instance.signOut();
                }



              }),
        ],
      ),
      body:Container(
        decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/chatback.jpg'),fit: BoxFit.cover
        ),
        ),
        child:Column(
          children: [
            Expanded(
              child:   Messages(),
            ),

            NewMessages(),
          ],

        )
      ),
    );
  }
}

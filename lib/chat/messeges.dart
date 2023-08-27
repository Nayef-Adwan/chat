import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx,AsyncSnapshot snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final docs = snapShot.data.docs;
        final user = FirebaseAuth.instance.currentUser;


        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (ctx, index) {
            final docData = docs[index].data() as Map<String, dynamic>;
            final hasPdf = docData.containsKey('chatPdf');
            final pdfUrl = hasPdf ? docData['chatPdf'] : null;
            final timestamp = docData['createdAt'] as Timestamp; // Retrieve timestamp

            print('PDF URL in MessageBubble: $pdfUrl');
           // final docData = docs[index].data() as Map<String, dynamic>;
            return MessageBubble(

            docs[index]?.data()?.containsKey('text') ?? false ? docs[index]['text'] : '',
            docs[index]['username'],
          //  timestamp as String ,
            docs[index]['userImage'],
            docs[index]?.data()?.containsKey('chat_images') ?? false ? docs[index]['chat_images'] : '',
             pdfUrl,
           timestamp,
          docs[index]['userId'] == user!.uid,
            key: ValueKey(docs[index].id),
          );
          },
        );
      },
    );
  }
}
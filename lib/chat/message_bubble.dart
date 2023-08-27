import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';


import '../Screens/pdfViwer.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.userName, this.userImage, this.chatImage,
      this.chatPdf,    this.timestamp, // Add timestamp parameter
  this.isMe,
      {required this.key});

  final Key key;
  final String message;
  final String userName;
  final String userImage;
  final String? chatImage;
  final String? chatPdf; // Add PDF URL field
  final Timestamp timestamp;
  final bool isMe;

  @override
  Widget build(BuildContext context) {

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(14),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(14),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(

                    userName,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: !isMe
                          ? Colors.black
                          : Theme.of(context).primaryTextTheme.headline6!.color,
                    ),
                  ),
                  SizedBox(width: 2,),
                  Text(
                    _formatTimestamp(timestamp),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                        fontSize: 6,

                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(89, 88, 88, 0.5)
                    ),
                  ),

                  Text(
                    message!,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).primaryTextTheme.headline6!.color,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                  if (chatImage != null && chatImage!.isNotEmpty)
                    Container(
                        child: ClipRRect(
                            child: Image.network(
                      chatImage!,
                      fit: BoxFit.cover,
                    ))),
                  if (chatPdf != null && chatPdf!.isNotEmpty)
                    Container(
                      child:

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                        onPressed: () async {
                          if (await canLaunch(chatPdf!)) {
                            await launch(chatPdf!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No PDF viewer app found')),
                            );
                          }
                        },
                        icon: Icon(Icons.file_download),
                        label: Text("View file"),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: !isMe ? 120 : null,
          right: isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }

  Future<void> _openPdfWithExternalApp(String pdfUrl) async {
    final result = await OpenFile.open(pdfUrl);
    if (result.type == ResultType.done) {
      print("File opened with external app.");
    } else {
      print("Error opening file: ${result.message}");
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formattedTime = DateFormat.jm().format(dateTime); // Format time as "12:00 AM"
    final dayOfWeek = DateFormat.E().format(dateTime); // Get three-letter day name
    final month = DateFormat.MMM().format(dateTime); // Get three-letter month name
    final dayOfMonth = DateFormat.d().format(dateTime); // Get day of the month
    return "$formattedTime-$dayOfWeek-$month/$dayOfMonth";
  }
}

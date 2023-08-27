import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class NewMessages extends StatefulWidget {


  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  final FirebaseStorage storage = FirebaseStorage.instance;

  File? _pickedImage;
  File ?  _pickedPdf;
  final ImagePicker _picker = ImagePicker();

 Future< void> _pickImage () async {
    final pickedImageFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 800);

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });

    } else {
      print("No Image Selected");
    }
  }
  Future< void> _pickImageCamera () async {
    final pickedImageFile =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 80, maxWidth: 800);

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });

    } else {
      print("No Image Selected");
    }
  }

  Future<void> _pickPdf() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      setState(() {
        _pickedPdf = File(pickedFile.files.single.path!);
      });
    } else {
      print("No PDF Selected");
    }
  }



  Future<String> uploadFile(File file) async {
    Reference storageReference =
    storage.ref().child('chat_images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<String> uploadFilepdf(File file) async {
    Reference storageReference =
    storage.ref().child('chat_pdf/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }







  _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'username': userData['username'],
      'userId': user.uid,
      'userImage': userData['image_url'],
    });
    _controller.clear();
setState(() {
  _enteredMessage="";

});
  }
  _sendMessageWithimage(String? chatUrl) async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'username': userData['username'],
      'userId': user.uid,
      'userImage': userData['image_url'],
      'chat_images': chatUrl,
    });
    _controller.clear();
setState(() {
  _enteredMessage="";

});
  }
  Future<void> _sendMessagepdf ( String? pdfUrl) async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'username': userData['username'],
      'userId': user.uid,
      'userImage': userData['image_url'],
      //'chat_images': chatUrl,
      'chatPdf': pdfUrl, // New field for PDF URL
    });

 }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(      color: Colors.deepPurple,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20))),
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.black),
              cursorColor: Theme.of(context).primaryColor,
              autocorrect: true,
              enableSuggestions: true,
              maxLines: 2 ,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),

                ),
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: Theme.of(context).primaryColor),

              ),
              onChanged: (val) {

                  _enteredMessage = val;
                  setState(() {
                    _enteredMessage = val;

                  });

              },
            ),
          ),
          Row(
            children: [
              IconButton(
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey,
                icon: Icon(Icons.send),
                onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              ),
            //  fab(),
              IconButton(
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey,
                icon: Icon(Icons.camera),
                onPressed: () async {
                  await _pickImageCamera();
                  if (_pickedImage != null) {
                    String imageUrl = await uploadFile(_pickedImage!);
                    _sendMessageWithimage(imageUrl);
                  }
                },
              ),
              IconButton(
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey,
                icon: Icon(Icons.image),
                onPressed:() async {
                  await _pickImage();
                  if (_pickedImage != null) {
                    String imageUrl = await uploadFile(_pickedImage!);
                    _sendMessageWithimage(imageUrl);
                  }
                },
              ),
              IconButton(
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey,
                icon: Icon(Icons.file_present_rounded),
                onPressed:() async {
                  await _pickPdf();
                  if (_pickedPdf != null) {
                    String pdfUrl = await uploadFilepdf(_pickedPdf!);
                    _sendMessagepdf( pdfUrl); // Empty string for chat image URL

                  }
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}
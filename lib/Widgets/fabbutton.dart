import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';

class fab extends StatefulWidget {
  const fab({Key? key}) : super(key: key);

  @override
  State<fab> createState() => _fabState();
}

class _fabState extends State<fab> {
  final isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) =>WillPopScope(
    onWillPop: ()async{
      if(isDialOpen.value){
        isDialOpen.value=false;
        return false;
      }else{
        return true;
      }
    },
      child: Scaffold(
        backgroundColor: Colors.amber,
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.black,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spacing: 12,
          spaceBetweenChildren: 12,
          closeManually: true,
          animatedIcon: AnimatedIcons.menu_close,
          onClose: () {
            isDialOpen.value = false;
          },
          children: [
            SpeedDialChild(
              child: Icon(Icons.image),
              label: 'Image',

            ),
            SpeedDialChild(
              child: Icon(Icons.camera),
              label: 'Camera',

            ),
            SpeedDialChild(
              child: Icon(Icons.file_present_rounded),
              label: 'file',
              onTap: (){ Fluttertoast.showToast(msg: 'done');}
              //onTap: {}()

            ),
          ],
        ),
      ),
    );
  }


import "package:flutter/material.dart";



class Appbar extends StatelessWidget {
  String T;

Appbar (this.T);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(T),
      backgroundColor: Colors.blue,

    );
  }
}

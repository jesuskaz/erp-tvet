import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Heade extends StatefulWidget {
  @override
  _Heade createState() => _Heade();
}

class _Heade extends State<Heade> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'images/house_01.jpg',
            ),
            fit: BoxFit.cover),
      ),
    );
  }
}

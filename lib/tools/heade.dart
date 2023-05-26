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
              'images/head.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.darken)
        ),
      ),
    );
  }
}

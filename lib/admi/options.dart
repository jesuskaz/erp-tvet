import 'dart:convert';
import 'package:erptvet/admi/liste_option.dart';
import 'package:erptvet/admi/option_event.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../tools/tool.dart';
import 'package:double_back_to_close/double_back_to_close.dart';

class Options extends StatefulWidget {
  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {

  @override
  Widget build(BuildContext context) {

    return DoubleBack(
      onFirstBackPress: (context) {
        Fluttertoast.showToast(
          msg: "Press again to exit.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          iconTheme: const IconThemeData(color: color_white),
          backgroundColor: text_color,
          elevation: 1.0,
          centerTitle: true,
          title: const Text('Erp-Tvet', style: style_init),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              // width: size.width * 0.6,
              margin: EdgeInsets.all(20),
              child: RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                    text: "Please choose an option to add the program or event, ",
                    style: TextStyle(color: Colors.blueGrey, fontSize: taille0),
                    children: [
                      TextSpan(
                        //recognizer: ,
                        text: "Administrator session only",
                        style: TextStyle(color: text_color0, fontSize: taille1),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 12.0),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Container(
                  padding: EdgeInsets.only(right: 5.0, left: 5.0),
                  width: MediaQuery.of(context).size.width - 200.0,
                  height: MediaQuery.of(context).size.height - 20,
                  child: GridView.count(
                    crossAxisCount: 2,
                    primary: false,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 0.0,
                    childAspectRatio: 0.9,
                    children: <Widget>[
                      _buildCard('images/timetable.jpg', 'Time table', 1, context),
                      _buildCard('images/attendance.jpg', 'Attendance', 2, context),
                      _buildCard('images/event.jpg', 'Event', 3, context),
                      _buildCard('images/grade.jpg', 'Grade', 4, context),
                    ],
                  )),
            ),
            // SizedBox(height: 15.0)
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String imgPath, message, id, context) {
    return Padding(
        padding:
        const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 5.0, right: 5.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0)
                ],
                color: Colors.white),
            child: Column(children: [
              InkWell(
                onTap: () {
                  if(id.toString() == "1")
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => List_option()));
                    }
                  if(id.toString() == "2")
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => List_option()));
                  }
                  if(id.toString() == "3")
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => List_event()));
                  }
                  if(id.toString() == "4")
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => List_option()));
                  }
                },
                child: Hero(
                    tag: imgPath,
                    child: Container(
                        height: 160.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(imgPath),
                                fit: BoxFit.contain)))),
              ),
              SizedBox(height: 7.0),
              Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
              Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Text("${message}"),
              )
            ])));
  }
}

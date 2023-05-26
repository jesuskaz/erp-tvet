import 'package:erptvet/admi/plage.dart';
import 'package:erptvet/admi/timetable.dart';
import 'package:erptvet/admi/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tools/tool.dart';


class List_option extends StatefulWidget {
  @override
  _List_option createState() => _List_option();
}

class _List_option extends State<List_option>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: text_color0,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Option Timetable',
            style: TextStyle(
                fontFamily: 'Varela', fontSize: 20.0, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        // physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: size.height * 0.05,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Plage()));
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue.shade50,
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.file_copy,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Create timetable file",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey
                    ),
                  ),
                ),
                subtitle: const Text(
                  "Before creating the schedule, first create the file, ...",
                  style: TextStyle(
                      color: Colors.black45
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.01,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Timetable()));
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue.shade50,
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Add timetable",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                ),
                subtitle: const Text(
                  "Please add the timetable",
                  style: TextStyle(
                      color: Colors.black45
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.01,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => View()));
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue.shade50,
                  ),
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.add_business_rounded,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "View Timetable",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey
                    ),
                  ),
                ),
                subtitle: const Text(
                  "Click here to see all the schedules already added.",
                  style: TextStyle(
                      color: Colors.black45
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

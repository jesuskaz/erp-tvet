import 'package:erptvet/admi/addevent.dart';
import 'package:erptvet/admi/plage.dart';
import 'package:erptvet/admi/timetable.dart';
import 'package:erptvet/admi/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tools/tool.dart';


class List_event extends StatefulWidget {
  @override
  _List_event createState() => _List_event();
}

class _List_event extends State<List_event> with TickerProviderStateMixin {
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddEvent()));
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
                    "Add event",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueGrey
                    ),
                  ),
                ),
                subtitle: const Text(
                  "Click and en event",
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddEvent()));
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
                    Icons.event,
                    size: 30,
                    color: Colors.blue.shade400,
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Show Event",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontSize: 18,
                    ),
                  ),
                ),
                subtitle: const Text(
                  "Click and show events",
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

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:erptvet/student/account.dart';
import 'package:erptvet/student/calendar.dart';
import 'package:erptvet/student/home.dart';
import 'package:erptvet/student/timetable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SchoolManagement extends StatefulWidget {
  const SchoolManagement({Key? key}) : super(key: key);

  @override
  State<SchoolManagement> createState() => _SchoolManagementState();
}

class _SchoolManagementState extends State<SchoolManagement> {
  int _selectedItemIndex = 0;
  final List pages = [HomePage(), Account(), TimeTable(), CalendarPage(),];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoubleBack(
        onFirstBackPress: (context) {
          Fluttertoast.showToast(
            msg: "Press again to exit.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          );
        },
        child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Color(0xFFF0F0F0),
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.black,
              selectedIconTheme: IconThemeData(color: Colors.blueGrey[600]),
              currentIndex: _selectedItemIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                setState(() {
                  _selectedItemIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  label: "",
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: Icon(Icons.account_circle),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: Icon(Icons.schedule),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: Icon(Icons.event),
                ),
              ],
            ),
            body: pages[_selectedItemIndex]
        ),
      ),
    );
  }
}

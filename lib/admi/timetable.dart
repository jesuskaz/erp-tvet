import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../tools/tool.dart';

class Timetable extends StatefulWidget {
  @override
  _Timetable createState() => _Timetable();
}

class _Timetable extends State<Timetable> with TickerProviderStateMixin {

  var _selected = "1";
  var _selected_day = "1";
  var _selected_date = "1";

  var tab = [];
  var tab_day = [];
  var tab_date = [];

  String url = '';
  String url_course = '';
  String url_date = '';

  bool process = false;
  bool istimeend = false;
  bool istime = false;



  Dio dio = new Dio();
  late ProgressDialog progressDialog;
  late http.Response response;
  late http.Response responseCat;

  DateTime now = new DateTime.now();

  Future getCourse() async {

    setState(() {
      process = true;
    });

    url_course = apiUrl + "data/get_course";

    responseCat = await http.get(Uri.parse(url_course), headers: <String, String>{
      "Authorization": "Bearer $token",
      "Accept": "application/json; charset=UTF-8"
    });

    if (responseCat.statusCode == 200) {
      var data = jsonDecode(responseCat.body);

      if (data["status"] == true) {
        if (mounted) {
          setState(() {
            tab = data["datas"];
            _selected = tab[0]["id"].toString();

            print("URL ::: $url ");
          });
        }
      }
    }
  }
  Future getDate() async {

    setState(() {
      process = true;
    });

    url_date = apiUrl + "data/get_timeTable";

    print("DATE IS ::: $url_date");

    responseCat = await http.get(Uri.parse(url_date), headers: <String, String>{
      "Authorization": "Bearer $token",
      "Accept": "application/json; charset=UTF-8"
    });

    if (responseCat.statusCode == 200) {
      var data = jsonDecode(responseCat.body);
      print("CHECK DATA ::: $data");
      if (data["status"] == true) {
        if (mounted) {
          setState(() {
            tab_date = data["datas"];
            _selected_date = tab_date[0]["id"].toString();

          });
        }
      }
    }
  }
  Future getDay() async {
    setState(() {
      process = true;
    });

    url = apiUrl + "data/get_day";

    responseCat = await http.get(Uri.parse(url), headers: <String, String>{
      "Authorization": "Bearer $token",
      "Accept": "application/json; charset=UTF-8"
    });

    if (responseCat.statusCode == 200) {
      var data = jsonDecode(responseCat.body);

      if (data["status"] == true) {
        if (mounted) {
          setState(() {
            tab_day = data["datas"];
            _selected_day = tab_day[0]["id"].toString();
          });
        }
      }
    }
  }

  showProgress() {
    progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: "Traitement en cours",
    );
    progressDialog.show();
  }
  showAlertDialog(BuildContext context) {
    // ignore: deprecated_member_use
    Widget cancelButton = ElevatedButton(
      // padding: EdgeInsets.all(10),
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    // ignore: deprecated_member_use
    Widget continueButton = ElevatedButton(
      // padding: EdgeInsets.all(10),
      onPressed: () async {
        Navigator.pop(context);
        await save();
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(text_color0),
      ),
      child: const Text(
        'Confirm',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const Text(
              "Message ",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10,),
            const Text(
              "Do you want to add this class session to the timetable ?",
              style: TextStyle(
                  color: text_color3
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 4),
              child: continueButton,
            ),
            cancelButton
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Future save() async {
    showProgress();
    String url = "${apiUrl}data/add_courseplan";
    print("URL ::: $url");
    var data = {
      "course_id": _selected.toString(),
      "day_id": _selected_day.toString(),
      "hour": "${dateTime.hour.toString().padLeft(2, '0')}:"
          "${dateTime.minute.toString().padLeft(2, '0')}-"
          "${dateTimeEnd.hour.toString().padLeft(2, '0')}:${dateTimeEnd.minute.toString().padLeft(2, '0')}",
      "timetable_id": _selected_date,
    };

    http.post(Uri.parse(url), body: data,).timeout(const Duration(seconds: 30)).then((res) async {

      progressDialog.dismiss();
      print("DATA ::: ${res.body}");


      if (res.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "Problem of server",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.white,
            textColor: Colors.grey);
      }
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data["status"] == true) {
          Fluttertoast.showToast(
            msg: "Date saved successfully",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          );
        }
        else {
          Fluttertoast.showToast(
            msg: "Error when saving",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black,
          );
        }
      }
    }).catchError((onError) {
      progressDialog.dismiss();

      Fluttertoast.showToast(
        msg: "Server Error.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    });
  }

  Widget _course(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: _selected == null ? Colors.grey : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: text_color2,
                      ),
                    ),
                    hintStyle: TextStyle(color: text_color2),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(2.0),
                  ),
                  isDense: true,
                  isExpanded: true,
                  hint: const Text(
                    "Select a course",
                    style: TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  value: _selected.toString(),
                  items: tab.map((data) {
                    return DropdownMenuItem<String>(
                      value: data["id"].toString(),
                      child: Text(data["title"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selected = value.toString();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Currency required';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _day(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: _selected_day == null ? Colors.grey : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: text_color2,
                      ),
                    ),
                    hintStyle: TextStyle(color: text_color2),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(2.0),
                  ),
                  isDense: true,
                  isExpanded: true,
                  hint: const Text(
                    "Select a day",
                    style: TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  value: _selected_day.toString(),
                  items: tab_day.map((data) {
                    return DropdownMenuItem<String>(
                      child: Text(data["day"]),
                      value: data["id"].toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selected_day = value.toString();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Currency required';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _date(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: _selected_date == null ? Colors.grey : Colors.black,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: text_color2,
                      ),
                    ),
                    hintStyle: TextStyle(color: text_color2),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(2.0),
                  ),
                  isDense: true,
                  isExpanded: true,
                  hint: const Text(
                    "Select a range date (file timetable)",
                    style: TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  value: _selected_date.toString(),
                  items: tab_date.map((data) {
                    return DropdownMenuItem<String>(
                      child: Text(data["date"]),
                      value: data["id"].toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selected_date = value.toString();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Date range required';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    getDay();
    getCourse();
    getDate();
    super.initState();
  }

  late DateTime dateTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  late DateTime dateTimeEnd = DateTime(now.year, now.month, now.day, now.hour, now.minute);

  Future<DateTime?> pickDate() {
    return showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
  }

  Future<DateTime?> pickDateEnd() {
    return showDatePicker(
        context: context,
        initialDate: dateTimeEnd,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    final hoursEnd = dateTimeEnd.hour.toString().padLeft(2, '0');
    final minutesEnd = dateTimeEnd.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: text_color0,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Add Timetable',
            style: TextStyle(
                fontFamily: 'Varela', fontSize: 20.0, color: Colors.white)),
        actions: <Widget>[
        ],
      ),
      body: ListView(
        // physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: 30,),
          _course(Icons.currency_franc_rounded, 'Course'),
          _day(Icons.currency_franc_rounded, 'Day'),
          _date(Icons.currency_franc_rounded, 'Date'),
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: size.height * 0.06,
                  width: size.width * 0.4,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(text_color0)),
                      onPressed: () async {
                        final time = await pickTime();
                        if(time == null) return ;

                        final newDateTime = DateTime(
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            time.hour,
                            time.minute
                        );

                        setState(() {
                          istime = true;
                          dateTime = newDateTime;
                        });
                      },
                      child: istime ? Text("${hours} : ${minutes}") : Text("Start time")
                  ),
                ),
                Container(
                  height: size.height * 0.06,
                  width: size.width * 0.4,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(text_color0)),
                      onPressed: () async {
                        final time = await pickTime();
                        if(time == null) return ;

                        final newDateTime = DateTime(
                            dateTimeEnd.year,
                            dateTimeEnd.month,
                            dateTimeEnd.day,
                            time.hour,
                            time.minute
                        );

                        setState(() {
                          istimeend = true;
                          dateTimeEnd = newDateTime;
                        });
                      },
                      child: istimeend ? Text("${hoursEnd} : ${minutesEnd}") : Text("End time")
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: size.height * 0.08,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(text_color0)
              ),
              // color: text_color0,
              child: const Text(
                "Validated",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                showAlertDialog(context);
              }
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> pickTime() {
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: dateTime.hour,
            minute: dateTime.minute
        )
    );

  }
}
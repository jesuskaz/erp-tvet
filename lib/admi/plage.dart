import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../tools/tool.dart';

class Plage extends StatefulWidget {
  @override
  _Plage createState() => _Plage();
}

class _Plage extends State<Plage> with TickerProviderStateMixin {

  String url = '';
  bool process = false;

  Dio dio = new Dio();
  late ProgressDialog progressDialog;
  late http.Response response;

  bool isdate = false;

  DateTime now = new DateTime.now();

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
              "Do you want to add this date ?",
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
    String url = "${apiUrl}data/add_timetable";

    var data = {
      "date": '${DateFormat('yyyy/MM/dd').format(dateRange.start)}'
          '-${DateFormat('yyyy/MM/dd').format(dateRange.end)}'.toString()
    };

    http.post(Uri.parse(url), body: data,).timeout(const Duration(seconds: 30)).then((res) async {

      progressDialog.dismiss();

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
        msg: "Impossible d'atteindre le serveur distant.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    });
  }

  late DateTimeRange dateRange = DateTimeRange(
    start: DateTime(now.year, now.month, now.day),
    end: DateTime(now.year, now.month, now.day)
  );

  Future pickDateRange() async {

    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if(newDateRange == null) return;
    setState(() {
      isdate = true;
      dateRange = newDateRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final start = dateRange.start;
    final end = dateRange.end;

    final difference = dateRange.duration;

    print("DIFFERENCE ::: ${difference}");

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
        title: const Text('Add the date range',
            style: TextStyle(
                fontFamily: 'Varela', fontSize: 20.0, color: Colors.white)),
        actions: <Widget>[
        ],
      ),
      body: ListView(
        // physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: size.height * 0.01,),
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              child: const Text(
                  "Before creating the schedule, first create the file, "
                      "the file has the name of the start date and the end date "
                      "of your timetable. eg: (2023/05/12-2023/05/19) juste for a week",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.001,),
          InkWell(
            onTap: () {
              pickDateRange();
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: size.height * 0.1,
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.zero),
                  color: Colors.blue.shade50,
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.01,),
                    Icon(
                      Icons.date_range,
                      size: 30,
                      color: Colors.blue.shade400,
                    ),
                    SizedBox(height: 10,),
                    isdate != true ? const Text(
                      "Select a date range",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey
                      ),
                    ):Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('yyyy/MM/dd').format(start),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const Text(' - ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(DateFormat('yyyy/MM/dd').format(end),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
          SizedBox(height: 16,),
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
                "add the range of this date",
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
}
import 'dart:async';
import 'package:connectivity/connectivity.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

import 'package:erptvet/tools/tool.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

class AddEvent extends StatefulWidget {
  @override
  _AddEvent createState() => _AddEvent();
}

class _AddEvent extends State<AddEvent> with TickerProviderStateMixin {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  bool process = false;
  var noInternet = '';
  bool networkOK = false;
  var file_image;

  Dio dio = new Dio();
  late ProgressDialog progressDialog;
  late http.Response response;

  var tab = [];
  var tab_cat = [];

  var _selected = "1";
  var _selected_cat = "1";

  String url = '';
  String url_cat = '';
  bool isdate = false;
  DateTime now = new DateTime.now();

  @override
  void dispose() {
    super.dispose();
  }
  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'gif']);

    if (result != null) {
      final file = result.files.first;
      // openFile(file);

      setState(() {
        file_image = File(result.files.single.path!);
        // type = file.extension.toString();
      });
    }
  }
  Future getDay() async {
    setState(() {
      process = true;
    });

    url = apiUrl + "data/get_day";

    response = await http.get(Uri.parse(url), headers: <String, String>{
      "Authorization": "Bearer $token",
      "Accept": "application/json; charset=UTF-8"
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data["status"] == true) {
        if (mounted) {
          setState(() {
            tab = data["datas"];
            _selected = tab[0]["id"].toString();
          });
        }
      }
    }
  }
  Future getCategory() async {
    setState(() {
      process = true;
    });

    url_cat = apiUrl + "data/category";

    response = await http.get(Uri.parse(url_cat), headers: <String, String>{
      "Authorization": "Bearer $token",
      "Accept": "application/json; charset=UTF-8"
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data["status"] == true) {
        if (mounted) {
          setState(() {
            tab_cat = data["datas"];
            print("URL :::: ${tab_cat}");
            _selected_cat = tab_cat[0]["id"].toString();
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              "do you want to register this event ?",
              style: TextStyle(color: text_color3),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 4),
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
      String url = apiUrl + "data/add_event";
      if (file_image != null) {
        FormData data = FormData.fromMap({
          "title": title.text,
          "description": description.text,
          "day": _selected.toString(),
          "date": '${DateFormat('yyyy/MM/dd').format(dateRange.start)}'
              '-${DateFormat('yyyy/MM/dd').format(dateRange.end)}'.toString(),
          "category": _selected_cat.toString(),
          "image": await MultipartFile.fromFile(
            file_image.path, filename: path.basename(file_image.path),
            // contentType:  MediaType("image", "$type")
          ),
        });

        // dio.options.headers["Authorization"] = "Bearer ${token}";
        await dio.post(url, data: data).timeout(Duration(seconds: 30)).then((res) {
          progressDialog.dismiss();

          if (res.statusCode == 200) {
            var d = jsonDecode(res.data);
            if (d["status"] == true) {

              Fluttertoast.showToast(
                msg: "${d["data"]}",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
            } else {
              Fluttertoast.showToast(
                msg: "${d["data"]}",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
            }
          }
          else {
            Fluttertoast.showToast(
              msg: "Please try again to load an event",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.white,
              textColor: Colors.black,
            );
          }
        }).catchError((onError) async {
          progressDialog.dismiss();
          if (onError.response.statusCode == 400) {
            Fluttertoast.showToast(
              msg: "Error to save this event",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.white,
              textColor: Colors.black,
            );
            return;
          }
        });
      } else {
        progressDialog.dismiss();
        Fluttertoast.showToast(
          msg: "Please select image for this event",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      }
  }

  Widget _title(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: title,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return "Title is required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: color_grey,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(2.0),
          ),
          //style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
      // ),
    );
  }
  Widget _description(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: description,
          style: TextStyle(color: Colors.blueGrey),
          validator: (value) {
            if (value!.isEmpty) {
              return "Nom est obligatoir";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: color_grey,
              ),
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: color_grey,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(2.0),
          ),
          //style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
      // ),
    );
  }
  Widget _day(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
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
                    "Select a day",
                    style: TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  value: _selected.toString(),
                  items: tab.map((data) {
                    return DropdownMenuItem<String>(
                      child: Text(data["day"]),
                      value: data["id"].toString(),
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
  Widget _cat(IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: _selected_cat == null ? Colors.grey : Colors.black,
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
                    "Select a categorie",
                    style: TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  value: _selected_cat.toString(),
                  items: tab_cat.map((data) {
                    return DropdownMenuItem<String>(
                      child: Text(data["category"]),
                      value: data["id"].toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selected_cat = value.toString();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Category required';
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
  initState() {
    getDay();
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;

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
        title: const Text('Add an event',
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
          InkWell(
            onTap: () {
              pickFiles();
              // _showPickOptionsDialog_back(context);
            },
            child: file_image == null
                ? Container(
              height: size.height * 0.2,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.zero),
                color: Colors.blue.shade50,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.04,),
                  Icon(Icons.add_a_photo, size: 30, color: Colors.blue.shade400,),
                  const SizedBox(height: 10,),
                  const Text(
                    "Add the event image",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  )
                ],
              ),
            )
                : Container(
              // height: size.height * 0.2,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.zero),
                color: Colors.blue.shade50,
              ),
              child: Image(
                image: FileImage(file_image),
                fit: BoxFit.cover,
                // fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _title(Icons.article, 'Title', TextInputType.name, TextInputAction.next,),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            child: _description(Icons.description_outlined, 'Description', TextInputType.name, TextInputAction.done),
          ),
          _day(Icons.currency_franc_rounded, 'Day'),
          _cat(Icons.currency_franc_rounded, 'Category'),
          InkWell(
              onTap: () {
                pickDateRange();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: size.height * 0.1,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(text_color0),
              ),
              child: const Text(
                "Sauvegarder",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                showAlertDialog(context);
              }),
        ),
      ),
    );
  }
}
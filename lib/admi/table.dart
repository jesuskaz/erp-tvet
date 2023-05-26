import 'dart:math';

import 'package:erptvet/admi/plage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tools/tool.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TableT extends StatefulWidget {
  String idoption;
  TableT(this.idoption);
  @override
  _TableT createState() => _TableT();
}

class _TableT extends State<TableT> with TickerProviderStateMixin {

  var rep;

  Future get_grade() async {
    String url = "${apiUrl}data/get_courseplan";

    var data = {
      "idoption" : widget.idoption.toString()
    };
    final response = await http.post(Uri.parse(url), body: data, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      var r = jsonDecode(response.body);
      rep = r["datas"];
    }
    return rep;
  }
  // initState() {
  //   get_grade();
  // }


  getRandom() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }
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
        title: const Text('Timetable',
            style: TextStyle(
                fontFamily: 'Varela', fontSize: 20.0, color: Colors.white)),
        actions: <Widget>[
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // Data table widget in not scrollable so we have to wrap it in a scroll view when we have a large data set..
        child: SingleChildScrollView(
          child: Column(

            children: [
              FutureBuilder(
                future: get_grade(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                  
                  
                  if(!snapshot.hasData)
                  {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.4, horizontal: size.width * 0.4),
                      child: const SizedBox(
                          height: 45,
                          width: 45,
                          child: CircularProgressIndicator()
                      ),
                    );
                  }
                  return snapshot.data.length > 0 ? DataTable(
                    dividerThickness: 5.0,
                    border: TableBorder.all(
                      width: 1.0,
                      color:Colors.black,),
                    columns: const [
                      DataColumn(
                        label: Text('Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18

                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text('Hour',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,

                          ),),
                      ),
                      DataColumn(
                        label: Text('Course',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18

                          ),),)
                    ],
                    rows: snapshot.data.map<DataRow>((data) {

                      var date = data["date"].split('-');

                      var split_date = date[0].split('/');
                      String yyyy = split_date[0];
                      String mm = split_date[1];
                      int dd = int.parse(split_date[2]);

                      return DataRow(
                          cells: [
                            DataCell(Text(
                                "${data["day"]}".toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            )),
                            DataCell(Text("${data["hour"]}".toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold
                              ),)),
                            DataCell(Text("${data["title"]}".toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold
                              ),)),
                          ]
                      );

                    }
                    ).toList(),
                  ) : Container(
                    padding: EdgeInsets.only(top: size.height * 0.4, left: size.width * 0.25),
                    child: Text("No timetable yet for this grade",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey
                      ),),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

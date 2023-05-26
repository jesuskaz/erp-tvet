import 'dart:math';
import 'package:erptvet/admi/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tools/tool.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class View extends StatefulWidget {
  @override
  _View createState() => _View();
}

class _View extends State<View> with TickerProviderStateMixin {

  var rep;

  Future get_grade() async {
    String url = "${apiUrl}data/view_grade";
    print("URL ::: ${url}");
    final response = await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      var r = jsonDecode(response.body);
      rep = r;
    }
    return rep ?? [];
  }
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
        title: const Text('Grade',
            style: TextStyle(
                fontFamily: 'Varela', fontSize: 20.0, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 25,),
          Container(
            child: const Text("Please select a grade to view the timetable",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey
              ),
            ),
          ),
          SizedBox(height: 25,),
          FutureBuilder(
            future: get_grade(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) {
                return const Center(
                  heightFactor: 10,
                  child: SizedBox(
                          height: 45,
                          width: 45,
                          child: CircularProgressIndicator()
                  ),
                );
              }
              return snapshot.hasData ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data["datas"].length,
                itemBuilder: (BuildContext ctx, index){
                  var grade = snapshot.data["datas"][index];

                  return  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TableT(grade["id"])));
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
                            color: getRandom(),
                          ),
                        ),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Timetable for the ${grade["grade"]}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueGrey
                            ),
                          ),
                        ),
                        subtitle: Text(
                          "Option ${grade["name"]}",
                          style: TextStyle(
                              color: Colors.black45
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Container(

                    child: Text("No Grade now", style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
              );
            },
          )
        ],
      ),
    );
  }
}

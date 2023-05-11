import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:erptvet/credential/signin.dart';
import 'tool.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  var boolVal;
  var response;
  var state = false;

  late SharedPreferences preferences;
  String user = '';

  void confirmProcess(String status) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setString("token", "");
    preferences.setString("iduser", "");

    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SigninScreen(),
        ));
  }
  void alertConfirm(String msg, String status) {
    QuickAlert.show(
        onConfirmBtnTap: () {
          if(status == "send") {
            Navigator.of(context).pop();
            confirmProcess(status);
          }
          else
            {
              Navigator.of(context).pop();
              confirmProcess(status);
            }
        },
        onCancelBtnTap: () {
          Navigator.of(context).pop();
        },
        context: context,
        type: QuickAlertType.confirm,
        title: "Veuillez vous connecter.",
        text: msg,
        confirmBtnText: 'Oui',
        cancelBtnText:  'Annuler',
        cancelBtnTextStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        confirmBtnColor: text_color
    );
  }
  void get_session() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState((){
      user = pref.getString("iduser").toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_session();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5, top: 30),
                  child: const Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            accountEmail: Container(
              margin: EdgeInsets.only(left: 5),
              child: const Text(
                "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "images/launcher.png",
                  width: 95,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/fond.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add_business_rounded),
              title: const Text(
                "Compte",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: const Text(
                "Ecrivez-nous",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () async {

              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.history),
              title: const Text(
                "Laissez une recherche",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {

              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.vpn_key),
              title: const Text(
                "Envoyez-nous immo",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                user = pref.getString("iduser").toString();

                print("USER IS EMPTY ? ${user.isEmpty}");

                Navigator.of(context).pop();
                if(user.isEmpty)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen()));
                  }
                else
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Container()));
                  }

              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.favorite, color: Colors.red,),
              title: const Text(
                "Mes favoris",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                user = pref.getString("iduser").toString();

                print("USER IS EMPTY ? ${user.isEmpty}");
                Navigator.of(context).pop();
                if(user.isEmpty)
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen()));
                }
                else
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Container()));
                }
              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.house),
              title: const Text(
                "Mes immo",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                user = pref.getString("iduser").toString();

                print("USER IS EMPTY ? ${user.isEmpty}");

                Navigator.of(context).pop();
                if(user.isEmpty)
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen()));
                }
                else
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Container()));
                }
              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.connect_without_contact),
              title: const Text(
                "Connexion",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => SigninScreen()));
              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: const Text(
                "Se Déconnecter",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                alertConfirm('Voulez-vous vous déconnecter ?', "deconnect");
              })
        ],
      ),
    );
  }
}



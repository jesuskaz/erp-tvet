import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:erptvet/tools/tool.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../credential/signin.dart';
import 'package:flutter/painting.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {

  void confirmProcess(String status) async {
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

            Navigator.of(context).pop();
            confirmProcess(status);
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
                  "images/head.jpg",
                  width: 95,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'images/head.jpg',
                  ),
                  fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken)
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.vpn_key),
              title: const Text(
                "Compte",
                style: TextStyle(
                  color: color_grey,
                  fontSize: taille2,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SigninScreen(),
                  ),
                );
              }),
          const Divider(height: 1),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: const Text(
                "Log out",
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
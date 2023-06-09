import 'dart:async';

import 'package:erptvet/admi/options.dart';
import 'package:erptvet/student/schoolmanagement.dart';
import 'package:erptvet/tools/tool.dart';
// import 'package:get/get.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';


class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
{
  bool isHidePassword = true;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  late SharedPreferences preferences;

  late ProgressDialog progressDialog;
  String initialCountry = 'CD';
  PhoneNumber number = PhoneNumber(isoCode: 'CD');
  final _formKey = GlobalKey<FormState>();

  var tel;

  Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;
  bool networkOK = false;
  var noInternet = '';
  String idimmo = '';

  void get_session() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState((){
      idimmo = pref.getString("idimmo").toString();
    });
  }
  void checkNetwork() async {
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          networkOK = result == ConnectivityResult.none ? false : true;
          if (networkOK) {
            noInternet = '';
          }
        });
      }
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none)
    {
      setState(() {
        networkOK = true;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
  @override
  initState() {
    _askPermissions();
    checkNetwork();
    get_session();
    super.initState();
  }
  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Fluttertoast.showToast(
          msg: "Accès donné avec succès",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.white,
          textColor: Colors.grey);
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Widget _telephone(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Center(
        child: InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            tel = number.phoneNumber;
          },
          onInputValidated: (bool value) {
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          spaceBetweenSelectorAndTextField: 0,
          inputDecoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFFF2F2F2),
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            border: OutlineInputBorder(),
            hintText: "Ex: 991234567",
            hintStyle: TextStyle(fontSize: 12),
            isCollapsed: true,
            contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Numéro de tel. vide';
            }
            if (value.length < 9) {
              return 'Tel. non valide';
            }
            return null;
          },
          maxLength: 9,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(color: Colors.white),
          initialValue: number,
          textFieldController: phone,
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
          inputBorder: const OutlineInputBorder(),
          onSaved: (PhoneNumber number) {},
        ),
      ),
    );
  }
  Widget _motdePasse(IconData icon, String hint, TextInputType inputType, TextInputAction inputAction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      child: Center(
        child: TextFormField(
          controller: password,
          obscureText: isHidePassword,
          style: TextStyle(color: color_grey),
          validator: (value) {
            if (value!.isEmpty) {
              return "Password Required";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: color_white,
                )),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: color_white,
            ),
            suffixIcon: InkWell(
              onTap: () => getHiddenPass(),
              child: const Icon(
                Icons.visibility,
                color: color_white,
              ),
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: color_white, fontSize: 12),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(2.0),
          ),
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
    );
  }

  showProgress() {
    progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: "In process ... ",
    );
    progressDialog.show();
  }
  Future login() async {
    setState(() {
      noInternet = '';
    });

    if(networkOK)
    {
      showProgress();
      String url = "${apiUrl}credential/signin";

      var data =  {
        "username": tel,
        "password": password.text,
      };

      http.post(Uri.parse(url), body: data,).timeout(const Duration(seconds: 30)).then((res) async {

        progressDialog.dismiss();

        if (res.statusCode == 400)
        {
          Fluttertoast.showToast(
              msg: "Nous avons rencontré un problème lors de votre connexion. Veuillez réessayer.",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.white,
              textColor: Colors.grey);
        }
        if (res.statusCode == 200)
        {
          var data = jsonDecode(res.body);
          String role = data["role"];

          if(role == "student")
          {
            var user = data["data"][0];
            String name = user["fullname"].toString();
            String tel = user["phone"].toString();
            String option = user["name"];
            String grade = user["grade"];
            String id = user["id"].toString();

            preferences = await SharedPreferences.getInstance();
            preferences.setString("name", name);
            preferences.setString("phone", tel);
            preferences.setString("option", option);
            preferences.setString("grade", grade);
            preferences.setString("iduser", id);

              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolManagement(),));
          }
          else if(role == "admin")
          {
            var user = data["data"][0];
            String name = user["fullname"].toString();
            String tel = user["phone"].toString();
            String id = user["id"].toString();

            preferences = await SharedPreferences.getInstance();
            preferences.setString("name", name);
            preferences.setString("phone", tel);
            preferences.setString("iduser", id);

            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Options(),));
          }
          else if(data["status"] == false)
            {
              Fluttertoast.showToast(
                msg: "Your information is not correct. Please enter a correct ursename and password",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.white,
                textColor: Colors.black,
              );
            }
        }
      }).catchError((onError){
        progressDialog.dismiss();

        Fluttertoast.showToast(
          msg: "Impossible d'atteindre le serveur distant.",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      });
    }
    else
    {
      Fluttertoast.showToast(
        msg: "Vérifiez votre connexion internet.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage(('images/fond.jpg')),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.8), BlendMode.darken))),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 120,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: size.height * 0.12,
                          child: const CircleAvatar(
                              backgroundColor: text_color,
                              child: ClipOval(
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                  ))),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        _telephone(
                          Icons.account_circle,
                          'Téléphone',
                          TextInputType.name,
                          TextInputAction.next,
                        ),
                        _motdePasse(
                          Icons.lock_outline_sharp,
                          'Mot de passe',
                          TextInputType.name,
                          TextInputAction.next,
                        ),
                        Container(
                          height: size.height * 0.11,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate())
                              {
                                login();
                              }
                            },
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(text_color),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                        side: BorderSide(color: text_color)
                                    )
                                )
                            ),
                            child: const Text(
                              'Se Connecter',
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans'),
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                        //     child: RichText(
                        //       textAlign: TextAlign.start,
                        //       text: const TextSpan(
                        //           text: "N'avez-vous pas un ",
                        //           style: TextStyle(
                        //               color: Colors.white, fontSize: 12),
                        //           children: [
                        //             TextSpan(
                        //               text: "Compte ?",
                        //               style: TextStyle(
                        //                   color: text_color0, fontSize: 12),
                        //             ),
                        //           ]),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
                text: "Copyright ©2022, All Rights Reserved. ",
                style: TextStyle(color: Colors.white, fontSize: 9),
                children: [
                  TextSpan(
                    text: "MQuick",
                    style: TextStyle(color: text_color, fontSize: 10),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
  void getHiddenPass() {
    setState(() {
      isHidePassword = !isHidePassword;
    });
  }
}

class InputEmail extends StatelessWidget {
  final String hintText;
  final String upperText;
  final IconData icon;
  final bool obscuretext;
  final TextInputType inputType;
  InputEmail(this.hintText, this.icon, this.obscuretext, this.upperText, this.inputType);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          upperText,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.yellowAccent,
                    offset: Offset(0, 2),
                    blurRadius: 10.0),
              ],
              image:
              DecorationImage(image: AssetImage('images/cookiecream.jpg'))),
          alignment: Alignment.centerLeft,
          height: 60,
          child: TextField(
            obscureText: obscuretext,
            keyboardType: inputType,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14),
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: hintText,
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }
}

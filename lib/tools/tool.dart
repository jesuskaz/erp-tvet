import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

const Color text_color0 = Color(0xff154a99);
// const Color text_color0 = Color(0xffeead41);
const Color text_color = Color(0xff154a99);

const Color text_color1 = Colors.white70;
const Color text_color2 = Colors.grey;
const Color text_color3 = Colors.green;
const Color text_color4 = Colors.blueAccent;
const Color kBlue = Color(0xff154a99);

const Color color_grey = Colors.grey;
const Color color_white = Colors.white;
const Color color_red = Colors.red;

const TextStyle kBodyText = TextStyle(fontSize: 18, color: Colors.white, height: 1.5);
const TextStyle style_init = TextStyle(fontFamily: 'Varela', fontSize: 18.0, color: color_white, fontWeight: FontWeight.bold);
const TextStyle style_init1 = TextStyle(fontFamily: 'Varela', fontSize: 18.0, color: text_color2, fontWeight: FontWeight.bold);

//Predefine size

const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

// final kTitleTextStyle = TextStyle(
//     fontSize: ScreenUtil().setSp(kSpacingUnit.w * 0.02),
//     fontWeight: FontWeight.w600,
//     color: Colors.blueGrey
// );

// final kCaptionTextStyle = TextStyle(
//   fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
//   fontWeight: FontWeight.w100,
// );

// final kButtonTextStyle = TextStyle(
//   fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
//   fontWeight: FontWeight.w400,
//   color: kDarkPrimaryColor,
// );

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
    color: kLightSecondaryColor,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'SFProText',
    bodyColor: kLightSecondaryColor,
    displayColor: kLightSecondaryColor,
  ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
    color: kDarkSecondaryColor,
  ),
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'SFProText',
    bodyColor: kDarkSecondaryColor,
    displayColor: kDarkSecondaryColor,
  ),
);

const double taille0 = 15;
const double taille1 = 15;
const double taille2 = 15;
const double taille3 = 12;

// Credential
const appId = "cc5315fdd98a42d98dbad2f476b74d10";
const token = "007eJxTYKg0UNAWOX3q6taW02yxNWUGTqdnf+X5H2uVsf1iwqQHCscUGJKTTY0NTdNSUiwtEk2MgGRKUmKKUZqJuVmSuUmKocH5uY7J/u+dksNiNrAyMkAgiM/BkJ9YnFmcWFDAwAAAH/Mj8Q==";
const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFFC6B299).withOpacity(0.3),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(0, 2)
      )
    ]
);
final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);
final kTitleStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'CM Sans Serif',
  fontSize: 26.0,
  height: 1.5,
);

List<Color> backgroundColors = [
  Colors.blue.shade400,
  Colors.green.shade400,
  Colors.red.shade400,
  Colors.yellow.shade400,
  Colors.orange.shade400,
  Colors.teal.shade400,
  Colors.purpleAccent.shade400
];

final kSubtitleStyle = TextStyle(color: Colors.white, fontSize: 18.0, height: 1.2,);

// const apiUrl = "http://www.oasisapp.tech/api/";
const domaine = "http://192.168.0.170/erp/";
// const domaine = "http://localhost/mquick/";
// const apiUrl = "https://oasisapp.tech/api/";
const apiUrl = domaine + "052023/api/";

const ressourceBasePath = apiUrl;
userHeaders() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var apiToken = preferences.getString("token");
  return {'token': "$apiToken", 'Accept': 'application/json'};
}
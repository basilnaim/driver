import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Const {
  //colors
  static const Color primaryColor = Color(0xFF94B92D);
  static const Color textColor = Color(0xFF29335C);
  static const Color hintColor = Color(0xFFC2C2C2);
  static const Color redRupeeColor = Color(0xFFD32C29);
  static const Color redButtonColor = Color(0xFFFC5759);
  static const Color uncheckLineColor = Color(0xFFD3D6DA);

  //fonts
  static const poppinsRegular = 'PoppinsRegular';
  static const poppinsSemiBold = 'PoppinsSemiBold';
  static const poppinsBlack = 'PoppinsBlack';
  static const poppinsBlackItalic = 'PoppinsBlackItalic';
  static const poppinsBold = 'PoppinsBold';
  static const poppinsBoldItalic = 'PoppinsBoldItalic';
  static const poppinsExtraBold = 'PoppinsExtraBold';
  static const poppinsExtraBoldItalic = 'PoppinsExtraBoldItalic';
  static const poppinsExtraLight = 'PoppinsExtraLight';
  static const poppinsExtraLightItalic = 'PoppinsExtraLightItalic';
  static const poppinsItalic = 'PoppinsItalic';
  static const poppinsLight = 'PoppinsLight';
  static const poppinsLightItalic = 'PoppinsLightItalic';
  static const poppinsMedium = 'PoppinsMedium';
  static const poppinsMediumItalic = 'PoppinsMediumItalic';
  static const poppinsSemiBoldItalic = 'PoppinsSemiBoldItalic';
  static const poppinsThin = 'PoppinsThin';
  static const poppinsThinItalic = 'PoppinsThinItalic';

  //api keys
  static const headerToken = 'headerToken';
  static const checkDriverStatus = 'checkDriverStatus';
  static const checkLogin = 'checkLogin';
  static const latitude = 'latitude';
  static const longitude = 'longitude';
  static const destinationLatitude = 'destinationLatitude';
  static const destinationLongitude = 'destinationLongitude';
  static const deviceToken = 'deviceToken';

  //toast long
  static showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  //loader data
  static const ProgressIndicator customLoader = CircularProgressIndicator(
    strokeWidth: 2,
    valueColor: AlwaysStoppedAnimation<Color>(Const.primaryColor),
  );
}

//dotted line
class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

//blink animation
//ToDo:complete this before release application
class MyBlinkingButton extends StatefulWidget {
  @override
  _MyBlinkingButtonState createState() => _MyBlinkingButtonState();
}

class _MyBlinkingButtonState extends State<MyBlinkingButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: MaterialButton(
        onPressed: () => null,
        child: Text("Text button"),
        color: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

//sharedprefrence
class Prefs {
  static SharedPreferences _prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  //sets
  static Future<bool> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  //gets
  static bool getBool(String key) => _prefs.getBool(key);

  static double getDouble(String key) => _prefs.getDouble(key);

  static int getInt(String key) => _prefs.getInt(key);

  static String getString(String key) => _prefs.getString(key);

  static List<String> getStringList(String key) => _prefs.getStringList(key);

  //deletes..
  static Future<bool> remove(String key) async => await _prefs.remove(key);

  static Future<bool> clear() async => await _prefs.clear();
}

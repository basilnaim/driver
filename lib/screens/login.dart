import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlans_driver/all_constant.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/screens/homepage.dart';
import 'package:foodlans_driver/screens/sign_up.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'verification_phone.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatefulWidget {
  final String login = '/Login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double screenHeight;
  double screenWidth;
  bool _obscureText = true;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  final _scaffoldKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  bool _showSpinner = false;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  String playerIdForLogin = '';
  @override
  void initState() {
    getPermission();
    setDeviceToken();
    super.initState();
  }

  Future<void> setDeviceToken() async {
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared.promptUserForPushNotificationPermission();

    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;

    setState(() {
      playerIdForLogin = playerId;
      Prefs.setString(Const.deviceToken, playerId);
    });
    print('device token is $playerIdForLogin');
  }

  Future<void> getPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);
    Prefs.setDouble(Const.latitude, _locationData.latitude);
    Prefs.setDouble(Const.longitude, _locationData.longitude);
    // LocationPermission permission = await checkPermission();
    // if (permission == LocationPermission.denied ||
    //     permission == LocationPermission.deniedForever) {
    //   permission = await requestPermission();
    // }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //local login
  Future<void> callLoginAPI() async {
    await setDeviceToken();
    getPermission();
    if (playerIdForLogin != '' && playerIdForLogin != null) {
      if (Prefs.getString(Const.deviceToken) != null) {
        playerIdForLogin = Prefs.getString(Const.deviceToken);
      }
    }
    setState(() {
      _showSpinner = true;
    });
    Map<String, String> body = {
      'email': _email.text,
      'password': _password.text,
      'provider': 'LOCAL',
      // if (playerIdforLogin != null && playerIdforLogin != '')
      'device_token': playerIdForLogin,
    };
    print(body);
    RestClient(Retro_Api().Dio_Data()).login(body).then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        Prefs.setBool(Const.checkLogin, true);
        Prefs.setString(Const.headerToken, response.data.token);
        Const.showToast(response.msg);
        if (response.data.verify == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Verification(
                userId: response.data.id,
              ),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        }
      } else {
        Const.showToast(response.msg);
      }
    }).catchError((Object obj) {
      setState(() {
        _showSpinner = false;
      });
      switch (obj.runtimeType) {
        case DioError:
          setState(() {
            _showSpinner = false;
          });
          // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          var msg = res.statusMessage;
          var responseCode = res.statusCode;
          if (responseCode == 401) {
            Const.showToast(res.statusMessage);
            print(responseCode);
            print(res.statusMessage);
          } else if (responseCode == 400) {
            print("code:$responseCode");
            print("msg:$msg");
            Const.showToast('Invalid Username or password');
          } else if (responseCode == 422) {
            print("code:$responseCode");
            print("msg:$msg");
            Const.showToast("code:$responseCode");
          } else if (responseCode == 500) {
            print("code:$responseCode");
            print("msg:$msg");
            Const.showToast(LocaleKeys.Internal_Server_Error.tr());
          }
          break;
        default:
      }
    });
  }

  //check validation
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return LocaleKeys.Enter_Valid_Email.tr();
    } else
      return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return LocaleKeys.Please_enter_some_text.tr();
    } else if (6 > value.length) {
      return LocaleKeys.Enter_more_than_6_character.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        progressIndicator: Const.customLoader,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: GestureDetector(
              onTap: () {
                setDeviceToken();
              },
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight / 2.2,
                      // color: Colors.red,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 35.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/images/foodlans.png',
                                height: 192,
                                width: 168,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          //driver png
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Image.asset(
                              'assets/images/driver.png',
                              height: 115,
                              width: 116,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 15.0, bottom: 10.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                LocaleKeys.SIGN_IN.tr(),
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: Const.poppinsSemiBold,
                                  color: Const.textColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //email stuff
                    Container(
                      height: screenHeight / 1.35,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.1),
                            offset: Offset(0, -1),
                            spreadRadius: 3,
                            blurRadius: 10.0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //email
                            Text(
                              LocaleKeys.Email.tr(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: Const.poppinsMedium,
                                color: Const.textColor,
                              ),
                            ),
                            TextFormField(
                              controller: _email,
                              // ..text = 'driver-foodlands@saasmonks.in',
                              focusNode: emailFocus,
                              onFieldSubmitted: (a) {
                                emailFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(passwordFocus);
                              },
                              autovalidate: true,
                              validator: validateEmail,
                              maxLines: 1,
                              enableSuggestions: false,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                hintText: 'harrypearson@gmail.com',
                                hintStyle: TextStyle(
                                  color: Const.hintColor,
                                  fontFamily: Const.poppinsRegular,
                                  fontSize: 16.0,
                                ),
                                labelStyle: TextStyle(
                                  color: Const.hintColor,
                                  fontFamily: Const.poppinsRegular,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight / 25),
                            //password
                            Text(
                              LocaleKeys.Password.tr(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: Const.poppinsMedium,
                                color: Const.textColor,
                              ),
                            ),
                            TextFormField(
                              controller: _password,
                              // ..text = '123456',
                              focusNode: passwordFocus,
                              onFieldSubmitted: (a) {
                                passwordFocus.unfocus();
                              },
                              autovalidate: true,
                              validator: validatePassword,
                              maxLines: 1,
                              enableSuggestions: false,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                hintText: '* * * * * *',
                                hintStyle: TextStyle(
                                  color: Const.hintColor,
                                  fontFamily: Const.poppinsRegular,
                                  fontSize: 16.0,
                                ),
                                labelStyle: TextStyle(
                                  color: Const.hintColor,
                                  fontFamily: Const.poppinsRegular,
                                  fontSize: 16.0,
                                ),
                                suffixIcon: IconButton(
                                  icon: _obscureText
                                      ? Icon(
                                          FontAwesomeIcons.eye,
                                          color: Const.hintColor,
                                        )
                                      : Icon(
                                          FontAwesomeIcons.eyeSlash,
                                          color: Const.hintColor,
                                        ),
                                  iconSize: 12,
                                  onPressed: _toggle,
                                ),
                              ),
                              obscureText: _obscureText,
                            ),
                            SizedBox(height: screenHeight / 36),
                            //forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  LocaleKeys.Forgot_Password.tr(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: Const.poppinsRegular,
                                    color: Const.textColor,
                                  ),
                                ),
                              ],
                            ),
                            //signin button
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.070,
                              margin: EdgeInsets.only(top: 36.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Const.primaryColor,
                                  onPrimary: Colors.black12,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    callLoginAPI();
                                  }
                                  print('sign in');
                                },
                                child: Text(
                                  LocaleKeys.SIGN_IN.tr(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: Const.poppinsMedium,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight / 30),
                            //devider
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.withOpacity(0.5),
                                    thickness: 1,
                                    height: 1,
                                    // indent: 50.0,
                                    endIndent: 15.0,
                                  ),
                                ),
                                Text(
                                  LocaleKeys.OR.tr(),
                                  style: TextStyle(
                                    color: Const.textColor,
                                    fontFamily: Const.poppinsRegular,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.withOpacity(0.5),
                                    thickness: 1,
                                    height: 1,
                                    indent: 15.0,
                                    // endIndent: 50.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight / 25),
                            //signup
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.If_you_are_new_user.tr(),
                                  style: TextStyle(
                                    color: Const.textColor,
                                    fontFamily: Const.poppinsMedium,
                                    fontSize: 12.0,
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.black12,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUp(),
                                        ));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => Login(),
                                    //     ));
                                  },
                                  child: Text(
                                    LocaleKeys.Signup.tr(),
                                    style: TextStyle(
                                      color: Const.primaryColor,
                                      fontFamily: Const.poppinsSemiBold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

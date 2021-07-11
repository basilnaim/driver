import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/screens/otp_check.dart';
import 'package:foodlans_driver/screens/verification_phone.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../all_constant.dart';
import 'homepage.dart';
import 'login.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _countryCode;
  bool _showSpinner = false;
  double screenHeight;
  double screenWidth;
  bool _obscureText = true;
  bool _conObscureText = true;
  TextEditingController _phone = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _conPassword = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode conPasswordFocus = FocusNode();
  final _scaffoldKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  double lat = 0;
  double long = 0;
  LocationData _locationData;
  Location _location = Location();

  @override
  void initState() {
    getLatLong();
    setDeviceToken();
    super.initState();
  }

  Future<void> getLatLong() async {
    _locationData = await _location.getLocation();
    setState(() {
      lat = _locationData.latitude;
      long = _locationData.longitude;
    });
    print(_locationData.latitude);
    print(_locationData.longitude);
    Prefs.setDouble(Const.latitude, _locationData.latitude);
    Prefs.setDouble(Const.longitude, _locationData.longitude);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _conToggle() {
    setState(() {
      _conObscureText = !_conObscureText;
    });
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return LocaleKeys.Enter_Valid_Email.tr();
    } else
      return null;
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return LocaleKeys.Please_enter_some_text.tr();
    } else if (4 > value.length) {
      return LocaleKeys.Enter_more_than_6_character.tr();
    }
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

  String validateConPassword(String value) {
    if (value.isEmpty) {
      return LocaleKeys.Password_is_empty.tr();
    } else if (value != _password.text) {
      return LocaleKeys.Confirm_Password_Does_Not_Match.tr();
    }
    return null;
  }

  void callApiSignUp() {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'name': _name.text,
      'email': _email.text,
      'phone': _phone.text,
      'phone_code': _countryCode,
      'password': _password.text,
      'password_confirmation': _conPassword.text,
      'lat': lat,
      'lang': long,
    };
    print(body);
    RestClient(Retro_Api().Dio_Data()).register(body).then((response) {
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
              builder: (context) => OtpScreen(userIdCheckOtp: response.data.id),
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

  Future<void> setDeviceToken() async {
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;
    print('device token is $playerId');
    Prefs.setString(Const.deviceToken, playerId);
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
                          //foodlance text
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
                                LocaleKeys.SIGN_UP.tr(),
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
                      height: screenHeight / 0.8,
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
                            //name
                            Text(
                              LocaleKeys.Name.tr(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: Const.poppinsMedium,
                                color: Const.textColor,
                              ),
                            ),
                            TextFormField(
                              controller: _name,
                              focusNode: nameFocus,
                              onFieldSubmitted: (a) {
                                nameFocus.unfocus();
                                FocusScope.of(context).requestFocus(emailFocus);
                              },
                              autovalidate: true,
                              validator: validateName,
                              maxLines: 1,
                              enableSuggestions: false,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                hintText: 'harry pearson',
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
                              focusNode: emailFocus,
                              onFieldSubmitted: (a) {
                                emailFocus.unfocus();
                                FocusScope.of(context).requestFocus(phoneFocus);
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
                            //phone
                            Text(
                              LocaleKeys.phone.tr(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: Const.poppinsMedium,
                                color: Const.textColor,
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(

                                  // borderRadius:
                                  //     BorderRadius.all(Radius.circular(35.0)),
                                  ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: CountryCodePicker(
                                      padding: EdgeInsets.zero,
                                      initialSelection: 'eg',
                                      showDropDownButton: true,
                                      onInit: (country) {
                                        _countryCode = country.dialCode;
                                      },
                                      onChanged: (countryCode) {
                                        _countryCode = countryCode.toString();
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth / 2,
                                    // color: Colors.red,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: _phone,
                                      autovalidate: true,
                                      validator: (String value) {
                                        String patttern =
                                            r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                        RegExp regExp = new RegExp(patttern);
                                        if (value.length > 10) {
                                          return LocaleKeys
                                              .Enter_Your_Phone_Number.tr();
                                        } else if (!regExp.hasMatch(value)) {
                                          return LocaleKeys
                                                  .Please_enter_valid_mobile_number
                                              .tr();
                                        }
                                        return null;
                                      },
                                      focusNode: phoneFocus,
                                      onFieldSubmitted: (a) {
                                        phoneFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(passwordFocus);
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        // border: InputBorder.none,
                                        hintText: 'Mobile Number',
                                        counterText: '',
                                        hintStyle: TextStyle(
                                          color: Const.hintColor,
                                          fontSize: 14,
                                          fontFamily: Const.poppinsMedium,
                                        ),
                                        labelStyle: TextStyle(
                                          color: Const.textColor,
                                          fontSize: 14,
                                          fontFamily: Const.poppinsMedium,
                                        ),
                                      ),
                                      maxLength: 10,
                                    ),
                                  ),
                                ],
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
                              autovalidateMode: AutovalidateMode.always,
                              controller: _password,
                              focusNode: passwordFocus,
                              onFieldSubmitted: (a) {
                                passwordFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(conPasswordFocus);
                              },
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
                            //confirm password
                            Text(
                              LocaleKeys.Confirm_Password.tr(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: Const.poppinsMedium,
                                color: Const.textColor,
                              ),
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              controller: _conPassword,
                              focusNode: conPasswordFocus,
                              onFieldSubmitted: (a) {
                                conPasswordFocus.unfocus();
                              },
                              validator: validateConPassword,
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
                                  icon: _conObscureText
                                      ? Icon(
                                          FontAwesomeIcons.eye,
                                          color: Const.hintColor,
                                        )
                                      : Icon(
                                          FontAwesomeIcons.eyeSlash,
                                          color: Const.hintColor,
                                        ),
                                  iconSize: 12,
                                  onPressed: _conToggle,
                                ),
                              ),
                              obscureText: _conObscureText,
                            ),
                            SizedBox(height: screenHeight / 36),
                            //signUP button
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.070,
                              margin: EdgeInsets.only(top: 36.0),
                              child: RaisedButton(
                                splashColor: Colors.black12,
                                color: Const.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    callApiSignUp();
                                  }
                                  print('signup');
                                },
                                child: Text(
                                  LocaleKeys.Signup.tr(),
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
                            SizedBox(height: screenHeight / 12),
                            //signup
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.Already_have_an_account.tr(),
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
                                          builder: (context) => Login(),
                                        ));
                                  },
                                  child: Text(
                                    LocaleKeys.Sign_in.tr(),
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
            )),
      ),
    );
  }
}

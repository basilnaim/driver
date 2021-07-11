import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/screens/otp_check.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import '../all_constant.dart';

class Verification extends StatefulWidget {
  final int userId;
  Verification({Key key, @required this.userId}) : super(key: key);
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String _countryCode;
  double screenHeight;
  double screenWidth;
  TextEditingController _phone = TextEditingController();
  FocusNode phoneFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _showSpinner = false;
  int previousUserId = 0;

  @override
  void initState() {
    previousUserId = widget.userId;
    super.initState();
  }

  void checkPhone() {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'id': previousUserId,
      'code': _countryCode,
      'phone': _phone.text,
    };
    print(body);
    RestClient(Retro_Api().Dio_Data()).verifyPhone(body).then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              userIdCheckOtp: previousUserId,
              previousPhone: _phone.text,
              previousCountyCode: _countryCode,
            ),
          ),
        );
        Const.showToast(response.msg);
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
            Const.showToast('Internal Server Error');
          }
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _formKey,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        progressIndicator: Const.customLoader,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: screenHeight,
            width: screenWidth,
            // color: Colors.red,
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
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'We have sent you an SMS with a code\nto your number',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: Const.poppinsRegular,
                              color: Const.hintColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFF4F7F9),
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: CountryCodePicker(
                                  padding: EdgeInsets.zero,
                                  initialSelection: 'IN',
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
                                width: screenWidth / 2.5,
                                // color: Colors.red,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _phone,
                                  validator: (String value) {
                                    String patttern =
                                        r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                    RegExp regExp = new RegExp(patttern);
                                    if (value.length > 10) {
                                      return 'Please enter mobile number';
                                    } else if (!regExp.hasMatch(value)) {
                                      return 'Please enter valid mobile number';
                                    }
                                    return null;
                                  },
                                  autofocus: true,
                                  focusNode: phoneFocus,
                                  onFieldSubmitted: (a) {
                                    phoneFocus.unfocus();
                                    checkPhone();
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none,
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
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.solidTimesCircle,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _phone.clear();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth,
                          height: screenHeight * 0.070,
                          margin: EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 20.0),
                          child: RaisedButton(
                            splashColor: Colors.black12,
                            color: Const.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                            onPressed: () {
                              checkPhone();
                              print('sign in');
                            },
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: Const.poppinsMedium,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
    );
  }
}

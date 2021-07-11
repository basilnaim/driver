import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/screens/homepage.dart';
import 'package:dio/dio.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../all_constant.dart';

class OtpScreen extends StatefulWidget {
  final int userIdCheckOtp;
  final String previousCountyCode, previousPhone;
  OtpScreen(
      {Key key,
      @required this.userIdCheckOtp,
      this.previousCountyCode,
      this.previousPhone})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _fullOtp = '';
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();
  TextEditingController _controller6 = TextEditingController();
  String _countryCode;
  double screenHeight;
  double screenWidth;
  final _formKey = GlobalKey<FormState>();
  bool _showSpinner = false;
  int checkUserId = 0;
  String previousCountyCode = '';
  String previousPhone = '';

  @override
  void initState() {
    checkUserId = widget.userIdCheckOtp;
    previousCountyCode = widget.previousCountyCode;
    previousPhone = widget.previousPhone;
    super.initState();
  }

  void resendOTP() {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'id': checkUserId,
      // 'code': previousCountyCode,
      // 'phone': previousPhone,
    };
    print(body);
    RestClient(Retro_Api().Dio_Data()).resendOTP(body).then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      Const.showToast(response.msg);
      // if (response.success) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomePage(),
      //     ),
      //   );
      // } else {
      //   Const.showToast(response.msg);
      // }
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

  void checkOTP() {
    setState(() {
      _showSpinner = true;
    });
    //TODO:implement dynamic otp with fullOtp
    Map<String, dynamic> body = {
      'id': checkUserId,
      // 'otp': 123456,
      'otp': _fullOtp,
      'phone': previousPhone,
    };
    print(body);
    RestClient(Retro_Api().Dio_Data()).checkOtp(body).then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
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
                            'Enter your OTP code here',
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        elevation: 5,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.all(20),
                        child: Container(
                          height: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextFormField(
                                    controller: _controller1,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    onChanged: (str) {
                                      if (str.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      } else {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextFormField(
                                    controller: _controller2,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    onChanged: (str) {
                                      if (str.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      } else {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextFormField(
                                    controller: _controller3,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    onChanged: (str) {
                                      if (str.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      } else {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextFormField(
                                    controller: _controller4,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    onChanged: (str) {
                                      if (str.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      } else {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextFormField(
                                    controller: _controller5,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    onChanged: (str) {
                                      if (str.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                      } else {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextFormField(
                                    controller: _controller6,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    onChanged: (str) {
                                      if (str.length == 1) {
                                        _fullOtp = _controller1.text +
                                            _controller2.text +
                                            _controller3.text +
                                            _controller4.text +
                                            _controller5.text +
                                            _controller6.text;
                                        print('otp is $_fullOtp');
                                        checkOTP();
                                        // FocusScope.of(context).nextFocus();
                                      } else {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            resendOTP();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => HomePage(),
                            //   ),
                            // );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              'Resend?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontFamily: Const.poppinsMedium,
                                fontSize: 14,
                                color: Const.textColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
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

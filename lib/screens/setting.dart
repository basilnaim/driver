import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foodlans_driver/all_constant.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/screens/homepage.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'custom_drawer.dart';
import 'custom_appbar.dart';
import 'package:dio/dio.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _showSpinner = false;
  double screenHeight;
  double screenWidth;
  bool callSwitch = false;
  bool notificationSwitch = false;
  bool locationSwitch = false;
  final _globalKey = GlobalKey<ScaffoldState>();
  String _phone = '';

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  void getProfileData() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).profile().then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        setState(() {
          _phone = '${response.data.phone}';
          if (response.data.enableCall == 1) {
            setState(() {
              callSwitch = true;
            });
          }
          if (response.data.enableNotification == 1) {
            setState(() {
              notificationSwitch = true;
            });
          }
          if (response.data.enableLocation == 1) {
            setState(() {
              locationSwitch = true;
            });
          }
        });
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

  void callChange() {
    int call;
    int notification;
    int location;
    if (callSwitch == true) {
      call = 1;
    } else {
      call = 0;
    }
    if (notificationSwitch == true) {
      notification = 1;
    } else {
      notification = 0;
    }
    if (locationSwitch == true) {
      location = 1;
    } else {
      location = 0;
    }
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'enable_call': call,
      'enable_notification': notification,
      'enable_location': location,
    };
    print(body);
    RestClient(Retro_Api().Dio_Data()).changeSetting(body).then((response) {
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
        setState(() {
          if (response.data.enableCall == 1) {
            setState(() {
              callSwitch = true;
            });
          }
          if (response.data.enableNotification == 1) {
            setState(() {
              notificationSwitch = true;
            });
          }
          if (response.data.enableLocation == 1) {
            setState(() {
              locationSwitch = true;
            });
          }
        });
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      progressIndicator: Const.customLoader,
      child: Scaffold(
        key: _globalKey,
        drawer: CustomDrawer(),
        appBar: PreferredSize(
          child: SafeArea(
            child: CustomAppbar(
              title: LocaleKeys.Setting.tr(),
              onMenuTap: () {
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
          preferredSize: Size(screenWidth, screenHeight),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.Phone_Number.tr(),
                    style: TextStyle(
                      fontFamily: Const.poppinsMedium,
                      color: Const.textColor,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    _phone,
                    style: TextStyle(
                      fontFamily: Const.poppinsMedium,
                      color: Const.textColor,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              MySeparator(
                height: 1,
                color: Colors.grey,
              ),
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: callSwitch,
                  title: Text(
                    LocaleKeys.Call.tr(),
                    style: TextStyle(
                      fontFamily: Const.poppinsMedium,
                      color: Const.textColor,
                      fontSize: 16.0,
                    ),
                  ),
                  activeColor: Const.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      callSwitch = value;
                    });
                  }),
              MySeparator(
                height: 1,
                color: Colors.grey,
              ),
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: notificationSwitch,
                  title: Text(
                    LocaleKeys.Notification.tr(),
                    style: TextStyle(
                      fontFamily: Const.poppinsMedium,
                      color: Const.textColor,
                      fontSize: 16.0,
                    ),
                  ),
                  activeColor: Const.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      notificationSwitch = value;
                    });
                  }),
              MySeparator(
                height: 1,
                color: Colors.grey,
              ),
              SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: locationSwitch,
                  title: Text(
                    LocaleKeys.Location.tr(),
                    style: TextStyle(
                      fontFamily: Const.poppinsMedium,
                      color: Const.textColor,
                      fontSize: 16.0,
                    ),
                  ),
                  activeColor: Const.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      locationSwitch = value;
                    });
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                
                  Text(
                    LocaleKeys.language.tr(),
                    style: TextStyle(
                      fontFamily: Const.poppinsMedium,
                      color: Const.textColor,
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20, right: 30),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            InkWell(
                              child: Text(LocaleKeys.arabic.tr()),
                              onTap: () {
                                EasyLocalization.of(context).locale =
                                    Locale('ar');
                              },
                            ),
                            InkWell(
                              child: Text(LocaleKeys.english.tr()),
                              onTap: () {
                                EasyLocalization.of(context).locale =
                                    Locale('en');
                              },
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 50.0,
          child: RaisedButton(
            color: Const.primaryColor,
            onPressed: () {
              callChange();
            },
            child: Text(
              'SAVE',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: Const.poppinsMedium,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

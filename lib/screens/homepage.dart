import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodlans_driver/all_constant.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/demo/new_demo.dart';
import 'package:foodlans_driver/screens/custom_drawer.dart';
import 'package:dio/dio.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'custom_appbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  final String homePage = '/HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSpinner = false;
  double screenHeight;
  double screenWidth;
  bool selectedRadio = false;
  DateTime currentBackPressTime;
  final _globalKey = GlobalKey<ScaffoldState>();
  int totalTrip = 0;
  String totalPrice = '0';
  int totalCancelTrip = 0;
  // double currentLatitude;
  // double currentLongitude;

  //google map
  LatLng _initialcameraposition =
      LatLng(Prefs.getDouble(Const.latitude), Prefs.getDouble(Const.latitude));
  GoogleMapController _controller;
  Location _location = Location();

  LocationData _locationData;

  @override
  void initState() {
    getTripInfo();
    getInfo();
    currentLocation();
    super.initState();
  }

  void getTripInfo() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).orderTrip().then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        print('${LocaleKeys.canceled.tr()} ${response.data.cancled}');
        print('${LocaleKeys.collected.tr()} ${response.data.collect}');
        print('${LocaleKeys.trip.tr()} ${response.data.trip}');
        setState(() {
          totalTrip = response.data.trip;
          totalPrice = response.data.collect.toString();
          totalCancelTrip = response.data.cancled;
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

  void getInfo() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).profile().then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        if (response.data.driverAvailable == 1) {
          setState(() {
            Prefs.setBool(Const.checkDriverStatus, true);
            selectedRadio = true;
          });
        } else {
          setState(() {
            Prefs.setBool(Const.checkDriverStatus, false);
            selectedRadio = false;
          });
        }
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

  void saveDriverLocation() {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'lat': '${_locationData.latitude}',
      'lang': '${_locationData.longitude}'
    };
    RestClient(Retro_Api().Dio_Data())
        .saveDriverLocation(body)
        .then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        print('savelocation');
        print(response.data.id);
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

  void changeDriverStatusOff() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).changeStatusOff().then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        Prefs.setBool(Const.checkDriverStatus, false);
        Const.showToast(LocaleKeys.Youre_offline_now.tr());
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

  void changeDriverStatusOn() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).changeStatusOn().then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        Prefs.setBool(Const.checkDriverStatus, true);
        Const.showToast(LocaleKeys.Youre_online_now.tr());
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

  // google map
  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  Future<void> currentLocation() async {
    _locationData = await _location.getLocation();
    setState(() {});
    saveDriverLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);
    Prefs.setDouble(Const.latitude, _locationData.latitude);
    Prefs.setDouble(Const.longitude, _locationData.longitude);
  }

  // exit
  @override
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Const.showToast(LocaleKeys.Press_again_to_exit.tr());
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: onWillPop,
      child: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        progressIndicator: Const.customLoader,
        child: Scaffold(
          key: _globalKey,
          drawer: CustomDrawer(),
          appBar: PreferredSize(
            child: SafeArea(
              child: CustomAppbarHome(
                title: LocaleKeys.Home.tr(),
                onMenuTap: () {
                  _globalKey.currentState.openDrawer();
                },
              ),
            ),
            preferredSize: Size(screenWidth, screenHeight),
          ),
          body: Container(
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
          ),
          bottomNavigationBar: Container(
            height: screenHeight / 5,
            width: screenWidth,
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => MyHomePage(),
                //         ));
                //   },
                // ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: selectedRadio,
                  activeColor: Const.primaryColor,
                  title: Text(
                    LocaleKeys.Today_Trip.tr(),
                    style: TextStyle(
                      color: Const.textColor,
                      fontFamily: Const.poppinsMedium,
                      fontSize: 18.0,
                    ),
                  ),
                  onChanged: (value) {
                    // print('bearer token is ${Prefs.getString(Const.headerToken)}');
                    value == false
                        ? changeDriverStatusOff()
                        : changeDriverStatusOn();
                    setState(() {
                      selectedRadio = value;
                    });
                  },
                ),
                MySeparator(
                  height: 1,
                  color: Colors.grey,
                ),
                SizedBox(height: 13.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/driver.png',
                        width: 55.0,
                        height: 55.0,
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$totalTrip ${LocaleKeys.Trips.tr()} '.tr(),
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: Const.poppinsMedium,
                                color: Const.textColor),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Const.hintColor,
                                size: 12.0,
                              ),
                              Text(
                                ' $totalCancelTrip  ${LocaleKeys.Cancel_Trips.tr()} ',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: Const.poppinsRegular,
                                  color: Const.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        '\$$totalPrice',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                          color: Const.primaryColor,
                        ),
                      ),
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

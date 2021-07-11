import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/screens/map_pin_pill.dart';
import 'package:foodlans_driver/screens/order_status.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../all_constant.dart';
import 'custom_drawer.dart';
import 'custom_appbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../models/pin_pill_info.dart';

class OrderDirection extends StatefulWidget {
  final String previousOrderNo;
  final int previousOrderId;
  const OrderDirection(
      {Key key, @required this.previousOrderNo, @required this.previousOrderId})
      : super(key: key);
  @override
  _OrderDirectionState createState() => _OrderDirectionState();
}

// Starting point latitude
double _originLatitude = Prefs.getDouble(Const.latitude);
// Starting point longitude
double _originLongitude = Prefs.getDouble(Const.longitude);
// Destination latitude
double _destLatitude = Prefs.getDouble(Const.destinationLatitude);
// Destination Longitude
double _destLongitude = Prefs.getDouble(Const.destinationLongitude);
// Markers to show points on the map
Map<MarkerId, Marker> markers = {};

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

// const double CAMERA_ZOOM = 16;
// const double CAMERA_TILT = 80;
// const double CAMERA_BEARING = 30;
//
// LatLng SOURCE_LOCATION =
//     LatLng(Prefs.getDouble(Const.latitude), Prefs.getDouble(Const.longitude));
// LatLng DEST_LOCATION = LatLng(Prefs.getDouble(Const.destinationLatitude),
//     Prefs.getDouble(Const.destinationLongitude));

class _OrderDirectionState extends State<OrderDirection> {
  TextEditingController _otp = TextEditingController();
  double screenHeight;
  double screenWidth;
  double updateDestinationLatitude;
  double updateDestinationLongitude;
  double passNextPageCurrentLatitude;
  double passNextPageCurrentLongitude;
  double passNextPageDestinationLatitude;
  double passNextPageDestinationLongitude;
  bool _showSpinner = false;
  bool _showSpinnerForModal = false;
  bool _showBottomContainer = false;
  bool isPickUpFood = false;
  bool isOnTheWay = false;
  bool isDriverReach = false;
  bool isDelivered = false;
  bool checkOfflinePayment = false;
  bool isOnlinePayment = false;
  String restaurantName = '',
      orderNumber = '',
      restaurantAddress = '',
      totalPrice = '',
      statusChangeButton = '';
  String checkDriverOtp = '';
  int driverStatus = 0;
  Timer timer;
  final _globalKey = GlobalKey<ScaffoldState>();
  LocationData _locationData;
  Location _location = Location();

  /*//for google map
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyDHvNc2AIRogHxsQvdd8jDC0T2kwLmGDZA';
// for my custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData currentLocation;
// a reference to the destination location
  LocationData destinationLocation;
// wrapper around the location API
  Location location;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      // pinPath: '',
      // avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation sourcePinInfo;
  PinInformation destinationPinInfo;*/

  // Google Maps controller
  Completer<GoogleMapController> _controller = Completer();
  // GoogleMapController _controllerNew;
  //for marker
  // BitmapDescriptor pinLocationIcon;
  // Set<Marker> _markers = {};
  // Configure map position and zoom
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(_originLatitude, _originLongitude),
    zoom: 15,
    bearing: 30,
  );

  @override
  void initState() {
    passNextPageDestinationLatitude = _destLatitude;
    passNextPageDestinationLongitude = _destLongitude;
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
    //         'assets/images/images/delivery_guy.png')
    //     .then((onValue) {
    //   pinLocationIcon = onValue;
    // });

    /*  create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();*/

    /// add origin marker origin(source) marker

    _addMarker(
      LatLng(_originLatitude, _originLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(_destLatitude, _destLongitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    // _location.onLocationChanged().listen((LocationData cLoc) {
    //   // cLoc contains the lat and long of the
    //   // current user's position in real time,
    //   // so we're holding on to it
    //   currentLocation = cLoc;
    //   updatePinOnMap();
    // });

    _getPolyline();
    getSingleOrderInfo();
    _currentLocationFunction();
    setState(() {
      timer = Timer.periodic(Duration(seconds: 60), (t) {
        _currentLocationFunction();
      });
    });

    super.initState();
  }

  /*void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/delivery_guy.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }*/

  Future<void> _currentLocationFunction() async {
    _locationData = await _location.getLocation();
    if (mounted) {
      setState(() {
        print(
            'originLatitude is $_originLatitude, originLongitude is $_originLongitude, destinationlatitude is $_destLatitude, destinationlongitude is $_destLongitude');
        _originLatitude = _locationData.latitude;
        _originLongitude = _locationData.longitude;
        passNextPageCurrentLatitude = _originLatitude;
        passNextPageCurrentLongitude = _originLongitude;
      });
    } else {
      setState(() {
        print(
            'originLatitude is $_originLatitude, originLongitude is $_originLongitude, destinationlatitude is $_destLatitude, destinationlongitude is $_destLongitude');
        _originLatitude = _locationData.latitude;
        _originLongitude = _locationData.longitude;
        passNextPageCurrentLatitude = _originLatitude;
        passNextPageCurrentLongitude = _originLongitude;
      });
    }

    //update marker
    // _addMarker(
    //   LatLng(_originLatitude, _originLongitude);
    //   "origin",
    //   BitmapDescriptor.defaultMarker,
    // );

    saveDriverLocation();
    _getPolyline();
    print(_locationData.latitude);
    print(_locationData.longitude);
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 4,
      color: Const.primaryColor,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    print(
        '_originLatitude $_originLatitude, _originLongitude $_originLongitude');

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDHvNc2AIRogHxsQvdd8jDC0T2kwLmGDZA",
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  void saveDriverLocation() {
    // setState(() {
    //   _showSpinner = true;
    // });
    Map<String, dynamic> body = {
      'lat': '${_locationData.latitude}',
      'lang': '${_locationData.longitude}'
    };
    RestClient(Retro_Api().Dio_Data())
        .saveDriverLocation(body)
        .then((response) {
      // setState(() {
      //   _showSpinner = false;
      // });
      print(response.success);
      if (response.success) {
        print('savelocation');
        print('login id is ${response.data.id}');
      }
    }).catchError((Object obj) {
      // setState(() {
      //   _showSpinner = false;
      // });
      switch (obj.runtimeType) {
        case DioError:
          // setState(() {
          //   _showSpinner = false;
          // });
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

  void getSingleOrderInfo() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data())
        .viewSingleOrderFood(widget.previousOrderId)
        .then((response) {
      print(response.success);
      if (response.success) {
        print('order id is ${response.data.id}');
        setState(() {
          _showSpinner = false;
          _showBottomContainer = true;

          restaurantName = response.data.shop.name;
          orderNumber = response.data.orderNo;
          restaurantAddress = response.data.shop.address;
          checkDriverOtp = response.data.driverOtp;
          totalPrice = response.data.payment.toString();
          updateDestinationLatitude = double.parse(response.data.customer.lat);
          updateDestinationLongitude =
              double.parse(response.data.customer.lang);
          passNextPageDestinationLatitude = updateDestinationLatitude;
          passNextPageDestinationLongitude = updateDestinationLongitude;
          if (response.data.orderStatus == 'DriverApproved') {
            driverStatus = 1;
            isPickUpFood = true;
            statusChangeButton = 'PICKUP FOOD';
          } else if (response.data.orderStatus == 'PickUpFood') {
            driverStatus = 2;
            isOnTheWay = true;
            statusChangeButton = 'COLLECT FOOD';
          } else if (response.data.orderStatus == 'OnTheWay') {
            driverStatus = 3;
            isOnTheWay = true;
            statusChangeButton = 'DRIVER REACH';
          } else if (response.data.orderStatus == 'DriverReach') {
            driverStatus = 5;
            isDriverReach = true;
            statusChangeButton = 'DELIVERED';
          } else if (response.data.orderStatus == 'Delivered') {
            driverStatus = 6;
            isDelivered = true;
            if (response.data.paymentType == 'Local') {
              statusChangeButton = 'PAYMENT COLLECTED';
              checkOfflinePayment = true;
            } else {
              isOnlinePayment = true;
              statusChangeButton = 'Done';
            }
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
            Const.showToast('Internal Server Error');
          }
          break;
        default:
      }
    });
  }

  void pickUpFoodFun() {
    showDialog(
      context: context,
      builder: (context) => ModalProgressHUD(
        inAsyncCall: _showSpinnerForModal,
        progressIndicator: Const.customLoader,
        child: Center(
          child: Container(
            height: screenHeight / 2.1,
            width: screenWidth / 1.2,
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: screenHeight / 26,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Enter Order OTP code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Const.primaryColor,
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        // height: 50,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000000).withOpacity(0.1),
                              offset: Offset(0, -1),
                              spreadRadius: 3,
                              blurRadius: 07.0,
                            )
                          ],
                        ),
                        child: TextFormField(
                          controller: _otp,
                          // ..text = 'driver-foodlands@saasmonks.in',
                          autovalidate: true,
                          maxLines: 1,
                          enableSuggestions: false,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 5.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Const.primaryColor),
                            ),
                            hintText: 'OTP',
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
                      ),
                    ],
                  ),
                  Container(
                    height: 50.0,
                    width: screenWidth / 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(5.0),
                        bottom: Radius.circular(5.0),
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Const.primaryColor,
                        onPrimary: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(5.0),
                            bottom: Radius.circular(5.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        checkOtp();
                      },
                      child: Text(
                        'Check OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: Const.poppinsMedium,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkOtp() {
    setState(() {
      _showSpinnerForModal = true;
    });
    Map<String, dynamic> body = {
      'order_id': widget.previousOrderId,
      'otp': _otp.text,
    };
    print('body of check otp is $body');
    RestClient(Retro_Api().Dio_Data())
        .pickupOrderCheckOtp(body)
        .then((response) {
      print(response.success);
      if (response.success) {
        print('order id is ${response.data.id}');
        setState(() {
          _showSpinnerForModal = false;
          Const.showToast('otp verified successfully');
          _destLatitude = updateDestinationLatitude;
          _destLongitude = updateDestinationLongitude;
          passNextPageDestinationLatitude = _destLatitude;
          passNextPageDestinationLongitude = _destLongitude;
          _addMarker(
            LatLng(_locationData.latitude, _locationData.longitude),
            "origin",
            BitmapDescriptor.defaultMarker,
          );

          // Add destination marker
          _addMarker(
            LatLng(_destLatitude, _destLongitude),
            "destination",
            BitmapDescriptor.defaultMarkerWithHue(90),
          );

          _getPolyline();

          isPickUpFood = false;
          isOnTheWay = true;
          _otp.clear();
          driverStatus = 3;
          Navigator.pop(context);
          var changeTheStatus = 'OnTheWay';
          onTheWayFun(changeTheStatus);
        });
      } else {
        Const.showToast(response.msg);
      }
    }).catchError((Object obj) {
      setState(() {
        _showSpinnerForModal = false;
      });
      switch (obj.runtimeType) {
        case DioError:
          setState(() {
            _showSpinnerForModal = false;
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

  void onTheWayFun(String status) {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'order_id': widget.previousOrderId,
      'status': status,
    };
    RestClient(Retro_Api().Dio_Data())
        .changeDriverStatus(body)
        .then((response) {
      print(response.success);
      if (response.success) {
        print('order id is ${response.data.id}');
        setState(() {
          driverStatus = 4;
          _showSpinner = false;
          Const.showToast(response.msg);
          statusChangeButton = 'DRIVER REACH';
          isOnTheWay = false;
          isDriverReach = true;
        });
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

  void driverReach(String status) {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'order_id': widget.previousOrderId,
      'status': status,
    };
    RestClient(Retro_Api().Dio_Data())
        .changeDriverStatus(body)
        .then((response) {
      print(response.success);
      if (response.success) {
        print('order id is ${response.data.id}');
        setState(() {
          driverStatus = 5;
          _showSpinner = false;
          Const.showToast(response.msg);
          statusChangeButton = 'DELIVERED';
          isDriverReach = false;
          isDelivered = true;
        });
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

  void delivered(String status) {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'order_id': widget.previousOrderId,
      'status': status,
    };
    RestClient(Retro_Api().Dio_Data())
        .changeDriverStatus(body)
        .then((response) {
      print(response.success);
      if (response.success) {
        print('order id is ${response.data.id}');
        setState(() {
          driverStatus = 6;
          _showSpinner = false;
          Const.showToast(response.msg);
          statusChangeButton = 'PAYMENT COLLECT';
          isDelivered = false;
          if (response.data.paymentType == 'Local') {
            statusChangeButton = 'PAYMENT COLLECT';
            checkOfflinePayment = true;
          } else {
            statusChangeButton = 'PAYMENT COLLECTED';
            Timer(Duration(seconds: 2), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/HomePage', (route) => false);
            });
            paymentCompleted(context);
          }
        });
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

  void foodPaymentCollected() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data())
        .foodPaymentCollected(widget.previousOrderId)
        .then((response) {
      print(response.success);
      if (response.success) {
        print('order id is ${response.data.id}');
        setState(() {
          _showSpinner = false;
          Const.showToast(response.msg);
          checkOfflinePayment = false;
          Timer(Duration(seconds: 2), () {
            markers.clear();
            polylines.clear();
            Navigator.pushNamedAndRemoveUntil(
                context, '/HomePage', (route) => false);
          });
          paymentCompleted(context);
        });
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

  void paymentCompleted(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          height: screenHeight / 2.3,
          width: screenWidth / 1.2,
          child: Card(
            color: Const.primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Image.asset(
                    'assets/images/payment_complete.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Your order is delivered\nyour payment has been collected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontFamily: Const.poppinsMedium,
                  ),
                ),
                Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5.0),
                      bottom: Radius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    'PAYMENT COLLECTED \$$totalPrice',
                    style: TextStyle(
                      color: Const.primaryColor,
                      fontFamily: Const.poppinsMedium,
                      fontSize: 18.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // CameraPosition initialCameraPosition = CameraPosition(
    //     zoom: CAMERA_ZOOM,
    //     tilt: CAMERA_TILT,
    //     bearing: CAMERA_BEARING,
    //     target: SOURCE_LOCATION);
    // if (currentLocation != null) {
    //   initialCameraPosition = CameraPosition(
    //       target: LatLng(currentLocation.latitude, currentLocation.longitude),
    //       zoom: CAMERA_ZOOM,
    //       tilt: CAMERA_TILT,
    //       bearing: CAMERA_BEARING);
    // }

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
              title: 'ORDER ${widget.previousOrderNo}',
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
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: true,
            markers: Set<Marker>.of(markers.values),
            // markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
            // polylines: _polylines,
            mapType: MapType.normal,
            // onTap: (LatLng loc) {
            //   pinPillPosition = -100;
            // },
            initialCameraPosition: _kGooglePlex,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            // markers: _markers,
            // onMapCreated: (GoogleMapController controller) {
            //   _controller.complete(controller);
            //   setState(() {
            //     _markers.add(Marker(
            //       markerId: MarkerId('<MARKER_ID>'),
            //       position: LatLng(_originLatitude, _originLongitude),
            //       icon: pinLocationIcon,
            //     ));
            //   });
            // },
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: _showBottomContainer,
          child: Container(
            height: screenHeight / 4,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -1),
                  spreadRadius: 5.0,
                  blurRadius: 10.0,
                )
              ],
              // borderRadius: BorderRadius.vertical(
              //   top: Radius.circular(20.0),
              // ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 6,
                  width: 66,
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Const.primaryColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        splashColor: Colors.black12,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderStatus(
                                checkStatus: driverStatus,
                                orderId: widget.previousOrderId,
                                // currentLat: passNextPageCurrentLatitude,
                                // currentLong: passNextPageCurrentLongitude,
                                // destinationLat: passNextPageDestinationLatitude,
                                // destinationLong:
                                //     passNextPageDestinationLongitude,
                                currentLat: passNextPageCurrentLatitude,
                                currentLong: passNextPageCurrentLongitude,
                                destinationLat: passNextPageDestinationLatitude,
                                destinationLong:
                                    passNextPageDestinationLongitude,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              restaurantName,
                              style: TextStyle(
                                color: Const.textColor,
                                fontFamily: Const.poppinsSemiBold,
                                fontSize: 16.0,
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.chevronRight,
                              color: Const.textColor,
                              size: 20.0,
                            )
                          ],
                        ),
                      ),
                      Text(
                        orderNumber,
                        style: TextStyle(
                          color: Const.hintColor,
                          fontFamily: Const.poppinsMedium,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        restaurantAddress,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Const.hintColor,
                          fontFamily: Const.poppinsMedium,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          splashColor: Colors.black12,
                          color: Const.primaryColor,
                          onPressed: () {
                            if (isPickUpFood == true) {
                              pickUpFoodFun();
                            } else if (isOnTheWay == true) {
                              var changeTheStatus = 'OnTheWay';
                              onTheWayFun(changeTheStatus);
                            } else if (isDriverReach == true) {
                              var changeTheStatus = 'DriverReach';
                              driverReach(changeTheStatus);
                            } else if (isDelivered == true) {
                              var changeTheStatus = 'Delivered';
                              delivered(changeTheStatus);
                            } else if (checkOfflinePayment == true) {
                              foodPaymentCollected();
                            } else if (isOnlinePayment == true) {
                              Timer(Duration(seconds: 2), () {
                                markers.clear();
                                polylines.clear();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/HomePage', (route) => false);
                              });
                              paymentCompleted(context);
                            }
                            print('order status');
                          },
                          child: Text(
                            statusChangeButton,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: Const.poppinsMedium,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
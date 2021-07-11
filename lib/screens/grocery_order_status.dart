import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:foodlans_driver/all_constant.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/view_singleorder_grocery.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_appbar.dart';
import 'custom_drawer.dart';
import 'grocery_order_details.dart';
import 'homepage.dart';

class GroceryOrderStatus extends StatefulWidget {
  final int checkStatus, orderId;
  final double currentLat, currentLong, destinationLat, destinationLong;

  GroceryOrderStatus({
    Key key,
    @required this.checkStatus,
    @required this.orderId,
    @required this.currentLat,
    @required this.currentLong,
    @required this.destinationLat,
    @required this.destinationLong,
  }) : super(key: key);
  @override
  _GroceryOrderStatusState createState() => _GroceryOrderStatusState();
}

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class _GroceryOrderStatusState extends State<GroceryOrderStatus> {
  double _originLatitude = 0.0;
  double _originLongitude = 0.0;
  double _destLatitude = 0.0;
  double _destLongitude = 0.0;
  // Markers to show points on the map
  Map<MarkerId, Marker> markers = {};
  double screenHeight;
  double screenWidth;
  int value = 6;
  final _globalKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  bool _showSpinner = false;

  bool orderConfirm = false;
  bool onTheWayToCollectOrder = false;
  bool foodCollected = false;
  bool foodOnTheWay = false;
  bool driverReach = false;
  bool delivered = false;
  String userCallInfo = '';

  String image = '';
  String userName = '';
  List<OrderItems> orderItem = [];
  double toPay = 0.0;

  //for map
  LocationData _locationData;
  Location _location = Location();

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    //for map
    _originLatitude = widget.currentLat;
    _originLongitude = widget.currentLong;
    _destLatitude = widget.destinationLat;
    _destLongitude = widget.destinationLong;
    // Markers to show points on the map
    Map<MarkerId, Marker> markers = {};

    /// add origin marker origin marker
    // setCustomMapPin();
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
    currentLocation();
    getSingleOrderInfo();
    checkStatusFunction();
    super.initState();
  }

  //for map
  Future<void> currentLocation() async {
    _locationData = await _location.getLocation();
    setState(() {
      print(
          'originLatitude is $_originLatitude, originLongitude is $_originLongitude, destinationlatitude is $_destLatitude, destinationlongitude is $_destLongitude');
      _originLatitude = _locationData.latitude;
      _originLongitude = _locationData.longitude;
    });

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
      setState(() {
        _showSpinner = false;
      });
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
            Const.showToast(LocaleKeys.Internal_Server_Error.tr());
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
        .viewSingleOrderGrocery(widget.orderId)
        .then((response) {
      print(response.success);
      if (response.success) {
        print('${LocaleKeys.order_id_is.tr()} ${response.data.id}');
        setState(() {
          _showSpinner = false;
          image = response.data.customer.completeImage;
          userName = response.data.customer.name;
          orderItem.addAll(response.data.orderItems);
          toPay = double.parse(response.data.payment.toString());
          userCallInfo = response.data.customer.phone;
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

  void checkStatusFunction() {
    if (widget.checkStatus == 1) {
      orderConfirm = true;
    } else if (widget.checkStatus == 2) {
      orderConfirm = true;
      onTheWayToCollectOrder = true;
    } else if (widget.checkStatus == 3) {
      orderConfirm = true;
      onTheWayToCollectOrder = true;
      foodCollected = true;
    } else if (widget.checkStatus == 4) {
      orderConfirm = true;
      onTheWayToCollectOrder = true;
      foodCollected = true;
      foodOnTheWay = true;
    } else if (widget.checkStatus == 5) {
      orderConfirm = true;
      onTheWayToCollectOrder = true;
      foodCollected = true;
      foodOnTheWay = true;
      driverReach = true;
    } else if (widget.checkStatus == 6) {
      orderConfirm = true;
      onTheWayToCollectOrder = true;
      foodCollected = true;
      foodOnTheWay = true;
      driverReach = true;
      delivered = true;
    }
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
                  LocaleKeys.Your_order_is_delivered.tr(),
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
                    'PAYMENT COLLECTED \$92',
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

  void customBottomSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: screenHeight / 1.8,
              width: screenWidth,
              padding: EdgeInsets.only(top: 15.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                children: [
                  Text(
                    LocaleKeys.Why_do_you_cancel_your_order.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Const.textColor,
                      fontFamily: Const.poppinsSemiBold,
                      fontSize: 20.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    child: MySeparator(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: screenHeight / 2.5,
                    width: screenWidth,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        List<String> cancelString = [
                          'Delivery is delay for heavy rain.',
                          'Customer cancel order.',
                          'Order delay for bike us Puncture.',
                          'Customer behavior not good.',
                          'Delivery another address.',
                          'Other',
                        ];
                        return Container(
                          height: 45.0,
                          child: RadioListTile(
                            activeColor: Const.primaryColor,
                            value: index,
                            groupValue: value,
                            onChanged: (ind) => setState(() {
                              Future.delayed(Duration(microseconds: 80000))
                                  .whenComplete(
                                () => Navigator.pop(context),
                              );
                              print(index);
                              return value = ind;
                            }),
                            title: Text(
                              cancelString[index],
                              style: TextStyle(
                                color: Const.hintColor,
                                fontSize: 14.0,
                                fontFamily: Const.poppinsRegular,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: 6,
                    ),
                  )
                ],
              ),
            );
          });
        });
    // _globalKey.currentState.showBottomSheet(
    //   (context) {
    //     return ;
    //   },
    // );
  }

  void cancelOrder(orderId) {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'order_id': orderId,
      'cancel_reason': 'other',
    };
    RestClient(Retro_Api().Dio_Data())
        .cancelGroceryOrder(body)
        .then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
              context, '/HomePage', (route) => false);
          Const.showToast(response.msg);
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

  Future<void> _makePhoneCall(String url) async {
    setState(() {
      _showSpinner = true;
    });
    if (await canLaunch(url)) {
      setState(() {
        _showSpinner = false;
      });
      await launch(url);
    } else {
      setState(() {
        _showSpinner = false;
      });
      throw 'Could not launch $url';
    }
  }

  //google map
  final LatLng _center =
      LatLng(Prefs.getDouble(Const.latitude), Prefs.getDouble(Const.latitude));

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(_originLatitude, _originLongitude),
      zoom: 15,
      bearing: 30,
    );
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
              title: 'ORDER #123658',
              onMenuTap: () {
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
          preferredSize: Size(screenWidth, screenHeight),
        ),
        body: Stack(
          children: [
            //map
            Container(
              height: screenHeight,
              width: screenWidth,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                polylines: Set<Polyline>.of(polylines.values),
                markers: Set<Marker>.of(markers.values),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            //view order
            Positioned(
              top: 30.0,
              right: .0,
              child: Container(
                height: 35,
                width: 130,
                child: RaisedButton(
                  splashColor: Colors.black12,
                  color: Const.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(25.0))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroceryOrderDetails(
                          previousId: widget.orderId,
                          checkPath: false,
                        ),
                      ),
                    );
                    print('view order');
                  },
                  child: Text(
                    LocaleKeys.VIEW_ORDER.tr(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: Const.poppinsMedium,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            //cancel order
            Positioned(
              top: 80.0,
              right: .0,
              child: Container(
                height: 35,
                width: 130,
                child: RaisedButton(
                  splashColor: Colors.black12,
                  color: Color(0xFFFC5759),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(25.0))),
                  onPressed: () {
                    // customBottomSheet();
                    cancelOrder(widget.orderId);
                    print('Cancel order');
                  },
                  child: Text(
                    LocaleKeys.Cancel_Order.tr(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: Const.poppinsMedium,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            //bottom container
            Positioned(
              bottom: .0,
              child: Column(
                children: [
                  //detailed container
                  Container(
                    height: screenHeight / 5.5,
                    width: screenWidth,
                    padding: EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87,
                          spreadRadius: 120.0,
                          offset: Offset(0, 160),
                          blurRadius: 80.0,
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //userimage
                            Container(
                              height: 60.0,
                              width: 60.0,
                              margin: EdgeInsets.only(left: 15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: image != null
                                    ? CachedNetworkImage(
                                        imageUrl: image,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            SpinKitFadingCircle(
                                                color: Const.primaryColor),
                                        errorWidget: (context, url, error) =>
                                            SpinKitFadingCircle(
                                                color: Const.primaryColor),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        // backgroundImage:
                                        //     AssetImage('assets/images/demo.jpg'),
                                        child: Container(),
                                      ),
                                // child: Image.asset(
                                //   'assets/images/demo.jpg',
                                //   height: 60.0,
                                //   width: 60.0,
                                //   fit: BoxFit.cover,
                                //   alignment: Alignment.center,
                                // ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //username
                                Text(
                                  '$userName',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: Const.poppinsMedium,
                                    color: Colors.white,
                                  ),
                                ),
                                //orders
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocaleKeys.Your_order.tr(),
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        fontFamily: Const.poppinsRegular,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: false,
                                        itemCount: orderItem.length > 2
                                            ? 2
                                            : orderItem.length,
                                        itemBuilder: (context, index) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${orderItem[index].itemName}',
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontFamily:
                                                      Const.poppinsRegular,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'x ${orderItem[index].quantity}',
                                              style: TextStyle(
                                                fontSize: 11.0,
                                                fontFamily:
                                                    Const.poppinsRegular,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5.0, top: 22.0),
                              child: Text(
                                '\$$toPay',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: Const.poppinsRegular,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // call
                        Positioned(
                          bottom: 10.0,
                          right: 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 35,
                                width: 110,
                                alignment: Alignment.bottomRight,
                                child: RaisedButton(
                                  splashColor: Colors.black12,
                                  color: Const.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(25.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    _makePhoneCall('tel:$userCallInfo');
                                    print('call');
                                  },
                                  child: Text(
                                    LocaleKeys.Call.tr(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: Const.poppinsMedium,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // timeline
                  Container(
                    color: Colors.white,
                    height: screenHeight / 2.8,
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Column(
                      children: [
                        //first
                        Container(
                          height: 35.0,
                          child: TimelineTile(
                            axis: TimelineAxis.vertical,
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            afterLineStyle: LineStyle(
                              color: orderConfirm == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            beforeLineStyle: LineStyle(
                              color: orderConfirm == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            indicatorStyle: IndicatorStyle(
                              color: orderConfirm == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              width: 12.0,
                              height: 12.0,
                            ),
                            isFirst: true,
                            endChild: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    LocaleKeys.Order_Confirmed.tr(),
                                    style: TextStyle(
                                      color: Const.textColor,
                                      fontFamily: Const.poppinsMedium,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //second
                        Container(
                          height: 35.0,
                          child: TimelineTile(
                            axis: TimelineAxis.vertical,
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            afterLineStyle: LineStyle(
                              color: onTheWayToCollectOrder == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            beforeLineStyle: LineStyle(
                              color: onTheWayToCollectOrder == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            indicatorStyle: IndicatorStyle(
                              color: onTheWayToCollectOrder == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              width: 12.0,
                              height: 12.0,
                            ),
                            endChild: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    LocaleKeys.On_the_way_to_pickup_your_food
                                        .tr(),
                                    style: TextStyle(
                                      color: Const.textColor,
                                      fontFamily: Const.poppinsMedium,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //third
                        Container(
                          height: 35.0,
                          child: TimelineTile(
                            axis: TimelineAxis.vertical,
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            afterLineStyle: LineStyle(
                              color: foodCollected == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            beforeLineStyle: LineStyle(
                              color: foodCollected == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            indicatorStyle: IndicatorStyle(
                              color: foodCollected == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              width: 12.0,
                              height: 12.0,
                            ),
                            endChild: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    LocaleKeys.Food_is_collected.tr(),
                                    style: TextStyle(
                                      color: Const.textColor,
                                      fontFamily: Const.poppinsMedium,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //fourth
                        Container(
                          height: 35.0,
                          child: TimelineTile(
                            axis: TimelineAxis.vertical,
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            afterLineStyle: LineStyle(
                              color: foodOnTheWay == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            beforeLineStyle: LineStyle(
                              color: foodOnTheWay == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            indicatorStyle: IndicatorStyle(
                              color: foodOnTheWay == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              width: 12.0,
                              height: 12.0,
                            ),
                            endChild: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    LocaleKeys.Food_is_On_the_way.tr(),
                                    style: TextStyle(
                                      color: Const.textColor,
                                      fontFamily: Const.poppinsMedium,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //fifth
                        Container(
                          height: 35.0,
                          child: TimelineTile(
                            axis: TimelineAxis.vertical,
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            afterLineStyle: LineStyle(
                              color: driverReach == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              // color: Colors.black,
                              thickness: 2,
                            ),
                            beforeLineStyle: LineStyle(
                              color: driverReach == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              // color: Colors.black,
                              thickness: 2,
                            ),
                            indicatorStyle: IndicatorStyle(
                              color: driverReach == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              width: 12.0,
                              height: 12.0,
                            ),
                            endChild: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    LocaleKeys.Reach_at_door_step.tr(),
                                    style: TextStyle(
                                      color: Const.textColor,
                                      fontFamily: Const.poppinsMedium,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //sixth
                        Container(
                          height: 35.0,
                          child: TimelineTile(
                            axis: TimelineAxis.vertical,
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            isLast: true,
                            afterLineStyle: LineStyle(
                              color: delivered == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            beforeLineStyle: LineStyle(
                              color: delivered == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              thickness: 2,
                            ),
                            indicatorStyle: IndicatorStyle(
                              color: delivered == true
                                  ? Const.primaryColor
                                  : Const.uncheckLineColor,
                              width: 12.0,
                              height: 12.0,
                            ),
                            endChild: Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    LocaleKeys.Delivered.tr(),
                                    style: TextStyle(
                                      color: Const.textColor,
                                      fontFamily: Const.poppinsMedium,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            //food collected
            // Positioned(
            //   bottom: 20.0,
            //   right: .0,
            //   child: Container(
            //     height: 35,
            //     width: 140,
            //     child: RaisedButton(
            //       splashColor: Colors.black12,
            //       color: Color(0xFF29335C),
            //       shape: RoundedRectangleBorder(
            //           borderRadius:
            //               BorderRadius.horizontal(left: Radius.circular(25.0))),
            //       onPressed: () {
            //         Timer(Duration(seconds: 2), () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => HomePage(),
            //             ),
            //           );
            //         });
            //
            //         //TODO:uncomment this
            //         paymentCompleted(context);
            //         print('Food collected');
            //       },
            //       child: Text(
            //         'Food Collected',
            //         style: TextStyle(
            //           fontSize: 14.0,
            //           fontFamily: Const.poppinsMedium,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

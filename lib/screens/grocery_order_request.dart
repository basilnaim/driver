import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/models/grocery_orders_request.dart';
import 'package:foodlans_driver/screens/grocery_order_details.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../all_constant.dart';
import 'custom_drawer.dart';
import 'custom_appbar.dart';
import 'grocery_order_direction.dart';
import 'package:easy_localization/easy_localization.dart';

class GroceryOrderRequest extends StatefulWidget {
  @override
  _GroceryOrderRequestState createState() => _GroceryOrderRequestState();
}

class _GroceryOrderRequestState extends State<GroceryOrderRequest> {
  double screenHeight;
  double screenWidth;
  final _globalKey = GlobalKey<ScaffoldState>();
  bool _showSpinner = false;
  bool canceled = false;
  bool collected = false;
  bool tripped = false;
  bool ordered = false;
  bool isDriverStatus = false;

  List<Requests> _groceryOrderRequest = [];
  List<Accepted> _groceryOrderAccept = [];

  @override
  void initState() {
    setState(() {
      isDriverStatus = Prefs.getBool(Const.checkDriverStatus);
    });
    getGroceryOrderRequest();
    super.initState();
  }

  Future<String> getRefreshData() async {
    setState(() {
      getGroceryOrderRequest();
    });
    return 'success';
  }

  Future<void> getGroceryOrderRequest() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).groceryOrderRequest().then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        /*DriverApproved ( if driver accept )
          Prepare ( After DriverApproved , when food is prepare )
          DriverAtShop ( After Prepare status )
          PickUpFood ( After DriverAtShop )
          OnTheWay ( After PickUpFood)
          DriverReach ( After OnTheWay )
          Delivered ( After DriverReach )
          Cancel ( If driver Cancel )
          */
        // print('canceled ${response.data.cancled}');
        // print('collected ${response.data.collect}');
        // print('trip ${response.data.trip}');
        _groceryOrderRequest.clear();
        _groceryOrderAccept.clear();
        setState(() {
          _groceryOrderRequest.addAll(response.data.requests);
          _groceryOrderAccept.addAll(response.data.accepted);
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

  void checkStatus(int previousOrderId, String orderNumber) {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data())
        .viewSingleOrderGrocery(previousOrderId)
        .then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        //for next page
        Prefs.setDouble(Const.destinationLatitude,
            double.parse(response.data.shop.latitude));
        Prefs.setDouble(Const.destinationLongitude,
            double.parse(response.data.shop.longitude));

        print('${LocaleKeys.order_id_is.tr()} ${response.data.id}');
        setState(() {
          if (response.data.orderStatus == 'Approved') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroceryOrderDetails(
                  previousId: previousOrderId,
                  checkPath: true,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'DriverApproved') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroceryOrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'PickUpGrocery') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroceryOrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'OutOfDelivery') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroceryOrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'DriverReach') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroceryOrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'Delivered') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroceryOrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
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

  // void cancelOrder(orderId) {
  //   setState(() {
  //     _showSpinner = true;
  //   });
  //   Map<String, dynamic> body = {
  //     'order_id': orderId,
  //     'cancel_reason': 'other',
  //   };
  //   RestClient(Retro_Api().Dio_Data()).cancelOrder(body).then((response) {
  //     setState(() {
  //       _showSpinner = false;
  //     });
  //     print(response.success);
  //     if (response.success) {
  //       setState(() {
  //         Const.showToast(response.msg);
  //       });
  //       getGroceryOrderRequest();
  //     }
  //   }).catchError((Object obj) {
  //     setState(() {
  //       _showSpinner = false;
  //     });
  //     switch (obj.runtimeType) {
  //       case DioError:
  //         setState(() {
  //           _showSpinner = false;
  //         });
  //         // Here's the sample to get the failed response error code and message
  //         final res = (obj as DioError).response;
  //         var msg = res.statusMessage;
  //         var responseCode = res.statusCode;
  //         if (responseCode == 401) {
  //           Const.showToast(res.statusMessage);
  //           print(responseCode);
  //           print(res.statusMessage);
  //         } else if (responseCode == 422) {
  //           print("code:$responseCode");
  //           print("msg:$msg");
  //           Const.showToast("code:$responseCode");
  //         } else if (responseCode == 500) {
  //           print("code:$responseCode");
  //           print("msg:$msg");
  //           Const.showToast('Internal Server Error');
  //         }
  //         break;
  //       default:
  //     }
  //   });
  // }

  void rejectGroceryOrder(orderId) {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data())
        .rejectGroceryOrder(orderId)
        .then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        setState(() {
          Const.showToast(LocaleKeys.Order_Rejected_Successfully.tr());
        });
        getGroceryOrderRequest();
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
        backgroundColor: Color(0xFFF4F7F9),
        drawer: CustomDrawer(),
        appBar: PreferredSize(
          child: SafeArea(
            child: CustomAppbar(
              title: LocaleKeys.GROCERY_ORDER_REQUEST.tr(),
              onMenuTap: () {
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
          preferredSize: Size(screenWidth, screenHeight),
        ),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () {
            return getRefreshData();
          },
          child: isDriverStatus == true
              ? SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: _groceryOrderRequest.length > 0 ||
                          _groceryOrderAccept.length > 0
                      ? Column(
                          children: [
                            //accepted
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _groceryOrderAccept.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.all(5),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //shopname and price
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                // _orderShop[index].name,
                                                _groceryOrderAccept[index]
                                                    .shop
                                                    .name,
                                                style: TextStyle(
                                                  color: Const.textColor,
                                                  fontSize: 18.0,
                                                  fontFamily:
                                                      Const.poppinsSemiBold,
                                                ),
                                              ),
                                              Text(
                                                '\$${_groceryOrderAccept[index].payment}',
                                                style: TextStyle(
                                                  color: Const.primaryColor,
                                                  fontSize: 18.0,
                                                  fontFamily:
                                                      Const.poppinsMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //orderid
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            '${LocaleKeys.Order_Id_No.tr()} : ${_groceryOrderAccept[index].orderNo}',
                                            style: TextStyle(
                                              color: Const.hintColor,
                                              fontSize: 14.0,
                                              fontFamily: Const.poppinsMedium,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: MySeparator(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            LocaleKeys.Pickup_Address.tr(),
                                            style: TextStyle(
                                              color: Const.textColor,
                                              fontSize: 18.0,
                                              fontFamily: Const.poppinsSemiBold,
                                            ),
                                          ),
                                        ),
                                        //pickup address
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            _groceryOrderAccept[index]
                                                .shop
                                                .address,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Const.hintColor,
                                              fontSize: 14.0,
                                              fontFamily: Const.poppinsRegular,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            LocaleKeys.Delivery_Address.tr(),
                                            style: TextStyle(
                                              color: Const.textColor,
                                              fontSize: 18.0,
                                              fontFamily: Const.poppinsSemiBold,
                                            ),
                                          ),
                                        ),
                                        //delivery address
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            '${_groceryOrderAccept[index].deliveryAddress.addressType}, ${_groceryOrderAccept[index].deliveryAddress.socName}, ${_groceryOrderAccept[index].deliveryAddress.street}, ${_groceryOrderAccept[index].deliveryAddress.city}, ${_groceryOrderAccept[index].deliveryAddress.zipcode}.',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Const.hintColor,
                                              fontSize: 14.0,
                                              fontFamily: Const.poppinsRegular,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30.0),
                                        //buttons
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: screenHeight * 0.055,
                                                width: screenWidth * 0.3,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Const.primaryColor,
                                                    onPrimary: Colors.black12,
                                                    elevation: 3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(25.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    checkStatus(
                                                        _groceryOrderAccept[
                                                                index]
                                                            .id,
                                                        _groceryOrderAccept[
                                                                index]
                                                            .orderNo);
                                                    print('Accepted');
                                                  },
                                                  child: Text(
                                                    LocaleKeys.ACCEPTED.tr(),
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                          Const.poppinsMedium,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: screenHeight * 0.055,
                                                width: screenWidth * 0.3,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Const.primaryColor,
                                                    onPrimary: Colors.black12,
                                                    elevation: 3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                        left: Radius.circular(
                                                            25.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            GroceryOrderDetails(
                                                          previousId:
                                                              _groceryOrderAccept[
                                                                      index]
                                                                  .id,
                                                          checkPath: false,
                                                        ),
                                                      ),
                                                    );
                                                    print('order detail');
                                                  },
                                                  child: Text(
                                                    LocaleKeys.ORDER_DETAIL
                                                        .tr(),
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily:
                                                          Const.poppinsMedium,
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
                                );
                              },
                            ),
                            SizedBox(height: 15.0),
                            //request
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _groceryOrderRequest.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.all(5),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //shopname and price
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                // _orderShop[index].name,
                                                _groceryOrderRequest[index]
                                                    .shop
                                                    .name,
                                                style: TextStyle(
                                                  color: Const.textColor,
                                                  fontSize: 18.0,
                                                  fontFamily:
                                                      Const.poppinsSemiBold,
                                                ),
                                              ),
                                              Text(
                                                '\$${_groceryOrderRequest[index].payment}',
                                                style: TextStyle(
                                                  color: Const.primaryColor,
                                                  fontSize: 18.0,
                                                  fontFamily:
                                                      Const.poppinsMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //orderid
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            '${LocaleKeys.Order_Id_No.tr()} : ${_groceryOrderRequest[index].orderNo}',
                                            style: TextStyle(
                                              color: Const.hintColor,
                                              fontSize: 14.0,
                                              fontFamily: Const.poppinsMedium,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: MySeparator(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            LocaleKeys.Pickup_Address.tr(),
                                            style: TextStyle(
                                              color: Const.textColor,
                                              fontSize: 18.0,
                                              fontFamily: Const.poppinsSemiBold,
                                            ),
                                          ),
                                        ),
                                        //pickup address
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            _groceryOrderRequest[index]
                                                .shop
                                                .address,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Const.hintColor,
                                              fontSize: 14.0,
                                              fontFamily: Const.poppinsRegular,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            LocaleKeys.Delivery_Address.tr(),
                                            style: TextStyle(
                                              color: Const.textColor,
                                              fontSize: 18.0,
                                              fontFamily: Const.poppinsSemiBold,
                                            ),
                                          ),
                                        ),
                                        //delivery address
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            '${_groceryOrderRequest[index].deliveryAddress.addressType}, ${_groceryOrderRequest[index].deliveryAddress.socName}, ${_groceryOrderRequest[index].deliveryAddress.street}, ${_groceryOrderRequest[index].deliveryAddress.city}, ${_groceryOrderRequest[index].deliveryAddress.zipcode}.',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Const.hintColor,
                                              fontSize: 14.0,
                                              fontFamily: Const.poppinsRegular,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30.0),
                                        //buttons
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: screenHeight * 0.055,
                                                width: screenWidth * 0.3,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Const.primaryColor,
                                                    onPrimary: Colors.black12,
                                                    elevation: 3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(25.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) => OrderDirection(),
                                                    //   ),
                                                    // );
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            GroceryOrderDetails(
                                                          previousId:
                                                              _groceryOrderRequest[
                                                                      index]
                                                                  .id,
                                                          checkPath: true,
                                                        ),
                                                      ),
                                                    );
                                                    print('Accepted');
                                                  },
                                                  child: Text(
                                                    LocaleKeys.ACCEPTED.tr(),
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                          Const.poppinsMedium,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: screenHeight * 0.055,
                                                width: screenWidth * 0.3,
                                                // color: Colors.black,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // minimumSize: Size(screenWidth * 0.0100,
                                                    //     screenHeight * 0.050),
                                                    primary:
                                                        Const.redButtonColor,
                                                    onPrimary: Colors.black12,
                                                    elevation: 3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(25.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    rejectGroceryOrder(
                                                        _groceryOrderRequest[
                                                                index]
                                                            .id);
                                                    print(LocaleKeys
                                                        .ORDER_DETAIL
                                                        .tr());
                                                  },
                                                  child: Text(
                                                    LocaleKeys.Reject.tr(),
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                          Const.poppinsMedium,
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
                                );
                              },
                            ),
                          ],
                        )
                      : Container(
                          height: screenHeight,
                          width: screenWidth,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Image.asset(
                            'assets/images/data_not_found.png',
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                          ),
                          // child: Text(
                          //   style: TextStyle(
                          //     color: Const.hintColor,
                          //     fontSize: 20,
                          //   ),
                          // ),
                        ),
                )
              : Container(
                  height: screenHeight,
                  width: screenWidth,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text(
                    LocaleKeys.Youre_offline_now.tr(),
                    style: TextStyle(
                      color: Const.hintColor,
                      fontSize: 20,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

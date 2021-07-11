import 'package:flutter/material.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/models/order_request.dart';
import 'package:foodlans_driver/screens/custom_drawer.dart';
import 'package:foodlans_driver/screens/order_detail.dart';
import 'package:foodlans_driver/screens/order_direction.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import '../all_constant.dart';
import 'custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderRequest extends StatefulWidget {
  @override
  _OrderRequestState createState() => _OrderRequestState();
}

class _OrderRequestState extends State<OrderRequest> {
  double screenHeight;
  double screenWidth;
  final _globalKey = GlobalKey<ScaffoldState>();
  bool _showSpinner = false;
  bool canceled = false;
  bool collected = false;
  bool tripped = false;
  bool ordered = false;
  bool isDriverStatus = false;

  List<Requests> _orderRequest = [];
  List<Accepted> _orderAccept = [];

  @override
  void initState() {
    setState(() {
      isDriverStatus = Prefs.getBool(Const.checkDriverStatus);
    });
    getOrderRequest();
    super.initState();
  }

  Future<String> getRefreshData() async {
    setState(() {
      getOrderRequest();
    });
    return 'success';
  }

  Future<void> getOrderRequest() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).orderRequest().then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        _orderRequest.clear();
        _orderAccept.clear();
        setState(() {
          _orderRequest.addAll(response.data.requests);
          _orderAccept.addAll(response.data.accepted);
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

  void checkStatus(int previousOrderId, String orderNumber) {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data())
        .viewSingleOrderFood(previousOrderId)
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

        print('order id is ${response.data.id}');
        setState(() {
          if (response.data.orderStatus == 'Approved') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetails(
                  previousId: previousOrderId,
                  checkPath: true,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'DriverApproved') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'PickUpFood') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'OnTheWay') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'DriverReach') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDirection(
                  previousOrderNo: orderNumber,
                  previousOrderId: previousOrderId,
                ),
              ),
            );
          } else if (response.data.orderStatus == 'Delivered') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDirection(
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
            Const.showToast('Internal Server Error');
          }
          break;
        default:
      }
    });
  }

  void rejectOrder(orderId) {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).rejectOrder(orderId).then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        setState(() {
          Const.showToast(LocaleKeys.Order_Rejected_Successfully.tr());
        });
        getOrderRequest();
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
              title: LocaleKeys.FOOD_ORDER_REQUEST.tr(),
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
                  child: _orderRequest.length > 0 || _orderAccept.length > 0
                      ? Column(
                          children: [
                            //accepted
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _orderAccept.length,
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
                                                _orderAccept[index].shop.name,
                                                style: TextStyle(
                                                  color: Const.textColor,
                                                  fontSize: 18.0,
                                                  fontFamily:
                                                      Const.poppinsSemiBold,
                                                ),
                                              ),
                                              Text(
                                                '\$${_orderAccept[index].payment}',
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
                                            '${LocaleKeys.Order_Id_No.tr()} : ${_orderAccept[index].orderNo}',
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
                                            _orderAccept[index].shop.address,
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
                                            '${_orderAccept[index].deliveryAddress.addressType}, ${_orderAccept[index].deliveryAddress.socName}, ${_orderAccept[index].deliveryAddress.street}, ${_orderAccept[index].deliveryAddress.city}, ${_orderAccept[index].deliveryAddress.zipcode}.',
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
                                                        _orderAccept[index].id,
                                                        _orderAccept[index]
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
                                                            OrderDetails(
                                                          previousId:
                                                              _orderAccept[
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
                              itemCount: _orderRequest.length,
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
                                                _orderRequest[index].shop.name,
                                                style: TextStyle(
                                                  color: Const.textColor,
                                                  fontSize: 18.0,
                                                  fontFamily:
                                                      Const.poppinsSemiBold,
                                                ),
                                              ),
                                              Text(
                                                '\$${_orderRequest[index].payment}',
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
                                            '${LocaleKeys.Order_Id_No.tr()} : ${_orderRequest[index].orderNo}',
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
                                            _orderRequest[index].shop.address,
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
                                            '${_orderRequest[index].deliveryAddress.addressType}, ${_orderRequest[index].deliveryAddress.socName}, ${_orderRequest[index].deliveryAddress.street}, ${_orderRequest[index].deliveryAddress.city}, ${_orderRequest[index].deliveryAddress.zipcode}.',
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
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderDetails(
                                                          previousId:
                                                              _orderRequest[
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
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
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
                                                    rejectOrder(
                                                        _orderRequest[index]
                                                            .id);
                                                    print('order detail');
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

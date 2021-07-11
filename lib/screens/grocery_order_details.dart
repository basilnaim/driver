import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/models/view_singleorder_grocery.dart';
import 'package:foodlans_driver/all_constant.dart';
import 'package:dio/dio.dart';
import 'package:foodlans_driver/screens/grocery_order_direction.dart';
import 'package:foodlans_driver/screens/grocery_order_request.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';

import 'custom_drawer.dart';
import 'custom_appbar.dart';

class GroceryOrderDetails extends StatefulWidget {
  final int previousId;
  final bool checkPath;

  const GroceryOrderDetails(
      {Key key, @required this.previousId, @required this.checkPath})
      : super(key: key);
  @override
  _GroceryOrderDetailsState createState() => _GroceryOrderDetailsState();
}

class _GroceryOrderDetailsState extends State<GroceryOrderDetails> {
  double screenHeight;
  double screenWidth;
  String image = '';
  bool _showSpinner = false;
  int previousOrderId;
  String shopName = '';
  String shopAdd = '';
  String orderNumber = '';
  String paymentMode = '';
  double itemTotal = 0.0;
  // double restaurantCharge = 0.0;
  double totalDiscount = 0.0;
  double deliveryFee = 0.0;
  // double cancellationCharge = 0.0;
  double toPay = 0.0;
  List<OrderItems> orderItem = [];
  final _globalKey = GlobalKey<ScaffoldState>();
  bool checkPath;
  ViewGroceryOrderData viewSingleGroceryOrderData;

  @override
  void initState() {
    previousOrderId = widget.previousId;
    checkPath = widget.checkPath;
    getSingleOrderInfo();
    super.initState();
  }

  void getSingleOrderInfo() {
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
        print(' ${LocaleKeys.order_id_is.tr()} ${response.data.id}');
        setState(() {
          viewSingleGroceryOrderData = response.data;
          image = response.data.shop.completeImage;
          shopName = response.data.shop.name;
          shopAdd = response.data.shop.address;
          orderItem.addAll(response.data.orderItems);
          orderNumber = response.data.orderNo;
          // restaurantCharge =
          //     double.parse(response.data.shop.rastaurantCharge.toString());
          totalDiscount = double.parse(response.data.couponPrice.toString());
          if (response.data.orderItems.length > 0) {
            double calculation = 0;
            for (int i = 0; i < response.data.orderItems.length; i++) {
              calculation +=
                  double.parse(response.data.orderItems[i].price.toString());
            }
            itemTotal = calculation;
          } else {
            Const.showToast(LocaleKeys.Error_white_getting_Order_Details.tr());
            Navigator.pop(context);
          }
          deliveryFee =
              double.parse(response.data.shop.deliveryCharge.toString());
          // cancellationCharge =
          //     double.parse(response.data.shop.cancleCharge.toString());
          toPay = double.parse(response.data.payment.toString());
          paymentMode = response.data.paymentType;

          //for polyline next page
          Prefs.setDouble(Const.destinationLatitude,
              double.parse(response.data.shop.latitude));
          Prefs.setDouble(Const.destinationLongitude,
              double.parse(response.data.shop.longitude));
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

  void orderAccept() {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {'order_id': previousOrderId};
    RestClient(Retro_Api().Dio_Data())
        .acceptGroceryOrder(body)
        .then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        setState(() {
          Const.showToast(response.msg);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GroceryOrderDirection(
                previousOrderNo: orderNumber,
                previousOrderId: previousOrderId,
              ),
            ),
          );
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
  //         Navigator.pop(context);
  //         Const.showToast(response.msg);
  //       });
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GroceryOrderRequest(),
            ));
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
              title: LocaleKeys.ORDER_DETAIL.tr(),
              onMenuTap: () {
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
          preferredSize: Size(screenWidth, screenHeight),
        ),
        body: Visibility(
          visible: viewSingleGroceryOrderData != null,
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: image != null
                                  ? CachedNetworkImage(
                                      imageUrl: image,
                                      imageBuilder: (context, imageProvider) =>
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
                            ),
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(5.0),
                            //   child: Image.asset(
                            //     'assets/images/pizza.jpg',
                            //     width: 56,
                            //     height: 56,
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            SizedBox(width: 10.0),
                            //shopname
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shopName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Const.textColor,
                                    fontSize: 14.0,
                                    fontFamily: Const.poppinsMedium,
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.05,
                                  width: screenWidth / 1.4,
                                  // color: Colors.red,
                                  child: Text(
                                    shopAdd,
                                    maxLines: 2,
                                    // softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Const.hintColor,
                                      fontSize: 10.0,
                                      fontFamily: Const.poppinsRegular,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        //all items
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderItem.length,
                          itemBuilder: (context, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //item names
                              Text(
                                // () {
                                //   if (orderItem[index].itemName != null &&
                                //       orderItem[index].itemName != '') {
                                //     return '${orderItem[index].itemName}';
                                //   } else if (orderItem[index].packageName !=
                                //           null &&
                                //       orderItem[index].packageName != '') {
                                //     return '${orderItem[index].packageName}';
                                //   }
                                // }(),
                                orderItem[index].itemName != null &&
                                        orderItem[index].itemName != ''
                                    ? orderItem[index].itemName
                                    : LocaleKeys.Something_went_wrong.tr(),
                                style: TextStyle(
                                  color: Const.textColor,
                                  fontSize: 12.0,
                                  fontFamily: Const.poppinsMedium,
                                ),
                              ),
                              Text(
                                '\$${orderItem[index].price}',
                                style: TextStyle(
                                  color: Const.primaryColor,
                                  fontSize: 12.0,
                                  fontFamily: Const.poppinsMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        // Container(
                        //   margin: EdgeInsets.symmetric(vertical: 15.0),
                        //   child: MySeparator(
                        //     height: 1,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                        // Row(
                        //   children: [
                        //     SvgPicture.asset('assets/icons/discount.svg'),
                        //     SizedBox(width: 5.0),
                        //     Text(
                        //       'APPLY COUPON',
                        //       style: TextStyle(
                        //         color: Const.textColor,
                        //         fontSize: 12.0,
                        //         fontFamily: Const.poppinsMedium,
                        //       ),
                        //     ),
                        //     Spacer(),
                        //     Icon(
                        //       FontAwesomeIcons.chevronRight,
                        //       color: Const.hintColor,
                        //       size: 20.0,
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10.0),
                        Text(
                          LocaleKeys.Bill_Details.tr(),
                          style: TextStyle(
                            color: Const.textColor,
                            fontSize: 12.0,
                            fontFamily: Const.poppinsMedium,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.Item_Total.tr(),
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            Text(
                              '\$$itemTotal',
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.Restaurant_Charges.tr(),
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            // Text(
                            //   '\$$restaurantCharge',
                            //   style: TextStyle(
                            //     color: Const.textColor,
                            //     fontSize: 10.0,
                            //     fontFamily: Const.poppinsMedium,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Discount',
                              style: TextStyle(
                                color: Const.primaryColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            Text(
                              '-\$$totalDiscount',
                              style: TextStyle(
                                color: Const.primaryColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          child: MySeparator(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.Delivery_Fee.tr(),
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            Text(
                              '\$$deliveryFee',
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.Cancellation_Fee.tr(),
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            // Text(
                            //   '\$$cancellationCharge',
                            //   style: TextStyle(
                            //     color: Const.textColor,
                            //     fontSize: 10.0,
                            //     fontFamily: Const.poppinsMedium,
                            //   ),
                            // ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          child: MySeparator(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.To_Pay.tr(),
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            Text(
                              '\$$toPay',
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.Payment_Method.tr(),
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            Text(
                              '$paymentMode',
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: viewSingleGroceryOrderData != null,
          child: Visibility(
            visible: checkPath,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      splashColor: Colors.black12,
                      color: Const.primaryColor,
                      onPressed: () {
                        orderAccept();
                        print('ACCEPTED');
                      },
                      child: Text(
                        LocaleKeys.ACCEPTED.tr(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      splashColor: Colors.black12,
                      color: Color(0xFFFC5759),
                      onPressed: () {
                        // cancelOrder(widget.previousId);
                        rejectGroceryOrder(widget.previousId);
                        print('Reject');
                      },
                      child: Text(
                        LocaleKeys.Reject.tr(),
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
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/models/review_modal.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../all_constant.dart';
import 'custom_drawer.dart';
import 'custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  double screenHeight;
  double screenWidth;
  String image = '';
  bool _showSpinner = false;
  final _globalKey = GlobalKey<ScaffoldState>();
  List<Food> foodList = [];
  List<Grocery> groceryList = [];

  @override
  void initState() {
    getReviewInfo();
    super.initState();
  }

  void getReviewInfo() {
    setState(() {
      _showSpinner = true;
    });
    RestClient(Retro_Api().Dio_Data()).review().then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        foodList.addAll(response.data.food);
        groceryList.addAll(response.data.grocery);
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
              title: LocaleKeys.Review.tr(),
              onMenuTap: () {
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
          preferredSize: Size(screenWidth, screenHeight),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              foodList.length > 0
                  ? Container(
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: foodList.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 20.0,
                          child: MySeparator(
                            height: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80)),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  // child: CircleAvatar(
                                  //   backgroundImage: AssetImage(
                                  //     'assets/images/demo.jpg',
                                  //   ),
                                  // ),
                                  child: CircleAvatar(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: CachedNetworkImage(
                                          imageUrl: foodList[index]
                                              .customer
                                              .completeImage,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              SpinKitFadingCircle(
                                                  color: Const.primaryColor),
                                          errorWidget: (context, url, error) =>
                                              SpinKitFadingCircle(
                                                  color: Const.primaryColor),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              foodList[index].customer.name,
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 16.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingBar(
                                  ignoreGestures: true,
                                  // initialRating: 4,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: int.parse(
                                      foodList[index].rate.toString()),
                                  itemSize: 15.0,
                                  maxRating: 5,
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      color: Color(0xFFFEC92B),
                                    ),
                                    half: Icon(
                                      Icons.star_half,
                                      color: Color(0xFFFEC92B),
                                    ),
                                    empty: Icon(
                                      Icons.star,
                                      color: Color(0xFFFEC92B),
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                Text(
                                  foodList[index].message,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Const.hintColor,
                                    fontSize: 14.0,
                                    fontFamily: Const.poppinsRegular,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              () {
                                DateFormat dateFormatOld =
                                    DateFormat("yyyy-MM-dd");
                                DateTime dateTimeStartTime = dateFormatOld
                                    .parse(foodList[index].createdAt);
                                DateFormat dateFormat =
                                    DateFormat("dd-MMM-yyyy");
                                final String formatted =
                                    dateFormat.format(dateTimeStartTime);
                                // print(formatted); // something like 2013-04-20
                                return formatted;
                                // return formatted +' at ${foodList[index].time}';
                              }(),
                              style: TextStyle(
                                color: Const.hintColor,
                                fontSize: 10.0,
                                fontFamily: Const.poppinsRegular,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Container(
                        child: Text(
                          LocaleKeys.there_are_no_reviews_yet.tr(),
                          style: TextStyle(
                            color: Const.hintColor,
                            fontSize: 14.0,
                            fontFamily: Const.poppinsRegular,
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 5,
                ),
                child: MySeparator(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              Container(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: groceryList.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20.0,
                    child: MySeparator(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            // child: CircleAvatar(
                            //   backgroundImage: AssetImage(
                            //     'assets/images/demo.jpg',
                            //   ),
                            // ),
                            child: CircleAvatar(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: CachedNetworkImage(
                                    imageUrl: groceryList[index]
                                        .customer
                                        .completeImage,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        SpinKitFadingCircle(
                                            color: Const.primaryColor),
                                    errorWidget: (context, url, error) =>
                                        SpinKitFadingCircle(
                                            color: Const.primaryColor),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        groceryList[index].customer.name,
                        style: TextStyle(
                          color: Const.textColor,
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar(
                            ignoreGestures: true,
                            // initialRating: 4,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount:
                                int.parse(groceryList[index].rate.toString()),
                            itemSize: 15.0,
                            maxRating: 5,
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: Color(0xFFFEC92B),
                              ),
                              half: Icon(
                                Icons.star_half,
                                color: Color(0xFFFEC92B),
                              ),
                              empty: Icon(
                                Icons.star,
                                color: Color(0xFFFEC92B),
                              ),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Text(
                            groceryList[index].message,
                            style: TextStyle(
                              color: Const.hintColor,
                              fontSize: 14.0,
                              fontFamily: Const.poppinsRegular,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        () {
                          DateFormat dateFormatOld = DateFormat("yyyy-MM-dd");
                          DateTime dateTimeStartTime =
                              dateFormatOld.parse(groceryList[index].createdAt);
                          DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
                          final String formatted =
                              dateFormat.format(dateTimeStartTime);
                          // print(formatted); // something like 2013-04-20
                          return formatted;
                          // return formatted +' at ${groceryList[index].time}';
                        }(),
                        style: TextStyle(
                          color: Const.hintColor,
                          fontSize: 10.0,
                          fontFamily: Const.poppinsRegular,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //   height: 50.0,
        //   child: RaisedButton(
        //     color: Const.primaryColor,
        //     onPressed: () {
        //       print('see all');
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           'SEE ALL REVIEW',
        //           style: TextStyle(
        //             fontSize: 16.0,
        //             fontFamily: Const.poppinsMedium,
        //             color: Colors.white,
        //           ),
        //         ),
        //         Text(
        //           '226+',
        //           style: TextStyle(
        //             fontSize: 16.0,
        //             fontFamily: Const.poppinsMedium,
        //             color: Colors.white,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

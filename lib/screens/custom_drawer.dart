import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodlans_driver/all_constant.dart';
import 'package:flutter/painting.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:dio/dio.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/screens/grocery_order_request.dart';
import 'package:foodlans_driver/screens/homepage.dart';
import 'package:foodlans_driver/screens/login.dart';
import 'package:foodlans_driver/screens/profile.dart';
import 'package:foodlans_driver/screens/setting.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'earnings.dart';
import 'order_request.dart';
import 'review.dart';
import '../demo/demomap.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomDrawer extends StatefulWidget {
  // final int currentIndex;
  // CustomDrawer({Key key, @required this.currentIndex}) : super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int currentIndex = 0;
  bool _showSpinner = false;
  String profileName = '';
  String image = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      // _login = (Prefs.getBool('Login') == null) ? false : true;
      getProfileData();
    });
    // currentIndex = widget.currentIndex;
  }

  List<DrawerMenu> drawerMenuList = [
    DrawerMenu(name: LocaleKeys.Home.tr(), iconName: 'assets/icons/home.svg'),
    DrawerMenu(
        name: LocaleKeys.Earnings.tr(), iconName: 'assets/icons/earning.svg'),
    DrawerMenu(
        name: LocaleKeys.Review.tr(), iconName: 'assets/icons/review.svg'),
    DrawerMenu(
        name: LocaleKeys.Profile.tr(), iconName: 'assets/icons/profile.svg'),
    DrawerMenu(
        name: LocaleKeys.Order_Request.tr(),
        iconName: 'assets/icons/order_request.svg'),
    DrawerMenu(
        name: LocaleKeys.Grocery_Request.tr(),
        iconName: 'assets/icons/order_request.svg'),
  ];

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
          profileName = response.data.name;
          image = response.data.completeImage;
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: screenWidth,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Const.primaryColor,
              ),
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   height: screenHeight * 0.100,
                  //   width: 100.0,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(50.0),
                  //     border: Border.all(color: Colors.white, width: 2),
                  //   ),
                  //   child: CircleAvatar(
                  //     radius: 50.0,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(50.0),
                  //       child: image != null
                  //           ? CachedNetworkImage(
                  //               imageUrl: image,
                  //               imageBuilder: (context, imageProvider) =>
                  //                   Container(
                  //                 decoration: BoxDecoration(
                  //                   image: DecorationImage(
                  //                     image: imageProvider,
                  //                     fit: BoxFit.cover,
                  //                   ),
                  //                 ),
                  //               ),
                  //               placeholder: (context, url) =>
                  //                   SpinKitFadingCircle(
                  //                       color: Const.primaryColor),
                  //               errorWidget: (context, url, error) =>
                  //                   SpinKitFadingCircle(
                  //                       color: Const.primaryColor),
                  //             )
                  //           : CircleAvatar(
                  //               radius: 50,
                  //               // backgroundImage:
                  //               //     AssetImage('assets/images/demo.jpg'),
                  //               child: Container(),
                  //             ),
                  //     ),
                  //   ),
                  // ),
                  Card(
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
                        child: CircleAvatar(
                          radius: 40,
                          // backgroundImage: AssetImage(
                          //   'assets/images/demo.jpg',
                          // ),
                          child: image != null
                              ? CachedNetworkImage(
                                  imageUrl: image,
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
                                      Const.customLoader,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  // backgroundImage:
                                  //     AssetImage('assets/images/demo.jpg'),
                                  child: Container(),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    profileName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Const.poppinsMedium,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Const.primaryColor,
              child: ListView.builder(
                itemCount: drawerMenuList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      leading: SvgPicture.asset(
                        drawerMenuList[index].iconName,
                        color: Colors.white,
                        alignment: Alignment.center,
                        // color: currentIndex == index
                        //     ? Const.primaryColor
                        //     : Colors.white,
                        // _login
                        //     ? drawerMenuListLogin[index].iconName
                        //     : drawerMenuList[index].iconName,
                        // color: currentIndex == index
                        //     ? Constant.blueColor
                        //     : Color(0xFF555555),
                      ),
                      title: Text(
                        drawerMenuList[index].name,
                        style: TextStyle(
                          color: Colors.white,
                          // color: currentIndex == index
                          // ? Constant.blueColor
                          // : Color(0xFF555555),
                          fontFamily: Const.poppinsMedium,
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Earnings(),
                              ));
                        } else if (index == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Review(),
                              ));
                        } else if (index == 3) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(),
                              ));
                        } else if (index == 4) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderRequest(),
                              ));
                        } else if (index == 5) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroceryOrderRequest(),
                              ));
                        }
                      });
                },
              ),
            ),
          ),
          Container(
            color: Const.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/setting.svg'),
                        SizedBox(width: 10.0),
                        Text(
                          LocaleKeys.Setting.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: Const.poppinsMedium,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Setting(),
                        ),
                      );
                      print('setting');
                    }),
                FlatButton(
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/logout.svg'),
                        SizedBox(width: 10.0),
                        Text(
                          LocaleKeys.Logout.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: Const.poppinsMedium,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Prefs.remove(Const.checkLogin);
                      Prefs.remove(Const.headerToken);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/Login', (route) => false);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DrawerMenu {
  String iconName, name;
  DrawerMenu({this.iconName, this.name});
}

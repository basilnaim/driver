import 'package:flutter/material.dart';
import 'package:foodlans_driver/all_constant.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/models/earning_modal.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'custom_drawer.dart';
import 'custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';

class Earnings extends StatefulWidget {
  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  double screenHeight;
  double screenWidth;
  bool _showSpinner = false;

  // Which holds the selected date
  // Defaults to today's date.
  DateTime startingDate = DateTime.now();
  String showStartingDate = '';
  DateTime endingDate = DateTime.now();
  String showEndingDate = '';

  List<EarningData> earningDataList = [];

  @override
  void initState() {
    getStartData();
    getEndData();
    getEarningData();
    super.initState();
  }

  void getStartData() {
    var addZero2;
    var addMonthZero2;
    if (DateTime.now().day < 10) {
      addZero2 = '0' + DateTime.now().day.toString();
    } else {
      addZero2 = DateTime.now().day.toString();
    }
    if (DateTime.now().month < 10) {
      addMonthZero2 = '0' + DateTime.now().month.toString();
    } else {
      addMonthZero2 = DateTime.now().month.toString();
    }
    showStartingDate = addZero2.toString() +
        '-' +
        addMonthZero2.toString() +
        '-' +
        DateTime.now().year.toString();
  }

  void getEndData() {
    var addZero2;
    var addMonthZero2;
    if (DateTime.now().day < 10) {
      addZero2 = '0' + DateTime.now().day.toString();
    } else {
      addZero2 = DateTime.now().day.toString();
    }
    if (DateTime.now().month < 10) {
      addMonthZero2 = '0' + DateTime.now().month.toString();
    } else {
      addMonthZero2 = DateTime.now().month.toString();
    }
    showEndingDate = addZero2.toString() +
        '-' +
        addMonthZero2.toString() +
        '-' +
        DateTime.now().year.toString();
  }

  void getEarningData() {
    setState(() {
      _showSpinner = true;
    });

    Map<String, dynamic> body = {
      'start_date': "${startingDate.toLocal()}".split(' ')[0],
      'end_date': "${endingDate.toLocal()}".split(' ')[0],
    };
    print(body);
    RestClient(Retro_Api().Dio_Data()).earning(body).then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      if (response.success) {
        earningDataList.clear();
        setState(() {
          print(response.data[0].id);
          if (response.data.length > 0) {
            earningDataList.addAll(response.data);
          } else {
            Const.showToast('Empty');
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
            Const.showToast(LocaleKeys.Internal_Server_Error.tr());
          }
          break;
        default:
      }
    });
  }

  final _globalKey = GlobalKey<ScaffoldState>();

  List<String> earningHistoryName = [
    'Andreea Reid',
    'Roy Stewart',
    'Megan Banks',
    'Andreea Reid',
  ];
  List<String> earningHistoryTime = [
    '10:05 AM',
    '10:27 AM',
    '11:12 AM',
    '11:40 AM',
  ];
  List<String> earningHistoryImage = [
    'assets/images/driver.png',
    'assets/images/driver.png',
    'assets/images/driver.png',
  ];
  List<String> earningHistoryPrice = [
    '\$18',
    '\$22',
    '\$28',
    '\$30',
  ];

  _startingDateFun(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startingDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      helpText:
          LocaleKeys.Select_Start_Earning_date.tr(), // Can be used as title
      cancelText: LocaleKeys.Not_now.tr(),
      confirmText: LocaleKeys.Select.tr(),
      errorFormatText: LocaleKeys.Enter_Valid_Name.tr(),
      errorInvalidText: LocaleKeys.Enter_date_in_valid_range.tr(),
    );

    DateFormat dateFormatOld = DateFormat("yyyy-MM-dd");
    DateTime dateTimeStartTime = dateFormatOld.parse(picked.toString());
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    showStartingDate = dateFormat.format(dateTimeStartTime);

    if (picked != null && picked != startingDate)
      setState(() {
        startingDate = picked;
      });

    DateFormat dateFormatOldEnding = DateFormat("yyyy-MM-dd");
    DateTime addADay = DateTime(picked.year, picked.month, picked.day + 1);
    DateTime dateTimeStartTimeEnding =
        dateFormatOldEnding.parse(addADay.toString());
    DateFormat dateFormatEnding = DateFormat("dd-MM-yyyy");
    showEndingDate = dateFormatEnding.format(dateTimeStartTimeEnding);

    if (addADay != null && addADay != endingDate)
      setState(() {
        endingDate = addADay;
      });

    getEarningData();
  }

  _endingDateFun(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: endingDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      helpText:
          LocaleKeys.Select_Ending_Earning_date.tr(), // Can be used as title
      cancelText: LocaleKeys.Not_now.tr(),
      confirmText: LocaleKeys.Select.tr(),
      errorFormatText: LocaleKeys.Enter_valid_date.tr(),
      errorInvalidText: LocaleKeys.Enter_date_in_valid_range.tr(),
    );
    DateFormat dateFormatOld = DateFormat("yyyy-MM-dd");
    DateTime dateTimeStartTime = dateFormatOld.parse(picked.toString());
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    showEndingDate = dateFormat.format(dateTimeStartTime);

    if (picked != null && picked != endingDate) {
      setState(() {
        endingDate = picked;
      });
    }
    getEarningData();
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
              title: LocaleKeys.EARNING_HISTORY.tr(),
              onMenuTap: () {
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
          preferredSize: Size(screenWidth, screenHeight),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListView(
            padding: EdgeInsets.all(15.0),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    // splashColor: Colors.black,
                    onTap: () {
                      _startingDateFun(context);
                    },
                    child: Text(
                      // "${startingDate.toLocal()}".split(' ')[0],
                      showStartingDate,
                      style: TextStyle(
                        color: Const.textColor,
                        fontSize: 20,
                        fontFamily: Const.poppinsRegular,
                      ),
                    ),
                  ),
                  InkWell(
                    // splashColor: Colors.black,
                    onTap: () {
                      _endingDateFun(context);
                    },
                    child: Text(
                      showEndingDate,
                      // "${endingDate.toLocal()}".split(' ')[0],
                      style: TextStyle(
                        color: Const.textColor,
                        fontSize: 20,
                        fontFamily: Const.poppinsRegular,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              earningDataList.length > 0
                  ? Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: earningDataList.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10.0,
                          child: MySeparator(
                            height: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image.asset(
                              'assets/images/driver.png',
                              fit: BoxFit.scaleDown,
                            ),
                            title: Text(
                              earningDataList[index].customerName,
                              style: TextStyle(
                                color: Const.textColor,
                                fontSize: 16.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Const.hintColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  () {
                                    DateFormat dateFormatOld =
                                        DateFormat("yyyy-MM-dd");
                                    DateTime dateTimeStartTime = dateFormatOld
                                        .parse(earningDataList[index].date);
                                    DateFormat dateFormat =
                                        DateFormat("dd-MM-yyyy");
                                    showEndingDate =
                                        dateFormat.format(dateTimeStartTime);
                                    return showEndingDate +
                                        ' ' +
                                        earningDataList[index].time;
                                  }(),
                                  style: TextStyle(
                                    color: Const.hintColor,
                                    fontSize: 14.0,
                                    fontFamily: Const.poppinsRegular,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              // earningDataList[index].driverEarning.split('.')[0],
                              '\$${earningDataList[index].driverEarning.toString()}',
                              style: TextStyle(
                                color: Const.redRupeeColor,
                                fontSize: 14.0,
                                fontFamily: Const.poppinsMedium,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text(
                          LocaleKeys.No_Earning.tr(),
                          style: TextStyle(
                            color: Const.hintColor,
                            fontSize: 14.0,
                            fontFamily: Const.poppinsRegular,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: screenHeight * 0.05),
              //yesterday trip
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yesterday Trip',
                    style: TextStyle(
                      color: Const.textColor,
                      fontFamily: Const.poppinsMedium,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    '\$92',
                    style: TextStyle(
                      color: Const.redRupeeColor,
                      fontFamily: Const.poppinsMedium,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: earningHistoryName.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10.0,
                    child: MySeparator(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.asset(
                        earningHistoryImage[index],
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        earningHistoryName[index],
                        style: TextStyle(
                          color: Const.textColor,
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Const.hintColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            earningHistoryTime[index],
                            style: TextStyle(
                              color: Const.hintColor,
                              fontSize: 14.0,
                              fontFamily: Const.poppinsRegular,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        earningHistoryPrice[index],
                        style: TextStyle(
                          color: Const.redRupeeColor,
                          fontSize: 14.0,
                          fontFamily: Const.poppinsMedium,
                        ),
                      ),
                    );
                  },
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

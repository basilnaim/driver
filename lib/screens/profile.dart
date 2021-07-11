import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlans_driver/all_constant.dart';
import 'package:foodlans_driver/api/Retro_Api.dart';
import 'package:foodlans_driver/api/api.dart';
import 'package:foodlans_driver/screens/homepage.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'custom_drawer.dart';
import 'custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _conPass = TextEditingController();
  bool _showSpinner = false;
  double screenHeight;
  double screenWidth;
  final _globalKey = GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  bool _obscureText2 = true;
  String profileName = '';
  String image;
  String _countryCode;
  final _formKey = GlobalKey<FormState>();

  String validatePassword(String value) {
    if (value.isEmpty) {
      return LocaleKeys.Please_enter_some_text.tr();
    } else if (6 > value.length) {
      return LocaleKeys.Enter_more_than_6_character.tr();
    }
    return null;
  }

  String validateConPassword(String value) {
    if (value.isEmpty) {
      return LocaleKeys.Password_is_empty.tr();
    } else if (value != _pass.text) {
      return LocaleKeys.Confirm_Password_Does_Not_Match.tr();
    }
    return null;
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
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
          profileName = response.data.name;
          image = response.data.completeImage;
          _name.text = response.data.name;
          _email.text = response.data.email;
          _phone.text = response.data.phone;
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

  void editProfileData() {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> body = {
      'name': _name.text,
      'phone': _phone.text,
      'code': _countryCode,
      'new_password': _pass.text,
      'confirm_password': _conPass.text,
    };
    print(body);
    RestClient(Retro_Api().Dio_Data()).editProfile(body).then((response) {
      setState(() {
        _showSpinner = false;
      });
      print(response.success);
      Const.showToast(response.msg);
      if (response.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
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
              title: LocaleKeys.Profile.tr(),
              onMenuTap: () {
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
          preferredSize: Size(screenWidth, screenHeight),
        ),
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //image name
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                              radius: 50,
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
                                      radius: 50,
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
                        style: TextStyle(
                          color: Const.primaryColor,
                          fontFamily: Const.poppinsMedium,
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  //name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.Name.tr(),
                        style: TextStyle(
                          color: Const.primaryColor,
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.010),
                      TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/name.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          hintText: 'Philip Mendez',
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
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  //Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.Email.tr(),
                        style: TextStyle(
                          color: Const.primaryColor,
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.010),
                      TextFormField(
                        controller: _email,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/email.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          hintText: 'exsample@gmail.com',
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
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  //phone
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.phone.tr(),
                        style: TextStyle(
                          color: Const.primaryColor,
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.010),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: CountryCodePicker(
                              padding: EdgeInsets.zero,
                              initialSelection: 'eg',
                              showDropDownButton: true,
                              onInit: (country) {
                                _countryCode = country.dialCode;
                              },
                              onChanged: (countryCode) {
                                _countryCode = countryCode.toString();
                              },
                            ),
                          ),
                          Container(
                            width: screenWidth / 1.8,
                            child: TextFormField(
                              controller: _phone,
                              validator: (String value) {
                                String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                RegExp regExp = new RegExp(patttern);
                                if (value.length > 10) {
                                  return LocaleKeys.Enter_Your_Phone_Number
                                      .tr();
                                } else if (!regExp.hasMatch(value)) {
                                  return LocaleKeys
                                      .Please_enter_valid_mobile_number.tr();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: SvgPicture.asset(
                                  'assets/icons/phone.svg',
                                  fit: BoxFit.scaleDown,
                                ),
                                hintText: '+20 1236 658975',
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
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  //password
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.Change_Password.tr(),
                        style: TextStyle(
                          color: Const.primaryColor,
                          fontSize: 16.0,
                          fontFamily: Const.poppinsMedium,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.010),
                      TextFormField(
                        controller: _pass,
                        validator: validatePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/password.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          suffixIcon: IconButton(
                            icon: _obscureText
                                ? Icon(
                                    FontAwesomeIcons.eye,
                                    color: Const.textColor,
                                  )
                                : Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    color: Const.textColor,
                                  ),
                            iconSize: 12,
                            onPressed: _toggle,
                          ),
                          hintText: LocaleKeys.New_Password.tr(),
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
                        obscureText: _obscureText,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      TextFormField(
                        controller: _conPass,
                        validator: validateConPassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/password.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          suffixIcon: IconButton(
                            icon: _obscureText2
                                ? Icon(
                                    FontAwesomeIcons.eye,
                                    color: Const.textColor,
                                  )
                                : Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    color: Const.textColor,
                                  ),
                            iconSize: 12,
                            onPressed: _toggle2,
                          ),
                          hintText: LocaleKeys.Confirm_Password.tr(),
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
                        obscureText: _obscureText2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 50.0,
          child: RaisedButton(
            color: Const.primaryColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                editProfileData();
              }
            },
            child: Text(
              LocaleKeys.SAVE.tr(),
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

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foodlans_driver/tanslations/codegen_loader.g.dart';
import 'package:foodlans_driver/tanslations/local_keys.g.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'all_constant.dart';
import 'api/Retro_Api.dart';
import 'api/api.dart';
import 'screens/homepage.dart';
import 'screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var easyLocalization = EasyLocalization;
  await Prefs.init(); // initialize here ! important
  runApp(EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var appId;
  @override
  void initState() {
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    getOneSignalRequest();
    super.initState();
  }

  Future<void> getOneSignalRequest() async {
    //one signal mate
    await OneSignal.shared.setRequiresUserPrivacyConsent(true);
    RestClient(Retro_Api().Dio_Data()).setting().then((response) async {
      print(response.success);
      if (response.success) {
        // print('order id is ${response.data.id}');
        // var settingApi = await CallApi().getData('setting');
        // var bodyy = json.decode(settingApi.body);
        // Map theDataa = bodyy['data'];
        // appId = theDataa['onesignal_app_id'];
        appId = response.data.onesignalAppId;
        OneSignal.shared.consentGranted(true);
        OneSignal.shared.init("$appId");

        OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

        OneSignal.shared.init("$appId", iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        });

        OneSignal.shared
            .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
        await OneSignal.shared
            .promptUserForPushNotificationPermission(fallbackToSettings: true);

        var status = await OneSignal.shared.getPermissionSubscriptionState();
        // var playerId = status.subscriptionStatus.userId;
        // print('the player id is $playerId');
        // Prefs.setString(Const.deviceToken, playerId);
        Timer(Duration(seconds: 2), () async {
          var playerId = status.subscriptionStatus.userId;
          print('the player id is $playerId');
          Prefs.setString(Const.deviceToken, playerId);
        });
      }
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
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
    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Foodeli driver',
      theme: ThemeData(
        primaryColor: Color(0xFF94B92D),
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xFF94B92D),
        // primarySwatch: Colors.blue,
        dividerColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => HomePage(),
        '/Login': (BuildContext context) => Login(),
      },
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Location location = new Location();

  @override
  void initState() {
    getPermission();
    setDeviceToken();
    super.initState();
  }

  Future<void> getPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);
    Prefs.setDouble(Const.latitude, _locationData.latitude);
    Prefs.setDouble(Const.longitude, _locationData.longitude);
    // LocationPermission permission = await checkPermission();
    // if (permission == LocationPermission.denied ||
    //     permission == LocationPermission.deniedForever) {
    //   permission = await requestPermission();
    // }
  }

  Future<void> setDeviceToken() async {
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    print('device token is $playerId');
    Prefs.setString(Const.deviceToken, playerId);
  }

  @override
  Widget build(BuildContext context) {
    bool directLogin;
    if (Prefs.getBool(Const.checkLogin) == true) {
      directLogin = true;
    } else {
      directLogin = false;
    }
    return directLogin == true ? HomePage() : Login();
  }
}

import 'package:dio/dio.dart';
import 'package:foodlans_driver/all_constant.dart';

class Retro_Api {
  Dio Dio_Data() {
    // print('bearer token is = ${Prefs.getString(Const.headerToken)}');
    final dio = Dio();
    dio.options.headers["Accept"] =
        "application/json"; // config your dio headers globally
    dio.options.headers["Authorization"] =
        "Bearer ${Prefs.getString(Const.headerToken)}"; // config your dio headers globally
    dio.options.followRedirects = false;
    dio.options.connectTimeout = 75000; //5s
    dio.options.receiveTimeout = 3000;
    return dio;
  }
}

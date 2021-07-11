import 'dart:convert';
import 'package:foodlans_driver/models/check_otp.dart';
import 'package:foodlans_driver/models/edit_profile.dart';
import 'package:foodlans_driver/models/login.dart';
import 'package:foodlans_driver/models/order_request.dart';
import 'package:foodlans_driver/models/profile.dart';
import 'package:foodlans_driver/models/reject_grocery_order.dart';
import 'package:foodlans_driver/models/resend_otp.dart';
import 'package:foodlans_driver/models/driver_setting.dart';
import 'package:foodlans_driver/models/setting.dart';
import 'package:foodlans_driver/models/verify_phone.dart';
import 'package:foodlans_driver/models/save_driver_location.dart';
import 'package:foodlans_driver/models/change_status.dart';
import 'package:foodlans_driver/models/driver_trip.dart';
import 'package:foodlans_driver/models/view_single_order.dart';
import 'package:foodlans_driver/models/review_modal.dart';
import 'package:foodlans_driver/models/accept_order.dart';
import 'package:foodlans_driver/models/cancel_order.dart';
import 'package:foodlans_driver/models/pickup_order.dart';
import 'package:foodlans_driver/models/earning_modal.dart';
import 'package:foodlans_driver/models/pickup_order_checkOtp.dart';
import 'package:foodlans_driver/models/driver_status.dart';
import 'package:foodlans_driver/models/cod_foodPayment.dart';
import 'package:foodlans_driver/models/grocery_orders_request.dart';
import 'package:foodlans_driver/models/view_singleorder_grocery.dart';
import 'package:foodlans_driver/models/grocery_driver_status.dart';
import 'package:foodlans_driver/models/reject_food_order.dart';
import 'package:foodlans_driver/models/accept_grocer_order.dart';
import 'package:foodlans_driver/models/cancel_grocery_order.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import 'dart:io';
import 'package:http_parser/http_parser.dart' show MediaType;

part 'api.g.dart';

@RestApi(baseUrl: "https://mandobna-gahez.shop/public/api/driver/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("login")
  Future<LoginModel> login(
    @Body() Map<String, String> map,
  );
  @POST("register")
  Future<LoginModel> register(
    @Body() Map<String, dynamic> map,
  );
  @POST("verifyPhone")
  Future<VerifyPhone> verifyPhone(
    @Body() Map<String, dynamic> map,
  );
  @POST("resendOTP")
  Future<ResendOTP> resendOTP(
    @Body() Map<String, dynamic> map,
  );
  @POST("checkOtp")
  Future<CheckOTP> checkOtp(
    @Body() Map<String, dynamic> map,
  );

  @GET("driverProfile")
  Future<ProfileModel> profile();

  @POST("editDriverProfile")
  Future<EditProfileModel> editProfile(
    @Body() Map<String, dynamic> map,
  );

  @POST("driverSetting")
  Future<DriverSettingModel> changeSetting(
    @Body() Map<String, dynamic> map,
  );

  @GET("driverTrip")
  Future<DriverTripModal> orderTrip();

  @GET("driverRequest")
  Future<OrderRequestModal> orderRequest();

  @GET("groceryOrderRequest")
  Future<GroceryOrderModal> groceryOrderRequest();

  @GET("changeAvaliableStatus/0")
  Future<ChangeStatusModal> changeStatusOff();

  @GET("changeAvaliableStatus/1")
  Future<ChangeStatusModal> changeStatusOn();

  @GET("driverReview")
  Future<ReviewModal> review();

  @POST("saveDriverLocation")
  Future<SaveDriverLocationModal> saveDriverLocation(
    @Body() Map<String, dynamic> map,
  );

  @GET("viewOrder/{id}")
  Future<ViewSingleOrderFoodModal> viewSingleOrderFood(
    @Path() int id,
  );

  @GET("viewGroceryOrder/{id}")
  Future<ViewSingleOrderGroceryModal> viewSingleOrderGrocery(
    @Path() int id,
  );

  @POST("acceptRequest")
  Future<AcceptOrderModal> acceptOrder(
    @Body() Map<String, dynamic> map,
  );

  @POST("acceptGroceryOrderRequest")
  Future<AcceptGroceryOrderModal> acceptGroceryOrder(
    @Body() Map<String, dynamic> map,
  );

  @POST("driverCancelOrder")
  Future<CancelOrderModal> cancelOrder(
    @Body() Map<String, dynamic> map,
  );

  @POST("driverCancelGroceryOrder")
  Future<CancelGroceryOrderModal> cancelGroceryOrder(
    @Body() Map<String, dynamic> map,
  );

  @GET("rejectDriverOrder/{id}")
  Future<RejectFoodOrderModal> rejectOrder(
    @Path() int id,
  );

  @GET("rejectGroceryOrder/{id}")
  Future<RejectGroceryOrderModal> rejectGroceryOrder(
    @Path() int id,
  );

  @POST("earningHistroy")
  Future<EarningModal> earning(
    @Body() Map<String, dynamic> map,
  );

  @POST("pickupFood")
  Future<PickUpOrderCheckOTPModal> pickupOrderCheckOtp(
    @Body() Map<String, dynamic> map,
  );

  @POST("pickupGrocery")
  Future<PickUpOrderCheckOTPModal> pickupGroceryOrderCheckOtp(
    @Body() Map<String, dynamic> map,
  );

  @POST("driverStatus")
  Future<DriverStatusModal> changeDriverStatus(
    @Body() Map<String, dynamic> map,
  );

  @POST("driverGroceryStatus")
  Future<GroceryDriverStatusModal> changeGroceryDriverStatus(
    @Body() Map<String, dynamic> map,
  );

  @GET("collectPayment/{id}")
  Future<CodFoodModal> foodPaymentCollected(
    @Path() int id,
  );
  @GET("collectGroceryPayment/{id}")
  Future<CodFoodModal> groceryPaymentCollected(
    @Path() int id,
  );

  @GET("keySetting")
  Future<SettingModal> setting();
}

class SettingModal {
  String msg;
  Data data;
  bool success;

  SettingModal({this.msg, this.data, this.success});

  SettingModal.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Data {
  int id;
  int cod;
  int stripe;
  int paypal;
  int razor;
  int paytabs;
  String stripePublicKey;
  String stripeSecretKey;
  String paypalSendbox;
  String paypalProduction;
  String razorPublishKey;
  String razorSecretKey;
  Null paytabEmail;
  Null paytabSecretKey;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int pushNotification;
  int sellProduct;
  int requestDuration;
  String twilioAccountId;
  String twilioAuthToken;
  String twilioPhoneNumber;
  String onesignalAppId;
  String onesignalProjectNumber;
  String currency;
  String mapKey;
  String currencySymbol;

  Data(
      {this.id,
      this.cod,
      this.stripe,
      this.paypal,
      this.razor,
      this.paytabs,
      this.stripePublicKey,
      this.stripeSecretKey,
      this.paypalSendbox,
      this.paypalProduction,
      this.razorPublishKey,
      this.razorSecretKey,
      this.paytabEmail,
      this.paytabSecretKey,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.pushNotification,
      this.sellProduct,
      this.requestDuration,
      this.twilioAccountId,
      this.twilioAuthToken,
      this.twilioPhoneNumber,
      this.onesignalAppId,
      this.onesignalProjectNumber,
      this.currency,
      this.mapKey,
      this.currencySymbol});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cod = json['cod'];
    stripe = json['stripe'];
    paypal = json['paypal'];
    razor = json['razor'];
    paytabs = json['paytabs'];
    stripePublicKey = json['stripePublicKey'];
    stripeSecretKey = json['stripeSecretKey'];
    paypalSendbox = json['paypalSendbox'];
    paypalProduction = json['paypalProduction'];
    razorPublishKey = json['razorPublishKey'];
    razorSecretKey = json['razorSecretKey'];
    paytabEmail = json['paytab_email'];
    paytabSecretKey = json['paytab_secret_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    pushNotification = json['push_notification'];
    sellProduct = json['sell_product'];
    requestDuration = json['request_duration'];
    twilioAccountId = json['twilio_account_id'];
    twilioAuthToken = json['twilio_auth_token'];
    twilioPhoneNumber = json['twilio_phone_number'];
    onesignalAppId = json['onesignal_app_id'];
    onesignalProjectNumber = json['onesignal_project_number'];
    currency = json['currency'];
    mapKey = json['map_key'];
    currencySymbol = json['currency_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cod'] = this.cod;
    data['stripe'] = this.stripe;
    data['paypal'] = this.paypal;
    data['razor'] = this.razor;
    data['paytabs'] = this.paytabs;
    data['stripePublicKey'] = this.stripePublicKey;
    data['stripeSecretKey'] = this.stripeSecretKey;
    data['paypalSendbox'] = this.paypalSendbox;
    data['paypalProduction'] = this.paypalProduction;
    data['razorPublishKey'] = this.razorPublishKey;
    data['razorSecretKey'] = this.razorSecretKey;
    data['paytab_email'] = this.paytabEmail;
    data['paytab_secret_key'] = this.paytabSecretKey;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['push_notification'] = this.pushNotification;
    data['sell_product'] = this.sellProduct;
    data['request_duration'] = this.requestDuration;
    data['twilio_account_id'] = this.twilioAccountId;
    data['twilio_auth_token'] = this.twilioAuthToken;
    data['twilio_phone_number'] = this.twilioPhoneNumber;
    data['onesignal_app_id'] = this.onesignalAppId;
    data['onesignal_project_number'] = this.onesignalProjectNumber;
    data['currency'] = this.currency;
    data['map_key'] = this.mapKey;
    data['currency_symbol'] = this.currencySymbol;
    return data;
  }
}

class SaveDriverLocationModal {
  bool success;
  String msg;
  Data data;

  SaveDriverLocationModal({this.success, this.msg, this.data});

  SaveDriverLocationModal.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  String email;
  String phoneCode;
  String phone;
  Null dateOfBirth;
  Null location;
  Null address;
  Null addressId;
  Null emailVerifiedAt;
  String image;
  Null coverImage;
  Null favourite;
  String otp;
  String referralCode;
  Null friendCode;
  int referralUser;
  int freeOrder;
  int verify;
  String provider;
  Null providerToken;
  String deviceToken;
  int role;
  int status;
  String lat;
  String lang;
  int driverRadius;
  int driverAvailable;
  int enableNotification;
  int enableLocation;
  int enableCall;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String imagePath;
  Null fullAddress;
  String completeImage;

  Data(
      {this.id,
      this.name,
      this.email,
      this.phoneCode,
      this.phone,
      this.dateOfBirth,
      this.location,
      this.address,
      this.addressId,
      this.emailVerifiedAt,
      this.image,
      this.coverImage,
      this.favourite,
      this.otp,
      this.referralCode,
      this.friendCode,
      this.referralUser,
      this.freeOrder,
      this.verify,
      this.provider,
      this.providerToken,
      this.deviceToken,
      this.role,
      this.status,
      this.lat,
      this.lang,
      this.driverRadius,
      this.driverAvailable,
      this.enableNotification,
      this.enableLocation,
      this.enableCall,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.imagePath,
      this.fullAddress,
      this.completeImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneCode = json['phone_code'];
    phone = json['phone'];
    dateOfBirth = json['dateOfBirth'];
    location = json['location'];
    address = json['address'];
    addressId = json['address_id'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    coverImage = json['cover_image'];
    favourite = json['favourite'];
    otp = json['otp'];
    referralCode = json['referral_code'];
    friendCode = json['friend_code'];
    referralUser = json['referral_user'];
    freeOrder = json['free_order'];
    verify = json['verify'];
    provider = json['provider'];
    providerToken = json['provider_token'];
    deviceToken = json['device_token'];
    role = json['role'];
    status = json['status'];
    lat = json['lat'];
    lang = json['lang'];
    driverRadius = json['driver_radius'];
    driverAvailable = json['driver_available'];
    enableNotification = json['enable_notification'];
    enableLocation = json['enable_location'];
    enableCall = json['enable_call'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imagePath = json['imagePath'];
    fullAddress = json['FullAddress'];
    completeImage = json['completeImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_code'] = this.phoneCode;
    data['phone'] = this.phone;
    data['dateOfBirth'] = this.dateOfBirth;
    data['location'] = this.location;
    data['address'] = this.address;
    data['address_id'] = this.addressId;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['cover_image'] = this.coverImage;
    data['favourite'] = this.favourite;
    data['otp'] = this.otp;
    data['referral_code'] = this.referralCode;
    data['friend_code'] = this.friendCode;
    data['referral_user'] = this.referralUser;
    data['free_order'] = this.freeOrder;
    data['verify'] = this.verify;
    data['provider'] = this.provider;
    data['provider_token'] = this.providerToken;
    data['device_token'] = this.deviceToken;
    data['role'] = this.role;
    data['status'] = this.status;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['driver_radius'] = this.driverRadius;
    data['driver_available'] = this.driverAvailable;
    data['enable_notification'] = this.enableNotification;
    data['enable_location'] = this.enableLocation;
    data['enable_call'] = this.enableCall;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['imagePath'] = this.imagePath;
    data['FullAddress'] = this.fullAddress;
    data['completeImage'] = this.completeImage;
    return data;
  }
}

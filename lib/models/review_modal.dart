class ReviewModal {
  String msg;
  Data data;
  bool success;

  ReviewModal({this.msg, this.data, this.success});

  ReviewModal.fromJson(Map<String, dynamic> json) {
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
  List<Food> food;
  List<Grocery> grocery;

  Data({this.food, this.grocery});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['food'] != null) {
      food = new List<Food>();
      json['food'].forEach((v) {
        food.add(new Food.fromJson(v));
      });
    }
    if (json['grocery'] != null) {
      grocery = new List<Grocery>();
      json['grocery'].forEach((v) {
        grocery.add(new Grocery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.food != null) {
      data['food'] = this.food.map((v) => v.toJson()).toList();
    }
    if (this.grocery != null) {
      data['grocery'] = this.grocery.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Food {
  int id;
  int customerId;
  int orderId;
  Null shopId;
  int deliveryBoyId;
  Null itemId;
  Null packageId;
  String message;
  int rate;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String shopName;
  String imagePath;
  Customer customer;

  Food(
      {this.id,
      this.customerId,
      this.orderId,
      this.shopId,
      this.deliveryBoyId,
      this.itemId,
      this.packageId,
      this.message,
      this.rate,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.shopName,
      this.imagePath,
      this.customer});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    orderId = json['order_id'];
    shopId = json['shop_id'];
    deliveryBoyId = json['deliveryBoy_id'];
    itemId = json['item_id'];
    packageId = json['package_id'];
    message = json['message'];
    rate = json['rate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    shopName = json['shopName'];
    imagePath = json['imagePath'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['order_id'] = this.orderId;
    data['shop_id'] = this.shopId;
    data['deliveryBoy_id'] = this.deliveryBoyId;
    data['item_id'] = this.itemId;
    data['package_id'] = this.packageId;
    data['message'] = this.message;
    data['rate'] = this.rate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['shopName'] = this.shopName;
    data['imagePath'] = this.imagePath;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Customer {
  int id;
  String name;
  String email;
  Null phoneCode;
  String phone;
  Null dateOfBirth;
  String location;
  Null address;
  int addressId;
  Null emailVerifiedAt;
  String image;
  String coverImage;
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
  Null driverRadius;
  Null driverAvailable;
  int enableNotification;
  int enableLocation;
  int enableCall;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String imagePath;
  FullAddress fullAddress;
  String completeImage;

  Customer(
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

  Customer.fromJson(Map<String, dynamic> json) {
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
    fullAddress = json['FullAddress'] != null
        ? new FullAddress.fromJson(json['FullAddress'])
        : null;
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
    if (this.fullAddress != null) {
      data['FullAddress'] = this.fullAddress.toJson();
    }
    data['completeImage'] = this.completeImage;
    return data;
  }
}

class FullAddress {
  int id;
  int userId;
  String addressType;
  String socName;
  String street;
  String city;
  String zipcode;
  String lat;
  String lang;
  String createdAt;
  String updatedAt;
  String deletedAt;

  FullAddress(
      {this.id,
      this.userId,
      this.addressType,
      this.socName,
      this.street,
      this.city,
      this.zipcode,
      this.lat,
      this.lang,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  FullAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    addressType = json['address_type'];
    socName = json['soc_name'];
    street = json['street'];
    city = json['city'];
    zipcode = json['zipcode'];
    lat = json['lat'];
    lang = json['lang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address_type'] = this.addressType;
    data['soc_name'] = this.socName;
    data['street'] = this.street;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Grocery {
  int id;
  int customerId;
  int orderId;
  int shopId;
  int deliveryBoyId;
  Null itemId;
  String message;
  int rate;
  String createdAt;
  String updatedAt;
  String imagePath;
  Customer customer;

  Grocery(
      {this.id,
      this.customerId,
      this.orderId,
      this.shopId,
      this.deliveryBoyId,
      this.itemId,
      this.message,
      this.rate,
      this.createdAt,
      this.updatedAt,
      this.imagePath,
      this.customer});

  Grocery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    orderId = json['order_id'];
    shopId = json['shop_id'];
    deliveryBoyId = json['deliveryBoy_id'];
    itemId = json['item_id'];
    message = json['message'];
    rate = json['rate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagePath = json['imagePath'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['order_id'] = this.orderId;
    data['shop_id'] = this.shopId;
    data['deliveryBoy_id'] = this.deliveryBoyId;
    data['item_id'] = this.itemId;
    data['message'] = this.message;
    data['rate'] = this.rate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imagePath'] = this.imagePath;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

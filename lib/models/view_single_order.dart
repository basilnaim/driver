class ViewSingleOrderFoodModal {
  bool success;
  String msg;
  ViewSingleOrderData data;

  ViewSingleOrderFoodModal({this.success, this.msg, this.data});

  ViewSingleOrderFoodModal.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    data = json['data'] != null
        ? new ViewSingleOrderData.fromJson(json['data'])
        : null;
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

class ViewSingleOrderData {
  int id;
  String orderNo;
  int ownerId;
  Null locationId;
  int shopId;
  int customerId;
  int deliveryBoyId;
  Null couponId;
  int addressId;
  String items;
  String packageId;
  int payment;
  String date;
  String time;
  int shopCharge;
  int deliveryCharge;
  int couponPrice;
  int discount;
  String orderStatus;
  int paymentStatus;
  String paymentType;
  String paymentToken;
  String deliveryType;
  String driverOtp;
  int reviewStatus;
  int shopReviewStatus;
  int driverReviewStatus;
  String cancelReason;
  Null rejectBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  Shop shop;
  Customer customer;
  dynamic driver;
  List<OrderItems> orderItems;
  String quantityTotal;

  ViewSingleOrderData(
      {this.id,
      this.orderNo,
      this.ownerId,
      this.locationId,
      this.shopId,
      this.customerId,
      this.deliveryBoyId,
      this.couponId,
      this.addressId,
      this.items,
      this.packageId,
      this.payment,
      this.date,
      this.time,
      this.shopCharge,
      this.deliveryCharge,
      this.couponPrice,
      this.discount,
      this.orderStatus,
      this.paymentStatus,
      this.paymentType,
      this.paymentToken,
      this.deliveryType,
      this.driverOtp,
      this.reviewStatus,
      this.shopReviewStatus,
      this.driverReviewStatus,
      this.cancelReason,
      this.rejectBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.shop,
      this.customer,
      this.driver,
      this.orderItems,
      this.quantityTotal});

  ViewSingleOrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    ownerId = json['owner_id'];
    locationId = json['location_id'];
    shopId = json['shop_id'];
    customerId = json['customer_id'];
    deliveryBoyId = json['deliveryBoy_id'];
    couponId = json['coupon_id'];
    addressId = json['address_id'];
    items = json['items'];
    packageId = json['package_id'];
    payment = json['payment'];
    date = json['date'];
    time = json['time'];
    shopCharge = json['shop_charge'];
    deliveryCharge = json['delivery_charge'];
    couponPrice = json['coupon_price'];
    discount = json['discount'];
    orderStatus = json['order_status'];
    paymentStatus = json['payment_status'];
    paymentType = json['payment_type'];
    paymentToken = json['payment_token'];
    deliveryType = json['delivery_type'];
    driverOtp = json['driver_otp'];
    reviewStatus = json['review_status'];
    shopReviewStatus = json['shopReview_status'];
    driverReviewStatus = json['driverReview_status'];
    cancelReason = json['cancel_reason'];
    rejectBy = json['reject_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    driver = json['driver'];
    if (json['orderItems'] != null) {
      orderItems = new List<OrderItems>();
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    quantityTotal = json['quantityTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_no'] = this.orderNo;
    data['owner_id'] = this.ownerId;
    data['location_id'] = this.locationId;
    data['shop_id'] = this.shopId;
    data['customer_id'] = this.customerId;
    data['deliveryBoy_id'] = this.deliveryBoyId;
    data['coupon_id'] = this.couponId;
    data['address_id'] = this.addressId;
    data['items'] = this.items;
    data['package_id'] = this.packageId;
    data['payment'] = this.payment;
    data['date'] = this.date;
    data['time'] = this.time;
    data['shop_charge'] = this.shopCharge;
    data['delivery_charge'] = this.deliveryCharge;
    data['coupon_price'] = this.couponPrice;
    data['discount'] = this.discount;
    data['order_status'] = this.orderStatus;
    data['payment_status'] = this.paymentStatus;
    data['payment_type'] = this.paymentType;
    data['payment_token'] = this.paymentToken;
    data['delivery_type'] = this.deliveryType;
    data['driver_otp'] = this.driverOtp;
    data['review_status'] = this.reviewStatus;
    data['shopReview_status'] = this.shopReviewStatus;
    data['driverReview_status'] = this.driverReviewStatus;
    data['cancel_reason'] = this.cancelReason;
    data['reject_by'] = this.rejectBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    data['driver'] = this.driver;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['quantityTotal'] = this.quantityTotal;
    return data;
  }
}

class Shop {
  int id;
  int userId;
  String name;
  String description;
  int location;
  String image;
  String address;
  String pincode;
  String phone;
  String website;
  String latitude;
  String longitude;
  int radius;
  String licenceCode;
  int rastaurantCharge;
  int avaragePlatePrice;
  int deliveryCharge;
  int cancleCharge;
  int deliveryTime;
  String openTime;
  String closeTime;
  int featured;
  int exclusive;
  int veg;
  int status;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int totalOrder;
  int rate;
  int totalReview;
  String imagePath;
  String itemNames;
  String completeImage;

  Shop(
      {this.id,
      this.userId,
      this.name,
      this.description,
      this.location,
      this.image,
      this.address,
      this.pincode,
      this.phone,
      this.website,
      this.latitude,
      this.longitude,
      this.radius,
      this.licenceCode,
      this.rastaurantCharge,
      this.avaragePlatePrice,
      this.deliveryCharge,
      this.cancleCharge,
      this.deliveryTime,
      this.openTime,
      this.closeTime,
      this.featured,
      this.exclusive,
      this.veg,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.totalOrder,
      this.rate,
      this.totalReview,
      this.imagePath,
      this.itemNames,
      this.completeImage});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    description = json['description'];
    location = json['location'];
    image = json['image'];
    address = json['address'];
    pincode = json['pincode'];
    phone = json['phone'];
    website = json['website'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    licenceCode = json['licence_code'];
    rastaurantCharge = json['rastaurant_charge'];
    avaragePlatePrice = json['avarage_plate_price'];
    deliveryCharge = json['delivery_charge'];
    cancleCharge = json['cancle_charge'];
    deliveryTime = json['delivery_time'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    featured = json['featured'];
    exclusive = json['exclusive'];
    veg = json['veg'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    totalOrder = json['totalOrder'];
    rate = json['rate'];
    totalReview = json['totalReview'];
    imagePath = json['imagePath'];
    itemNames = json['itemNames'];
    completeImage = json['completeImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['location'] = this.location;
    data['image'] = this.image;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['radius'] = this.radius;
    data['licence_code'] = this.licenceCode;
    data['rastaurant_charge'] = this.rastaurantCharge;
    data['avarage_plate_price'] = this.avaragePlatePrice;
    data['delivery_charge'] = this.deliveryCharge;
    data['cancle_charge'] = this.cancleCharge;
    data['delivery_time'] = this.deliveryTime;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['featured'] = this.featured;
    data['exclusive'] = this.exclusive;
    data['veg'] = this.veg;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['totalOrder'] = this.totalOrder;
    data['rate'] = this.rate;
    data['totalReview'] = this.totalReview;
    data['imagePath'] = this.imagePath;
    data['itemNames'] = this.itemNames;
    data['completeImage'] = this.completeImage;
    return data;
  }
}

class Customer {
  int id;
  String name;
  String email;
  Null phoneCode;
  String phone;
  String dateOfBirth;
  String location;
  Null address;
  int addressId;
  Null emailVerifiedAt;
  String image;
  String coverImage;
  String favourite;
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
  int driverAvailable;
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

class OrderItems {
  int id;
  int orderId;
  int item;
  int packageId;
  int price;
  int quantity;
  String createdAt;
  String updatedAt;
  String itemName;
  String packageName;
  String itemImage;
  String packageImage;
  String imagePath;

  OrderItems(
      {this.id,
      this.orderId,
      this.item,
      this.packageId,
      this.price,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.itemName,
      this.packageName,
      this.itemImage,
      this.packageImage,
      this.imagePath});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    item = json['item'];
    packageId = json['package_id'];
    price = json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemName = json['itemName'];
    packageName = json['packageName'];
    itemImage = json['itemImage'];
    packageImage = json['packageImage'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['item'] = this.item;
    data['package_id'] = this.packageId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['itemName'] = this.itemName;
    data['packageName'] = this.packageName;
    data['itemImage'] = this.itemImage;
    data['packageImage'] = this.packageImage;
    data['imagePath'] = this.imagePath;
    return data;
  }
}

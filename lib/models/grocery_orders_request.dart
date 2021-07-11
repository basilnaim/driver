class GroceryOrderModal {
  bool success;
  String msg;
  Data data;

  GroceryOrderModal({this.success, this.msg, this.data});

  GroceryOrderModal.fromJson(Map<String, dynamic> json) {
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
  List<Requests> requests;
  List<Accepted> accepted;

  Data({this.requests, this.accepted});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['requests'] != null) {
      requests = new List<Requests>();
      json['requests'].forEach((v) {
        requests.add(new Requests.fromJson(v));
      });
    }
    if (json['accepted'] != null) {
      accepted = new List<Accepted>();
      json['accepted'].forEach((v) {
        accepted.add(new Accepted.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requests != null) {
      data['requests'] = this.requests.map((v) => v.toJson()).toList();
    }
    if (this.accepted != null) {
      data['accepted'] = this.accepted.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requests {
  int id;
  String orderNo;
  int ownerId;
  int shopId;
  int customerId;
  Null deliveryBoyId;
  Null couponId;
  int addressId;
  String items;
  int payment;
  String date;
  String time;
  int deliveryCharge;
  String deliveryType;
  int couponPrice;
  int discount;
  String orderStatus;
  int paymentStatus;
  String paymentType;
  String paymentToken;
  String orderOtp;
  Null rejectBy;
  int reviewStatus;
  String createdAt;
  String updatedAt;
  DeliveryAddress deliveryAddress;
  List<OrderItems> orderItems;
  String quantityTotal;
  Shop shop;

  Requests(
      {this.id,
      this.orderNo,
      this.ownerId,
      this.shopId,
      this.customerId,
      this.deliveryBoyId,
      this.couponId,
      this.addressId,
      this.items,
      this.payment,
      this.date,
      this.time,
      this.deliveryCharge,
      this.deliveryType,
      this.couponPrice,
      this.discount,
      this.orderStatus,
      this.paymentStatus,
      this.paymentType,
      this.paymentToken,
      this.orderOtp,
      this.rejectBy,
      this.reviewStatus,
      this.createdAt,
      this.updatedAt,
      this.deliveryAddress,
      this.orderItems,
      this.quantityTotal,
      this.shop});

  Requests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    ownerId = json['owner_id'];
    shopId = json['shop_id'];
    customerId = json['customer_id'];
    deliveryBoyId = json['deliveryBoy_id'];
    couponId = json['coupon_id'];
    addressId = json['address_id'];
    items = json['items'];
    payment = json['payment'];
    date = json['date'];
    time = json['time'];
    deliveryCharge = json['delivery_charge'];
    deliveryType = json['delivery_type'];
    couponPrice = json['coupon_price'];
    discount = json['discount'];
    orderStatus = json['order_status'];
    paymentStatus = json['payment_status'];
    paymentType = json['payment_type'];
    paymentToken = json['payment_token'];
    orderOtp = json['order_otp'];
    rejectBy = json['reject_by'];
    reviewStatus = json['review_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryAddress = json['delivery_address'] != null
        ? new DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    if (json['orderItems'] != null) {
      orderItems = new List<OrderItems>();
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    quantityTotal = json['quantityTotal'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_no'] = this.orderNo;
    data['owner_id'] = this.ownerId;
    data['shop_id'] = this.shopId;
    data['customer_id'] = this.customerId;
    data['deliveryBoy_id'] = this.deliveryBoyId;
    data['coupon_id'] = this.couponId;
    data['address_id'] = this.addressId;
    data['items'] = this.items;
    data['payment'] = this.payment;
    data['date'] = this.date;
    data['time'] = this.time;
    data['delivery_charge'] = this.deliveryCharge;
    data['delivery_type'] = this.deliveryType;
    data['coupon_price'] = this.couponPrice;
    data['discount'] = this.discount;
    data['order_status'] = this.orderStatus;
    data['payment_status'] = this.paymentStatus;
    data['payment_type'] = this.paymentType;
    data['payment_token'] = this.paymentToken;
    data['order_otp'] = this.orderOtp;
    data['reject_by'] = this.rejectBy;
    data['review_status'] = this.reviewStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.deliveryAddress != null) {
      data['delivery_address'] = this.deliveryAddress.toJson();
    }
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['quantityTotal'] = this.quantityTotal;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    return data;
  }
}

class DeliveryAddress {
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

  DeliveryAddress(
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

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
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
  int itemId;
  int price;
  int quantity;
  String createdAt;
  String updatedAt;
  String itemName;
  String imagePath;

  OrderItems(
      {this.id,
      this.orderId,
      this.itemId,
      this.price,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.itemName,
      this.imagePath});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    itemId = json['item_id'];
    price = json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemName = json['itemName'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['item_id'] = this.itemId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['itemName'] = this.itemName;
    data['imagePath'] = this.imagePath;
    return data;
  }
}

class Shop {
  int id;
  String name;
  int userId;
  int location;
  String categoryId;
  String coverImage;
  String image;
  String description;
  String address;
  String latitude;
  String longitude;
  String website;
  String phone;
  int radius;
  String openTime;
  String closeTime;
  int deliveryCharge;
  String deliveryType;
  int status;
  String createdAt;
  String updatedAt;
  String imagePath;
  int rate;
  int totalReview;
  String completeImage;

  Shop(
      {this.id,
      this.name,
      this.userId,
      this.location,
      this.categoryId,
      this.coverImage,
      this.image,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      this.website,
      this.phone,
      this.radius,
      this.openTime,
      this.closeTime,
      this.deliveryCharge,
      this.deliveryType,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.imagePath,
      this.rate,
      this.totalReview,
      this.completeImage});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    location = json['location'];
    categoryId = json['category_id'];
    coverImage = json['cover_image'];
    image = json['image'];
    description = json['description'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    website = json['website'];
    phone = json['phone'];
    radius = json['radius'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    deliveryCharge = json['delivery_charge'];
    deliveryType = json['delivery_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagePath = json['imagePath'];
    rate = json['rate'];
    totalReview = json['totalReview'];
    completeImage = json['completeImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['location'] = this.location;
    data['category_id'] = this.categoryId;
    data['cover_image'] = this.coverImage;
    data['image'] = this.image;
    data['description'] = this.description;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['website'] = this.website;
    data['phone'] = this.phone;
    data['radius'] = this.radius;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['delivery_charge'] = this.deliveryCharge;
    data['delivery_type'] = this.deliveryType;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imagePath'] = this.imagePath;
    data['rate'] = this.rate;
    data['totalReview'] = this.totalReview;
    data['completeImage'] = this.completeImage;
    return data;
  }
}

class Accepted {
  int id;
  String orderNo;
  int ownerId;
  int shopId;
  int customerId;
  int deliveryBoyId;
  Null couponId;
  int addressId;
  String items;
  int payment;
  String date;
  String time;
  int deliveryCharge;
  String deliveryType;
  int couponPrice;
  int discount;
  String orderStatus;
  int paymentStatus;
  String paymentType;
  String paymentToken;
  String orderOtp;
  Null rejectBy;
  int reviewStatus;
  String createdAt;
  String updatedAt;
  DeliveryAddress deliveryAddress;
  List<OrderItems> orderItems;
  String quantityTotal;
  Shop shop;

  Accepted(
      {this.id,
      this.orderNo,
      this.ownerId,
      this.shopId,
      this.customerId,
      this.deliveryBoyId,
      this.couponId,
      this.addressId,
      this.items,
      this.payment,
      this.date,
      this.time,
      this.deliveryCharge,
      this.deliveryType,
      this.couponPrice,
      this.discount,
      this.orderStatus,
      this.paymentStatus,
      this.paymentType,
      this.paymentToken,
      this.orderOtp,
      this.rejectBy,
      this.reviewStatus,
      this.createdAt,
      this.updatedAt,
      this.deliveryAddress,
      this.orderItems,
      this.quantityTotal,
      this.shop});

  Accepted.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    ownerId = json['owner_id'];
    shopId = json['shop_id'];
    customerId = json['customer_id'];
    deliveryBoyId = json['deliveryBoy_id'];
    couponId = json['coupon_id'];
    addressId = json['address_id'];
    items = json['items'];
    payment = json['payment'];
    date = json['date'];
    time = json['time'];
    deliveryCharge = json['delivery_charge'];
    deliveryType = json['delivery_type'];
    couponPrice = json['coupon_price'];
    discount = json['discount'];
    orderStatus = json['order_status'];
    paymentStatus = json['payment_status'];
    paymentType = json['payment_type'];
    paymentToken = json['payment_token'];
    orderOtp = json['order_otp'];
    rejectBy = json['reject_by'];
    reviewStatus = json['review_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryAddress = json['delivery_address'] != null
        ? new DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    if (json['orderItems'] != null) {
      orderItems = new List<OrderItems>();
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    quantityTotal = json['quantityTotal'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_no'] = this.orderNo;
    data['owner_id'] = this.ownerId;
    data['shop_id'] = this.shopId;
    data['customer_id'] = this.customerId;
    data['deliveryBoy_id'] = this.deliveryBoyId;
    data['coupon_id'] = this.couponId;
    data['address_id'] = this.addressId;
    data['items'] = this.items;
    data['payment'] = this.payment;
    data['date'] = this.date;
    data['time'] = this.time;
    data['delivery_charge'] = this.deliveryCharge;
    data['delivery_type'] = this.deliveryType;
    data['coupon_price'] = this.couponPrice;
    data['discount'] = this.discount;
    data['order_status'] = this.orderStatus;
    data['payment_status'] = this.paymentStatus;
    data['payment_type'] = this.paymentType;
    data['payment_token'] = this.paymentToken;
    data['order_otp'] = this.orderOtp;
    data['reject_by'] = this.rejectBy;
    data['review_status'] = this.reviewStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.deliveryAddress != null) {
      data['delivery_address'] = this.deliveryAddress.toJson();
    }
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['quantityTotal'] = this.quantityTotal;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    return data;
  }
}

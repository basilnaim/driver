class EarningModal {
  bool success;
  String msg;
  List<EarningData> data;

  EarningModal({this.success, this.msg, this.data});

  EarningModal.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<EarningData>();
      json['data'].forEach((v) {
        data.add(new EarningData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EarningData {
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
  Null packageId;
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
  dynamic driverEarning;
  String customerName;
  List<OrderItems> orderItems;
  String quantityTotal;

  EarningData(
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
      this.driverEarning,
      this.customerName,
      this.orderItems,
      this.quantityTotal});

  EarningData.fromJson(Map<String, dynamic> json) {
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
    driverEarning = json['driver_earning'];
    customerName = json['customer_name'];
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
    data['driver_earning'] = this.driverEarning;
    data['customer_name'] = this.customerName;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['quantityTotal'] = this.quantityTotal;
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
  Null packageName;
  String itemImage;
  Null packageImage;
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

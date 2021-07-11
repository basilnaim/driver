class RejectGroceryOrderModal {
  String msg;
  Data data;
  bool success;

  RejectGroceryOrderModal({this.msg, this.data, this.success});

  RejectGroceryOrderModal.fromJson(Map<String, dynamic> json) {
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
  String rejectBy;
  int reviewStatus;
  String createdAt;
  String updatedAt;
  List<OrderItems> orderItems;
  String quantityTotal;

  Data(
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
      this.orderItems,
      this.quantityTotal});

  Data.fromJson(Map<String, dynamic> json) {
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

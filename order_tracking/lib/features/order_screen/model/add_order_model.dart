class OrderModel {
  String? orderId;
  String? orderName;
  double? orderLat;
  double? orderLong;
  double? userLat;
  double? userLong;
  String? orderUserId;
  String? orderDate;
  String? orderStatus;

  OrderModel(
    this.orderId,
    this.orderName,
    this.orderLat,
    this.orderLong,
    this.userLat,
    this.userLong,
    this.orderUserId,
    this.orderDate,
    this.orderStatus,
  );
  //"AIzaSyCkBGQUQ08_Vz1jHb__CRvC7PQBHRba0mY"
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      json['order_id'],
      json['order_name'],
      json['order_lat'],
      json['order_long'],
      json['user_lat'],
      json['user_long'],
      json['order_user_id'],
      json['order_date'],
      json['order_status'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['order_id'] = orderId;
    data['order_name'] = orderName;
    data['order_lat'] = orderLat;
    data['order_long'] = orderLong;
    data['user_lat'] = userLat;
    data['user_long'] = userLong;
    data['order_user_id'] = orderUserId;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;

    return data;
  }
}

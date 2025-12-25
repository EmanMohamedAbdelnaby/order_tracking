
import 'package:order_tracking/features/order_screen/model/add_order_model.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class AddingOrderStatus extends OrdersState {}

class SuccessAddingOrder extends OrdersState {
  final String message;
  SuccessAddingOrder(this.message);
}

class ErrorAddingOrder extends OrdersState {
  final String message;
  ErrorAddingOrder(this.message);
}


class GettingOrderStatus extends OrdersState {}

class SuccessGettingOrder extends OrdersState {
  final List<OrderModel> orderList;
  SuccessGettingOrder(this.orderList);
}

class ErrorGettingOrder extends OrdersState {
  final String message;
  ErrorGettingOrder(this.message);
}

class OrderDeliverdstatus extends OrdersState {
  final String message;
  OrderDeliverdstatus(this.message);
}


class GettingOneOrderStatus extends OrdersState {}

class SuccessGettingOneOrder extends OrdersState {
  final OrderModel order;
  SuccessGettingOneOrder(this.order);
}

class ErrorGettingOneOrder extends OrdersState {
  final String message;
  ErrorGettingOneOrder(this.message);
}
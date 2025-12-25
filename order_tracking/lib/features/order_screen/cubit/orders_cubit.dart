

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:order_tracking/features/order_screen/cubit/order_state.dart';
import 'package:order_tracking/features/order_screen/model/add_order_model.dart';
import 'package:order_tracking/features/order_screen/repo/order_repo.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this.orderRepo) : super(OrdersInitial());

  OrderRepo orderRepo;
  void addOrder({required OrderModel order}) async {
    emit(AddingOrderStatus());
    final result = await orderRepo.addOrder(order: order);
    result.fold(
      (l) => emit(ErrorAddingOrder(l)),
      (r) => emit(SuccessAddingOrder(r)),
    );
  }

  void getOrders() async {
    emit(GettingOrderStatus());
    final result = await orderRepo.getOrders();
    result.fold(
      (l) => emit(ErrorGettingOrder(l)),
      (r) => emit(SuccessGettingOrder(r)),
    );
  }

  void sendUserNewLocation({
    required String orderId,
    required double userLat,
    required double userLong,
  }) async {
    await orderRepo.updateUserLocation(
      orderId: orderId,
      userLat: userLat,
      userLong: userLong,
    );
  }

  void makeOrderDeliverdStatus({required String orderId}) async {
    final result = await orderRepo.makeStatusDeliverd(orderId: orderId);
    return result.fold(
      (l) {},
      (r) => emit(OrderDeliverdstatus(r)),
    );
  }

  void searhByOrderId({required String orderId}) async {
    emit(GettingOneOrderStatus());
    final result = await orderRepo.searhByOrderId(orderId: orderId);
    return result.fold(
      (l) => emit(ErrorGettingOneOrder(l)),
      (r) => emit(SuccessGettingOneOrder(r)),
    );
  }
}

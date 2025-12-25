import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracking/features/order_screen/model/add_order_model.dart';

class OrderRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<Either<String, String>> addOrder({required OrderModel order}) async {
    try {
      await firebaseFirestore.collection("orders").doc().set({
        "order_id": order.orderId,
        "order_name": order.orderName,
        "order_lat": order.orderLat,
        "order_long": order.orderLong,
        "user_lat": order.userLat,
        "user_long": order.userLong,
        "order_user_id": order.orderUserId,
        "order_date": order.orderDate,
        "order_status": order.orderStatus,
      });
      return const Right("order created successfuly");
    } catch (e) {
      return Left("the error is  :$e");
    }
  }

  Future<Either<String, List<OrderModel>>> getOrders() async {
    try {
      List<OrderModel> orderList = [];
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firebaseFirestore
              .collection("orders")
              .where(
                "order_user_id",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .get();
      for (var element in querySnapshot.docs) {
        orderList.add(OrderModel.fromJson(element.data()));
      }
      return Right(orderList);
    } catch (e) {
      return Left("the error is $e");
    }
  }

  Future<Either<String, String>> updateUserLocation({
    required String orderId,
    required double userLat,
    required double userLong,
  }) async {
    try {
      await firebaseFirestore
          .collection("orders")
          .where("order_id", isEqualTo: orderId)
          .get()
          .then((value) {
            value.docs.first.reference.update({
              "user_lat": userLat,
              "user_long": userLong,
              "order_status": "on the way",
            });
          });
      return const Right("user location updated successfuly");
    } catch (e) {
      return Left("the error is $e");
    }
  }

  Future<Either<String, String>> makeStatusDeliverd({
    required String orderId,
  }) async {
    try {
      await firebaseFirestore
          .collection("orders")
          .where("order_id", isEqualTo: orderId)
          .get()
          .then((value) {
            value.docs.first.reference.update({"order_status": "deliverd"});
          });
      return const Right("user location updated successfuly");
    } catch (e) {
      return Left("the error is $e");
    }
  }

  Future<Either<String, OrderModel>> searhByOrderId({
    required String orderId,
  }) async {
    try {
     DocumentSnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
          .collection("orders")
          .where("order_id", isEqualTo: orderId)
          .get()
          .then((value) => value.docs.first);
          OrderModel orderModel = OrderModel.fromJson(querySnapshot.data()!);

      return  Right(orderModel);
    } catch (e) {
      return Left("the error is $e");
    }
  }
}

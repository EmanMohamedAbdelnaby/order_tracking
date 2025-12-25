import 'dart:async';
import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_tracking/core/styling/app_assets.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/utils/location_services.dart';
import 'package:order_tracking/features/order_screen/cubit/order_state.dart';
import 'package:order_tracking/features/order_screen/cubit/orders_cubit.dart';
import 'package:order_tracking/features/order_screen/model/add_order_model.dart';

class UserTrackMapScreen extends StatefulWidget {
  final OrderModel orderModel;
  const UserTrackMapScreen({super.key, required this.orderModel});

  @override
  State<UserTrackMapScreen> createState() => _UserTrackMapScreenState();
}

class _UserTrackMapScreenState extends State<UserTrackMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  Set<Marker> markers = {};
  LatLng? userCurrentLocation;

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  final String apiKey = "";

  loadMarkerOrderAndUser(OrderModel orderModel) async {
    final Uint8List markerIconOrder = await LocationServices.getBytesFromAsset(
      AppAssets.order,
      50,
    );
    final Uint8List markerIconUser = await LocationServices.getBytesFromAsset(
      AppAssets.truck,
      50,
    );
    final Marker markerOrder = Marker(
      icon: BitmapDescriptor.bytes(markerIconOrder),
      markerId: MarkerId(orderModel.orderId.toString()),
      position: LatLng(orderModel.orderLat ?? 0.0, orderModel.orderLong ?? 0.0),
      onTap: () {
        customInfoWindowController.addInfoWindow!(
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Id : #${widget.orderModel.orderId}",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color.fromARGB(255, 150, 54, 25),
                    ),
                  ),

                  Text(
                    "Order Name : ${widget.orderModel.orderName}",
                    style: TextStyle(fontSize: 12.sp),
                  ),

                  Text("Order Date : ${widget.orderModel.orderDate}"),

                  Text(
                    "Order Status : ${widget.orderModel.orderStatus}",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ),
          LatLng(orderModel.orderLat ?? 0.0, orderModel.orderLong ?? 0.0),
        );
      },
      draggable: true,
      onDrag: (value) {
        // print("Marker 1 Dragged ${value}");
      },
      onDragEnd: (value) {
        print("Marker 1 Dragged Ended ${value}");
      },
    );

    final Marker markerUser = Marker(
      icon: BitmapDescriptor.bytes(markerIconUser),
      markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid.toString()),
      position: userCurrentLocation ?? LatLng(0.0, 0.0),
      onTap: () {
        customInfoWindowController.addInfoWindow!(
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Id : #${widget.orderModel.orderId}",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color.fromARGB(255, 150, 54, 25),
                    ),
                  ),

                  Text(
                    "Order Name : ${widget.orderModel.orderName}",
                    style: TextStyle(fontSize: 12.sp),
                  ),

                  Text("Order Date : ${widget.orderModel.orderDate}"),

                  Text(
                    "Order Status : ${widget.orderModel.orderStatus}",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ),
          LatLng(
            userCurrentLocation?.latitude ?? 0.0,
            userCurrentLocation?.longitude ?? 0.0,
          ),
        );
      },
      draggable: false,
    );
    markers.addAll([markerOrder, markerUser]);

    setState(() {});
  }

  getCurrentPositionAndAnimateToIT() async {
    try {
      userCurrentLocation = LatLng(
        widget.orderModel.userLat ?? 0.0,
        widget.orderModel.userLong ?? 0.0,
      );
      _animateToPosition(
        LatLng(userCurrentLocation!.latitude, userCurrentLocation!.longitude),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _animateToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 16),
      ),
    );
  }

  getLocationThenLoadMarker() async {
    await getCurrentPositionAndAnimateToIT();
    _getPolyline();
    loadMarkerOrderAndUser(widget.orderModel);
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  bool isLoading = false;
  String? errorMessage;
  _getPolyline() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      polylineCoordinates.clear();
      polylines.clear();
    });

    try {
      final result = await polylinePoints.getRouteBetweenCoordinatesV2(
        request: RoutesApiRequest(
          origin: PointLatLng(
            userCurrentLocation!.latitude,
            userCurrentLocation!.longitude,
          ),
          destination: PointLatLng(
            widget.orderModel.orderLat ?? 0.0,
            widget.orderModel.orderLong ?? 0.0,
          ),
        ),
      );

      if (result.primaryRoute?.polylinePoints case List<PointLatLng> points) {
        for (var point in points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        _addPolyLine();
      } else {
        setState(() {
          errorMessage = result.errorMessage ?? 'No route found';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void ListenToOrderUpdate() {
    FirebaseFirestore.instance
        .collection("orders")
        .where("order_id", isEqualTo: widget.orderModel.orderId)
        .snapshots()
        .listen(
          (event) {
            if (event.docs.isNotEmpty) {
              var doc = event.docs.first;
              final data = doc.data();
              OrderModel updateOrder = OrderModel.fromJson(data);
              setState(() {
                userCurrentLocation = LatLng(
                  updateOrder.userLat ?? 0.0,
                  updateOrder.userLong ?? 0.0,
                );
                updateMarkerUser();
                _getPolyline();
              });
            }
          },
          onError: (e) => print("----------------------Listen failed with $e"),
        );
  }

  updateMarkerUser() async {
    final Uint8List markerIconUser = await LocationServices.getBytesFromAsset(
      AppAssets.truck,
      50,
    );
    final Marker markerUser = Marker(
      icon: BitmapDescriptor.bytes(markerIconUser),
      markerId: MarkerId(FirebaseAuth.instance.currentUser!.uid.toString()),
      position: userCurrentLocation ?? LatLng(0.0, 0.0),
      onTap: () {
        customInfoWindowController.addInfoWindow!(
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Id : #${widget.orderModel.orderId}",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color.fromARGB(255, 150, 54, 25),
                    ),
                  ),

                  Text(
                    "Order Name : ${widget.orderModel.orderName}",
                    style: TextStyle(fontSize: 12.sp),
                  ),

                  Text("Order Date : ${widget.orderModel.orderDate}"),

                  Text(
                    "Order Status : ${widget.orderModel.orderStatus}",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ),
          LatLng(
            userCurrentLocation?.latitude ?? 0.0,
            userCurrentLocation?.longitude ?? 0.0,
          ),
        );
      },
      draggable: false,
    );
    markers.remove(markerUser);
    markers.add(markerUser);
    setState(() {});
  }

  @override
  void initState() {
    getLocationThenLoadMarker();

    polylinePoints = PolylinePoints(
      apiKey: "AIzaSyCkBGQUQ08_Vz1jHb__CRvC7PQBHRba0mY",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrderDeliverdstatus) {
            showAnimatedSnackDialog(
              context,
              message: state.message,
              type: AnimatedSnackBarType.success,
            );
            context.pop();
          }
        },
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.terrain,
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.orderModel.orderLat ?? 0.0,
                  widget.orderModel.orderLong ?? 0.0,
                ),
                zoom: 14.16,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                customInfoWindowController.googleMapController = controller;
              },
              onTap: (argument) {
                customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                customInfoWindowController.onCameraMove!();
              },
              markers: markers,
            ),

            // CustomInfoWindow(
            CustomInfoWindow(
              controller: customInfoWindowController,
              height: 200,
              width: 200,
              offset: 50,
            ),
          ],
        ),
      ),
    );
  }
}

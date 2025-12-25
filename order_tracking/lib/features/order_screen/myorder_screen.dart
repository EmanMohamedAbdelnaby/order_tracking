import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/widgets/primay_button_widget.dart';
import 'package:order_tracking/features/order_screen/cubit/order_state.dart';
import 'package:order_tracking/features/order_screen/cubit/orders_cubit.dart';
import 'package:order_tracking/features/order_screen/model/add_order_model.dart';

class MyorderScreen extends StatefulWidget {
  const MyorderScreen({super.key});

  @override
  State<MyorderScreen> createState() => _MyorderScreenState();
}

class _MyorderScreenState extends State<MyorderScreen> {
  @override
  void initState() {
    context.read<OrdersCubit>().getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Orders Screen",
          style: TextStyle(color: AppColors.whiteColor),
        ),
        leading: Container(),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is GettingOrderStatus) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: SizedBox(
                  width: 40.sp,
                  height: 40.sp,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            );
          }
          if (state is ErrorGettingOrder) {
            return Center(child: Text(state.message));
          }
          if (state is SuccessGettingOrder) {
            return Padding(
              padding: EdgeInsets.all(8.sp),
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async {
                  context.read<OrdersCubit>().getOrders();
                },
                child: ListView.builder(
                  itemCount: state.orderList.length,
                  itemBuilder: (context, index) {
                    OrderModel orderModel = state.orderList[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Id : #${orderModel.orderId}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: const Color.fromARGB(255, 150, 54, 25),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Order Name : ${orderModel.orderName}",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            SizedBox(height: 8.h),
                            Text("Order Date : ${orderModel.orderDate}"),
                            SizedBox(height: 8.h),
                            Text(
                              "Order Status : ${orderModel.orderStatus}",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            PrimayButtonWidget(
                              width: double.infinity,
                              height: 50.h,
                              buttonText: "Start Tracking",
                              fontSize: 18.sp,
                              onPress: () {
                                GoRouter.of(context).pushNamed(
                                  AppRoutes.orderTrackMapScreen,
                                  extra: orderModel,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

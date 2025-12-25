import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_assets.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/widgets/custom_text_field.dart';
import 'package:order_tracking/core/widgets/primay_button_widget.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';
import 'package:order_tracking/features/order_screen/cubit/order_state.dart';
import 'package:order_tracking/features/order_screen/cubit/orders_cubit.dart';
import 'package:order_tracking/features/order_screen/model/add_order_model.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController orderIdController = TextEditingController();
  TextEditingController orderNameController = TextEditingController();
  TextEditingController orderDateController = TextEditingController();
  LatLng? orderLocation;
  LatLng? userLocation;
  DateTime? orderArrivalDate;
  String orderLocationDetails = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is SuccessAddingOrder) {
              showAnimatedSnackDialog(
                context,
                message: state.message,
                type: AnimatedSnackBarType.success,
              );
              GoRouter.of(context).pushNamed(AppRoutes.mainScreen);
              orderDateController.clear();
              orderIdController.clear();
              orderNameController.clear();
              orderLocationDetails = "";
              orderArrivalDate = null;
              orderLocation = null;
              userLocation = null;
            }

            if (state is ErrorAddingOrder) {
              showAnimatedSnackDialog(
                context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is AddingOrderStatus) {
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
            return Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(28),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Create Your New order",
                        style: AppStyles.primaryHeadLinesStyle,
                      ),
                    ),
                    const HeightSpace(8),
                    SizedBox(
                      width: 335.w,
                      child: Text(
                        "Let’s create your order.",
                        style: AppStyles.grey12MediumStyle,
                      ),
                    ),
                    const HeightSpace(20),
                    Center(
                      child: Image.asset(
                        AppAssets.order,
                        width: 190.w,
                        height: 190.w,
                      ),
                    ),
                    const HeightSpace(32),
                    Text("Order Id", style: AppStyles.black16w500Style),
                    const HeightSpace(8),

                    CustomTextField(
                      controller: orderIdController,
                      hintText: "Enter Your Order Id",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Order Id";
                        }
                        return null;
                      },
                    ),
                    HeightSpace(8),
                    Text("Order Name", style: AppStyles.black16w500Style),
                    const HeightSpace(8),

                    CustomTextField(
                      controller: orderNameController,
                      hintText: "Enter Your Order Name",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Order Name";
                        }
                        return null;
                      },
                    ),
                    const HeightSpace(8),
                    Text(
                      "Arrival Order Date",
                      style: AppStyles.black16w500Style,
                    ),
                    const HeightSpace(8),

                    CustomTextField(
                      controller: orderDateController,
                      hintText: "Enter Your Arrival Order Date",
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          initialDate: DateTime.now(),
                        ).then((value) {
                          orderArrivalDate = value;
                          if (orderArrivalDate != null) {
                            String dateFormated = DateFormat(
                              "yyy-mm-dd",
                            ).format(orderArrivalDate!);
                            orderDateController.text = dateFormated;
                          }
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Order Date";
                        }
                        return null;
                      },
                    ),
                    HeightSpace(16),
                    PrimayButtonWidget(
                      buttonText: "Select Order Location",
                      icon: Icon(
                        Icons.map_outlined,
                        size: 20,
                        color: AppColors.whiteColor,
                      ),
                      onPress: () async {
                        LatLng? latLng = await context.push<LatLng?>(
                          AppRoutes.placePickerScreen,
                        );
                        if (latLng != null) {
                          orderLocation = latLng;
                          List<Placemark> placeMarks =
                              await placemarkFromCoordinates(
                                orderLocation!.latitude,
                                orderLocation!.longitude,
                              );
                          orderLocationDetails =
                              "${placeMarks.first.country!},${placeMarks.first.locality!},${placeMarks.first.street!}";
                          setState(() {});
                        }
                        log(latLng.toString());
                      },
                    ),
                    const HeightSpace(10),
                    orderLocationDetails.isNotEmpty
                        ? Text(
                            orderLocationDetails,
                            style: AppStyles.black16w500Style,
                          )
                        : SizedBox.shrink(),
                    const HeightSpace(40),
                    PrimayButtonWidget(
                      buttonText: "Create Order",
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          if (orderArrivalDate == null) {
                            showAnimatedSnackDialog(
                              context,
                              message: "Select Order Arrival Date",
                              type: AnimatedSnackBarType.warning,
                            );
                          }
                          if (orderLocation == null) {
                            showAnimatedSnackDialog(
                              context,
                              message: "Select Order Location",
                              type: AnimatedSnackBarType.warning,
                            );
                            orderLocation = LatLng(30.030803, 31.2565769);
                            OrderModel orderModel = OrderModel(
                              orderIdController.text,
                              orderNameController.text,
                              orderLocation!.latitude,
                              orderLocation!.longitude,
                              30.0410569,
                              31.2173309,
                              FirebaseAuth.instance.currentUser!.uid,
                              orderDateController.text,
                              "Not Started",
                            );
                            context.read<OrdersCubit>().addOrder(
                              order: orderModel,
                            );
                          }
                        }
                      },
                    ),
                    const HeightSpace(8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

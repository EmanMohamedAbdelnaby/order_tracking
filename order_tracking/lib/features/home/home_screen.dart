import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text("Home", style: TextStyle(color: AppColors.whiteColor)),
        leading: Container(),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.sp),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.sp,
            crossAxisSpacing: 8.sp,
          ),
          children: [
            InkWell(
              onTap: () {
                GoRouter.of(context).pushNamed(AppRoutes.myOrderScreen);
              },
              child: Container(
                margin: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    "Orders",

                    style: TextStyle(
                      fontSize: 26.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                GoRouter.of(context).pushNamed(AppRoutes.addOrderScreen);
              },
              child: Container(
                margin: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    "Add Order",
                    style: TextStyle(
                      fontSize: 26.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

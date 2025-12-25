import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/utils/service_locator.dart';
import 'package:order_tracking/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking/features/auth/login_screen.dart';
import 'package:order_tracking/features/auth/register_screen.dart';
import 'package:order_tracking/features/home/home_screen.dart';
import 'package:order_tracking/features/order_screen/add_order_screen.dart';
import 'package:order_tracking/features/order_screen/cubit/orders_cubit.dart';
import 'package:order_tracking/features/order_screen/model/add_order_model.dart';
import 'package:order_tracking/features/order_screen/myorder_screen.dart';
import 'package:order_tracking/features/order_screen/order_track_map_screen.dart';
import 'package:order_tracking/features/order_screen/place_picker_screen.dart';
import 'package:order_tracking/features/order_screen/search_myorder_screen.dart';
import 'package:order_tracking/features/order_screen/user_track_map_screen.dart';
import 'package:order_tracking/features/splash_screen/splash_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        name: AppRoutes.splashScreen,
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.mainScreen,
        path: AppRoutes.mainScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRoutes.addOrderScreen,
        path: AppRoutes.addOrderScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<OrdersCubit>(),
          child: const AddOrderScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.placePickerScreen,
        path: AppRoutes.placePickerScreen,
        builder: (context, state) => const PlacePickerScreen(),
      ),
      GoRoute(
        name: AppRoutes.myOrderScreen,
        path: AppRoutes.myOrderScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<OrdersCubit>(),
          child: const MyorderScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.orderTrackMapScreen,
        path: AppRoutes.orderTrackMapScreen,
        builder: (context, state) {
          OrderModel order = state.extra as OrderModel;
          return BlocProvider(
            create: (context) => sl<OrdersCubit>(),
            child: OrderTrackMapScreen(orderModel: order),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.searchOrderScreen,
        path: AppRoutes.searchOrderScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<OrdersCubit>(),
            child: const SearchMyOrderScreen(),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.userTrackMapScreen,
        path: AppRoutes.userTrackMapScreen,
        builder: (context, state) {
          OrderModel order = state.extra as OrderModel;
          return BlocProvider(
            create: (context) => sl<OrdersCubit>(),
            child: UserTrackMapScreen(orderModel: order),
          );
        },
      ),
    ],
  );
}

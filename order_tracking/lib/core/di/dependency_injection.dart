import 'package:get_it/get_it.dart';
import 'package:order_tracking/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking/features/auth/repo/auth_repo.dart';
import 'package:order_tracking/features/order_screen/cubit/orders_cubit.dart';
import 'package:order_tracking/features/order_screen/repo/order_repo.dart';

GetIt sl = GetIt.instance;
Future<void> initDI() async {
  sl.registerSingleton<AuthRepo>(AuthRepo());
  sl.registerLazySingleton<OrderRepo>(() => OrderRepo());


 sl.registerFactory(() => OrdersCubit(sl<OrderRepo>()));
  sl.registerFactory(() => AuthCubit(sl<AuthRepo>()));
}

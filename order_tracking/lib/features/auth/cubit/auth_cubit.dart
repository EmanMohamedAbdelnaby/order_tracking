import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking/core/constants/constants.dart';
import 'package:order_tracking/features/auth/cubit/auth_state.dart';
import 'package:order_tracking/features/auth/repo/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());

  final AuthRepo authRepo;

  void login({required String email, required String password}) async {
    emit(AuthLoding());

    final result = await authRepo.loginUser(password: password, email: email);
    return result.fold(
      (error) {
        emit(AuthError(error));
      },
      (userModel) {
        UserData.userModel = userModel;
        emit(AuthSuccess("Login in successfully"));
      },
    );
  }

  void register({
    required String email,
    required String userName,
    required String password,
  }) async {
    emit(AuthLoding());

    final result = await authRepo.registerUser(password: password,userName: userName, email: email);
    return result.fold(
      (error) {
        emit(AuthError(error));
      },
      (userModel) {
        emit(AuthSuccess("Login in successfully"));
      },
    );
  }
}

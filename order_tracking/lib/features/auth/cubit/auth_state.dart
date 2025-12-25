

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoding extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess(this.message);

}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

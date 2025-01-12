class AuthState {}

class AuthInitial extends AuthState {}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterError extends AuthState {
  final String message;

  RegisterError(this.message);
}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);
}

class LoginWithFingerprintLoading extends AuthState {}

class LoginWithFingerprintSuccess extends AuthState {}

class LoginWithFingerprintError extends AuthState {
  final String message;

  LoginWithFingerprintError(this.message);
}
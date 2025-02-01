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

class LoginWithNfcLoading extends AuthState {}

class LoginWithNfcSuccess extends AuthState {}

class LoginWithNfcError extends AuthState {
  final String message;

  LoginWithNfcError(this.message);
}

class RegisterNfcCardLoading extends AuthState {}

class RegisterNfcCardSuccess extends AuthState {}

class RegisterNfcCardError extends AuthState {
  final String message;

  RegisterNfcCardError(this.message);
}

// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/controller/auth/auth_controller.dart';
import 'package:solitaire/cubit/auth/auth_state.dart';
import 'package:solitaire/utils/network_connectivity.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthController _authController = AuthController();

  Future<void> registerUser(String name, String phone, String email) async {
    emit(RegisterLoading());
    try {
      // check internet connection
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _authController.registerUser(name, phone, email);

        emit(RegisterSuccess());
      } else {
        emit(RegisterError('No internet connection'));
      }
    } catch (e) {
      print('error: $e');
      emit(RegisterError(e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _authController.loginUser(email, password);
        emit(LoginSuccess());
      } else {
        emit(LoginError('No internet connection'));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> loginWithFingerprint(String email) async {
    emit(LoginWithFingerprintLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _authController.loginWithFingerprint(email);
        emit(LoginWithFingerprintSuccess());
      } else {
        emit(LoginWithFingerprintError('No internet connection'));
      }
    } catch (e) {
      emit(LoginWithFingerprintError(e.toString()));
    }
  }

  Future<void> loginWithNfc(String nfcCardId) async {
    emit(LoginWithNfcLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _authController.loginWithNfc(nfcCardId);
        emit(LoginWithNfcSuccess());
      }
    } catch (e) {
      emit(LoginWithNfcError(e.toString()));
    }
  }
}

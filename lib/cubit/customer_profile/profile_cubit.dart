import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/controller/customer_profile/customer_profile_controller.dart';
import 'package:solitaire/cubit/customer_profile/profile_state.dart';
import 'package:solitaire/model/user_model.dart';
import 'package:solitaire/utils/network_connectivity.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final CustomerProfileController _customerProfileController =
      CustomerProfileController();

  static ProfileCubit get(BuildContext context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  num? currentBalance;

  String imageUrl = '';

  Future<void> getCustomerProfile() async {
    emit(ProfileLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        final user = await _customerProfileController.getCustomerProfile();
        nameController.text = user.name ?? '';
        phoneController.text = user.phone ?? '';
        emailController.text = user.email ?? '';
        addressController.text = user.address ?? 'No address';
        imageUrl = user.avatar ?? '';
        currentBalance = user.currentBalance;
        emit(ProfileSuccess(user));
      } else {
        emit(ProfileError('No internet connection'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateCustomerProfile(UserModel user, {File? imageFile}) async {
    emit(ProfileLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _customerProfileController.updateCustomerProfile(user,
            imageFile: imageFile);
        emit(ProfileUpdateSuccess());
      } else {
        emit(ProfileError('No internet connection'));
      }
    } catch (e) {
      emit(ProfileUpdateError(e.toString()));
    }
  }

  Future<void> enableFingerprint(bool value) async {
    emit(FingerprintEnableDisableLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _customerProfileController.enableFingerprint(value);
        await getCustomerProfile();
        emit(FingerprintEnableDisableSuccess());
      } else {
        emit(FingerprintEnableDisableError('No internet connection'));
      }
    } catch (e) {
      emit(FingerprintEnableDisableError(e.toString()));
    }
  }

  Future<void> enableNfc(bool value, String nfcCardId) async {
    emit(NfcEnableDisableLoading());
    try {
      final isConnected = await NetworkConnectivity.instance.checkInternet();

      if (isConnected) {
        await _customerProfileController.enableNfc(value, nfcCardId);
        emit(NfcEnableDisableSuccess());
      } else {
        emit(NfcEnableDisableError('No internet connection'));
      }
    } catch (e) {
      emit(NfcEnableDisableError(e.toString()));
    }
  }
}

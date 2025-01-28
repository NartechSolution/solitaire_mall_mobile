import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire/controller/picker_request/picker_request_controller.dart';
import 'package:solitaire/cubit/picker_request/picker_request_state.dart';
import 'package:solitaire/model/request_status_model.dart';

class PickerRequestCubit extends Cubit<PickerRequestState> {
  final PickerRequestController _pickerRequestController =
      PickerRequestController();
  String currentAddress = '';
  double? currentLatitude;
  double? currentLongitude;

  PickerRequestCubit() : super(PickerRequestInitial());

  void updateLocation(String address, double latitude, double longitude) {
    currentAddress = address;
    currentLatitude = latitude;
    currentLongitude = longitude;
  }

  Future<void> submitRequest(
    String pickerId,
    String location,
    double latitude,
    double longitude,
  ) async {
    emit(PickerRequestLoading());
    try {
      // check internet connection
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(PickerRequestError('No internet connection'));
        return;
      }

      await _pickerRequestController.submitRequest(
        pickerId,
        location,
        latitude,
        longitude,
      );

      emit(PickerRequestSuccess('Request submitted successfully'));
    } catch (e) {
      emit(PickerRequestError(e.toString()));
    }
  }

  List<RequestStatusModel> requestStatus = [];

  Future<void> getRequestStatus() async {
    emit(PickerRequestStatusLoading());
    try {
      // check internet connection
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(PickerRequestStatusError('No internet connection'));
        return;
      }

      final requestStatus = await _pickerRequestController.getRequestStatus();
      this.requestStatus = requestStatus;
      emit(PickerRequestStatusSuccess(requestStatus));
    } catch (e) {
      emit(PickerRequestStatusError(e.toString()));
    }
  }

  Future<void> cancelRequest(String requestId) async {
    emit(PickerRequestCancelLoading());
    try {
      // check internet connection
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(PickerRequestCancelError('No internet connection'));
        return;
      }

      await _pickerRequestController.cancelRequest(requestId);
      emit(PickerRequestCancelSuccess());
    } catch (e) {
      emit(PickerRequestCancelError(e.toString()));
    }
  }
}

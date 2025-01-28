import 'package:solitaire/model/request_status_model.dart';

class PickerRequestState {}

class PickerRequestInitial extends PickerRequestState {}

class PickerRequestLoading extends PickerRequestState {}

class PickerRequestSuccess extends PickerRequestState {
  final String message;

  PickerRequestSuccess(this.message);
}

class PickerRequestError extends PickerRequestState {
  final String message;

  PickerRequestError(this.message);
}

class PickerRequestStatusLoading extends PickerRequestState {}

class PickerRequestStatusSuccess extends PickerRequestState {
  final List<RequestStatusModel> requestStatus;

  PickerRequestStatusSuccess(this.requestStatus);
}

class PickerRequestStatusError extends PickerRequestState {
  final String message;

  PickerRequestStatusError(this.message);
}

class PickerRequestCancelLoading extends PickerRequestState {}

class PickerRequestCancelSuccess extends PickerRequestState {}

class PickerRequestCancelError extends PickerRequestState {
  final String message;

  PickerRequestCancelError(this.message);
}

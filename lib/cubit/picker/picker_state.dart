import 'package:solitaire/model/picker_model.dart';

class PickerState {}

class PickerInitialState extends PickerState {}

class PickerLoadingState extends PickerState {}

class PickerSuccessState extends PickerState {
  final List<PickerModel> pickers;

  PickerSuccessState(this.pickers);
}

class PickerErrorState extends PickerState {
  final String message;

  PickerErrorState(this.message);
}

class PickerReviewLoadingState extends PickerState {}

class PickerReviewSuccessState extends PickerState {}

class PickerReviewErrorState extends PickerState {
  final String message;

  PickerReviewErrorState(this.message);
}

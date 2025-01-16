import 'package:solitaire/model/picker_model.dart';
import 'package:solitaire/services/http_service.dart';

class PickerController {
  final HttpService _httpService = HttpService();

  Future<List<PickerModel>> getPickers(int page, int limit) async {
    final url = "/api/v1/pickers/available?page=$page&limit=$limit";
    final response = await _httpService.request(url, method: HttpMethod.get);

    var pickers = response['data']['pickers'] as List;
    return pickers.map((item) => PickerModel.fromJson(item)).toList();
  }

  Future<void> submitReview(
      String pickerId, double rating, String comments) async {
    final url = "/api/v1/customers/review";
    _httpService.request(
      url,
      method: HttpMethod.post,
      data: {
        "pickerId": pickerId,
        "rating": rating,
        "comment": comments,
      },
      additionalHeaders: {
        "Content-Type": "application/json",
      },
    );
  }
}

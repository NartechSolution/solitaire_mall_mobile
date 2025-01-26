import 'package:solitaire/model/request_status_model.dart';
import 'package:solitaire/services/http_service.dart';
import 'package:solitaire/utils/app_preferences.dart';

class PickerRequestController {
  final HttpService _httpService = HttpService();

  Future<void> submitRequest(
    String pickerId,
    String location,
    double latitude,
    double longitude,
  ) async {
    final token = AppPreferences.getToken();
    final url = "/api/v1/picker-requests/create";
    await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {
        'pickerId': pickerId,
        'location': location,
        'latitude': latitude,
        'longitude': longitude
      },
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<List<RequestStatusModel>> getRequestStatus() async {
    final token = AppPreferences.getToken();
    final url = "/api/v1/picker-requests/customer/status";
    final response = await _httpService.request(
      url,
      method: HttpMethod.get,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print(response['data']['requests']);
    return (response['data']['requests'] as List)
        .map((item) => RequestStatusModel.fromJson(item))
        .toList();
  }
}

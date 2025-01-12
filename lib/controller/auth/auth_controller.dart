import 'package:solitaire/services/http_service.dart';
import 'package:solitaire/utils/app_preferences.dart';

class AuthController {
  final HttpService _httpService = HttpService();

  Future<void> registerUser(String name, String phone, String email) async {
    const url = "/api/v1/customers/register";

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {
        'name': name,
        'phone': phone,
        'email': email,
      },
      additionalHeaders: {
        'Content-Type': 'application/json',
      },
    );

    await AppPreferences.setUserData(
      id: response['data']['id'],
      name: response['data']['name'],
      email: response['data']['email'],
      phone: response['data']['phone'],
      token: response['data']['token'],
      hasNfc: response['data']['hasNfc'] ?? false,
      hasFingerprint: response['data']['hasFingerprint'] ?? false,
    );
  }

  Future<void> loginUser(String email, String password) async {
    const url = "/api/v1/customers/login";

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {
        'email': email,
        'password': password,
      },
      additionalHeaders: {
        'Content-Type': 'application/json',
      },
    );

    await AppPreferences.setUserData(
      id: response['data']['id'],
      name: response['data']['name'],
      email: response['data']['email'],
      phone: response['data']['phone'],
      token: response['data']['token'],
      hasNfc: response['data']['hasNfc'] ?? false,
      hasFingerprint: response['data']['hasFingerprint'] ?? false,
    );
  }

  // login with fingerprint
  Future<void> loginWithFingerprint(String email) async {
    const url = "/api/v1/customers/fingerprint/login";

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {'email': email},
      additionalHeaders: {
        'Content-Type': 'application/json',
      },
    );

    await AppPreferences.setUserData(
      id: response['data']['id'],
      name: response['data']['name'],
      email: response['data']['email'],
      phone: response['data']['phone'],
      token: response['data']['token'],
      hasNfc: response['data']['hasNfc'] ?? false,
      hasFingerprint: response['data']['hasFingerprint'] ?? false,
    );
  }
}

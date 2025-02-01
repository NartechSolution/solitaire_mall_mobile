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

    AppPreferences.setHasFingerprint(response['data']['hasFingerprint']);
    AppPreferences.setHasNfc(response['data']['hasNfcCard']);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);
    AppPreferences.setCurrentBalance(response['data']['currentBalance']);
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

    AppPreferences.setHasFingerprint(response['data']['hasFingerprint']);
    AppPreferences.setHasNfc(response['data']['hasNfcCard']);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);
    AppPreferences.setCurrentBalance(response['data']['currentBalance']);
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

    AppPreferences.setHasFingerprint(response['data']['hasFingerprint']);
    AppPreferences.setHasNfc(response['data']['hasNfcCard']);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);
    AppPreferences.setCurrentBalance(response['data']['currentBalance']);
  }

  Future<void> loginWithNfc(String nfcCardId) async {
    const url = "/api/v1/customers/nfc/login";

    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {'nfcCardId': nfcCardId},
    );

    AppPreferences.setHasFingerprint(response['data']['hasFingerprint']);
    AppPreferences.setHasNfc(response['data']['hasNfcCard']);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);
    AppPreferences.setCurrentBalance(response['data']['currentBalance']);
  }

  Future<void> registerNfcCard(String nfcCardId) async {
    const url = "/api/v1/customers/register/nfc";
    final response = await _httpService.request(
      url,
      method: HttpMethod.post,
      data: {'nfcCardId': nfcCardId},
      additionalHeaders: {
        'Content-Type': 'application/json',
      },
    );

    AppPreferences.setHasFingerprint(response['data']['hasFingerprint']);
    AppPreferences.setHasNfc(response['data']['hasNfcCard']);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setCurrentBalance(response['data']['currentBalance']);
    AppPreferences.setName(response['data']['name']);
  }
}

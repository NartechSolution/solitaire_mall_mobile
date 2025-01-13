import 'dart:convert';

import 'package:solitaire/constants/constant.dart';
import 'package:solitaire/model/user_model.dart';
import 'package:solitaire/services/http_service.dart';
import 'package:solitaire/utils/app_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

class CustomerProfileController {
  final HttpService _httpService = HttpService();

  Future<UserModel> getCustomerProfile() async {
    const url = "/api/v1/customers/profile";

    final response = await _httpService.request(url, method: HttpMethod.get);

    AppPreferences.setHasFingerprint(response['data']['hasFingerprint']);
    AppPreferences.setHasNfc(response['data']['hasNfcCard']);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);

    return UserModel.fromJson(response['data']);
  }

  Future<void> updateCustomerProfile(UserModel user, {File? imageFile}) async {
    final token = AppPreferences.getToken();
    print(token);
    const url = "/api/v1/customers/profile";

    final request =
        http.MultipartRequest('PUT', Uri.parse("${AppUrls.baseUrl}$url"));

    // Add text fields
    request.fields['name'] = user.name ?? '';
    request.fields['email'] = user.email ?? '';
    request.fields['phone'] = user.phone ?? '';
    request.fields['address'] = user.address ?? '';
    request.fields['password'] = user.password ?? '';

    // Add image file if provided
    if (imageFile != null) {
      final imageStream = http.ByteStream(imageFile.openRead());
      final imageLength = await imageFile.length();

      final multipartFile = http.MultipartFile(
        'avatar',
        imageStream,
        imageLength,
        filename: imageFile.path.split('/').last,
        contentType: MediaType(
            'image', 'jpeg'), // Adjust content type based on your needs
      );

      request.files.add(multipartFile);
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  Future<void> enableFingerprint(bool value) async {
    final token = AppPreferences.getToken();
    const url = "/api/v1/customers/fingerprint";
    final response = await _httpService.request(
      url,
      method: HttpMethod.patch,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      data: {
        "enable": value,
      },
    );
    AppPreferences.setHasFingerprint(response['data']['hasFingerprint']);
  }

  Future<void> enableNfc(bool value, String nfcCardId) async {
    final token = AppPreferences.getToken();
    const url = "/api/v1/customers/nfc";

    final response = await _httpService.request(
      url,
      method: HttpMethod.patch,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      data: value == true
          ? {"enable": value, "nfcCardId": nfcCardId}
          : {"enable": value},
    );
    AppPreferences.setHasNfc(response['data']['hasNfcCard']);
  }
}

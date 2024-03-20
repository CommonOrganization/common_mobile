import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants/constants_value.dart';

class HttpService {
  static final HttpService _instance = HttpService._initialize();
  factory HttpService() => _instance;
  HttpService._initialize() {
    log('HttpService Initialized');
  }

  static Future<void> sendEmail({
    required String email,
    required String certifyCode,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    const serviceId = 'service_kbwouod';
    const templateId = 'template_fhs7vkp';
    const userId = 'UB1SvQLjvQV50-rvG';

    await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'email': email,
            'certifyCode': certifyCode,
          }
        },
      ),
    );
  }

  static Future<String?> searchPlaceWithKeyword(String keyword) async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://dapi.kakao.com/v2/local/search/keyword.json?page=1&size=15&sort=accuracy&query=$keyword'),
        headers: {'Authorization': 'KakaoAK $kKakaoRestAPIKey'},
      );
      String? result;
      final placeSearchResult = jsonDecode(res.body);
      List placeList = placeSearchResult['documents'];
      if (placeList.isNotEmpty) {
        if (placeList.first['road_address_name'].isNotEmpty) {
          result = placeList.first['road_address_name'];
        } else {
          result = placeList.first['address_name'];
        }
      }
      return result;
    } catch (e) {
      log('HttpService - searchPlaceWithKeyword Failed : $e');
      return null;
    }
  }
}

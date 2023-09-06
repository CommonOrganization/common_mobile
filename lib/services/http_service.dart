import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants/constants_enum.dart';
import '../constants/constants_value.dart';
import '../utils/local_utils.dart';

class HttpService {
  static final HttpService _instance = HttpService._initialize();
  factory HttpService() => _instance;
  HttpService._initialize() {
    log('HttpService Initialized');
  }

  static Future<bool> sendSMS({
    required String phoneNumber,
    required String certificationNumber,
    required Country country,
  }) async {
    try {
      Map<String, dynamic> data = {
        "type": "SMS",
        "contentType": "COMM",
        "countryCode": country.code.toString(),
        "from": "01037058825", //여기는 발신번호
        "content": "[커먼]인증번호는[$certificationNumber]입니다",
        "messages": [
          {
            "to": phoneNumber, //수신자 번호
            "content": "[커먼]인증번호는[$certificationNumber]입니다", //내용
          }
        ],
      };
      String timeStamp = (DateTime.now().millisecondsSinceEpoch).toString();
      await http.post(
        Uri.parse(
            'https://sens.apigw.ntruss.com/sms/v2/services/$kSENSServiceId/messages'),
        headers: {
          "accept": "application/json",
          'content-Type': 'application/json; charset=UTF-8',
          'x-ncp-apigw-timestamp': timeStamp,
          'x-ncp-iam-access-key': kSENSAccessKey,
          'x-ncp-apigw-signature-v2': getSignatureKey(
            serviceId: kSENSServiceId,
            timeStamp: timeStamp,
            accessKey: kSENSAccessKey,
            secretKey: kSENSSecretKey,
          ),
        },
        body: json.encode(data),
      );
      log('$phoneNumber에게 보낸 메세지 : [커먼]인증번호는[$certificationNumber]입니다');
      return true;
    } catch (e) {
      log('HttpService - sendSMS Failed : $e');
      return false;
    }
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

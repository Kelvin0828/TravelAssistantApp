import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MofaService {
  static const String _baseUrl =
      'https://apis.data.go.kr/1262000/TravelAlarmService2/getTravelAlarmList2';

  // ✨ 에러 식별을 위해 반환 타입을 Nullable로 변경
  static Future<Map<String, String>?> fetchTravelAlarms() async {
    final apiKey = dotenv.env['MOFA_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      print('오류: .env 파일에 MOFA_API_KEY가 설정되지 않았습니다.');
      return null;
    }

    final String url =
        '$_baseUrl?serviceKey=$apiKey&returnType=JSON&numOfRows=300&pageNo=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedData['response'] == null ||
            decodedData['response']['body'] == null ||
            decodedData['response']['body']['items'] == null) {
          return null; // 파싱 불가 시 null 반환
        }

        final items = decodedData['response']['body']['items'];
        if (items == '') return null; // API 통신은 되었으나 데이터가 없는 비정상 상태

        final List<dynamic> itemList = items['item'] ?? [];
        Map<String, String> travelAlarms = {};

        for (var item in itemList) {
          String countryName = item['country_nm'] ?? '';
          String alarmLevel = item['alarm_lvl']?.toString() ?? '';

          if (countryName.isNotEmpty && alarmLevel.isNotEmpty) {
            if (travelAlarms.containsKey(countryName)) {
              int currentLevel = int.tryParse(travelAlarms[countryName]!) ?? 0;
              int newLevel = int.tryParse(alarmLevel) ?? 0;
              if (newLevel > currentLevel) {
                travelAlarms[countryName] = newLevel.toString();
              }
            } else {
              travelAlarms[countryName] = alarmLevel;
            }
          }
        }
        print('=== 여행 경보 파싱 완료 (총 ${travelAlarms.length}개국) ===');
        return travelAlarms;
      } else {
        print('API 통신 실패: 상태 코드 ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('데이터 파싱 중 에러 발생: $e');
      return null;
    }
  }
}
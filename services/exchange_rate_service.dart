// lib/Project/services/exchange_rate_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeRateService {
  static const String _cacheKey = 'exchange_rates_cache';
  static const String _dateKey = 'exchange_rates_date';

  // 🚀 KRW(원화) 기준 전 세계 환율 데이터를 가져옵니다.
  static Future<Map<String, dynamic>> fetchRates() async {
    final prefs = await SharedPreferences.getInstance();

    // 매일 환율이 달라지므로, 날짜(YYYY-MM-DD)를 기준으로 캐싱합니다.
    final today = DateTime.now().toIso8601String().split('T')[0];
    final cachedDate = prefs.getString(_dateKey);

    // 오늘 이미 환율을 가져왔다면 API를 호출하지 않고 캐시를 씁니다.
    if (cachedDate == today && prefs.containsKey(_cacheKey)) {
      final cachedData = prefs.getString(_cacheKey);
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }
    }

    try {
      // 회원가입이 필요 없는 무료 환율 API (원화 기준)
      final response = await http.get(Uri.parse('https://open.er-api.com/v6/latest/KRW'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        // 새 환율 정보 캐시에 저장
        prefs.setString(_cacheKey, jsonEncode(rates));
        prefs.setString(_dateKey, today);
        print('🌐 [환율 API] 최신 환율 정보를 성공적으로 업데이트했습니다.');
        return rates;
      }
    } catch (e) {
      print('❌ 환율 정보 로드 실패: $e');
    }

    // 통신 실패 시 어제 저장해둔 캐시라도 끌어와서 사용합니다.
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      return jsonDecode(cachedData);
    }

    return {}; // 완전히 실패했을 경우 빈 맵 리턴
  }
}
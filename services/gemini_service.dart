// lib/Project/services/gemini_service.dart

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../models/travel_models.dart';

class GeminiService {
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  late final GenerativeModel model;

  final bool useDummyData = false;

  DateTime _lastRequestTime = DateTime.fromMillisecondsSinceEpoch(0);
  final int _cooldownSeconds = 5;
  final int _cacheValidDurationDays = 30;

  GeminiService() {
    model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
  }

  Future<void> _rateLimitWait() async {
    final now = DateTime.now();
    final difference = now.difference(_lastRequestTime).inSeconds;

    if (difference < _cooldownSeconds) {
      final waitTime = _cooldownSeconds - difference;
      await Future.delayed(Duration(seconds: waitTime));
    }
    _lastRequestTime = DateTime.now();
  }

  dynamic _parseJson(String responseText) {
    try {
      final regex = RegExp(r'(\{.*\}|\[.*\])', dotAll: true);
      final match = regex.firstMatch(responseText);

      if (match != null) {
        return jsonDecode(match.group(0)!);
      } else {
        throw Exception('JSON 형식을 찾을 수 없습니다.');
      }
    } catch (e) {
      print('JSON 파싱 에러: $e\n원본 텍스트: $responseText');
      throw Exception('JSON parsing failed');
    }
  }

  Future<String> _generateWithRetry(String prompt, {int maxRetries = 2}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        await _rateLimitWait();

        final response = await model.generateContent([Content.text(prompt)])
            .timeout(const Duration(seconds: 60));

        if (response.text != null && response.text!.isNotEmpty) {
          return response.text!;
        }
      } catch (e) {
        print('API 호출 실패 (시도 ${i + 1}/$maxRetries): $e');
        if (i == maxRetries - 1) {
          throw Exception('API 호출 최종 실패');
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    throw Exception('API 호출 최종 실패');
  }

  Future<CityDetails> fetchCityDetails(String city, {bool forceRefresh = false}) async {
    if (useDummyData) {
      await Future.delayed(const Duration(seconds: 1));
      return CityDetails(
          accommodations: ["가짜 호텔 (시내 중심) - 200000원 [링크: https://google.com]"],
          sightseeings: ["가짜 랜드 마크 1 (전망대) - 15000원 [휴무: 화요일]"],
          restaurants: ["가짜 맛집 1 (파스타) - 25000원"],
          cafes: ["가짜 카페 1 (디저트) - 8000원"],
          arts: ["가짜 미술관 1 (인상주의) - 12000원 [휴무: 월요일]"],
          shopping: ["가짜 쇼핑몰 1 (기념품) - 50000원"],
          parks: ["가짜 공원 1 (피크닉) - 0원"],
          viewpoints: ["가짜 뷰포인트 1 (전경) - 0원"],
          averageBudget: "약 150,000원 (1인 1일 기준)",
          itinerary: ["1일차: 아침(A) - 점심(B) - 오후(C) - 저녁(D)"],
          bestSeason: "3~5월",
          currencyCode: "USD",
          coordinates: {"가짜 랜드 마크 1": [37.5, 126.9], "가짜 호텔": [37.51, 126.91]}
      );
    }

    final prefs = await SharedPreferences.getInstance();

    // ✨ 숙소 카테고리 및 프롬프트 대폭 변경으로 인해 v8 적용
    final cacheKey = 'city_details_v8_$city';

    if (!forceRefresh && prefs.containsKey(cacheKey)) {
      final cachedDataStr = prefs.getString(cacheKey);
      if (cachedDataStr != null) {
        try {
          final cachedObj = jsonDecode(cachedDataStr);
          if (cachedObj.containsKey('timestamp') && cachedObj.containsKey('data')) {
            final savedTime = DateTime.fromMillisecondsSinceEpoch(cachedObj['timestamp']);
            if (DateTime.now().difference(savedTime).inDays < _cacheValidDurationDays) {
              print('✅ [$city] 유효한 v8 캐시 데이터를 불러옵니다.');
              return CityDetails.fromJson(cachedObj['data']);
            } else {
              print('🔄 [$city] 캐시가 만료되어 새로 데이터를 불러옵니다.');
            }
          } else {
            print('🔄 [$city] 구형 캐시 발견, 새로 데이터를 불러옵니다.');
          }
        } catch(e) {
          print('캐시 데이터 파싱 오류, 새로 불러옵니다: $e');
        }
      }
    }

    // ✨ 프롬프트에 휴무일 경고, 숙소 예약 링크 지시사항 추가
    final prompt = '''
    Create a travel guide for $city. Output ONLY JSON.
    Provide 7 items per category. Keep descriptions under 15 words.
    CRITICAL 1: Append the estimated cost in KRW at the end of EACH place string using ' - [price]원'. If free, write ' - 0원'. For accommodations, provide price per night.
    CRITICAL 2: You MUST provide a "coordinates" object containing the exact [latitude, longitude] array for EVERY single place you generated (including accommodations). The key must exactly match the Place Name (excluding the description and price).
    CRITICAL 3: If a place has a known closed day, append '[휴무: 요일]' at the very end. Example: "루브르 박물관 (모나리자) - 25000원 [휴무: 화요일]"
    CRITICAL 4: For accommodations, append a booking link or Google Maps link using '[링크: URL]'. Example: "힐튼 파리 (시내 중심) - 300000원 [링크: https://www.google.com/...]"
    All generated text MUST be in Korean (한국어).
    {
      "best_season": "e.g., 3~5월 (봄 날씨)",
      "currency_code": "e.g., JPY, EUR, THB, USD (Must be 3-letter ISO code for the local currency)",
      "accommodations": ["Acc 1 (desc) - 150000원 [링크: URL]", "Acc 2", "Acc 3", "Acc 4", "Acc 5", "Acc 6", "Acc 7"],
      "sightseeings": ["Landmark 1 (desc) - 15000원 [휴무: 월요일]", "Landmark 2", "Landmark 3", "Landmark 4", "Landmark 5", "Landmark 6", "Landmark 7"],
      "restaurants": ["Rest 1 (desc) - 25000원", "Rest 2", "Rest 3", "Rest 4", "Rest 5", "Rest 6", "Rest 7"],
      "cafes": ["Cafe 1 (desc) - 8000원", "Cafe 2", "Cafe 3", "Cafe 4", "Cafe 5", "Cafe 6", "Cafe 7"],
      "arts": ["Art 1 (desc) - 12000원 [휴무: 월요일]", "Art 2", "Art 3", "Art 4", "Art 5", "Art 6", "Art 7"],
      "shopping": ["Shop 1 (desc) - 0원", "Shop 2", "Shop 3", "Shop 4", "Shop 5", "Shop 6", "Shop 7"],
      "parks": ["Park 1 (desc) - 0원", "Park 2", "Park 3", "Park 4", "Park 5", "Park 6", "Park 7"],
      "viewpoints": ["View 1 (desc) - 0원", "View 2", "View 3", "View 4", "View 5", "View 6", "View 7"],
      "coordinates": {
        "Landmark 1": [37.5511, 126.9882],
        "Acc 1": [37.5665, 126.9780]
      },
      "average_budget": "e.g., 약 150,000원 (1인 1일)",
      "itinerary": [
        "1일차: 아침(Place) - 점심(Place) - 오후(Place) - 저녁(Place)",
        "2일차: 아침(Place) - 점심(Place) - 오후(Place) - 저녁(Place)",
        "3일차: 아침(Place) - 점심(Place) - 오후(Place) - 저녁(Place)"
      ]
    }
    ''';

    try {
      final String rawText = await _generateWithRetry(prompt);
      final dynamic parsedJson = _parseJson(rawText);

      final saveData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': parsedJson,
      };
      prefs.setString(cacheKey, jsonEncode(saveData));
      print('🚀 [$city] 새 API 데이터를 가져와 캐시에 저장했습니다.');

      return CityDetails.fromJson(parsedJson);

    } catch (e) {
      print('❌ [$city] 데이터 로드 완전 실패, 더미 데이터로 대체합니다.');
      return CityDetails(
          accommodations: ["데이터 로드 실패 - 0원"],
          sightseeings: ["데이터 로드 실패 - 0원"],
          restaurants: ["- 0원"],
          cafes: ["- 0원"],
          arts: ["- 0원"],
          shopping: ["- 0원"],
          parks: ["- 0원"],
          viewpoints: ["- 0원"],
          averageBudget: "알 수 없음",
          itinerary: ["-"],
          bestSeason: "알 수 없음",
          currencyCode: "USD",
          coordinates: {}
      );
    }
  }

  Future<List<String>> optimizeRoute(String city, List<String> places) async {
    if (useDummyData || places.length <= 1) {
      await Future.delayed(const Duration(milliseconds: 500));
      return places;
    }

    final placesStr = places.join(', ');
    final prompt = '''
    Reorder these places in $city by shortest geographical route: $placesStr.
    Output ONLY a JSON array of strings containing these exact places.
    All text must remain in Korean.
    ''';

    try {
      final String rawText = await _generateWithRetry(prompt, maxRetries: 1);
      final List<dynamic> parsedList = _parseJson(rawText);
      List<String> sortedPlaces = parsedList.map((e) => e.toString()).toList();

      for (var p in places) {
        if (!sortedPlaces.contains(p)) sortedPlaces.add(p);
      }
      return sortedPlaces;

    } catch (e) {
      print('❌ 경로 최적화 실패, 원래 순서를 유지합니다.');
      return places;
    }
  }
}
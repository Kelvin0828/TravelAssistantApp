// lib/Project/screens/city_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/gemini_service.dart';
import '../services/exchange_rate_service.dart';
import '../models/travel_models.dart';
import '../widgets/travel_loading_widget.dart';

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// 캐시 변수들은 상태가 초기화되어도 유지되도록 전역으로 선언
final Map<String, Map<int, Map<String, List<String>>>> _customItineraryCache = {};
final Map<String, Map<int, String>> _basecampCache = {};
final Map<String, Map<String, int>> _customPlacePricesCache = {};
final Map<String, Map<String, LatLng>> _customPlaceCoordsCache = {};

class CityDetailScreen extends StatefulWidget {
  final String cityName;

  const CityDetailScreen({super.key, required this.cityName});

  @override
  _CityDetailScreenState createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  final GeminiService _apiService = GeminiService();
  Future<CityDetails>? _cityDetailsFuture;

  Map<String, dynamic> _exchangeRates = {};
  final GlobalKey _repaintKey = GlobalKey();
  final MapController _mapController = MapController();

  List<String> _allAssets = [];
  String _lastMapPointsHash = '';

  String _selectedCategory = '숙소';
  final List<String> _categories = [
    '숙소', '랜드 마크', '맛집', '카페', '미술관', '쇼핑', '공원', '뷰포인트'
  ];

  String _selectedItineraryType = 'AI 추천 일정';
  final List<String> _itineraryTypes = ['AI 추천 일정', '나만의 DIY 일정'];
  int _itineraryDayIndex = 0;

  DateTime? _startDate;
  DateTime? _endDate;
  int _totalDays = 2;

  late Map<int, Map<String, List<String>>> _myCustomItinerary;
  late Map<String, int> _myCustomPrices;
  late Map<String, LatLng> _myCustomCoords;
  final Set<String> _addedPlaces = {};

  bool _isOptimizingRoute = false;

  late Map<int, String> _basecamps;
  final Map<String, TextEditingController> _memoControllers = {};

  final Map<String, String> _cityEngMap = {
    // 유럽
    '파리': 'Paris', '니스': 'Nice', '리옹': 'Lyon', '마르세유': 'Marseille', '안시': 'Annecy', '콜마르': 'Colmar', '몽생미셸': 'Mont Saint-Michel', '아비뇽': 'Avignon',
    '로마': 'Rome', '피렌체': 'Florence', '베네치아': 'Venice', '밀라노': 'Milan', '친퀘테레': 'Cinque Terre', '시에나': 'Siena', '포지타노': 'Positano', '돌로미티': 'Dolomites',
    '인터라켄': 'Interlaken', '루체른': 'Lucerne', '취리히': 'Zurich', '그린델발트': 'Grindelwald', '체르마트': 'Zermatt', '몽트뢰': 'Montreux',
    '마드리드': 'Madrid', '바르셀로나': 'Barcelona', '세비야': 'Seville', '론다': 'Ronda', '톨레도': 'Toledo', '그라나다': 'Granada', '이비자': 'Ibiza',
    '런던': 'London', '에든버러': 'Edinburgh', '맨체스터': 'Manchester', '바스': 'Bath', '코츠월드': 'Cotswolds', '옥스퍼드': 'Oxford',
    '베를린': 'Berlin', '뮌헨': 'Munich', '프랑크푸르트': 'Frankfurt', '하이델베르크': 'Heidelberg', '로텐부르크': 'Rothenburg', '퓌센': 'Füssen',
    '프라하': 'Prague', '체스키크룸로프': 'Cesky Krumlov', '브르노': 'Brno', '카를로비바리': 'Karlovy Vary', '플젠': 'Pilsen', '올로모우츠': 'Olomouc', '텔치': 'Telc', '리베레츠': 'Liberec', '오스트라바': 'Ostrava', '파르두비체': 'Pardubice', '즈노이모': 'Znojmo',
    '부다페스트': 'Budapest', '데브레첸': 'Debrecen', '세게드': 'Szeged', '페치': 'Pecs', '에게르': 'Eger', '죄르': 'Gyor', '쇼프론': 'Sopron', '케치케메트': 'Kecskemet', '미슈콜츠': 'Miskolc', '세케슈페헤르바르': 'Szekesfehervar', '에스테르곰': 'Esztergom',
    '두브로브니크': 'Dubrovnik', '스플리트': 'Split', '자그레브': 'Zagreb', '자다르': 'Zadar', '로빈': 'Rovinj', '시베니크': 'Sibenik', '풀라': 'Pula', '바라주딘': 'Varazdin', '오시예크': 'Osijek', '트로기르': 'Trogir', '리예카': 'Rijeka',
    '이스탄불': 'Istanbul', '안탈리아': 'Antalya', '이즈미르': 'Izmir', '괴레메/카파도키아': 'Goreme / Cappadocia', '보드룸': 'Bodrum', '쿠샤다스': 'Kusadasi', '부르사': 'Bursa', '콘야': 'Konya', '에스키셰히르': 'Eskisehir', '트라브존': 'Trabzon', '마르딘': 'Mardin', '샨르우르파': 'Sanliurfa',
    '아테네': 'Athens', '테살로니키': 'Thessaloniki', '산토리니': 'Santorini', '미코노스': 'Mykonos', '로도스': 'Rhodes', '이라클리온': 'Heraklion', '이오안니나': 'Ioannina', '카발라': 'Kavala', '나플리오': 'Nafplio', '파트라': 'Patras', '볼로스': 'Volos', '칼라마타': 'Kalamata',
    '암스테르담': 'Amsterdam', '로테르담': 'Rotterdam', '헤이그': 'The Hague', '위트레흐트': 'Utrecht', '마스트리흐트': 'Maastricht', '흐로닝언': 'Groningen', '델프트': 'Delft', '하를럼': 'Haarlem', '라이덴': 'Leiden', '아인트호벤': 'Eindhoven', '즈볼러': 'Zwolle',
    '브뤼셀': 'Brussels', '브뤼헤': 'Bruges', '안트베르펜': 'Antwerp', '겐트': 'Ghent', '루벤': 'Leuven', '메헬렌': 'Mechelen', '나뮈르': 'Namur', '디낭': 'Dinant', '리에주': 'Liege', '몽스': 'Mons', '이프르': 'Ypres', '오스텐더': 'Ostend',
    '리스본': 'Lisbon', '포르투': 'Porto', '파루': 'Faro', '코임브라': 'Coimbra', '브라가': 'Braga', '신트라': 'Sintra', '기마랑이스': 'Guimaraes', '에보라': 'Evora', '나자레': 'Nazare', '오비두스': 'Obidos', '아베이루': 'Aveiro', '비제우': 'Viseu',
    '스톡홀름': 'Stockholm', '예테보리': 'Gothenburg', '말뫼': 'Malmo', '웁살라': 'Uppsala', '비스뷔': 'Visby', '키루나': 'Kiruna', '룬드': 'Lund', '외레브로': 'Orebro', '우메오': 'Umea', '룰레오': 'Lulea', '칼마르': 'Kalmar', '베스테로스': 'Vasteras',
    // 남아메리카
    '리우데자네이루': 'Rio de Janeiro', '상파울루': 'Sao Paulo', '이구아수': 'Iguazu', '파라티': 'Paraty',
    '부에노스아이레스': 'Buenos Aires', '바릴로체': 'Bariloche', '우수아이아': 'Ushuaia', '엘 칼라파테': 'El Calafate',
    '리마': 'Lima', '쿠스코': 'Cusco', '마추픽추': 'Machu Picchu', '우루밤바': 'Urubamba',
    '산티아고': 'Santiago', '발파라이소': 'Valparaiso', '산페드로데아타카마': 'San Pedro de Atacama', '푸에르토 나탈레스': 'Puerto Natales',
    '보고타': 'Bogota', '메데인': 'Medellin', '카르타헤나': 'Cartagena', '살렌토': 'Salento',
    // 북아메리카
    '뉴욕': 'New York', '로스앤젤레스': 'Los Angeles', '시카고': 'Chicago', '라스베이거스': 'Las Vegas', '샌프란시스코': 'San Francisco', '워싱턴 D.C.': 'Washington D.C.', '보스턴': 'Boston', '마이애미': 'Miami', '올랜도': 'Orlando', '시애틀': 'Seattle', '호놀룰루': 'Honolulu', '샌디에이고': 'San Diego', '필라델피아': 'Philadelphia', '애틀랜타': 'Atlanta', '뉴올리언스': 'New Orleans', '내슈빌': 'Nashville', '댈러스': 'Dallas', '휴스턴': 'Houston', '포틀랜드': 'Portland', '덴버': 'Denver', '보이시': 'Boise', '덜루스': 'Duluth', '유레카': 'Eureka', '포트 웨인': 'Fort Wayne', '녹스빌': 'Knoxville', '오클라호마시티': 'Oklahoma City', '위치타': 'Wichita', '디모인': 'Des Moines', '링컨': 'Lincoln', '시더래피즈': 'Cedar Rapids', '수폴스': 'Sioux Falls',
    '토론토': 'Toronto', '밴쿠버': 'Vancouver', '몬트리올': 'Montreal', '나이아가라 폴스': 'Niagara Falls', '퀘벡시티': 'Quebec City', '오타와': 'Ottawa', '캘거리': 'Calgary', '빅토리아': 'Victoria', '위니펙': 'Winnipeg', '에드먼턴': 'Edmonton', '핼리팩스': 'Halifax', '휘슬러': 'Whistler', '트로아 리비에르': 'Trois-Rivieres', '선더베이': 'Thunder Bay', '레드 디어': 'Red Deer', '멍크턴': 'Moncton', '서드베리': 'Sudbury', '캠루프스': 'Kamloops', '세인트 존': 'Saint John', '구엘프': 'Guelph', '브랜던': 'Brandon', '코너 브룩': 'Corner Brook', '프린스 조지': 'Prince George', '무스 조': 'Moose Jaw',
    '멕시코시티': 'Mexico City', '칸쿤': 'Cancun', '툴룸': 'Tulum', '카보산루카스': 'Cabo San Lucas', '파라초': 'Paracho', '파랄': 'Parral', '틀락스칼라': 'Tlaxcala', '콜리마': 'Colima',
    '아바나': 'Havana', '바라데로': 'Varadero', '트리니다드': 'Trinidad', '비냘레스(마을)': 'Vinales (Town)', '라스 투나스': 'Las Tunas', '바야모': 'Bayamo', '마탄사스': 'Matanzas', '구아네': 'Guane',
    // 아프리카
    '카이로': 'Cairo', '룩소르': 'Luxor', '아스완': 'Aswan', '다합': 'Dahab',
    '마라케시': 'Marrakech', '카사블랑카': 'Casablanca', '페스': 'Fes', '쉐프샤우엔': 'Chefchaouen', '메르주가': 'Merzouga',
    '케이프타운': 'Cape Town', '크루거 국립공원': 'Kruger National Park',
    // 오세아니아
    '시드니': 'Sydney', '멜버른': 'Melbourne', '브리즈번': 'Brisbane', '바이런 베이': 'Byron Bay', '울룰루': 'Uluru', '태즈메이니아': 'Tasmania',
    '오클랜드': 'Auckland', '퀸스타운': 'Queenstown', '테카포': 'Tekapo', '로토루아': 'Rotorua',
    // 아시아
    '서울': 'Seoul', '부산': 'Busan', '제주도': 'Jeju Island', '경주': 'Gyeongju', '강릉': 'Gangneung', '안동': 'Andong', '전주': 'Jeonju',
    '도쿄': 'Tokyo', '오사카': 'Osaka', '후쿠오카': 'Fukuoka', '교토': 'Kyoto', '오키나와': 'Okinawa', '삿포로': 'Sapporo', '가나자와': 'Kanazawa', '유후인': 'Yufuin', '다카마쓰': 'Takamatsu', '구라시키': 'Kurashiki',
    '베이징': 'Beijing', '상하이': 'Shanghai', '광저우': 'Guangzhou', '장자제 (장가계)': 'Zhangjiajie', '리장': 'Lijiang', '구이린 (계림)': 'Guilin',
    '타이베이': 'Taipei', '가오슝': 'Kaohsiung', '타이난': 'Tainan', '화롄': 'Hualien', '지우펜': 'Jiufen',
    '홍콩섬 (센트럴)': 'Hong Kong Island (Central)', '구룡반도 (침사추이)': 'Kowloon Peninsula (Tsim Sha Tsui)',
    '다낭': 'Da Nang', '호치민': 'Ho Chi Minh City', '하노이': 'Hanoi', '나트랑': 'Nha Trang', '달랏': 'Da Lat', '사파': 'Sa Pa', '호이안': 'Hoi An', '푸꾸옥': 'Phu Quoc',
    '방콕': 'Bangkok', '푸껫': 'Phuket', '파타야': 'Pattaya', '치앙마이': 'Chiang Mai', '빠이': 'Pai', '코사무이': 'Koh Samui', '끄라비': 'Krabi',
    '발리': 'Bali', '자카르타': 'Jakarta', '우붓 (발리 내륙)': 'Ubud (Inland Bali)', '롬복': 'Lombok', '족자카르타': 'Yogyakarta',
    '쿠알라룸푸르': 'Kuala Lumpur', '코타키나발루': 'Kota Kinabalu', '페낭': 'Penang', '말라카': 'Malacca', '랑카위': 'Langkawi',
    '마리나 베이': 'Marina Bay', '오차드 로드': 'Orchard Road', '센토사': 'Sentosa', '차이나타운': 'Chinatown', '림추캉': 'Lim Chu Kang', '풍골': 'Punggol', '투아스': 'Tuas', '파야레바': 'Paya Lebar',
    '마닐라': 'Manila', '세부': 'Cebu', '보라카이': 'Boracay', '팔라완': 'Palawan', '타클로반': 'Tacloban', '카가얀데오로': 'Cagayan de Oro', '바콜로드': 'Bacolod', '잠보앙가': 'Zamboanga',
    '프놈펜': 'Phnom Penh', '씨엠립': 'Siem Reap', '시아누크빌': 'Sihanoukville', '바탐방': 'Battambang', '스퉁트렝': 'Stung Treng', '라타나키리': 'Ratanakiri', '몬돌끼리': 'Mondulkiri', '캄퐁톰': 'Kampong Thom',
    '델리': 'Delhi', '뭄바이': 'Mumbai', '자이푸르': 'Jaipur', '아그라': 'Agra', '파트나': 'Patna', '랑푸르': 'Rangpur', '간디나가르': 'Gandhinagar', '보팔': 'Bhopal',
    '두바이': 'Dubai', '아부다비': 'Abu Dhabi', '샤르자': 'Sharjah', '라스알카이마': 'Ras Al Khaimah', '푸자이라': 'Fujairah', '움알쿠와인': 'Umm Al Quwain', '알다이드': 'Al Dhaid', '무와일리 (Muwailih)': 'Muwailih',
  };

  @override
  void initState() {
    super.initState();
    _loadAssets();
    _loadData(forceRefresh: false);
    _initializeCustomItinerary(_totalDays);
    _loadExchangeRates();
  }

  Future<void> _loadAssets() async {
    try {
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      setState(() {
        _allAssets = manifest.listAssets();
      });
    } catch (e) {
      print('에셋 로드 실패: $e');
    }
  }

  String? _getCityImagePath(String koreanCityName) {
    String engName = _cityEngMap[koreanCityName] ?? '';
    if (engName.isEmpty) return null;

    String safeEngName = engName.replaceAll('/', '').replaceAll('  ', ' ').trim().toLowerCase();

    try {
      final matchedPath = _allAssets.firstWhere((path) {
        String lowerPath = path.toLowerCase();
        bool isInCitiesFolder = lowerPath.contains('images/cities/');
        String fileName = lowerPath.split('/').last;
        bool isMatchingName = fileName.startsWith('$safeEngName.');
        return isInCitiesFolder && isMatchingName;
      });
      return matchedPath;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    for (var controller in _memoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getMemoController(String key) {
    if (!_memoControllers.containsKey(key)) {
      _memoControllers[key] = TextEditingController();
    }
    return _memoControllers[key]!;
  }

  void _loadExchangeRates() async {
    final rates = await ExchangeRateService.fetchRates();
    if (mounted) {
      setState(() {
        _exchangeRates = rates;
      });
    }
  }

  void _initializeCustomItinerary(int days) {
    if (!_customItineraryCache.containsKey(widget.cityName)) {
      _customItineraryCache[widget.cityName] = {};
    }
    var cityMap = _customItineraryCache[widget.cityName]!;
    for (int i = 0; i < days; i++) {
      if (!cityMap.containsKey(i)) {
        cityMap[i] = {'아침': [], '점심': [], '오후': [], '저녁': []};
      }
    }
    _myCustomItinerary = cityMap;

    if (!_basecampCache.containsKey(widget.cityName)) {
      _basecampCache[widget.cityName] = {};
    }
    _basecamps = _basecampCache[widget.cityName]!;

    if (!_customPlacePricesCache.containsKey(widget.cityName)) {
      _customPlacePricesCache[widget.cityName] = {};
    }
    _myCustomPrices = _customPlacePricesCache[widget.cityName]!;

    if (!_customPlaceCoordsCache.containsKey(widget.cityName)) {
      _customPlaceCoordsCache[widget.cityName] = {};
    }
    _myCustomCoords = _customPlaceCoordsCache[widget.cityName]!;

    _syncAddedPlacesSet();
  }

  void _syncAddedPlacesSet() {
    _addedPlaces.clear();
    for (int i = 0; i < _totalDays; i++) {
      if (_myCustomItinerary.containsKey(i)) {
        for (var places in _myCustomItinerary[i]!.values) {
          _addedPlaces.addAll(places);
        }
      }
      if (_basecamps.containsKey(i)) {
        _addedPlaces.add(_basecamps[i]!);
      }
    }
  }

  void _loadData({required bool forceRefresh}) {
    setState(() {
      _cityDetailsFuture = Future.wait([
        _apiService.fetchCityDetails(widget.cityName, forceRefresh: forceRefresh),
        if (forceRefresh || !_apiService.useDummyData) Future.delayed(const Duration(milliseconds: 2500)),
      ]).then((results) => results[0] as CityDetails);
    });
  }

  int _extractPrice(String placeString) {
    final match = RegExp(r'-\s*(?:약\s*)?([0-9,]+)\s*원?').firstMatch(placeString);
    if (match != null) {
      return int.tryParse(match.group(1)!.replaceAll(',', '')) ?? 0;
    }
    return 0;
  }

  String _getClosedDay(String fullText) {
    final match = RegExp(r'\[휴무:\s*(.*?)\]').firstMatch(fullText);
    return match?.group(1) ?? '';
  }

  String? _getOriginalPlaceString(String cleanName, CityDetails details) {
    final allLists = [details.sightseeings, details.restaurants, details.cafes, details.arts, details.shopping, details.parks, details.viewpoints, details.accommodations];
    for (var list in allLists) {
      for (var item in list) {
        if (item.split(RegExp(r'[\(\-]')).first.trim() == cleanName) return item;
      }
    }
    return null;
  }

  void _confirmRefresh() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('새로운 추천 받기 🔄'),
            content: const Text('현재 추천된 장소들이 마음에 들지 않으신가요?\nAI에게 새로운 장소들을 추천해달라고 요청할 수 있습니다.'),
            actions: [
              CupertinoDialogAction(child: const Text('취소', style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.pop(context)),
              CupertinoDialogAction(isDefaultAction: true, child: const Text('새로 추천받기'), onPressed: () { Navigator.pop(context); _loadData(forceRefresh: true); }),
            ],
          );
        }
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: '여행 기간을 선택해주세요',
      saveText: '확인',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: CupertinoColors.activeBlue, onPrimary: Colors.white, surface: Colors.white, onSurface: Colors.black)),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _totalDays = picked.end.difference(picked.start).inDays + 1;
        _initializeCustomItinerary(_totalDays);
        _syncAddedPlacesSet();

        if (_itineraryDayIndex >= _totalDays) {
          _itineraryDayIndex = _totalDays - 1;
        }
      });
    }
  }

  // ✨ 해결 2 & 3: 완벽한 좌표 매칭 로직 (Fuzzy Match 및 커스텀 괄호 처리 포함)
  LatLng? _getCoordinatesForPlace(String placeName, CityDetails details) {
    final cleanName = placeName.split(RegExp(r'[\(\-]')).first.trim();

    // 1. 커스텀 장소 전체 이름(placeName) 우선 확인 (괄호, 하이픈 포함 이슈 완벽 해결)
    if (_myCustomCoords.containsKey(placeName)) return _myCustomCoords[placeName];

    // 2. 커스텀 장소 cleanName 확인
    if (_myCustomCoords.containsKey(cleanName)) return _myCustomCoords[cleanName];

    // 3. AI 응답 데이터에서 정확히 일치하는지 확인
    if (details.coordinates.containsKey(cleanName)) {
      final c = details.coordinates[cleanName]!;
      if (c.length >= 2) return LatLng(c[0], c[1]);
    }

    // 4. AI 응답 데이터에서 유사 검색 (이름이 살짝 다를 경우, 설명이 붙은 경우 대비)
    for (String key in details.coordinates.keys) {
      if (key.startsWith(cleanName) || cleanName.startsWith(key) ||
          key.contains(cleanName) || cleanName.contains(key)) {
        final c = details.coordinates[key]!;
        if (c.length >= 2) return LatLng(c[0], c[1]);
      }
    }

    return null;
  }

  void _optimizeCurrentDayRoute(CityDetails details) {
    final dayPlan = _myCustomItinerary[_itineraryDayIndex]!;
    List<String> allPlaces = [];
    List<int> counts = [];

    for (var time in ['아침', '점심', '오후', '저녁']) {
      allPlaces.addAll(dayPlan[time]!);
      counts.add(dayPlan[time]!.length);
    }

    if (allPlaces.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('동선을 정렬하려면 장소가 2개 이상 필요해요!')));
      return;
    }

    final currentBasecamp = _basecamps[_itineraryDayIndex];
    if (currentBasecamp == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('동선 마법사를 쓰려면 먼저 오늘의 숙소(출발지)를 설정해주세요!')));
      return;
    }

    // ✨ 해결 2 적용: 헬퍼 함수로 안전하게 좌표 추출
    LatLng? startPoint = _getCoordinatesForPlace(currentBasecamp, details);

    if (startPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('숙소의 위치 좌표를 찾을 수 없어 동선 계산이 불가능합니다.')));
      return;
    }

    List<String> unvisited = List.from(allPlaces);
    List<String> sortedPlaces = [];
    const Distance distanceCalc = Distance();

    LatLng currentPoint = startPoint;

    while (unvisited.isNotEmpty) {
      String? nearestPlace;
      double minDistance = double.infinity;
      LatLng? nextPoint;

      for (String place in unvisited) {
        // ✨ 해결 2 적용: 헬퍼 함수로 안전하게 좌표 추출
        LatLng? pLatLng = _getCoordinatesForPlace(place, details);

        if (pLatLng != null) {
          double dist = distanceCalc.as(LengthUnit.Meter, currentPoint, pLatLng);
          if (dist < minDistance) {
            minDistance = dist;
            nearestPlace = place;
            nextPoint = pLatLng;
          }
        } else {
          if (nearestPlace == null) {
            nearestPlace = place;
            minDistance = 0;
          }
        }
      }

      if (nearestPlace != null) {
        sortedPlaces.add(nearestPlace);
        unvisited.remove(nearestPlace);
        if (nextPoint != null) currentPoint = nextPoint;
      }
    }

    if (sortedPlaces.length >= 2) {
      // ✨ 해결 2 적용: 헬퍼 함수로 안전하게 좌표 추출
      LatLng? firstLatLng = _getCoordinatesForPlace(sortedPlaces.first, details);
      LatLng? lastLatLng = _getCoordinatesForPlace(sortedPlaces.last, details);

      if (firstLatLng != null && lastLatLng != null) {
        double distFromStartToFirst = distanceCalc.as(LengthUnit.Meter, startPoint, firstLatLng);
        double distFromStartToLast = distanceCalc.as(LengthUnit.Meter, startPoint, lastLatLng);

        if (distFromStartToLast < distFromStartToFirst) {
          sortedPlaces = sortedPlaces.reversed.toList();
        }
      }
    }

    setState(() {
      int pIndex = 0;
      final times = ['아침', '점심', '오후', '저녁'];
      for (int i = 0; i < times.length; i++) {
        int count = counts[i];
        if (pIndex + count <= sortedPlaces.length) {
          _myCustomItinerary[_itineraryDayIndex]![times[i]] = sortedPlaces.sublist(pIndex, pIndex + count);
        } else {
          _myCustomItinerary[_itineraryDayIndex]![times[i]] = sortedPlaces.sublist(pIndex);
        }
        pIndex += count;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✨ 마커가 있는 장소들을 기준으로 최적 동선을 짰습니다!')));
  }

  Future<void> _launchGoogleMapsRoute(int dayIndex) async {
    final dayPlan = _myCustomItinerary[dayIndex]!;
    List<String> allPlaces = [];

    final currentBasecamp = _basecamps[dayIndex];
    if (currentBasecamp != null) {
      allPlaces.add(currentBasecamp);
    }

    for (var time in ['아침', '점심', '오후', '저녁']) {
      allPlaces.addAll(dayPlan[time]!);
    }

    if (allPlaces.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('경로를 보려면 장소나 숙소를 먼저 2개 이상 추가해주세요!')));
      return;
    }

    if (allPlaces.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('경유지가 10개를 초과하여 안전상 일부만 렌더링됩니다.')));
      allPlaces = allPlaces.sublist(0, 10);
    }

    String origin = Uri.encodeComponent('${widget.cityName} ${allPlaces.first}');
    String destination = Uri.encodeComponent('${widget.cityName} ${allPlaces.last}');
    String urlString = 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination';

    if (allPlaces.length > 2) {
      List<String> waypointsList = allPlaces.sublist(1, allPlaces.length - 1).map((p) => '${widget.cityName} $p').toList();
      String waypoints = Uri.encodeComponent(waypointsList.join('|'));
      urlString += '&waypoints=$waypoints';
    }

    final url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('지도를 열 수 없습니다.')));
    }
  }

  void _focusInternalMap(List<LatLng> points) {
    if (points.isEmpty) return;
    try {
      if (points.length == 1) {
        _mapController.move(points.first, 15.0);
        return;
      }
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)));
    } catch (e) {
      print('지도 카메라 업데이트 오류: $e');
    }
  }

  void _toggleBasketItem(String fullPlaceName) {
    final cleanPlaceName = fullPlaceName.split(RegExp(r'[\(\-]')).first.trim();

    if (_addedPlaces.contains(cleanPlaceName)) {
      setState(() {
        _addedPlaces.remove(cleanPlaceName);
        for (var day in _myCustomItinerary.values) {
          for (var places in day.values) {
            places.remove(cleanPlaceName);
          }
        }
        _basecamps.removeWhere((key, value) => value == cleanPlaceName);
        _myCustomPrices.remove(cleanPlaceName);
        _myCustomCoords.remove(cleanPlaceName);
        _syncAddedPlacesSet();
      });
    } else {
      if (_selectedCategory == '숙소') {
        _showAccommodationDialog(cleanPlaceName);
      } else {
        _showAddDialog(cleanPlaceName);
      }
    }
  }

  void _showAccommodationDialog(String placeName) {
    int tempStartDay = _itineraryDayIndex;
    int tempNights = 1;

    // ✨ 해결 1: 전체 일수 중 '체크인'이 가능한 최대 날짜 계산 (마지막 날짜는 체크인 불가)
    int maxCheckInDay = _totalDays > 1 ? _totalDays - 1 : 1;

    // 만약 현재 탭(Day)이 마지막 날이라면 이전 날로 자동 조정
    if (tempStartDay >= maxCheckInDay) {
      tempStartDay = maxCheckInDay - 1;
    }

    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (context, setDialogState) {
                // ✨ 해결 1: 시작 날짜(tempStartDay)에 따라 '선택 가능한 최대 숙박 일수' 동적 계산
                int availableNights = _totalDays - tempStartDay - 1;
                if (availableNights < 1) availableNights = 1;

                // 시작 날짜를 바꿨을 때 선택된 숙박 일수가 초과되면 자동 컷
                if (tempNights > availableNights) {
                  tempNights = availableNights;
                }

                return CupertinoAlertDialog(
                  title: const Text('베이스캠프 지정하기 🏨'),
                  content: Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(placeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CupertinoColors.activeBlue)),
                      const SizedBox(height: 20),
                      const Text('체크인 (몇 일 차?)', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.center,
                        children: List.generate(maxCheckInDay, (index) {
                          bool isSelected = tempStartDay == index;
                          return GestureDetector(
                            onTap: () => setDialogState(() => tempStartDay = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(20)),
                              child: Text('${index + 1}일 차', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black54, fontSize: 13)),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      const Text('몇 박을 머무시나요?', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.center,
                        children: List.generate(availableNights, (index) {
                          int night = index + 1;
                          bool isSelected = tempNights == night;
                          return GestureDetector(
                            onTap: () => setDialogState(() => tempNights = night),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: isSelected ? CupertinoColors.systemIndigo : CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(20)),
                              child: Text('$night박', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black54, fontSize: 13)),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(child: const Text('취소'), onPressed: () => Navigator.pop(ctx)),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('확정'),
                      onPressed: () {
                        setState(() {
                          for (int i = 0; i < tempNights; i++) {
                            if (tempStartDay + i < _totalDays) {
                              _basecamps[tempStartDay + i] = placeName;
                            }
                          }
                          _addedPlaces.add(placeName);
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🏨 $placeName(이)가 숙소로 설정되었습니다!'), duration: const Duration(seconds: 2)));
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  void _showAddDialog(String placeName) {
    int tempDay = _itineraryDayIndex;
    String tempTime = '아침';

    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (context, setDialogState) {
                return CupertinoAlertDialog(
                  title: const Text('나만의 일정에 추가 ✏️'),
                  content: Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(placeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CupertinoColors.activeBlue)),
                      const SizedBox(height: 20),
                      const Text('몇 일 차에 방문하시겠어요?', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.center,
                        children: List.generate(_totalDays, (index) {
                          bool isSelected = tempDay == index;
                          return GestureDetector(
                            onTap: () => setDialogState(() => tempDay = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(20)),
                              child: Text('${index + 1}일 차', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black54, fontSize: 13)),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      const Text('어느 시간대에 방문하시겠어요?', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      CupertinoSlidingSegmentedControl<String>(
                        groupValue: tempTime,
                        children: const {'아침': Text('아침'), '점심': Text('점심'), '오후': Text('오후'), '저녁': Text('저녁')},
                        onValueChanged: (v) => setDialogState(() => tempTime = v!),
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(child: const Text('취소'), onPressed: () => Navigator.pop(ctx)),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('담기'),
                      onPressed: () {
                        setState(() {
                          _myCustomItinerary[tempDay]![tempTime]!.add(placeName);
                          _addedPlaces.add(placeName);
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${tempDay + 1}일 차 $tempTime 일정에 추가되었습니다! 🎒'), duration: const Duration(seconds: 2)));
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  // ✨ 해결 3: 다중 주소 검색 폴백(Fallback) 기능 탑재
  Future<LatLng?> _geocodeAddress(String query) async {
    try {
      // 1차 시도: 도시명 + 주소 (일반적으로 가장 정확)
      var url = Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent('${widget.cityName} $query')}&format=json&limit=1');
      var response = await http.get(url, headers: {'User-Agent': 'TravelGuideApp/1.0'});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data.isNotEmpty) return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
      }

      // 2차 시도: 주소 단독 검색 (도시명이 오히려 방해가 될 경우)
      url = Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1');
      response = await http.get(url, headers: {'User-Agent': 'TravelGuideApp/1.0'});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data.isNotEmpty) return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
      }

      // 3차 시도: 영문 도시명 + 주소 (해외 지역 검색 시 한국어 도시명이 문제될 경우 해결)
      String engCity = _cityEngMap[widget.cityName] ?? widget.cityName;
      url = Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent('$engCity $query')}&format=json&limit=1');
      response = await http.get(url, headers: {'User-Agent': 'TravelGuideApp/1.0'});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data.isNotEmpty) return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
      }

    } catch (e) {
      print('주소 변환 에러: $e');
    }
    return null; // 모든 시도 실패 시
  }

  void _showAddCustomPlaceDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    int tempDay = _itineraryDayIndex;
    String tempTime = '오후';
    bool isGeocoding = false;

    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (context, setDialogState) {
                return CupertinoAlertDialog(
                  title: const Text('나만의 장소 직접 추가 ✍️'),
                  content: Column(
                    children: [
                      const SizedBox(height: 16),
                      CupertinoTextField(
                        controller: nameController,
                        placeholder: '장소 이름 (예: 지인 집, 핫플 식당)',
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8)),
                      ),
                      const SizedBox(height: 12),
                      CupertinoTextField(
                        controller: addressController,
                        placeholder: '정확한 주소 또는 영문 상호명 (선택)',
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 8),
                        child: Text('주소를 입력하면 지도에 핀이 꽂힙니다 📍', style: TextStyle(fontSize: 11, color: CupertinoColors.activeBlue)),
                      ),
                      CupertinoTextField(
                        controller: priceController,
                        placeholder: '예상 비용 (숫자만, 예: 15000)',
                        keyboardType: TextInputType.number,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8)),
                      ),
                      const SizedBox(height: 20),
                      const Text('몇 일 차에 방문하시겠어요?', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6.0, runSpacing: 6.0, alignment: WrapAlignment.center,
                        children: List.generate(_totalDays, (index) {
                          bool isSelected = tempDay == index;
                          return GestureDetector(
                            onTap: () => setDialogState(() => tempDay = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(16)),
                              child: Text('${index + 1}일 차', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black54, fontSize: 12)),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      CupertinoSlidingSegmentedControl<String>(
                        groupValue: tempTime,
                        children: const {'아침': Text('아침', style: TextStyle(fontSize: 12)), '점심': Text('점심', style: TextStyle(fontSize: 12)), '오후': Text('오후', style: TextStyle(fontSize: 12)), '저녁': Text('저녁', style: TextStyle(fontSize: 12))},
                        onValueChanged: (v) => setDialogState(() => tempTime = v!),
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(child: const Text('취소', style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.pop(ctx)),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: isGeocoding ? const CupertinoActivityIndicator() : const Text('추가하기'),
                      onPressed: isGeocoding ? null : () async {
                        if (nameController.text.trim().isEmpty) return;

                        setDialogState(() => isGeocoding = true);
                        String customName = '[직접추가] ${nameController.text.trim()}';
                        int customPrice = int.tryParse(priceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

                        LatLng? resolvedCoords;
                        if (addressController.text.trim().isNotEmpty) {
                          resolvedCoords = await _geocodeAddress(addressController.text.trim());
                        }

                        setState(() {
                          _myCustomPrices[customName] = customPrice;
                          if (resolvedCoords != null) {
                            _myCustomCoords[customName] = resolvedCoords;
                          }
                          _myCustomItinerary[tempDay]![tempTime]!.add(customName);
                          _addedPlaces.add(customName);
                        });

                        Navigator.pop(ctx);

                        // ✨ 해결 3: 사용자에게 주소 변환 결과를 명확히 안내 (Toast 알림 세분화)
                        if (resolvedCoords != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✨ 지도 좌표 확보! $customName 일정이 추가되었습니다.'), duration: const Duration(seconds: 2)));
                        } else if (addressController.text.trim().isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('⚠️ 일정이 추가되었으나 주소를 찾을 수 없어 지도에는 생략됩니다. (정확한 영문 주소 권장)'), duration: const Duration(seconds: 4)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✨ $customName 일정이 추가되었습니다. (주소 미입력)'), duration: const Duration(seconds: 2)));
                        }
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  Future<void> _launchGoogleMaps(String placeName) async {
    final query = Uri.encodeComponent('${widget.cityName} $placeName');
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (!await launchUrl(url)) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('지도를 열 수 없습니다.')));
  }

  Future<void> _launchYoutubeSearch() async {
    final query = Uri.encodeComponent('${widget.cityName} 여행 브이로그');
    final url = Uri.parse('https://www.youtube.com/results?search_query=$query');
    if (!await launchUrl(url)) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('유튜브를 열 수 없습니다.')));
  }

  void _copyItinerary(CityDetails details) {
    String textToCopy = '[${widget.cityName} AI 추천 일정]\n\n';
    int daysToCopy = _totalDays < details.itinerary.length ? _totalDays : details.itinerary.length;
    for (int i = 0; i < daysToCopy; i++) {
      textToCopy += '${details.itinerary[i]}\n\n';
    }
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI 추천 일정이 복사되었습니다!'), duration: Duration(seconds: 2)));
  }

  void _copyMyBasket() {
    bool isEmpty = true;
    String textToCopy = '[${widget.cityName} 나만의 DIY 일정]\n\n';
    for (int day = 0; day < _totalDays; day++) {
      textToCopy += '📍 ${day + 1}일 차\n';

      if (_basecamps.containsKey(day)) {
        textToCopy += '🏨 숙소: ${_basecamps[day]}\n';
      }

      for (String time in ['아침', '점심', '오후', '저녁']) {
        final places = _myCustomItinerary[day]![time]!;
        if (places.isNotEmpty) {
          isEmpty = false;
          textToCopy += '- $time: ${places.join(', ')}\n';
        }
      }
      textToCopy += '\n';
    }
    if (isEmpty && _basecamps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('일정이 비어있습니다. 장소를 먼저 담아주세요!')));
      return;
    }
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('나만의 DIY 일정이 복사되었습니다!'), duration: Duration(seconds: 2)));
  }

  Future<void> _shareTimelineAsImage() async {
    try {
      RenderRepaintBoundary boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        await Share.shareXFiles(
            [XFile.fromData(pngBytes, mimeType: 'image/png', name: 'itinerary.png')],
            text: '${widget.cityName} 여행! ${_selectedItineraryType == "AI 추천 일정" ? "AI가 짜준 일정" : "내가 만든 일정"} 공유할게! ✈️'
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('이미지 공유 중 오류가 발생했습니다: $e')));
    }
  }

  Widget _buildCityImageHeader() {
    String? imagePath = _getCityImagePath(widget.cityName);

    return Container(
      width: double.infinity,
      height: 250,
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBFD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: imagePath != null
                  ? Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              )
                  : Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(CupertinoIcons.photo, color: Colors.black26, size: 50),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.black45, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: const Icon(CupertinoIcons.chevron_back, color: Colors.black87, size: 22),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Discover',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Hero(
                          tag: 'city-${widget.cityName}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.cityName,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _confirmRefresh,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(CupertinoIcons.arrow_clockwise, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: FutureBuilder<CityDetails>(
        future: _cityDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const TravelLoadingWidget();
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.exclamationmark_triangle_fill, color: CupertinoColors.systemOrange, size: 60),
                  const SizedBox(height: 16),
                  const Text('앗! AI가 너무 바빠서 일정을 놓쳤어요 😵‍💫', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  CupertinoButton(color: CupertinoColors.activeBlue, onPressed: () => _loadData(forceRefresh: true), child: const Text('다시 시도하기 🔄', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            );
          }

          final details = snapshot.data!;

          final Map<String, int> placePriceMap = {};
          final allCategoriesLists = [
            details.accommodations, details.sightseeings, details.restaurants, details.cafes,
            details.arts, details.shopping, details.parks, details.viewpoints
          ];

          for (var list in allCategoriesLists) {
            for (var item in list) {
              String cleanName = item.split(RegExp(r'[\(\-]')).first.trim();
              placePriceMap[cleanName] = _extractPrice(item);
            }
          }

          int diyTotalKrw = 0;
          for (int i = 0; i < _totalDays; i++) {
            if (_basecamps.containsKey(i)) {
              diyTotalKrw += placePriceMap[_basecamps[i]!] ?? _myCustomPrices[_basecamps[i]!] ?? 0;
            }
            if (_myCustomItinerary.containsKey(i)) {
              for (var places in _myCustomItinerary[i]!.values) {
                for (var p in places) {
                  diyTotalKrw += placePriceMap[p] ?? _myCustomPrices[p] ?? 0;
                }
              }
            }
          }

          List<LatLng> mapRoutePoints = [];
          List<Marker> mapMarkers = [];

          if (_selectedItineraryType == '나만의 DIY 일정') {
            int order = 1;

            final currentBasecamp = _basecamps[_itineraryDayIndex];
            if (currentBasecamp != null) {
              // ✨ 해결 2 적용: 헬퍼 함수로 안전하게 좌표 추출
              LatLng? point = _getCoordinatesForPlace(currentBasecamp, details);

              if (point != null) {
                mapRoutePoints.add(point);
                mapMarkers.add(
                    Marker(
                      point: point, width: 40, height: 40,
                      child: const Icon(CupertinoIcons.house_alt_fill, color: CupertinoColors.activeBlue, size: 30),
                    )
                );
              }
            }

            final dayPlan = _myCustomItinerary[_itineraryDayIndex]!;
            for (var time in ['아침', '점심', '오후', '저녁']) {
              for (var place in dayPlan[time]!) {
                // ✨ 해결 2 적용: 헬퍼 함수로 안전하게 좌표 추출
                LatLng? point = _getCoordinatesForPlace(place, details);

                if (point != null) {
                  mapRoutePoints.add(point);
                  mapMarkers.add(
                      Marker(
                          point: point, width: 40, height: 40,
                          child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(color: CupertinoColors.activeBlue, shape: BoxShape.circle),
                                  child: Text('$order', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ]
                          )
                      )
                  );
                  order++;
                }
              }
            }
            if (currentBasecamp != null && mapRoutePoints.length > 1) {
              // ✨ 해결 2 적용: 마지막 복귀 좌표 처리
              LatLng? point = _getCoordinatesForPlace(currentBasecamp, details);
              if (point != null) mapRoutePoints.add(point);
            }

            String currentHash = mapRoutePoints.map((p) => '${p.latitude},${p.longitude}').join('|');
            if (currentHash != _lastMapPointsHash) {
              _lastMapPointsHash = currentHash;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _selectedItineraryType == '나만의 DIY 일정') {
                  _focusInternalMap(mapRoutePoints);
                }
              });
            }
          }

          String rawBudget = details.averageBudget;
          String mainPrice = rawBudget.contains('(') ? rawBudget.substring(0, rawBudget.indexOf('(')).trim() : rawBudget;
          String subDesc = rawBudget.contains('(') ? rawBudget.substring(rawBudget.indexOf('(')).trim() : '';
          final match = RegExp(r'[0-9,]+').firstMatch(mainPrice);
          final int budgetKrw = match != null ? (int.tryParse(match.group(0)!.replaceAll(',', '')) ?? 0) : 0;

          String localCurrencyStr = '';
          String diyLocalCurrencyStr = '';

          if (_exchangeRates.isNotEmpty && _exchangeRates.containsKey(details.currencyCode)) {
            double rate = (_exchangeRates[details.currencyCode] as num).toDouble();
            double localAmount = budgetKrw * rate;
            double diyLocalAmount = diyTotalKrw * rate;
            try {
              localCurrencyStr = '약 ${NumberFormat.simpleCurrency(name: details.currencyCode).format(localAmount)}';
              diyLocalCurrencyStr = NumberFormat.simpleCurrency(name: details.currencyCode).format(diyLocalAmount);
            } catch(e) {
              localCurrencyStr = '약 ${NumberFormat('#,##0.##').format(localAmount)} ${details.currencyCode}';
              diyLocalCurrencyStr = '${NumberFormat('#,##0.##').format(diyLocalAmount)} ${details.currencyCode}';
            }
          } else {
            int budgetUsd = (budgetKrw / 1400).round();
            localCurrencyStr = '약 \$$budgetUsd';
            int diyUsd = (diyTotalKrw / 1400).round();
            diyLocalCurrencyStr = '\$$diyUsd';
          }

          List<String> currentPlaces = [];
          IconData sectionIcon = CupertinoIcons.map_pin_ellipse;

          switch (_selectedCategory) {
            case '숙소': currentPlaces = details.accommodations; sectionIcon = CupertinoIcons.bed_double_fill; break;
            case '맛집': currentPlaces = details.restaurants; sectionIcon = Icons.restaurant; break;
            case '카페': currentPlaces = details.cafes; sectionIcon = Icons.local_cafe; break;
            case '미술관': currentPlaces = details.arts; sectionIcon = Icons.palette; break;
            case '쇼핑': currentPlaces = details.shopping; sectionIcon = Icons.shopping_bag; break;
            case '공원': currentPlaces = details.parks; sectionIcon = Icons.park; break;
            case '뷰포인트': currentPlaces = details.viewpoints; sectionIcon = Icons.camera_alt; break;
            default: currentPlaces = details.sightseeings; sectionIcon = CupertinoIcons.map_pin_ellipse;
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildCityImageHeader(),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16, top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(color: CupertinoColors.activeGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: CupertinoColors.activeGreen.withOpacity(0.3))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.leaf_arrow_circlepath, color: CupertinoColors.activeGreen, size: 18),
                            const SizedBox(width: 8),
                            Text('방문 최적기: ${details.bestSeason}', style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeGreen)),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: _launchYoutubeSearch,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.redAccent.withOpacity(0.3))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.play_rectangle_fill, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text('이 도시의 여행 브이로그 찾아보기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: '1일 평균 예상 경비',
                      icon: CupertinoIcons.money_dollar_circle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(mainPrice, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue)),
                              if (budgetKrw > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(12)),
                                  child: Text(localCurrencyStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                                ),
                            ],
                          ),
                          if (subDesc.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(subDesc, style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.3)),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionCard(
                      title: '추천 장소/숙소 보기',
                      icon: sectionIcon,
                      actionWidget: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          icon: const Icon(Icons.keyboard_arrow_down, color: CupertinoColors.activeBlue),
                          style: const TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold, fontSize: 15),
                          borderRadius: BorderRadius.circular(12),
                          items: _categories.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                          onChanged: (String? newValue) => setState(() => _selectedCategory = newValue!),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: currentPlaces.isEmpty
                            ? [const Padding(padding: EdgeInsets.only(top: 10), child: Text("해당 카테고리의 추천 장소가 없습니다.", style: TextStyle(color: Colors.grey)))]
                            : currentPlaces.map((place) {
                          final placeName = place.split(RegExp(r'[\(\-]')).first.trim();
                          bool isAdded = _addedPlaces.contains(placeName);

                          String closedDay = _getClosedDay(place);
                          String displayName = place.replaceAll(RegExp(r'\[휴무:.*?\]|\[링크:.*?\]'), '').trim();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Icon(CupertinoIcons.circle_fill, size: 8, color: CupertinoColors.systemGrey),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(displayName, style: const TextStyle(fontSize: 15, height: 1.4)),

                                      if (closedDay.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                            child: Text('🚨 휴무일 주의: $closedDay', style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                                          ),
                                        ),

                                      const SizedBox(height: 6),
                                      GestureDetector(
                                        onTap: () => _launchGoogleMaps(placeName),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(CupertinoIcons.location_solid, size: 14, color: CupertinoColors.activeBlue),
                                            SizedBox(width: 4),
                                            Text('지도 보기', style: TextStyle(fontSize: 13, color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isAdded ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                    color: isAdded ? CupertinoColors.destructiveRed : CupertinoColors.systemGrey3,
                                    size: 26,
                                  ),
                                  onPressed: () => _toggleBasketItem(place),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSectionCard(
                      title: '일정 확인하기',
                      icon: CupertinoIcons.calendar_today,
                      actionWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _shareTimelineAsImage,
                            child: Icon(CupertinoIcons.share, size: 20, color: _selectedItineraryType == 'AI 추천 일정' ? CupertinoColors.activeBlue : CupertinoColors.systemIndigo),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => _selectedItineraryType == 'AI 추천 일정' ? _copyItinerary(details) : _copyMyBasket(),
                            child: Icon(CupertinoIcons.doc_on_clipboard, size: 20, color: _selectedItineraryType == 'AI 추천 일정' ? CupertinoColors.activeBlue : CupertinoColors.systemIndigo),
                          ),
                          const SizedBox(width: 12),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedItineraryType,
                              icon: Icon(Icons.keyboard_arrow_down, color: _selectedItineraryType == 'AI 추천 일정' ? CupertinoColors.activeBlue : CupertinoColors.systemIndigo),
                              style: TextStyle(color: _selectedItineraryType == 'AI 추천 일정' ? CupertinoColors.activeBlue : CupertinoColors.systemIndigo, fontWeight: FontWeight.bold, fontSize: 14),
                              borderRadius: BorderRadius.circular(12),
                              items: _itineraryTypes.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedItineraryType = newValue!;
                                  if (newValue == '나만의 DIY 일정') {
                                    _lastMapPointsHash = '';
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _startDate != null && _endDate != null
                                      ? '${_startDate!.month}/${_startDate!.day} ~ ${_endDate!.month}/${_endDate!.day} ($_totalDays일)'
                                      : '기본 설정 ($_totalDays일)',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                GestureDetector(
                                  onTap: _selectDateRange,
                                  child: Row(
                                    children: const [
                                      Icon(CupertinoIcons.calendar, size: 18, color: CupertinoColors.activeBlue),
                                      SizedBox(width: 4),
                                      Text('기간 변경', style: TextStyle(fontSize: 14, color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (_selectedItineraryType == '나만의 DIY 일정')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(color: CupertinoColors.activeOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: CupertinoColors.activeOrange.withOpacity(0.3))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(children: [Icon(CupertinoIcons.money_dollar_circle_fill, color: CupertinoColors.activeOrange), SizedBox(width: 8), Text('나만의 일정 총예산', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeOrange))]),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('${NumberFormat('#,###').format(diyTotalKrw)}원', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CupertinoColors.activeOrange)),
                                      if (diyTotalKrw > 0) Text('(현지 통화: $diyLocalCurrencyStr)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: CupertinoColors.activeOrange.withOpacity(0.8))),
                                    ],
                                  )
                                ],
                              ),
                            ),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(_totalDays, (index) {
                                bool isSelected = _itineraryDayIndex == index;
                                Color themeColor = _selectedItineraryType == 'AI 추천 일정' ? CupertinoColors.activeBlue : CupertinoColors.systemIndigo;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _itineraryDayIndex = index;
                                      _lastMapPointsHash = '';
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: isSelected ? themeColor : CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(20)),
                                    child: Text('${index + 1}일 차', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black54, fontSize: 14)),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (_selectedItineraryType == '나만의 DIY 일정' && mapRoutePoints.isNotEmpty)
                            Container(
                              height: 250,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
                              clipBehavior: Clip.antiAlias,
                              child: FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(initialCenter: mapRoutePoints.first, initialZoom: 13.0),
                                children: [
                                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.your.travelapp'),
                                  PolylineLayer(polylines: [Polyline(points: mapRoutePoints, strokeWidth: 4.0, color: CupertinoColors.systemIndigo)]),
                                  MarkerLayer(markers: mapMarkers),
                                ],
                              ),
                            ),

                          RepaintBoundary(
                            key: _repaintKey,
                            child: Container(
                              color: Colors.white,
                              child: _selectedItineraryType == 'AI 추천 일정'
                                  ? (_itineraryDayIndex < details.itinerary.length
                                  ? _buildVerticalTimeline(details.itinerary[_itineraryDayIndex])
                                  : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(12)),
                                child: const Column(
                                  children: [Icon(CupertinoIcons.info_circle_fill, color: Colors.grey, size: 30), SizedBox(height: 12), Text('AI 추천 일정은 3일 차까지만 제공됩니다.\n남은 일정은 [나만의 DIY 일정] 탭에서 직접 채워보세요!', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, height: 1.5, fontSize: 13))],
                                ),
                              ))
                                  : _buildCustomTimeline(_itineraryDayIndex, details),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVerticalTimeline(String dayPlan) {
    String cleanPlan = dayPlan.contains(':') ? dayPlan.substring(dayPlan.indexOf(':') + 1).trim() : dayPlan;
    List<String> steps = cleanPlan.split(' - ');
    if (steps.length == 1) steps = cleanPlan.split('-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        return _buildTimelineItem(
          content: Text(entry.value.trim(), style: const TextStyle(fontSize: 15, height: 1.4)),
          isLast: entry.key == steps.length - 1,
          themeColor: CupertinoColors.activeBlue,
          bgColor: CupertinoColors.systemGrey6,
        );
      }).toList(),
    );
  }

  Widget _buildTimelineItem({required Widget content, required bool isLast, required Color themeColor, required Color bgColor}) {
    return Stack(
      children: [
        if (!isLast)
          Positioned(top: 24, bottom: 0, left: 5, child: Container(width: 2, color: themeColor.withOpacity(0.3))),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(margin: const EdgeInsets.only(top: 18), child: Icon(CupertinoIcons.circle_fill, size: 12, color: themeColor)),
            const SizedBox(width: 16),
            Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 24.0), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)), child: content))),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomTimeline(int dayIndex, CityDetails details) {
    final dayPlan = _myCustomItinerary[dayIndex]!;
    final times = ['아침', '점심', '오후', '저녁'];

    List<Map<String, dynamic>> flatItems = [];
    for (var time in times) {
      flatItems.add({'type': 'header', 'time': time, 'id': 'header_$time'});
      if (dayPlan[time]!.isEmpty) {
        flatItems.add({'type': 'empty', 'time': time, 'id': 'empty_$time'});
      } else {
        for (var place in dayPlan[time]!) {
          flatItems.add({'type': 'place', 'place': place, 'time': time, 'id': 'place_$place'});
        }
      }
    }

    String? currentBasecamp = _basecamps[dayIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 12,
          children: [
            const Text('💡 자유롭게 드래그 앤 드롭 해보세요!', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                GestureDetector(
                  onTap: () => _launchGoogleMapsRoute(dayIndex),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: CupertinoColors.activeGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: CupertinoColors.activeGreen.withOpacity(0.3))),
                    child: const Text('🗺️ 전체 경로', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.activeGreen)),
                  ),
                ),
                _isOptimizingRoute
                    ? const CupertinoActivityIndicator()
                    : GestureDetector(
                  onTap: () => _optimizeCurrentDayRoute(details),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: CupertinoColors.systemIndigo.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: CupertinoColors.systemIndigo.withOpacity(0.3))),
                    child: const Text('🪄 마법사', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.systemIndigo)),
                  ),
                ),
                GestureDetector(
                  onTap: _showAddCustomPlaceDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: CupertinoColors.activeBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: CupertinoColors.activeBlue.withOpacity(0.3))),
                    child: const Text('➕ 직접 추가', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.activeBlue)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: const Text('일정 초기화 🗑️'),
                        content: const Text('\n현재 선택된 일차만 지우시겠습니까, 아니면 모든 일정을 전체 삭제할까요?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('현재 일차만', style: TextStyle(color: CupertinoColors.activeBlue)),
                            onPressed: () {
                              setState(() {
                                _myCustomItinerary[dayIndex] = {'아침': [], '점심': [], '오후': [], '저녁': []};
                                _basecamps.remove(dayIndex);
                                _syncAddedPlacesSet();
                              });
                              Navigator.pop(ctx);
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: const Text('전체 지우기'),
                            onPressed: () {
                              setState(() {
                                for (int i = 0; i < _totalDays; i++) {
                                  _myCustomItinerary[i] = {'아침': [], '점심': [], '오후': [], '저녁': []};
                                }
                                _basecamps.clear();
                                _syncAddedPlacesSet();
                              });
                              Navigator.pop(ctx);
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('취소', style: TextStyle(color: Colors.grey)),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: CupertinoColors.destructiveRed.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: CupertinoColors.destructiveRed.withOpacity(0.3))),
                    child: const Text('🗑️ 초기화', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.destructiveRed)),
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 24),

        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: currentBasecamp != null ? CupertinoColors.activeBlue.withOpacity(0.1) : CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(16)
          ),
          child: Row(
            children: [
              Icon(CupertinoIcons.house_alt_fill, color: currentBasecamp != null ? CupertinoColors.activeBlue : Colors.grey, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('오늘의 숙소 (베이스캠프)', style: TextStyle(fontSize: 12, color: currentBasecamp != null ? CupertinoColors.activeBlue : Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(currentBasecamp ?? '숙소를 아직 정하지 않았어요! 상단에서 추가해주세요.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: currentBasecamp != null ? Colors.black87 : Colors.black54)),
                  ],
                ),
              ),
              if (currentBasecamp != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _basecamps.remove(dayIndex);
                      _syncAddedPlacesSet();
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed, size: 22),
                  ),
                ),
            ],
          ),
        ),

        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: flatItems.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = flatItems.removeAt(oldIndex);
              flatItems.insert(newIndex, item);

              Map<String, List<String>> newDayPlan = {'아침': [], '점심': [], '오후': [], '저녁': []};
              String currentTime = '아침';

              for (var flat in flatItems) {
                if (flat['type'] == 'header') {
                  currentTime = flat['time'];
                } else if (flat['type'] == 'place') {
                  newDayPlan[currentTime]!.add(flat['place']);
                }
              }

              _myCustomItinerary[dayIndex] = newDayPlan;
            });
          },
          itemBuilder: (context, index) {
            final item = flatItems[index];
            final isLast = index == flatItems.length - 1;

            return Container(
              key: ValueKey(item['id']),
              color: Colors.transparent,
              child: Stack(
                children: [
                  if (!isLast)
                    Positioned(top: item['type'] == 'header' ? 24 : 0, bottom: 0, left: 11, child: Container(width: 2, color: CupertinoColors.systemIndigo.withOpacity(0.3))),
                  if (item['type'] == 'header')
                    const Positioned(top: 18, left: 5, child: Icon(CupertinoIcons.circle_fill, size: 12, color: CupertinoColors.systemIndigo)),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, bottom: 16.0),
                    child: _buildFlatItemContent(item, index, dayIndex, details),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFlatItemContent(Map<String, dynamic> item, int index, int dayIndex, CityDetails details) {
    if (item['type'] == 'header') {
      return Padding(padding: const EdgeInsets.only(top: 13.0), child: Text(item['time'], style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemIndigo, fontSize: 16)));
    } else if (item['type'] == 'empty') {
      return Padding(padding: const EdgeInsets.only(top: 4.0), child: Text('${item['time']} (일정을 비워두었어요)', style: const TextStyle(fontSize: 14, color: Colors.grey)));
    } else {
      String placeName = item['place'];
      String memoKey = '${dayIndex}_${item['time']}_$placeName';
      TextEditingController memoController = _getMemoController(memoKey);

      String? originalPlaceText = _getOriginalPlaceString(placeName, details);
      String closedDay = originalPlaceText != null ? _getClosedDay(originalPlaceText) : '';

      return Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: CupertinoColors.systemIndigo.withOpacity(0.2)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))]),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 2.0), child: Icon(CupertinoIcons.check_mark_circled_solid, size: 16, color: CupertinoColors.systemIndigo)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(placeName, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.3, fontWeight: FontWeight.bold)),
                  if (closedDay.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(children: [const Icon(CupertinoIcons.exclamationmark_triangle_fill, size: 12, color: CupertinoColors.destructiveRed), const SizedBox(width: 4), Text('휴무일 주의: $closedDay', style: const TextStyle(fontSize: 12, color: CupertinoColors.destructiveRed, fontWeight: FontWeight.bold))]),
                    ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: memoController,
                    placeholder: '자유 메모 (주소 입력, 바우처 등)',
                    style: const TextStyle(fontSize: 13),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: CupertinoColors.systemGrey6, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.transparent)),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  _myCustomItinerary[dayIndex]![item['time']]!.remove(placeName);
                  _myCustomPrices.remove(placeName);
                  _myCustomCoords.remove(placeName);
                  _syncAddedPlacesSet();
                });
              },
              child: Container(
                padding: const EdgeInsets.only(left: 8, right: 4, top: 4, bottom: 4),
                color: Colors.transparent,
                child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed, size: 22),
              ),
            ),

            ReorderableDragStartListener(
              index: index,
              child: Container(padding: const EdgeInsets.only(left: 8, right: 0, top: 4, bottom: 4), color: Colors.transparent, child: const Icon(Icons.drag_handle, color: Colors.grey, size: 24)),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child, Widget? actionWidget}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(icon, color: Colors.black54), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54))]),
              if (actionWidget != null) actionWidget,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
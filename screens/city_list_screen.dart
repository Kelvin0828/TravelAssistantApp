// lib/Project/screens/city_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'city_detail_screen.dart';
import '../models/travel_models.dart';
import '../data/travel_data.dart';

class CityListScreen extends StatefulWidget {
  final String countryName;
  final bool isPopular;

  const CityListScreen({
    super.key,
    required this.countryName,
    required this.isPopular,
  });

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  List<CityInfo> cities = [];
  List<String> _allAssets = [];
  bool _isLoading = true;

  // 🔥 팀원들과 분담한 영문 도시명 완벽 매핑
  final Map<String, String> _cityEngMap = {
    // 유럽 (Europe)
    '파리': 'Paris', '니스': 'Nice', '리옹': 'Lyon', '마르세유': 'Marseille', '안시': 'Annecy', '콜마르': 'Colmar', '몽생미셸': 'Mont Saint-Michel', '아비뇽': 'Avignon',
    '로마': 'Rome', '피렌체': 'Florence', '베네치아': 'Venice', '밀라노': 'Milan', '친퀘테레': 'Cinque Terre', '시에나': 'Siena', '포지타노': 'Positano', '돌로미티': 'Dolomites',
    '인터라켄': 'Interlaken', '루체른': 'Lucerne', '취리히': 'Zurich', '그린델발트': 'Grindelwald', '체르마트': 'Zermatt', '몽트뢰': 'Montreux',
    '마드리드': 'Madrid', '바르셀로나': 'Barcelona', '세비야': 'Seville', '론다': 'Ronda', '톨레도': 'Toledo', '그라나다': 'Granada', '이비자': 'Ibiza',
    '런던': 'London', '에든버러': 'Edinburgh', '맨체스터': 'Manchester', '바스': 'Bath', '코츠월드': 'Cotswolds', '옥스퍼드': 'Oxford',
    '베를린': 'Berlin', '뮌헨': 'Munich', '프랑크푸르트': 'Frankfurt', '하이델베르크': 'Heidelberg', '로텐부르크': 'Rothenburg', '퓌센': 'Füssen',
    '프라하': 'Prague', '체스키크룸로프': 'Cesky Krumlov', '브르노': 'Brno', '카를로비바리': 'Karlovy Vary', '플젠': 'Pilsen', '올로모우츠': 'Olomouc', '텔치': 'Telc', '리베레츠': 'Liberec', '오스트라바': 'Ostrava', '파르두비체': 'Pardubice', '즈노이모': 'Znojmo',
    '부다페스트': 'Budapest', '데브레첸': 'Debrecen', '세게드': 'Szeged', '페치': 'Pecs', '에게르': 'Eger', '죄르': 'Gyor', '쇼프론': 'Sopron', '케치케메트': 'Kecskemet', '미슈콜츠': 'Miskolc', '세케슈페헤르바르': 'Szekesfehervar', '에스테르곰': 'Esztergom',
    '두브로브니크': 'Dubrovnik', '스플리트': 'Split', '자그레브': 'Zagreb', '자다르': 'Zadar', '로빈': 'Rovinj', '시베니크': 'Sibenik', '풀라': 'Pula', '바라주딘': 'Varazdin', '오시예크': 'Osijek', '트로기르': 'Trogir', '리예카': 'Rijeka',
    '이스탄불': 'Istanbul', '안탈리아': 'Antalya', '이즈미르': 'Izmir', '괴레메/카파도키아': 'Goreme', '보드룸': 'Bodrum', '쿠샤다스': 'Kusadasi', '부르사': 'Bursa', '콘야': 'Konya', '에스키셰히르': 'Eskisehir', '트라브존': 'Trabzon', '마르딘': 'Mardin', '샨르우르파': 'Sanliurfa',
    '아테네': 'Athens', '테살로니키': 'Thessaloniki', '산토리니': 'Santorini', '미코노스': 'Mykonos', '로도스': 'Rhodes', '이라클리온': 'Heraklion', '이오안니나': 'Ioannina', '카발라': 'Kavala', '나플리오': 'Nafplio', '파트라': 'Patras', '볼로스': 'Volos', '칼라마타': 'Kalamata',
    '암스테르담': 'Amsterdam', '로테르담': 'Rotterdam', '헤이그': 'The Hague', '위트레흐트': 'Utrecht', '마스트리흐트': 'Maastricht', '흐로닝언': 'Groningen', '델프트': 'Delft', '하를럼': 'Haarlem', '라이덴': 'Leiden', '아인트호벤': 'Eindhoven', '즈볼러': 'Zwolle',
    '브뤼셀': 'Brussels', '브뤼헤': 'Bruges', '안트베르펜': 'Antwerp', '겐트': 'Ghent', '루벤': 'Leuven', '메헬렌': 'Mechelen', '나뮈르': 'Namur', '디낭': 'Dinant', '리에주': 'Liege', '몽스': 'Mons', '이프르': 'Ypres', '오스텐더': 'Ostend',
    '리스본': 'Lisbon', '포르투': 'Porto', '파루': 'Faro', '코임브라': 'Coimbra', '브라가': 'Braga', '신트라': 'Sintra', '기마랑이스': 'Guimaraes', '에보라': 'Evora', '나자레': 'Nazare', '오비두스': 'Obidos', '아베이루': 'Aveiro', '비제우': 'Viseu',
    '스톡홀름': 'Stockholm', '예테보리': 'Gothenburg', '말뫼': 'Malmo', '웁살라': 'Uppsala', '비스뷔': 'Visby', '키루나': 'Kiruna', '룬드': 'Lund', '외레브로': 'Orebro', '우메오': 'Umea', '룰레오': 'Lulea', '칼마르': 'Kalmar', '베스테로스': 'Vasteras',

    // 남아메리카 (South America)
    '리우데자네이루': 'Rio de Janeiro', '상파울루': 'Sao Paulo', '이구아수': 'Iguazu', '파라티': 'Paraty',
    '부에노스아이레스': 'Buenos Aires', '바릴로체': 'Bariloche', '우수아이아': 'Ushuaia', '엘 칼라파테': 'El Calafate',
    '리마': 'Lima', '쿠스코': 'Cusco', '마추픽추': 'Machu Picchu', '우루밤바': 'Urubamba',
    '산티아고': 'Santiago', '발파라이소': 'Valparaiso', '산페드로데아타카마': 'San Pedro de Atacama', '푸에르토 나탈레스': 'Puerto Natales',
    '보고타': 'Bogota', '메데인': 'Medellin', '카르타헤나': 'Cartagena', '살렌토': 'Salento',

    // 북아메리카 (North America)
    '뉴욕': 'New York', '로스앤젤레스': 'Los Angeles', '시카고': 'Chicago', '라스베이거스': 'Las Vegas', '샌프란시스코': 'San Francisco', '워싱턴 D.C.': 'Washington D.C.', '보스턴': 'Boston', '마이애미': 'Miami', '올랜도': 'Orlando', '시애틀': 'Seattle', '호놀룰루': 'Honolulu', '샌디에이고': 'San Diego', '필라델피아': 'Philadelphia', '애틀랜타': 'Atlanta', '뉴올리언스': 'New Orleans', '내슈빌': 'Nashville', '댈러스': 'Dallas', '휴스턴': 'Houston', '포틀랜드': 'Portland', '덴버': 'Denver', '보이시': 'Boise', '덜루스': 'Duluth', '유레카': 'Eureka', '포트 웨인': 'Fort Wayne', '녹스빌': 'Knoxville', '오클라호마시티': 'Oklahoma City', '위치타': 'Wichita', '디모인': 'Des Moines', '링컨': 'Lincoln', '시더래피즈': 'Cedar Rapids', '수폴스': 'Sioux Falls',
    '토론토': 'Toronto', '밴쿠버': 'Vancouver', '몬트리올': 'Montreal', '나이아가라 폴스': 'Niagara Falls', '퀘벡시티': 'Quebec City', '오타와': 'Ottawa', '캘거리': 'Calgary', '빅토리아': 'Victoria', '위니펙': 'Winnipeg', '에드먼턴': 'Edmonton', '핼리팩스': 'Halifax', '휘슬러': 'Whistler', '트로아 리비에르': 'Trois-Rivieres', '선더베이': 'Thunder Bay', '레드 디어': 'Red Deer', '멍크턴': 'Moncton', '서드베리': 'Sudbury', '캠루프스': 'Kamloops', '세인트 존': 'Saint John', '구엘프': 'Guelph', '브랜던': 'Brandon', '코너 브룩': 'Corner Brook', '프린스 조지': 'Prince George', '무스 조': 'Moose Jaw',
    '멕시코시티': 'Mexico City', '칸쿤': 'Cancun', '툴룸': 'Tulum', '카보산루카스': 'Cabo San Lucas', '파라초': 'Paracho', '파랄': 'Parral', '틀락스칼라': 'Tlaxcala', '콜리마': 'Colima',
    '아바나': 'Havana', '바라데로': 'Varadero', '트리니다드': 'Trinidad', '비냘레스(마을)': 'Vinales', '라스 투나스': 'Las Tunas', '바야모': 'Bayamo', '마탄사스': 'Matanzas', '구아네': 'Guane',

    // 아프리카 (Africa)
    '카이로': 'Cairo', '룩소르': 'Luxor', '아스완': 'Aswan', '다합': 'Dahab',
    '마라케시': 'Marrakech', '카사블랑카': 'Casablanca', '페스': 'Fes', '쉐프샤우엔': 'Chefchaouen', '메르주가': 'Merzouga',
    '케이프타운': 'Cape Town', '크루거 국립공원': 'Kruger National Park',

    // 오세아니아 (Oceania)
    '시드니': 'Sydney', '멜버른': 'Melbourne', '브리즈번': 'Brisbane', '바이런 베이': 'Byron Bay', '울룰루': 'Uluru', '태즈메이니아': 'Tasmania',
    '오클랜드': 'Auckland', '퀸스타운': 'Queenstown', '테카포': 'Tekapo', '로토루아': 'Rotorua',

    // 아시아 (Asia)
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _allAssets = manifest.listAssets();
    } catch (e) {
      print('❌ 도시 에셋 로드 실패: $e');
    }

    Map<String, List<Map<String, String>>>? countryCities = TravelData.citiesByCountry[widget.countryName];
    List<Map<String, String>> rawData;

    if (countryCities != null) {
      rawData = widget.isPopular ? (countryCities['popular'] ?? []) : (countryCities['quiet'] ?? []);
    } else {
      rawData = widget.isPopular ? TravelData.defaultPopularCities : TravelData.defaultQuietCities;
    }

    setState(() {
      cities = rawData.map((data) => CityInfo(
        name: data['name']!,
        description: data['description']!,
      )).toList();
      _isLoading = false;
    });
  }

  // 🔥 1개의 Cities 폴더 안에서 대소문자, 확장자 무관하게 이미지를 찾는 로직
  String? _getCityImagePath(String koreanCityName) {
    String engName = _cityEngMap[koreanCityName] ?? '';
    if (engName.isEmpty) return null;

    // 슬래시 등 특수문자 제거 및 소문자로 변환
    String safeEngName = engName.replaceAll('/', '').replaceAll('  ', ' ').trim().toLowerCase();

    try {
      final matchedPath = _allAssets.firstWhere((path) {
        String lowerPath = path.toLowerCase();

        // 1. 반드시 'images/cities/' 폴더 안에 있는 파일이어야 함 (국가 이미지와 혼동 방지)
        bool isInCitiesFolder = lowerPath.contains('images/cities/');

        // 2. 파일명이 영어 도시명으로 시작하는지 확인 (예: amsterdam.jpg, amsterdam.webp 등)
        String fileName = lowerPath.split('/').last;
        bool isMatchingName = fileName.startsWith('$safeEngName.');

        return isInCitiesFolder && isMatchingName;
      });
      return matchedPath;
    } catch (e) {
      print('⚠️ [$koreanCityName] 이미지를 찾을 수 없습니다. (검색어: $safeEngName)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          '${widget.countryName} 도시 선택',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : cities.isEmpty
          ? Center(child: Text('${widget.countryName}의 도시 데이터가 없습니다.'))
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.85,
        ),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          final imagePath = _getCityImagePath(city.name);

          return CityGridCard(
            title: city.name,
            subtitle: city.description,
            imagePath: imagePath,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CityDetailScreen(cityName: city.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CityGridCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imagePath;
  final VoidCallback onTap;

  const CityGridCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: [
            imagePath != null
                ? Image.asset(
              imagePath!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            )
                : Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(CupertinoIcons.photo, color: Colors.black26, size: 40),
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.black45, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
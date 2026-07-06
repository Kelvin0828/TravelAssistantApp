// lib/Project/screens/country_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart'; // 🔥 AssetManifest 사용을 위해 필수
import 'dart:convert';
import 'city_list_screen.dart';
import '../models/travel_models.dart';
import '../data/travel_data.dart';
import '../services/mofa_service.dart';
import '../widgets/auto_sliding_image_card.dart';

class CountryListScreen extends StatefulWidget {
  final String continent;
  final bool isPopular;

  const CountryListScreen({
    super.key,
    required this.continent,
    required this.isPopular,
  });

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  List<CountryInfo> countries = [];
  List<String> _allAssets = [];
  bool _isLoading = true;
  bool _apiFetchFailed = false;

  final Map<String, String> _isoCodes = {
    '대한민국': 'KR', '일본': 'JP', '대만': 'TW', '중국': 'CN', '홍콩': 'HK', '마카오': 'MO',
    '베트남': 'VN', '태국': 'TH', '인도네시아': 'ID', '말레이시아': 'MY', '싱가포르': 'SG',
    '필리핀': 'PH', '몽골': 'MN', '라오스': 'LA', '캄보디아': 'KH', '인도': 'IN', '몰디브': 'MV',
    '아랍에미리트': 'AE', '프랑스': 'FR', '이탈리아': 'IT', '스위스': 'CH', '스페인': 'ES',
    '영국': 'GB', '독일': 'DE', '오스트리아': 'AT', '체코': 'CZ', '헝가리': 'HU',
    '크로아티아': 'HR', '튀르키예공화국': 'TR', '그리스': 'GR', '네덜란드': 'NL', '벨기에': 'BE',
    '아이슬란드': 'IS', '포르투갈': 'PT', '노르웨이': 'NO', '스웨덴': 'SE', '핀란드': 'FI',
    '미합중국': 'US', '미국': 'US', '캐나다': 'CA', '멕시코': 'MX', '코스타리카': 'CR', '쿠바': 'CU',
    '브라질': 'BR', '아르헨티나': 'AR', '페루': 'PE', '칠레': 'CL', '콜롬비아': 'CO',
    '호주': 'AU', '뉴질랜드': 'NZ', '이집트': 'EG', '모로코': 'MA', '남아프리카공화국': 'ZA', '케냐': 'KE',
  };

  final Map<String, String> _continentEngMap = {
    '아시아': 'Asia',
    '유럽': 'Europe',
    '북아메리카': 'NorthAmerica',
    '남아메리카': 'SouthAmerica',
    '오세아니아': 'Oceania',
    '아프리카': 'Africa',
  };

  final Map<String, String> _countryEngMap = {
    '대한민국': 'SouthKorea', '일본': 'Japan', '대만': 'Taiwan', '중국': 'China', '홍콩': 'HongKong', '마카오': 'Macau',
    '베트남': 'Vietnam', '태국': 'Thailand', '인도네시아': 'Indonesia', '말레이시아': 'Malaysia', '싱가포르': 'Singapore',
    '필리핀': 'Philippines', '몽골': 'Mongolia', '라오스': 'Laos', '캄보디아': 'Cambodia', '인도': 'India', '몰디브': 'Maldives',
    '아랍에미리트': 'Uae', '프랑스': 'France', '이탈리아': 'Italy', '스위스': 'Swiss', '스페인': 'Spain',
    '영국': 'Britain', '독일': 'Germany', '오스트리아': 'Austria', '체코': 'Chez', '헝가리': 'Hungary',
    '크로아티아': 'Croatia', '튀르키예공화국': 'Turkey', '그리스': 'Greece', '네덜란드': 'Netherlands', '벨기에': 'Belgium',
    '아이슬란드': 'Iceland', '포르투갈': 'Portugal', '노르웨이': 'Norway', '스웨덴': 'Sweden', '핀란드': 'Finland',
    '미합중국': 'Us', '미국': 'Us', '캐나다': 'Canada', '멕시코': 'Mexico', '코스타리카': 'CostaRica', '쿠바': 'Cuba',
    '브라질': 'Brazil', '아르헨티나': 'Argentina', '페루': 'Peru', '칠레': 'Chile', '콜롬비아': 'Colombia',
    '호주': 'Australia', '뉴질랜드': 'NewZealand', '이집트': 'Egypt', '모로코': 'Morocco', '남아프리카공화국': 'SouthAfrica', '케냐': 'Kenya',
  };

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() {
      _isLoading = true;
      _apiFetchFailed = false;
    });

    // 🔥 최신 플러터 버전에 맞춘 안전한 에셋 로드 방식
    try {
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _allAssets = manifest.listAssets();
      print('✅ 시스템 전체 에셋 ${ _allAssets.length }개 로드 완료!');
    } catch (e) {
      print('❌ 에셋 목록 로드 실패 (사진이 안 뜰 수 있습니다): $e');
    }

    final Map<String, String>? fetchedSafetyData = await MofaService.fetchTravelAlarms();

    if (fetchedSafetyData == null) {
      _apiFetchFailed = true;
    }
    final Map<String, String> safeData = fetchedSafetyData ?? {};

    List<CountryInfo> localCountries = [];

    TravelData.countriesByContinent.forEach((continentName, countryList) {
      for (var countryMap in countryList) {
        bool isPop = countryMap['type'] == 'popular' || countryMap['type'] == 'both';
        bool isQuiet = countryMap['type'] == 'quiet' || countryMap['type'] == 'both';

        bool isContinentMatch = false;
        String uiContinent = widget.continent.trim().toLowerCase();
        String dataContinent = continentName.trim().toLowerCase();

        if (uiContinent.isEmpty || uiContinent == 'all' || uiContinent == '전체') {
          isContinentMatch = true;
        } else if (uiContinent.contains(dataContinent) || dataContinent.contains(uiContinent)) {
          isContinentMatch = true;
        } else {
          if (dataContinent == '북아메리카' && (uiContinent.contains('북미') || uiContinent.contains('north'))) {
            isContinentMatch = true;
          } else if (dataContinent == '남아메리카' && (uiContinent.contains('남미') || uiContinent.contains('south'))) {
            isContinentMatch = true;
          } else if (dataContinent == '오세아니아' && uiContinent.contains('oceania')) {
            isContinentMatch = true;
          } else if (dataContinent == '아프리카' && uiContinent.contains('africa')) {
            isContinentMatch = true;
          } else if (dataContinent == '아시아' && uiContinent.contains('asia')) {
            isContinentMatch = true;
          } else if (dataContinent == '유럽' && uiContinent.contains('europe')) {
            isContinentMatch = true;
          }
        }

        bool isMatch = false;
        if (isContinentMatch) {
          isMatch = widget.isPopular ? isPop : isQuiet;
        }

        if (isMatch) {
          String pureName = countryMap['name'] ?? '';

          String? apiLevel = safeData[pureName];
          String finalSafetyLevel = (apiLevel != null && apiLevel.isNotEmpty)
              ? '$apiLevel단계'
              : (countryMap['safetyLevel'] ?? '정보 없음');

          localCountries.add(
            CountryInfo(
              name: pureName,
              reason: countryMap['reason'] ?? '',
              safetyLevel: finalSafetyLevel,
            ),
          );
        }
      }
    });

    setState(() {
      countries = localCountries;
      _isLoading = false;
    });
  }

  Widget _buildSafetyBadge(String level) {
    Color bgColor;
    Color textColor;
    IconData icon;

    if (level.contains('1단계')) {
      bgColor = Colors.blue.shade500;
      textColor = Colors.white;
      icon = Icons.info_outline;
    } else if (level.contains('2단계')) {
      bgColor = Colors.orange.shade500;
      textColor = Colors.white;
      icon = Icons.warning_amber_rounded;
    } else if (level.contains('3단계')) {
      bgColor = Colors.red.shade500;
      textColor = Colors.white;
      icon = Icons.error_outline;
    } else if (level.contains('4단계')) {
      bgColor = Colors.black;
      textColor = Colors.white;
      icon = Icons.dangerous_outlined;
    } else {
      bgColor = Colors.green.shade500;
      textColor = Colors.white;
      icon = Icons.gpp_good_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            level,
            style: TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 🔥 대소문자를 모두 소문자로 변환하여 검색 (인식 실패 완벽 방지)
  List<String> _getCountryImagePaths(String continentName, String countryName) {
    String continentEng = _continentEngMap[continentName] ?? 'UnknownContinent';
    String countryEng = _countryEngMap[countryName] ?? 'UnknownCountry';

    // 경로를 소문자로 통일 (예: images/countries/northamerica/mexico/)
    String targetFolder = 'images/countries/${continentEng.toLowerCase()}/${countryEng.toLowerCase()}/';

    List<String> images = _allAssets.where((path) {
      String lowerPath = path.toLowerCase();
      return lowerPath.startsWith(targetFolder) &&
          (lowerPath.endsWith('.jpg') ||
              lowerPath.endsWith('.jpeg') ||
              lowerPath.endsWith('.png') ||
              lowerPath.endsWith('.webp') ||
              lowerPath.endsWith('.jfif') ||
              lowerPath.endsWith('.gif'));
    }).toList();

    // 숫자가 뒤죽박죽 나오는 것을 방지하기 위해 파일명순(1, 2, 3...)으로 정렬
    images.sort();

    // 개발자가 터미널에서 성공/실패 여부를 쉽게 확인할 수 있도록 로그 출력
    if (images.isEmpty) {
      print('⚠️ [$countryName] 이미지 로드 실패 - 경로를 확인하세요: $targetFolder');
    } else {
      print('📸 [$countryName] 이미지 ${images.length}장 정상 로드');
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        title: Text(
            (widget.isPopular && widget.continent.isEmpty)
                ? '인기 추천 국가'
                : '${widget.continent} 추천 국가',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if (_apiFetchFailed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
              color: Colors.red.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.exclamationmark_triangle_fill, color: Colors.red.shade700, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '최신 안전 정보를 불러오지 못해 기본 데이터를 표시합니다.',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          Expanded(
            child: countries.isEmpty
                ? Center(child: Text('${widget.continent} 지역의 데이터가 없습니다.', style: const TextStyle(fontSize: 16)))
                : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                final isoCode = _isoCodes[country.name] ?? 'KR';

                final imagePaths = _getCountryImagePaths(widget.continent, country.name);

                return AutoSlidingImageCard(
                  title: '$isoCode ${country.name}',
                  subtitle: country.reason,
                  badge: _buildSafetyBadge(country.safetyLevel),
                  imagePaths: imagePaths,
                  onTap: () {
                    void navigateToCityList() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityListScreen(
                            countryName: country.name,
                            isPopular: widget.isPopular,
                          ),
                        ),
                      );
                    }

                    if (country.safetyLevel.contains('4단계')) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: const Row(
                              children: [
                                Icon(Icons.dangerous, color: Colors.red),
                                SizedBox(width: 8),
                                Text('여행 금지 경고', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                            content: Text(
                              '${country.name}은(는) 현재 외교부 지정 여행 경보 4단계(여행금지) 지역입니다.\n\n방문 시 관련 법령에 의해 처벌받을 수 있으며 생명과 안전을 위협받을 수 있습니다. 그래도 해당 국가의 정보를 확인하시겠습니까?',
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('돌아가기', style: TextStyle(color: Colors.grey)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade50,
                                  foregroundColor: Colors.red.shade700,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  navigateToCityList();
                                },
                                child: const Text('무시하고 보기'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      navigateToCityList();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
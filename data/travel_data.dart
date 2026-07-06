// lib/Project/data/travel_data.dart

class TravelData {
  static const Map<String, List<Map<String, String>>> countriesByContinent = {
    '아시아': [
      {'name': '대한민국', 'flag': '🇰🇷', 'reason': '전통과 첨단 트렌드가 공존하는 다이내믹 코리아', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '일본', 'flag': '🇯🇵', 'reason': '가깝고 맛있는 음식이 가득한 매력적인 이웃나라', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '대만', 'flag': '🇹🇼', 'reason': '다채로운 야시장과 미식의 천국', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '중국', 'flag': '🇨🇳', 'reason': '압도적인 스케일의 대자연과 유구한 역사', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '홍콩', 'flag': '🇭🇰', 'reason': '화려한 야경과 쇼핑, 미식의 중심지', 'safetyLevel': '안전', 'type': 'popular'},
      {'name': '마카오', 'flag': '🇲🇴', 'reason': '아시아의 라스베이거스, 동서양 문화의 융합', 'safetyLevel': '안전', 'type': 'popular'},
      {'name': '베트남', 'flag': '🇻🇳', 'reason': '저렴한 물가와 환상적인 휴양지', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '태국', 'flag': '🇹🇭', 'reason': '이국적인 문화와 화려한 사원의 조화', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '인도네시아', 'flag': '🇮🇩', 'reason': '발리를 비롯한 아름다운 자연경관', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '말레이시아', 'flag': '🇲🇾', 'reason': '다양한 문화가 공존하는 평화로운 국가', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '싱가포르', 'flag': '🇸🇬', 'reason': '세련된 도심과 세계 최고 수준의 치안', 'safetyLevel': '안전', 'type': 'popular'},
      {'name': '필리핀', 'flag': '🇵🇭', 'reason': '에메랄드빛 바다와 해양 스포츠의 천국', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '몽골', 'flag': '🇲🇳', 'reason': '끝없는 초원과 은하수가 펼쳐지는 대자연', 'safetyLevel': '안전', 'type': 'quiet'},
      {'name': '라오스', 'flag': '🇱🇦', 'reason': '시간이 멈춘 듯한 평화로운 불교 국가', 'safetyLevel': '안전', 'type': 'quiet'},
      {'name': '캄보디아', 'flag': '🇰🇭', 'reason': '앙코르와트의 웅장한 미스터리', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '인도', 'flag': '🇮🇳', 'reason': '신비로운 종교와 강렬한 색채의 나라', 'safetyLevel': '위험', 'type': 'both'},
      {'name': '몰디브', 'flag': '🇲🇻', 'reason': '인도양의 보석, 궁극의 프라이빗 휴양지', 'safetyLevel': '안전', 'type': 'quiet'},
      {'name': '아랍에미리트', 'flag': '🇦🇪', 'reason': '사막 위에 세워진 미래 도시의 기적', 'safetyLevel': '안전', 'type': 'popular'},
    ],
    '유럽': [
      {'name': '프랑스', 'flag': '🇫🇷', 'reason': '예술, 낭만, 미식의 중심지', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '이탈리아', 'flag': '🇮🇹', 'reason': '고대 로마의 역사와 풍부한 문화유산', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '스위스', 'flag': '🇨🇭', 'reason': '알프스의 웅장한 대자연을 만끽할 수 있는 곳', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '스페인', 'flag': '🇪🇸', 'reason': '정열적인 플라멩코와 가우디의 건축물', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '영국', 'flag': '🇬🇧', 'reason': '클래식한 매력과 현대적인 문화가 공존하는 곳', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '독일', 'flag': '🇩🇪', 'reason': '오랜 역사와 웅장한 성, 그리고 맥주', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '오스트리아', 'flag': '🇦🇹', 'reason': '클래식 음악과 아름다운 알프스 풍경', 'safetyLevel': '안전', 'type': 'quiet'},
      {'name': '체코', 'flag': '🇨🇿', 'reason': '중세 동화 속 마을 같은 로맨틱한 풍경', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '헝가리', 'flag': '🇭🇺', 'reason': '도나우 강의 진주, 압도적인 국회의사당 야경', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '크로아티아', 'flag': '🇭🇷', 'reason': '아드리아 해의 숨은 보석, 붉은 지붕의 향연', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '튀르키예공화국', 'flag': '🇹🇷', 'reason': '동양과 서양이 교차하는 열기구의 나라', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '그리스', 'flag': '🇬🇷', 'reason': '푸른 지중해와 신화가 살아 숨 쉬는 곳', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '네덜란드', 'flag': '🇳🇱', 'reason': '풍차와 튤립, 자유로운 분위기의 운하 도시', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '벨기에', 'flag': '🇧🇪', 'reason': '달콤한 초콜릿과 와플, 아름다운 중세 광장', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '아이슬란드', 'flag': '🇮🇸', 'reason': '오로라와 빙하, 신비로운 대자연', 'safetyLevel': '안전', 'type': 'quiet'},
      {'name': '포르투갈', 'flag': '🇵🇹', 'reason': '대서양의 햇살과 노란 트램의 낭만', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '노르웨이', 'flag': '🇳🇴', 'reason': '경이로운 피오르드와 북유럽의 웅장함', 'safetyLevel': '안전', 'type': 'quiet'},
      {'name': '스웨덴', 'flag': '🇸🇪', 'reason': '세련된 북유럽 디자인과 평화로운 자연', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '핀란드', 'flag': '🇫🇮', 'reason': '산타의 고향, 숲과 호수가 끝없이 펼쳐진 곳', 'safetyLevel': '안전', 'type': 'quiet'},
    ],
    '북아메리카': [
      {'name': '미국', 'flag': '🇺🇸', 'reason': '광활한 자연과 세계 대도시의 융합', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '캐나다', 'flag': '🇨🇦', 'reason': '숨 막히는 로키산맥과 청정한 자연', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '멕시코', 'flag': '🇲🇽', 'reason': '마야 문명과 아름다운 카리브해', 'safetyLevel': '위험', 'type': 'both'},
      {'name': '코스타리카', 'flag': '🇨🇷', 'reason': '생태 관광의 천국, 순수한 대자연', 'safetyLevel': '안전', 'type': 'quiet'},
      {'name': '쿠바', 'flag': '🇨🇺', 'reason': '올드카와 시가가 있는 카리브해의 시간 여행', 'safetyLevel': '주의', 'type': 'both'},
    ],
    '남아메리카': [
      {'name': '브라질', 'flag': '🇧🇷', 'reason': '정열의 쌈바와 아마존의 신비', 'safetyLevel': '위험', 'type': 'both'},
      {'name': '아르헨티나', 'flag': '🇦🇷', 'reason': '탱고의 고향과 경이로운 이과수 폭포', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '페루', 'flag': '🇵🇪', 'reason': '안데스 산맥의 잃어버린 공중 도시', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '칠레', 'flag': '🇨🇱', 'reason': '길게 뻗은 국토가 빚어낸 파타고니아의 절경', 'safetyLevel': '안전', 'type': 'quiet'},
      {'name': '콜롬비아', 'flag': '🇨🇴', 'reason': '커피 향이 가득한 남미의 숨겨진 보석', 'safetyLevel': '위험', 'type': 'both'},
    ],
    '오세아니아': [
      {'name': '호주', 'flag': '🇦🇺', 'reason': '코알라와 캥거루, 아름다운 산호초', 'safetyLevel': '안전', 'type': 'both'},
      {'name': '뉴질랜드', 'flag': '🇳🇿', 'reason': '반지의 제왕 촬영지, 압도적인 대자연', 'safetyLevel': '안전', 'type': 'quiet'},
    ],
    '아프리카': [
      {'name': '이집트', 'flag': '🇪🇬', 'reason': '신비로운 피라미드와 스핑크스의 나라', 'safetyLevel': '주의', 'type': 'popular'},
      {'name': '모로코', 'flag': '🇲🇦', 'reason': '사하라 사막과 이국적인 메디나', 'safetyLevel': '주의', 'type': 'both'},
      {'name': '남아프리카공화국', 'flag': '🇿🇦', 'reason': '아프리카 대자연과 아프리카의 끝자락', 'safetyLevel': '위험', 'type': 'both'},
      {'name': '케냐', 'flag': '🇰🇪', 'reason': '야생동물이 뛰노는 진짜 사파리 체험', 'safetyLevel': '위험', 'type': 'quiet'},
    ]
  };

  static const Map<String, Map<String, List<Map<String, String>>>> citiesByCountry = {
    '대한민국': {
      'popular': [
        {'name': '서울', 'description': '경복궁부터 강남까지, 트렌드와 역사가 공존하는 수도'},
        {'name': '부산', 'description': '해운대와 광안리의 탁 트인 바다가 반기는 제2의 도시'},
        {'name': '제주도', 'description': '에메랄드빛 바다와 한라산이 있는 환상의 섬'},
      ],
      'quiet': [
        {'name': '경주', 'description': '발길 닿는 곳이 유적인 지붕 없는 박물관'},
        {'name': '강릉', 'description': '푸른 동해 바다와 향긋한 커피거리가 있는 곳'},
        {'name': '안동', 'description': '하회마을이 있는 한국 정신문화의 수도'},
        {'name': '전주', 'description': '한옥마을과 맛깔나는 비빔밥의 고향'},
      ]
    },
    '일본': {
      'popular': [
        {'name': '도쿄', 'description': '현대적인 랜드마크와 트렌드의 중심지'},
        {'name': '오사카', 'description': '먹다 지친다는 미식의 도시'},
        {'name': '후쿠오카', 'description': '가깝고 부담 없이 떠나는 맛집 투어'},
        {'name': '교토', 'description': '일본 전통의 아름다움을 간직한 천년 고도'},
        {'name': '오키나와', 'description': '일본의 하와이, 푸른 산호초 해변'},
      ],
      'quiet': [
        {'name': '삿포로', 'description': '눈 덮인 겨울 왕국과 한적한 대자연'},
        {'name': '가나자와', 'description': '전통이 살아있는 고즈넉한 소도시'},
        {'name': '유후인', 'description': '긴린코 호수와 아기자기한 온천 마을'},
        {'name': '다카마쓰', 'description': '조용한 예술의 섬과 우동 투어'},
        {'name': '구라시키', 'description': '흰 벽과 운하가 어우러진 옛 상인들의 거리'},
      ]
    },
    '중국': {
      'popular': [
        {'name': '베이징', 'description': '만리장성과 자금성을 품은 제국의 수도'},
        {'name': '상하이', 'description': '동양의 파리, 화려한 와이탄 야경'},
        {'name': '광저우', 'description': '딤섬의 본고장, 역동적인 상업 도시'},
      ],
      'quiet': [
        {'name': '장자제 (장가계)', 'description': '영화 아바타의 모티브가 된 기암괴석'},
        {'name': '리장', 'description': '옥룡설산 아래 시간이 멈춘 고성 마을'},
        {'name': '구이린 (계림)', 'description': '수묵화가 현실이 되는 몽환적인 산수경관'},
      ]
    },
    '대만': {
      'popular': [
        {'name': '타이베이', 'description': '활기찬 야시장과 101타워의 멋진 야경'},
        {'name': '가오슝', 'description': '따뜻한 남부의 활기찬 항구 도시'},
      ],
      'quiet': [
        {'name': '타이난', 'description': '대만의 옛 수도, 풍부한 문화유산'},
        {'name': '화롄', 'description': '타이로거 협곡이 있는 웅장한 대자연'},
        {'name': '지우펜', 'description': '홍등이 켜지는 센과 치히로의 모티브 마을'},
      ]
    },
    '홍콩': {
      'popular': [
        {'name': '홍콩섬 (센트럴)', 'description': '세계 최고의 스카이라인과 야경'},
        {'name': '구룡반도 (침사추이)', 'description': '쇼핑과 미식, 스타의 거리가 있는 곳'},
      ],
      'quiet': []
    },
    '베트남': {
      'popular': [
        {'name': '다낭', 'description': '한국인이 가장 사랑하는 휴양지'},
        {'name': '호치민', 'description': '베트남의 경제 중심지, 동양의 파리'},
        {'name': '하노이', 'description': '호수와 어우러진 차분한 천년 수도'},
        {'name': '나트랑', 'description': '동양의 나폴리라 불리는 아름다운 해변'},
      ],
      'quiet': [
        {'name': '달랏', 'description': '연중 봄 날씨의 꽃과 호수의 소도시'},
        {'name': '사파', 'description': '고산지대의 안개 낀 계단식 논 풍경'},
        {'name': '호이안', 'description': '밤이면 등불이 켜지는 로맨틱한 구시가지'},
        {'name': '푸꾸옥', 'description': '떠오르는 한적하고 평화로운 섬'},
      ]
    },
    '태국': {
      'popular': [
        {'name': '방콕', 'description': '화려한 사원과 끝없는 즐길 거리'},
        {'name': '푸껫', 'description': '안다만 해의 진주, 최고의 휴양지'},
        {'name': '파타야', 'description': '다이나믹한 해양 스포츠와 나이트라이프'},
      ],
      'quiet': [
        {'name': '치앙마이', 'description': '한 달 살기의 성지, 여유로운 북방의 장미'},
        {'name': '빠이', 'description': '산속에 숨겨진 전 세계 배낭여행객의 안식처'},
        {'name': '코사무이', 'description': '프라이빗하고 평화로운 고급 휴양 섬'},
        {'name': '끄라비', 'description': '기암절벽과 에메랄드 바다가 빚어낸 절경'},
      ]
    },
    '인도네시아': {
      'popular': [
        {'name': '발리', 'description': '신들의 섬이라 불리는 세계 최고의 휴양지'},
        {'name': '자카르타', 'description': '빠르게 성장하는 역동적인 메트로폴리스'},
      ],
      'quiet': [
        {'name': '우붓 (발리 내륙)', 'description': '울창한 숲과 예술, 요가의 성지'},
        {'name': '롬복', 'description': '개발되지 않은 순수한 자연을 간직한 섬'},
        {'name': '족자카르타', 'description': '보로부두르 사원이 있는 고대 문화의 중심'},
      ]
    },
    '말레이시아': {
      'popular': [
        {'name': '쿠알라룸푸르', 'description': '페트로나스 트윈 타워가 빛나는 현대 도시'},
        {'name': '코타키나발루', 'description': '세계 3대 석양을 자랑하는 해양 휴양지'},
      ],
      'quiet': [
        {'name': '페낭', 'description': '낡은 벽화와 미식의 향연이 펼쳐지는 조지타운'},
        {'name': '말라카', 'description': '유럽과 아시아가 섞인 붉은빛의 항구 도시'},
        {'name': '랑카위', 'description': '안다만 해의 평화로운 면세 휴양 섬'},
      ]
    },
    '싱가포르': {
      'popular': [
        {'name': '마리나 베이', 'description': '마리나 베이 샌즈와 가든스 바이 더 베이가 빛나는 화려한 야경'},
        {'name': '오차드 로드', 'description': '세계적인 브랜드가 끝없이 이어지는 쇼핑의 메카'},
        {'name': '센토사', 'description': '유니버설 스튜디오와 해변이 있는 즐거움과 액티비티의 섬'},
        {'name': '차이나타운', 'description': '다양한 길거리 음식과 붉은빛 사원의 이국적인 조화'},
      ],
      'quiet': [
        {'name': '림추캉', 'description': '맹그로브 숲과 농장들이 모여있는 이색적인 시골 풍경'},
        {'name': '풍골', 'description': '자연 친화적인 수변 공원과 트렌디한 카페가 있는 신도시'},
        {'name': '투아스', 'description': '산업 단지의 불빛과 말레이시아로 향하는 조용한 관문'},
        {'name': '파야레바', 'description': '공군 기지와 현지인들의 일상이 녹아있는 주거 상업 지구'},
      ]
    },
    '필리핀': {
      'popular': [
        {'name': '마닐라', 'description': '과거 스페인 식민지 시대의 성벽 도시와 메트로폴리스의 공존'},
        {'name': '세부', 'description': '다이빙, 호핑투어 등 한국인이 사랑하는 최고의 열대 휴양지'},
        {'name': '보라카이', 'description': '에메랄드빛 바다와 눈처럼 하얀 화이트 비치가 펼쳐진 섬'},
        {'name': '팔라완', 'description': '지하강과 엘니도의 석회암 절벽이 있는 최후의 비경'},
      ],
      'quiet': [
        {'name': '타클로반', 'description': '맥아더 장군의 상륙지와 산후아니코 다리가 있는 레이테 섬의 중심'},
        {'name': '카가얀데오로', 'description': '급류 타기와 에코 투어리즘으로 유명한 미нда나오의 액티비티 도시'},
        {'name': '바콜로드', 'description': '미소의 도시라 불리는 필리핀 최대의 사탕수수 생산지와 마스카라 축제'},
        {'name': '잠보앙가', 'description': '스페인 문화가 강하게 남은 아시아의 라틴 시티이자 항구 도시'},
      ]
    },
    '캄보디아': {
      'popular': [
        {'name': '프놈펜', 'description': '메콩강을 끼고 왕궁과 아픈 역사의 킬링필드가 공존하는 수도'},
        {'name': '씨엠립', 'description': '세계적인 미스터리, 앙코르와트 사원으로 향하는 필수 관문'},
        {'name': '시아누크빌', 'description': '푸른 타이만 해변을 즐길 수 있는 캄보디아 최대의 해안 휴양지'},
        {'name': '바탐방', 'description': '아름다운 프랑스 식민지 시대 건축물과 대나무 기차가 있는 예술 도시'},
      ],
      'quiet': [
        {'name': '스퉁트렝', 'description': '메콩강의 돌고래와 때 묻지 않은 자연을 만날 수 있는 라오스 접경지'},
        {'name': '라타나키리', 'description': '화산 호수 옉롬과 울창한 밀림, 그리고 소수 민족의 삶이 있는 곳'},
        {'name': '몬돌끼리', 'description': '시원한 고산 기후와 코끼리 보호구역이 있는 캄보디아의 거친 대자연'},
        {'name': '캄퐁톰', 'description': '삼보 프레이 쿡 유적지와 고즈넉한 톤레사프 호수 주변의 평화로운 마을'},
      ]
    },
    '인도': {
      'popular': [
        {'name': '델리', 'description': '수천 년 역사가 겹겹이 쌓인 혼돈과 매력의 수도'},
        {'name': '뭄바이', 'description': '발리우드의 심장이자 식민지 시대 건축물이 가득한 인도의 거대한 경제 중심지'},
        {'name': '자이푸르', 'description': '건물들이 핑크빛으로 물든 화려한 핑크 시티이자 라자스탄의 관문'},
        {'name': '아그라', 'description': '불멸의 사랑을 간직한 타지마할이 있는 가장 아름답고 유명한 도시'},
      ],
      'quiet': [
        {'name': '파트나', 'description': '고대 마가다 제국의 수도이자 불교 및 힌두교의 역사적 뿌리가 깊은 성지'},
        {'name': '랑푸르', 'description': '구자라트 주에 위치한 고대 하라파 문명의 흥미로운 고고학적 발굴지'},
        {'name': '간디나가르', 'description': '구자라트의 계획도시이자 정교한 아크샤르담 사원이 있는 깨끗한 도시'},
        {'name': '보팔', 'description': '수많은 인공 호수와 언덕이 어우러진 호수의 도시이자 중부 인도의 중심'},
      ]
    },
    '아랍에미리트': {
      'popular': [
        {'name': '두바이', 'description': '부르즈 할리파와 팜 주메이라가 빛나는 사막 위의 기적 같은 메트로폴리스'},
        {'name': '아부다비', 'description': '셰이크 자이드 그랜드 모스크와 루브르 박물관이 있는 럭셔리한 문화 수도'},
        {'name': '샤르자', 'description': '이슬람 문화와 예술 박물관들이 밀집해 있는 UAE의 지적인 문화 중심지'},
        {'name': '라스알카이마', 'description': '자벨 제이스 산의 짜릿한 짚라인과 해변 리조트가 있는 액티비티 천국'},
      ],
      'quiet': [
        {'name': '푸자이라', 'description': '다이빙과 거친 산악 지형이 매력적인 오만만에 닿아있는 에미리트'},
        {'name': '움알쿠와인', 'description': '고요한 맹그로브 숲과 옛 아랍의 전통적인 어촌 풍경을 간직한 소도시'},
        {'name': '알다이드', 'description': '모래사막 한가운데 오아시스와 대추야자 농장이 펼쳐진 내륙의 농업 도시'},
        {'name': '무와일리 (Muwailih)', 'description': '샤르자 외곽의 떠오르는 푸드 트럭과 카페 거리 등 로컬 트렌드 중심지'},
      ]
    },
    '미국': {
      'popular': [
        {'name': '뉴욕', 'description': '잠들지 않는 세계의 중심, 타임스퀘어와 센트럴파크'},
        {'name': '로스앤젤레스', 'description': '할리우드와 연중 따뜻한 캘리포니아의 햇살'},
        {'name': '시카고', 'description': '건축과 딥디쉬 피자의 매력적인 윈디 시티'},
        {'name': '라스베이거스', 'description': '사막 위에 지어진 화려한 엔터테인먼트의 도시'},
        {'name': '샌프란시스코', 'description': '금문교와 낭만적인 케이블카'},
        {'name': '워싱턴 D.C.', 'description': '미국의 심장이자 수많은 박물관이 있는 수도'},
        {'name': '보스턴', 'description': '하버드와 MIT가 있는 역사 깊은 교육의 도시'},
        {'name': '마이애미', 'description': '끝없이 펼쳐진 해변과 화려한 라틴 문화'},
        {'name': '올랜도', 'description': '전 세계 테마파크 팬들의 꿈의 도시'},
        {'name': '시애틀', 'description': '스타벅스 1호점과 스페이스 니들의 낭만'},
        {'name': '호놀룰루', 'description': '와이키키 해변이 있는 태평양의 지상 낙원'},
        {'name': '샌디에이고', 'description': '연중 온화한 날씨와 아름다운 해안선'},
        {'name': '필라델피아', 'description': '미국 독립의 역사가 살아 숨 쉬는 곳'},
        {'name': '애틀랜타', 'description': '남부의 중심이자 CNN과 코카콜라의 고향'},
        {'name': '뉴올리언스', 'description': '재즈의 선율과 독특한 크레올 문화'},
        {'name': '내슈빌', 'description': '컨트리 음악의 성지이자 활기찬 도시'},
        {'name': '댈러스', 'description': '카우보이 문화와 현대적인 예술이 공존하는 곳'},
        {'name': '휴스턴', 'description': 'NASA 우주 센터가 있는 거대한 메트로폴리스'},
        {'name': '포틀랜드', 'description': '힙스터 문화와 평화로운 자연의 조화'},
        {'name': '덴버', 'description': '로키산맥의 관문인 마일 하이 시티'},
      ],
      'quiet': [
        {'name': '보이시', 'description': '자연 친화적이고 평화로운 아이다호의 중심'},
        {'name': '덜루스', 'description': '슈피리어호의 장엄한 풍경을 품은 항구 도시'},
        {'name': '유레카', 'description': '울창한 레드우드 숲과 빅토리아풍 건축물'},
        {'name': '포트 웨인', 'description': '가족 친화적이고 조용한 인디애나의 도시'},
        {'name': '녹스빌', 'description': '스모키 마운틴으로 향하는 여유로운 관문'},
        {'name': '오클라호마시티', 'description': '서부의 역사와 현대적 감각이 만나는 곳'},
        {'name': '위치타', 'description': '항공 산업의 중심이자 활기찬 캔자스의 도시'},
        {'name': '디모인', 'description': '평화로운 농업 지대와 어우러진 아이오와의 수도'},
        {'name': '링컨', 'description': '광활한 평원 속 네브래스카의 여유로운 대학 도시'},
        {'name': '시더래피즈', 'description': '체코 문화의 흔적이 남은 예술적인 소도시'},
        {'name': '수폴스', 'description': '도심 한가운데 아름다운 폭포가 흐르는 곳'},
      ]
    },
    '캐나다': {
      'popular': [
        {'name': '토론토', 'description': 'CN타워와 나이아가라 폭포로 향하는 다문화 중심지'},
        {'name': '밴쿠버', 'description': '바다와 산이 어우러진 살기 좋은 항구 도시'},
        {'name': '몬트리올', 'description': '북미의 파리, 프랑스어와 세련된 문화의 중심'},
        {'name': '나이아가라 폴스', 'description': '세계에서 가장 유명하고 웅장한 폭포'},
        {'name': '퀘벡시티', 'description': '드라마 도깨비 촬영지, 동화 같은 프랑스풍 구시가지'},
        {'name': '오타와', 'description': '아름다운 리도 운하가 흐르는 고풍스러운 수도'},
        {'name': '캘거리', 'description': '로키산맥 동쪽의 로데오 축제와 카우보이 문화'},
        {'name': '빅토리아', 'description': '정원이 아름다운 브리티시컬럼비아의 우아한 수도'},
        {'name': '위니펙', 'description': '대초원 지대의 중심이자 다문화가 숨 쉬는 곳'},
        {'name': '에드먼턴', 'description': '거대한 쇼핑몰과 활기찬 축제의 도시'},
        {'name': '핼리팩스', 'description': '대서양의 아름다운 항구와 풍부한 해양 역사'},
        {'name': '휘슬러', 'description': '세계 최고의 스키 리조트와 액티비티 천국'},
      ],
      'quiet': [
        {'name': '트로아 리비에르', 'description': '퀘벡의 역사가 깃든 세인트로렌스강 유역의 소도시'},
        {'name': '선더베이', 'description': '슈피리어호 북쪽의 광활한 대자연을 품은 곳'},
        {'name': '레드 디어', 'description': '캘거리와 에드먼턴 사이의 평화로운 거점 도시'},
        {'name': '멍크턴', 'description': '아카디아 문화와 조수 간만의 차를 볼 수 있는 곳'},
        {'name': '서드베리', 'description': '독특한 지형과 거대한 동전 조형물이 있는 광산 도시'},
        {'name': '캠루프스', 'description': '건조한 기후와 야외 액티비티가 발달한 내륙 도시'},
        {'name': '세인트 존', 'description': '펀디만의 조수와 역사적인 구시가지가 돋보이는 곳'},
        {'name': '구엘프', 'description': '석회암 건축물과 농업 연구가 유명한 평온한 도시'},
        {'name': '브랜던', 'description': '매니토바주 대초원의 농업과 교육 중심지'},
        {'name': '코너 브룩', 'description': '뉴펀들랜드섬 서해안의 웅장한 피오르드 관문'},
        {'name': '프린스 조지', 'description': '브리티시컬럼비아 북부 울창한 숲의 거점'},
        {'name': '무스 조', 'description': '온천과 지하 터널 투어가 있는 사스캐처원의 이색 소도시'},
      ]
    },
    '멕시코': {
      'popular': [
        {'name': '멕시코시티', 'description': '아즈텍 문명과 스페인 식민지 문화가 섞인 거대 수도'},
        {'name': '칸쿤', 'description': '카리브해의 에메랄드빛 바다와 올인클루시브 리조트'},
        {'name': '툴룸', 'description': '마야 유적과 카리브해가 어우러진 신비로운 곳'},
        {'name': '카보산루카스', 'description': '바하칼리포르니아 반도의 럭셔리한 휴양지'},
      ],
      'quiet': [
        {'name': '파라초', 'description': '영화 코코의 모티브가 된 아름다운 기타 장인의 마을'},
        {'name': '파랄', 'description': '멕시코 혁명의 역사와 웅장한 광산이 남겨진 도시'},
        {'name': '틀락스칼라', 'description': '멕시코에서 가장 작은 주에 숨겨진 깊은 역사와 문화'},
        {'name': '콜리마', 'description': '화산의 절경과 평화로운 분위기가 어우러진 소도시'},
      ]
    },
    '쿠바': {
      'popular': [
        {'name': '아바나', 'description': '파스텔톤 올드카와 시가 향기가 가득한 시간 여행'},
        {'name': '바라데로', 'description': '카리브해 최고의 새하얀 백사장이 펼쳐진 휴양지'},
        {'name': '트리니다드', 'description': '스페인 식민 시대가 완벽히 보존된 알록달록한 마을'},
        {'name': '비냘레스(마을)', 'description': '독특한 석회암 언덕과 시가 농장이 펼쳐진 푸른 대자연'},
      ],
      'quiet': [
        {'name': '라스 투나스', 'description': '마술과 조각품이 곳곳에 있는 독특하고 평화로운 도시'},
        {'name': '바야모', 'description': '쿠바 독립의 발상지이자 역사가 깃든 말마차의 도시'},
        {'name': '마탄사스', 'description': '운하와 다리가 많아 쿠바의 아테네라 불리는 곳'},
        {'name': '구아네', 'description': '때 묻지 않은 자연과 동굴을 탐험할 수 있는 서부 끝자락'},
      ]
    },
    '체코': {
      'popular': [
        {'name': '프라하', 'description': '빨간 지붕과 낭만적인 야경의 로맨틱 도시'},
        {'name': '체스키크룸로프', 'description': '블타바 강이 감싸고 도는 중세 보석 같은 소도시'},
        {'name': '브르노', 'description': '체코 제2의 도시, 트렌디한 카페와 모더니즘 건축'},
        {'name': '카를로비바리', 'description': '온천수를 마시며 힐링하는 유럽 귀족들의 휴양지'},
        {'name': '플젠', 'description': '필스너 맥주의 탄생지, 양조장 투어의 성지'},
      ],
      'quiet': [
        {'name': '올로모우츠', 'description': '프라하의 축소판, 성 삼위일체 탑이 있는 역사 도시'},
        {'name': '텔치', 'description': '호수와 르네상스 양식의 건물들이 어우러진 동화 마을'},
        {'name': '리베레츠', 'description': '예슈테트 타워와 아름다운 자연경관을 품은 북부 도시'},
        {'name': '오스트라바', 'description': '산업 혁명의 유산이 독특한 문화 공간으로 재탄생한 곳'},
        {'name': '파르두비체', 'description': '달콤한 진저브레드와 경마로 유명한 여유로운 도시'},
        {'name': '즈노이모', 'description': '와인 산지와 중세 성곽이 남아있는 남모라바의 진주'},
      ]
    },
    '헝가리': {
      'popular': [
        {'name': '부다페스트', 'description': '도나우 강의 진주, 압도적인 국회의사당 야경'},
        {'name': '데브레첸', 'description': '헝가리 제2의 도시, 웅장한 대교회와 문화 중심지'},
        {'name': '세게드', 'description': '티서강이 흐르는 일조량 풍부한 햇살의 도시'},
        {'name': '페치', 'description': '초기 기독교 유적과 지중해풍 분위기가 매력적인 곳'},
        {'name': '에게르', 'description': '영웅적인 역사와 황소의 피 와인이 있는 매혹적인 소도시'},
      ],
      'quiet': [
        {'name': '죄르', 'description': '다채로운 바로크 건축물과 강물이 합쳐지는 고즈넉한 도시'},
        {'name': '쇼프론', 'description': '오스트리아 국경 근처의 역사적인 중세 구시가지'},
        {'name': '케치케메트', 'description': '아르누보 양식의 건물과 살구 팔링카가 유명한 곳'},
        {'name': '미슈콜츠', 'description': '릴라퓌레드 폭포와 동굴 온천을 즐길 수 있는 자연의 도시'},
        {'name': '세케슈페헤르바르', 'description': '역대 헝가리 국왕들의 대관식이 열렸던 유서 깊은 고도'},
        {'name': '에스테르곰', 'description': '거대한 대성당이 굽어보는 다뉴브강 변의 종교적 중심지'},
      ]
    },
    '크로아티아': {
      'popular': [
        {'name': '두브로브니크', 'description': '아드리아 해의 진주, 성벽으로 둘러싸인 구시가지'},
        {'name': '스플리트', 'description': '디오클레티아누스 궁전이 있는 달마티아의 심장'},
        {'name': '자그레브', 'description': '아기자기한 매력의 크로아티아 수도'},
        {'name': '자다르', 'description': '파도가 연주하는 바다 오르간과 황홀한 일몰'},
        {'name': '로빈', 'description': '이스트라 반도의 베네치아라 불리는 낭만적인 항구 도시'},
      ],
      'quiet': [
        {'name': '시베니크', 'description': '세계유산인 성 야고보 대성당이 있는 중세 돌의 도시'},
        {'name': '풀라', 'description': '거대한 고대 로마 원형 투기장이 완벽하게 보존된 곳'},
        {'name': '바라주딘', 'description': '바로크 양식의 궁전과 성이 남겨진 우아한 구시가지'},
        {'name': '오시예크', 'description': '드라바 강변을 따라 여유롭게 산책하기 좋은 동부 중심지'},
        {'name': '트로기르', 'description': '성벽으로 둘러싸인 작은 섬 위의 완벽한 중세 박물관'},
        {'name': '리예카', 'description': '다양한 문화가 교차하는 활기찬 항구이자 산업 도시'},
      ]
    },
    '튀르키예공화국': {
      'popular': [
        {'name': '이스탄불', 'description': '유럽과 아시아가 만나는 비잔틴의 심장'},
        {'name': '안탈리아', 'description': '튀르키예인들이 사랑하는 지중해 최고 휴양지'},
        {'name': '이즈미르', 'description': '에게해의 진주라 불리는 세련되고 자유로운 해안 도시'},
        {'name': '괴레메/카파도키아', 'description': '기암괴석 위로 떠오르는 수백 개의 열기구'},
        {'name': '보드룸', 'description': '하얀 집들과 요트가 어우러진 튀르키예의 산토리니'},
        {'name': '쿠샤다스', 'description': '에페수스 유적으로 향하는 활기찬 크루즈 기항지'},
      ],
      'quiet': [
        {'name': '부르사', 'description': '오스만 제국의 첫 번째 수도이자 실크의 도시'},
        {'name': '콘야', 'description': '메블라나 교단과 회전 춤으로 유명한 신비로운 종교 도시'},
        {'name': '에스키셰히르', 'description': '운하를 따라 곤돌라가 다니는 트렌디한 대학 도시'},
        {'name': '트라브존', 'description': '흑해의 거친 자연과 절벽에 매달린 수멜라 수도원'},
        {'name': '마르딘', 'description': '메소포타미아 평원을 굽어보는 황토빛의 아름다운 옛 도시'},
        {'name': '샨르우르파', 'description': '예언자 아브라함의 탄생지로 알려진 성스러운 순례지'},
      ]
    },
    '그리스': {
      'popular': [
        {'name': '아테네', 'description': '파르테논 신전이 있는 서양 문명의 요람'},
        {'name': '테살로니키', 'description': '비잔틴 유적과 트렌디한 문화가 공존하는 제2의 도시'},
        {'name': '산토리니', 'description': '하얀 벽과 파란 지붕, 엽서 속 낭만의 섬'},
        {'name': '미코노스', 'description': '골목골목 하얀 집들이 가득한 트렌디한 섬'},
        {'name': '로도스', 'description': '기사단의 성벽과 중세 시대 거리가 완벽히 보존된 섬'},
        {'name': '이라클리온', 'description': '크레타 섬의 중심이자 미노아 문명의 크노소스 궁전'},
      ],
      'quiet': [
        {'name': '이오안니나', 'description': '은공예품과 잔잔한 호수가 매력적인 에피루스의 중심'},
        {'name': '카발라', 'description': '언덕 위 성채와 오스만 양식의 수로가 돋보이는 해안 도시'},
        {'name': '나플리오', 'description': '세 성곽이 지키는 낭만적이고 우아한 그리스의 첫 수도'},
        {'name': '파트라', 'description': '로마 시대 극장과 거대한 카니발 축제로 유명한 항구 도시'},
        {'name': '볼로스', 'description': '펠리온 산의 신화가 깃든 치푸라디코(전통 선술집)의 고향'},
        {'name': '칼라마타', 'description': '아름다운 올리브 밭과 여유로운 펠로폰네소스의 자연'},
      ]
    },
    '네덜란드': {
      'popular': [
        {'name': '암스테르담', 'description': '운하와 자전거, 박물관이 가득한 자유의 도시'},
        {'name': '로테르담', 'description': '독특한 현대 건축물들이 돋보이는 제2의 도시'},
        {'name': '헤이그', 'description': '명화와 국제 사법 재판소가 있는 우아한 정치 도시'},
        {'name': '위트레흐트', 'description': '미피의 고향이자 네덜란드에서 가장 아름다운 운하를 가진 곳'},
        {'name': '마스트리흐트', 'description': '독일, 벨기에 국경에 맞닿아 있는 유러피안 감성의 고도'},
      ],
      'quiet': [
        {'name': '흐로닝언', 'description': '자전거와 젊음의 에너지가 넘치는 북부의 매력적인 대학 도시'},
        {'name': '델프트', 'description': '푸른빛 도자기와 진주 귀걸이를 한 소녀의 고즈넉한 배경'},
        {'name': '하를럼', 'description': '튤립의 중심지이자 암스테르담 근교의 조용하고 아름다운 구시가지'},
        {'name': '라이덴', 'description': '네덜란드 최고(最古) 대학과 렘브란트의 숨결이 남은 곳'},
        {'name': '아인트호벤', 'description': '필립스의 본고장, 현대적인 디자인과 하이테크의 중심지'},
        {'name': '즈볼러', 'description': '별 모양의 해자와 아름다운 서점이 있는 한자 동맹 도시'},
      ]
    },
    '벨기에': {
      'popular': [
        {'name': '브뤼셀', 'description': '달콤한 초콜릿과 와플, 그랑 플라스의 웅장함'},
        {'name': '브뤼헤', 'description': '아름다운 운하와 백조가 있는 플랑드르의 동화 마을'},
        {'name': '안트베르펜', 'description': '화려한 다이아몬드와 루벤스의 명작이 있는 패션의 도시'},
        {'name': '겐트', 'description': '중세 성과 트렌디한 분위기가 조화로운 플랑드르의 숨은 보석'},
        {'name': '루벤', 'description': '오랜 역사의 대학과 맥주의 활기찬 고향'},
        {'name': '메헬렌', 'description': '거대한 종탑이 울려 퍼지는 평화롭고 고풍스러운 소도시'},
      ],
      'quiet': [
        {'name': '나뮈르', 'description': '강물이 만나는 절벽 위의 웅장한 요새 도시'},
        {'name': '디낭', 'description': '기암절벽과 색소폰의 창시자 아돌프 삭스의 고향'},
        {'name': '리에주', 'description': '활기찬 왈론 지역의 중심이자 맛있는 정통 와플의 성지'},
        {'name': '몽스', 'description': '유네스코 종탑과 르네상스 양식이 어우러진 매력적인 문화 도시'},
        {'name': '이프르', 'description': '플랜더스 들판의 슬픈 역사와 장엄한 직물 회관이 남은 곳'},
        {'name': '오스텐더', 'description': '길게 뻗은 모래사장과 북해의 신선한 해산물이 있는 휴양지'},
      ]
    },
    '포르투갈': {
      'popular': [
        {'name': '리스본', 'description': '대서양의 햇살과 노란 트램의 낭만'},
        {'name': '포르투', 'description': '도우루 강변의 포트와인과 클래식한 야경'},
        {'name': '파루', 'description': '알가르브 해안의 아름다운 절경과 따뜻한 햇살의 관문'},
        {'name': '코임브라', 'description': '파두의 선율과 해리포터의 영감이 된 유서 깊은 대학 도시'},
        {'name': '브라가', 'description': '가장 오래된 대성당과 깊은 종교적 역사가 있는 곳'},
        {'name': '신트라', 'description': '페나 궁전 등 동화 속 궁전들이 모여있는 신비한 산속 마을'},
      ],
      'quiet': [
        {'name': '기마랑이스', 'description': '포르투갈의 국가적 정체성이 태동한 매력적인 중세 도시'},
        {'name': '에보라', 'description': '고대 로마 신전과 섬뜩하고 신비로운 뼈의 예배당이 있는 고도'},
        {'name': '나자레', 'description': '세계에서 가장 높은 파도를 타는 서퍼들의 짜릿한 성지'},
        {'name': '오비두스', 'description': '성벽으로 둘러싸인 아기자기한 골목과 달콤한 체리 주스'},
        {'name': '아베이루', 'description': '포르투갈의 베니스라 불리는 다채로운 색감의 운하 도시'},
        {'name': '비제우', 'description': '맛있는 와인과 화려한 르네상스 건축물이 가득한 내륙 중심지'},
      ]
    },
    '스웨덴': {
      'popular': [
        {'name': '스톡홀름', 'description': '세련된 북유럽 디자인과 군도 위 평화로운 자연'},
        {'name': '예테보리', 'description': '활기찬 항구와 짜릿한 놀이공원이 있는 매력적인 제2의 도시'},
        {'name': '말뫼', 'description': '코펜하겐과 연결된 외레순 다리와 친환경 에코 시티의 매력'},
        {'name': '웁살라', 'description': '북유럽 최대 성당과 역사를 자랑하는 대학 도시'},
        {'name': '비스뷔', 'description': '발트해 고틀란드 섬에 위치한 장미와 붉은 성벽의 중세 마을'},
        {'name': '키루나', 'description': '신비로운 오로라와 얼음 호텔을 만날 수 있는 최북단 광산 도시'},
      ],
      'quiet': [
        {'name': '룬드', 'description': '천년의 역사를 지닌 로마네스크 양식의 대성당과 학술의 중심지'},
        {'name': '외레브로', 'description': '도심 한가운데 호수 위로 떠 있는 아름다운 르네상스 성'},
        {'name': '우메오', 'description': '백작 나무가 가득한 문화와 예술이 넘치는 북부의 트렌디한 도시'},
        {'name': '룰레오', 'description': '얼어붙은 바다 위를 걷고 유네스코 세계유산 교회 마을이 있는 곳'},
        {'name': '칼마르', 'description': '웅장한 르네상스 양식의 성과 스몰란드의 자연이 만나는 곳'},
        {'name': '베스테로스', 'description': '멜라렌 호숫가의 평화로움과 스웨덴 산업 역사가 숨 쉬는 곳'},
      ]
    },
    '프랑스': {
      'popular': [
        {'name': '파리', 'description': '에펠탑과 루브르가 있는 예술의 도시'},
        {'name': '니스', 'description': '코트다쥐르의 눈부신 지중해 휴양지'},
        {'name': '리옹', 'description': '프랑스 미식의 수도'},
        {'name': '마르세유', 'description': '활기찬 항구 도시의 매력'},
      ],
      'quiet': [
        {'name': '안시', 'description': '알프스의 베니스라 불리는 호수 마을'},
        {'name': '콜마르', 'description': '하울의 움직이는 성 모티브가 된 동화 마을'},
        {'name': '몽생미셸', 'description': '바다 위 갯벌에 우뚝 솟은 신비로운 수도원'},
        {'name': '아비뇽', 'description': '남프랑스 프로방스 지방의 교황의 도시'},
      ]
    },
    '이탈리아': {
      'popular': [
        {'name': '로마', 'description': '도시 전체가 살아있는 거대한 박물관'},
        {'name': '피렌체', 'description': '르네상스의 발상지, 낭만적인 풍경'},
        {'name': '베네치아', 'description': '물 위에 떠 있는 신비로운 낭만의 운하 도시'},
        {'name': '밀라노', 'description': '세계적인 패션과 디자인의 중심지'},
      ],
      'quiet': [
        {'name': '친퀘테레', 'description': '절벽에 매달린 다섯 개의 알록달록한 어촌 마을'},
        {'name': '시에나', 'description': '토스카나 지방의 중세 시대 붉은 벽돌 도시'},
        {'name': '포지타노', 'description': '아말피 해안의 절벽을 따라 지어진 눈부신 마을'},
        {'name': '돌로미티', 'description': '이탈리아 북부 알프스의 비현실적인 암봉 경관'},
      ]
    },
    '스위스': {
      'popular': [
        {'name': '인터라켄', 'description': '알프스 여행의 관문이자 액티비티 천국'},
        {'name': '루체른', 'description': '아름다운 호수와 카펠교의 낭만'},
        {'name': '취리히', 'description': '스위스의 경제 중심지이자 세련된 문화 도시'},
      ],
      'quiet': [
        {'name': '그린델발트', 'description': '아이거 북벽 아래 동화 같은 산악 마을'},
        {'name': '체르마트', 'description': '마테호른을 품은 청정 알파인 마을'},
        {'name': '몽트뢰', 'description': '레만 호숫가의 우아한 재즈의 도시'},
      ]
    },
    '스페인': {
      'popular': [
        {'name': '마드리드', 'description': '활기찬 분위기와 세계적인 미술관의 도시'},
        {'name': '바르셀로나', 'description': '가우디의 독창적인 건축물이 숨 쉬는 곳'},
        {'name': '세비야', 'description': '정열적인 플라멩코와 투우의 본고장'},
      ],
      'quiet': [
        {'name': '론다', 'description': '아찔한 절벽 협곡 위에 세워진 매혹적인 마을'},
        {'name': '톨레도', 'description': '중세 시대의 모습을 그대로 간직한 옛 수도'},
        {'name': '그라나다', 'description': '알함브라 궁전이 있는 이슬람 문화의 흔적'},
        {'name': '이비자', 'description': '낮에는 에메랄드 바다, 밤에는 파티의 섬'},
      ]
    },
    '영국': {
      'popular': [
        {'name': '런던', 'description': '빅벤과 타워브릿지, 템즈강의 낭만'},
        {'name': '에든버러', 'description': '해리포터의 탄생지, 스코틀랜드의 심장'},
        {'name': '맨체스터', 'description': '축구와 산업혁명의 도시'},
      ],
      'quiet': [
        {'name': '바스', 'description': '고대 로마 온천장이 남아있는 우아한 도시'},
        {'name': '코츠월드', 'description': '가장 영국다운 전원 풍경을 간직한 시골 마을들'},
        {'name': '옥스퍼드', 'description': '학구적이고 고풍스러운 대학 도시'},
      ]
    },
    '독일': {
      'popular': [
        {'name': '베를린', 'description': '역사와 힙한 언더그라운드 문화가 공존하는 곳'},
        {'name': '뮌헨', 'description': '옥토버페스트와 남부 바이에른의 중심'},
        {'name': '프랑크푸르트', 'description': '유럽 금융의 중심이자 마인 강변의 대도시'},
      ],
      'quiet': [
        {'name': '하이델베르크', 'description': '네카어 강변의 낭만적인 고성과 대학 도시'},
        {'name': '로텐부르크', 'description': '크리스마스 마켓으로 유명한 중세 동화 마을'},
        {'name': '퓌센', 'description': '디즈니랜드 성의 모티브가 된 노이슈반슈타인 성'},
      ]
    },
    '브라질': {
      'popular': [
        {'name': '리우데자네이루', 'description': '거대 예수상과 코파카바나 해변의 열정'},
        {'name': '상파울루', 'description': '남미 경제를 움직이는 거대한 메트로폴리스'},
      ],
      'quiet': [
        {'name': '이구아수', 'description': '악마의 목구멍이라 불리는 압도적인 거대 폭포'},
        {'name': '파라티', 'description': '자갈길과 포르투갈 양식이 남은 아름다운 항구 마을'},
      ]
    },
    '아르헨티나': {
      'popular': [
        {'name': '부에노스아이레스', 'description': '남미의 파리라 불리는 탱고의 본고장'},
      ],
      'quiet': [
        {'name': '바릴로체', 'description': '아르헨티나의 스위스, 호수와 눈 덮인 안데스 산맥'},
        {'name': '우수아이아', 'description': '세상의 끝, 남극으로 가는 관문 도시'},
        {'name': '엘 칼라파테', 'description': '거대한 푸른 빙하를 만날 수 있는 파타고니아의 거점'},
      ]
    },
    '페루': {
      'popular': [
        {'name': '리마', 'description': '미식의 도시로 떠오르는 페루의 해안 수도'},
      ],
      'quiet': [
        {'name': '쿠스코', 'description': '잉카 제국의 숨결이 살아있는 고산 도시'},
        {'name': '마추픽추', 'description': '구름 속에 숨겨진 잉카의 잃어버린 공중 도시'},
        {'name': '우루밤바', 'description': '안데스의 자연과 잉카 유적이 남은 고요한 계곡'},
      ]
    },
    '칠레': {
      'popular': [
        {'name': '산티아고', 'description': '안데스 산맥 아래 자리 잡은 현대적인 수도'},
      ],
      'quiet': [
        {'name': '발파라이소', 'description': '알록달록한 벽화와 케이블카가 있는 항구 도시'},
        {'name': '산페드로데아타카마', 'description': '달의 계곡과 별이 쏟아지는 세상에서 가장 건조한 사막'},
        {'name': '푸에르토 나탈레스', 'description': '토레스 델 파이네 국립공원으로 가는 트레킹의 성지'},
      ]
    },
    '콜롬비아': {
      'popular': [
        {'name': '보고타', 'description': '황금 박물관과 그라피티가 가득한 고산 수도'},
        {'name': '메데인', 'description': '영원한 봄의 도시로 불리는 혁신적인 산악 도시'},
      ],
      'quiet': [
        {'name': '카르타헤나', 'description': '성벽으로 둘러싸인 카리브해의 화려하고 낭만적인 항구'},
        {'name': '살렌토', 'description': '세계에서 가장 높은 야자수와 커피 농장이 있는 그림 같은 마을'},
      ]
    },
    '호주': {
      'popular': [
        {'name': '시드니', 'description': '오페라 하우스와 하버 브릿지가 있는 남반구 최대 도시'},
        {'name': '멜버른', 'description': '골목마다 커피 향이 가득한 문화와 예술의 수도'},
        {'name': '브리즈번', 'description': '일 년 내내 햇살이 쏟아지는 여유로운 퀸즐랜드의 중심'},
      ],
      'quiet': [
        {'name': '바이런 베이', 'description': '서퍼들의 천국, 여유롭고 힙한 보헤미안 감성 마을'},
        {'name': '울룰루', 'description': '호주의 붉은 배꼽, 아웃백 사막 한가운데의 거대한 바위'},
        {'name': '태즈메이니아', 'description': '태초의 자연을 그대로 간직한 호주 최남단의 섬'},
      ]
    },
    '뉴질랜드': {
      'popular': [
        {'name': '오클랜드', 'description': '요트가 떠다니는 항구와 세련된 북섬의 중심지'},
      ],
      'quiet': [
        {'name': '퀸스타운', 'description': '번지점프의 발상지, 아름다운 호숫가 익스트림 성지'},
        {'name': '테카포', 'description': '밀키블루빛 호수와 세계에서 가장 아름다운 별구경'},
        {'name': '로토루아', 'description': '간헐천이 솟아오르는 마오리족 전통 문화의 중심지'},
      ]
    },
    '이집트': {
      'popular': [
        {'name': '카이로', 'description': '기자 피라미드와 나일강이 흐르는 장엄한 아랍의 중심'},
        {'name': '룩소르', 'description': '도시 전체가 고대 이집트의 거대한 야외 박물관'},
      ],
      'quiet': [
        {'name': '아스완', 'description': '나일강의 펠루카와 누비아 문화가 살아있는 평화로운 곳'},
        {'name': '다합', 'description': '전 세계 다이버와 배낭여행객이 사랑하는 홍해의 블랙홀'},
      ]
    },
    '모로코': {
      'popular': [
        {'name': '마라케시', 'description': '제마 엘 프나 광장의 열기와 붉은 성벽이 매력적인 도시'},
        {'name': '카사블랑카', 'description': '거대한 핫산 2세 모스크가 있는 모로코 경제의 중심'},
      ],
      'quiet': [
        {'name': '페스', 'description': '미로 같은 9천 개의 골목과 천 년 역사의 메디나가 있는 곳'},
        {'name': '쉐프샤우엔', 'description': '리프 산맥에 숨겨진 온통 푸른빛으로 물든 요정의 마을'},
        {'name': '메르주가', 'description': '사하라 사막의 황금빛 모래 언덕 위로 지는 환상적인 일몰'},
      ]
    },
    '남아프리카공화국': {
      'popular': [
        {'name': '케이프타운', 'description': '테이블 마운틴과 희망봉이 있는 압도적인 절경'},
      ],
      'quiet': [
        {'name': '크루거 국립공원', 'description': '사자와 코끼리가 눈앞에 나타나는 사파리의 끝판왕'},
      ]
    },
  };

  static const List<Map<String, String>> defaultPopularCities = [
    {'name': '수도 및 중심 도시', 'description': '가장 번화하고 볼거리가 많은 메인 도시입니다.'},
    {'name': '유명 관광 도시', 'description': '전 세계 여행객들이 가장 많이 찾는 필수 코스입니다.'},
  ];

  static const List<Map<String, String>> defaultQuietCities = [
    {'name': '한적한 근교 소도시', 'description': '관광객이 적어 현지의 일상을 느낄 수 있는 조용한 곳입니다.'},
    {'name': '자연 휴양지', 'description': '도심을 벗어나 평화롭게 힐링하는 공간입니다.'},
  ];
}
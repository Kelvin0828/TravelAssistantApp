// lib/Project/models/travel_models.dart

class CountryInfo {
  final String name;
  final String reason;
  final String safetyLevel;

  CountryInfo({required this.name, required this.reason, required this.safetyLevel});

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(
      name: json['name'] ?? '',
      reason: json['reason'] ?? '',
      safetyLevel: json['safety_level'] ?? '안전',
    );
  }
}

class CityInfo {
  final String name;
  final String description;

  CityInfo({required this.name, required this.description});

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class CityDetails {
  final List<String> accommodations; // ✨ 숙소 카테고리 추가
  final List<String> sightseeings;
  final List<String> restaurants;
  final List<String> cafes;
  final List<String> arts;
  final List<String> shopping;
  final List<String> parks;
  final List<String> viewpoints;

  final String averageBudget;
  final List<String> itinerary;
  final String bestSeason;
  final String currencyCode;

  final Map<String, List<double>> coordinates;

  CityDetails({
    required this.accommodations,
    required this.sightseeings,
    required this.restaurants,
    required this.cafes,
    required this.arts,
    required this.shopping,
    required this.parks,
    required this.viewpoints,
    required this.averageBudget,
    required this.itinerary,
    required this.bestSeason,
    required this.currencyCode,
    required this.coordinates,
  });

  factory CityDetails.fromJson(Map<String, dynamic> json) {
    Map<String, List<double>> parsedCoords = {};
    if (json['coordinates'] != null) {
      (json['coordinates'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List && value.length >= 2) {
          parsedCoords[key] = [value[0].toDouble(), value[1].toDouble()];
        }
      });
    }

    return CityDetails(
      accommodations: List<String>.from(json['accommodations'] ?? []),
      sightseeings: List<String>.from(json['sightseeings'] ?? []),
      restaurants: List<String>.from(json['restaurants'] ?? []),
      cafes: List<String>.from(json['cafes'] ?? []),
      arts: List<String>.from(json['arts'] ?? []),
      shopping: List<String>.from(json['shopping'] ?? []),
      parks: List<String>.from(json['parks'] ?? []),
      viewpoints: List<String>.from(json['viewpoints'] ?? []),
      averageBudget: json['average_budget'] ?? '',
      itinerary: List<String>.from(json['itinerary'] ?? []),
      bestSeason: json['best_season'] ?? '정보 없음',
      currencyCode: json['currency_code'] ?? 'USD',
      coordinates: parsedCoords,
    );
  }
}
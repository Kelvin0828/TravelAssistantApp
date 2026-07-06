// lib/Project/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'country_list_screen.dart';

final Map<String, String> _continentImages = {
  '아시아': 'https://images.unsplash.com/photo-1546874177-9e664107314e?q=80&w=800&auto=format&fit=crop',
  '유럽': 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?q=80&w=800&auto=format&fit=crop',
  '북아메리카': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?q=80&w=800&auto=format&fit=crop',
  '남아메리카': 'https://images.unsplash.com/photo-1526392060635-9d6019884377?q=80&w=800&auto=format&fit=crop',
  '오세아니아': 'https://images.unsplash.com/photo-1523482580672-f109ba8cb9be?q=80&w=800&auto=format&fit=crop',
  '아프리카': 'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?q=80&w=800&auto=format&fit=crop',
};

class MainScreen extends StatefulWidget {
  const MainScreen({super.key}); // ✨ 경고 제거 완벽 적용

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isInitialLoading = true;
  int _selectedTab = 0; // ✨ 로직 수정: 현재 선택된 탭 기억

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialLoading) {
      _preloadFirstImages();
    }
  }

  Future<void> _preloadFirstImages() async {
    try {
      List<Future<void>> futures = [];
      for (var url in _continentImages.values) {
        futures.add(precacheImage(CachedNetworkImageProvider(url), context));
      }
      await Future.wait(futures);
    } catch (e) {
      print('이미지 초기 로드 에러: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(radius: 16),
              SizedBox(height: 16),
              Text('멋진 여행지 사진을 준비 중입니다 ✈️', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;

    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('어디로 떠날까요?', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoSegmentedControl<int>(
                    children: const {
                      0: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Best & Safe', style: TextStyle(fontWeight: FontWeight.bold))),
                      1: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Hidden & Quiet', style: TextStyle(fontWeight: FontWeight.bold))),
                    },
                    onValueChanged: (int val) {
                      setState(() {
                        _selectedTab = val; // ✨ 로직 수정: 탭 상태 동기화
                      });
                    },
                    groupValue: _selectedTab,
                    selectedColor: CupertinoColors.activeBlue,
                    borderColor: CupertinoColors.activeBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              '대륙을 선택해주세요 🌍',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _continentImages.length,
                itemBuilder: (context, index) {
                  String continentName = _continentImages.keys.elementAt(index);
                  String imageUrl = _continentImages.values.elementAt(index);

                  return ContinentCard(
                    title: continentName,
                    imageUrl: imageUrl,
                    isPopular: _selectedTab == 0, // ✨ 로직 수정: 현재 탭 상태값 전달
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContinentCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isPopular;

  const ContinentCard({
    super.key, // ✨ 경고 제거
    required this.title,
    required this.imageUrl,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CountryListScreen(
              continent: title,     // ✨ 로직 수정: 대륙 전달
              isPopular: isPopular, // ✨ 로직 수정: 탭 상태 전달
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(color: Colors.transparent),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.error, color: Colors.grey),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))]
                ),
              ),
            ),

            const Positioned(
              top: 16,
              right: 16,
              child: Icon(CupertinoIcons.arrow_right_circle_fill, color: Colors.white70, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
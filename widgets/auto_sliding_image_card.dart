// lib/Project/widgets/auto_sliding_image_card.dart

import 'dart:async';
import 'package:flutter/material.dart';

class AutoSlidingImageCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget? badge;
  final List<String> imagePaths;
  final VoidCallback onTap;

  const AutoSlidingImageCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.imagePaths,
    required this.onTap,
  });

  @override
  State<AutoSlidingImageCard> createState() => _AutoSlidingImageCardState();
}

class _AutoSlidingImageCardState extends State<AutoSlidingImageCard> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    if (widget.imagePaths.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
        if (_currentPage < widget.imagePaths.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: [
            // 🔥 해결 1: 이미지가 디코딩되는 찰나의 순간에 하얀색이 보이지 않도록 기본 배경색을 깔아줍니다.
            Container(color: Colors.grey.shade300),

            widget.imagePaths.isNotEmpty
                ? PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  widget.imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  // 🔥 해결 2: 사진이 팍! 하고 뜨지 않고 부드럽게 나타나도록 Fade-in 효과를 줍니다.
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 400), // 0.4초 동안 스르륵 나타남
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            )
                : Container(color: Colors.grey.shade300),

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

            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.badge != null) ...[
                    widget.badge!,
                    const SizedBox(height: 6.0),
                  ],
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13.0,
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
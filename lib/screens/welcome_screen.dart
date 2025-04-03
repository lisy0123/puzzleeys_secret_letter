import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> svgPaths = [
      'assets/imgs/tutorial_1.svg',
      'assets/imgs/tutorial_2.svg',
      'assets/imgs/tutorial_3.svg',
      'assets/imgs/tutorial_4.svg',
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: svgPaths.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (_, index) {
              return Center(child: SvgPicture.asset(svgPaths[index]));
            },
          ),
          _buildPageIndicator(svgPaths),
          _buildButton(svgPaths),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(List<String> svgPaths) {
    return Positioned(
      top: 160.0.h,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            svgPaths.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 50.0.w),
              height: 50.0.w,
              width: 50.0.w,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue : Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(List<String> svgPaths) {
    return Positioned(
      bottom: 260.0.h,
      left: 0,
      right: 0,
      child: Builder(
        builder: (context) {
          if (_currentPage == svgPaths.length - 1) {
            return Center(
              child: CustomButton(
                iconName: 'btn_puzzle',
                iconTitle: CustomStrings.start,
                onTap: () => Navigator.pop(context),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

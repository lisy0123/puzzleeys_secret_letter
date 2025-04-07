import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  final bool shouldAddExtraPage;

  const WelcomeScreen({super.key, this.shouldAddExtraPage = false});

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
    final int svgPathLength = svgPaths.length;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: svgPathLength,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (_, index) {
              return Center(child: SvgPicture.asset(svgPaths[index]));
            },
          ),
          _buildPageIndicator(svgPathLength),
          _buildButton(svgPathLength, widget.shouldAddExtraPage),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int svgPathLength) {
    return Positioned(
      top: 160.0.h,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            svgPathLength,
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

  Widget _buildButton(int svgPathLength, bool shouldAddExtraPage) {
    return Positioned(
      bottom: 260.0.h,
      left: 0,
      right: 0,
      child: Builder(
        builder: (context) {
          if (_currentPage == svgPathLength - 1) {
            return Center(
              child: CustomButton(
                iconName: 'btn_puzzle',
                iconTitle: CustomStrings.start,
                onTap: () {
                  Navigator.pop(context);
                  if (shouldAddExtraPage) {
                    BuildDialog.show(
                      iconName: 'onboarding',
                      dismissible: false,
                      context: context,
                    );
                  }
                },
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

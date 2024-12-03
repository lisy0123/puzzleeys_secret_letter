import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/outliner/bottom_icon_bar.dart';
import 'package:puzzleeys_secret_letter/screens/outliner/status_bar.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_personal_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_subject_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_global_screen.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    _controller = TabController(
      length: 3,
      vsync: this,
      animationDuration: Duration.zero,
    );
    super.initState();
  }

  void navigateToTab(int index) {
    if (_controller.index != index) {
      setState(() {
        _controller.animateTo(index);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                TabBarView(
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PuzzleGlobalScreen(),
                    PuzzleSubjectScreen(),
                    PuzzlePersonalScreen(),
                  ],
                ),
                SafeArea(
                  top: true,
                  bottom: true,
                  child: Container(
                    margin: EdgeInsets.all(40.0.w),
                    padding: EdgeInsets.only(bottom: 20.0.h),
                    child: _build(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusBar(),
        ButtonIconBar(
          currentIndex: _controller.index,
          onIconTap: navigateToTab,
        ),
      ],
    );
  }
}

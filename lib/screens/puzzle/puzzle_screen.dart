import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/home/home_status_bar.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_icons.dart';
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
    _controller = TabController(length: 3, vsync: this);
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
                    PuzzlePersonalScreen(),
                    PuzzleGlobalScreen(),
                    PuzzleSubjectScreen(),
                  ],
                ),
                SafeArea(
                  top: true,
                  child: Column(
                    children: [
                      SizedBox(height: 24.0.w),
                      HomeStatusBar(),
                      PuzzleIcons(
                        currentIndex: _controller.index,
                        onIconTap: navigateToTab,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

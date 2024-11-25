import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/home/home_status_bar.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_icons.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_personal_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_subject_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_world_screen.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen>
    with TickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    controller: controller,
                    children: [
                      PuzzlePersonalScreen(),
                      PuzzleWorldScreen(),
                      PuzzleSubjectScreen(),
                    ],
                  ),
                  Stack(
                    children: [
                      HomeStatusBar(),
                      PuzzleIcons(),
                    ],
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

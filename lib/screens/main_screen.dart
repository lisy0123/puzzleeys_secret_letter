import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/outliner/bottom_icon_bar.dart';
import 'package:puzzleeys_secret_letter/screens/outliner/status_bar.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_scale_provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_personal_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_subject_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_global_screen.dart';
import 'package:puzzleeys_secret_letter/screens/shop/shop_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_ui.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: this,
      animationDuration: Duration.zero,
    );
    super.initState();
  }

  void navigateToTab(int index) {
    if (_tabController.index != index) {
      setState(() {
        _tabController.animateTo(index);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                _buildTabBarView(),
                _buildMainContent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        PuzzleGlobalScreen(),
        PuzzleSubjectScreen(),
        PuzzlePersonalScreen(),
        ShopScreen(),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Container(
        margin: EdgeInsets.all(40.0.w),
        padding: EdgeInsets.only(bottom: 20.0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusBar(),
            Column(
              children: [
                if (_tabController.index != 3) _buildActionButtons(),
                ButtonIconBar(
                  currentIndex: _tabController.index,
                  onIconTap: navigateToTab,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.all(100.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomUiCircle(
            svgImage: 'cir_zoom',
            onTap: () => context.read<PuzzleScaleProvider>().toggleScale(),
          ),
          CustomUiCircle(
            svgImage: 'cir_shuffle',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

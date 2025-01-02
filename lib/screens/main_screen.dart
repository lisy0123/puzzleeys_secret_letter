import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/bar/bottom_bar.dart';
import 'package:puzzleeys_secret_letter/screens/bar/status_bar.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_scale_provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_personal_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_subject_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_global_screen.dart';
import 'package:puzzleeys_secret_letter/screens/shop/shop_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_shapes.dart';

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
    return Stack(
      children: [
        _buildTabBarView(),
        _buildMainTop(context),
        _buildMainBottom(context),
      ],
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
        EmptyShopScreen(),
      ],
    );
  }

  Widget _buildMainTop(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        margin: EdgeInsets.all(40.0.w),
        child: const StatusBar(),
      ),
    );
  }

  Widget _buildMainBottom(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(40.0.w),
      padding: EdgeInsets.only(bottom: 200.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_tabController.index != 3) _buildActionButtons(),
          if (_tabController.index == 3) const ShopScreen(),
          BottomBar(
            currentIndex: _tabController.index,
            onIconTap: navigateToTab,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.all(100.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCircle(
            svgImage: 'cir_zoom',
            onTap: () => context.read<PuzzleScaleProvider>().toggleScale(),
          ),
          (_tabController.index == 0)
              ? CustomCircle(svgImage: 'cir_shuffle', onTap: () {})
              : SizedBox(height: 1),
        ],
      ),
    );
  }
}

class EmptyShopScreen extends StatelessWidget {
  const EmptyShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

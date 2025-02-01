import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/bar/bottom_bar.dart';
import 'package:puzzleeys_secret_letter/screens/bar/status_bar.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_scale_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_personal_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_subject_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_global_screen.dart';
import 'package:puzzleeys_secret_letter/screens/shop/shop_screen.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_shapes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  Future<void> _initializeTabController() async {
    final savedIndex = await SharedPreferencesUtils.get('tab');
    final int index = (savedIndex == null) ? 0 : int.tryParse(savedIndex) ?? 0;

    _tabController = TabController(
      length: 4,
      initialIndex: index,
      vsync: this,
      animationDuration: Duration.zero,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return PuzzleLoadingScreen();
    }
    return Stack(
      children: [
        _buildTabBarView(),
        _buildMainTop(),
        _buildMainBottom(_tabController!.index),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        PuzzleGlobalScreen(),
        PuzzleSubjectScreen(),
        PuzzlePersonalScreen(),
        EmptyShopScreen(),
      ],
    );
  }

  Widget _buildMainTop() {
    return SafeArea(
      top: true,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.0.w),
        child: StatusBar(),
      ),
    );
  }

  Widget _buildMainBottom(int index) {
    return Container(
      margin: EdgeInsets.all(40.0.w),
      padding: EdgeInsets.only(bottom: 160.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (index != 3) _buildActionButtons(),
          if (index == 3) const ShopScreen(),
          BottomBar(currentIndex: index, onIconTap: _navigateToTab),
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
          CustomCircle(svgImage: 'cir_shuffle', onTap: _shuffle),
        ],
      ),
    );
  }

  void _shuffle() {
    final PuzzleType puzzleType = _getPuzzleType(_tabController!.index);
    context.read<PuzzleProvider>().updateShuffle(true);
    context.read<PuzzleProvider>().initializeColors(puzzleType);
  }

  PuzzleType _getPuzzleType(int index) {
    return {
      0: PuzzleType.global,
      1: PuzzleType.subject,
      2: PuzzleType.personal,
    }[index]!;
  }

  void _navigateToTab(int index) async {
    if (_tabController!.index != index) {
      setState(() {
        _tabController!.animateTo(index);
      });
      await SharedPreferencesUtils.save('tab', index.toString());
    }
  }
}

class EmptyShopScreen extends StatelessWidget {
  const EmptyShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

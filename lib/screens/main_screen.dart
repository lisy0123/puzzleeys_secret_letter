import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/providers/tab_index_provider.dart';
import 'package:puzzleeys_secret_letter/screens/bar/bottom_bar.dart';
import 'package:puzzleeys_secret_letter/screens/bar/status_bar.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_screen.dart';
import 'package:puzzleeys_secret_letter/screens/shop/shop_screen.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_shapes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  late TabIndexProvider _tabIndexProvider;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    _tabIndexProvider = context.read<TabIndexProvider>();

    _tabController = TabController(
      length: 3, // TODO: need to add 4 later
      initialIndex: _tabIndexProvider.currentTabIndex,
      vsync: this,
      animationDuration: Duration.zero,
    );

    _tabIndexProvider.addListener(() {
      _tabController!.animateTo(_tabIndexProvider.currentTabIndex);
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
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
        // TODO: need to add 4 later
        // EmptyShopScreen(),
      ],
    );
  }

  Widget _buildMainTop() {
    return SafeArea(
      top: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0.w),
        child: StatusBar(),
      ),
    );
  }

  Widget _buildMainBottom(int index) {
    return Padding(
      padding: EdgeInsets.all(40.0.w).copyWith(bottom: 160.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (index != 3) _buildActionButtons(),
          if (index == 3) ShopScreen(),
          BottomBar(currentIndex: index, onIconTap: _navigateToTab),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(100.0.w),
      child: Align(
        alignment: Alignment.bottomRight,
        child: CustomCircle(svgImage: 'cir_shuffle', onTap: _shuffle),
      ),
    );
  }

  void _shuffle() async {
    final PuzzleType puzzleType =
        GetPuzzleType.indexToType(_tabController!.index);
    final PuzzleProvider puzzleProvider = context.read<PuzzleProvider>();

    puzzleProvider.updateShuffle(true);
    await puzzleProvider.initializeColors(puzzleType);
  }

  void _navigateToTab(int index) async {
    if (_tabController!.index != index) {
      setState(() {
        _tabIndexProvider.changeTabIndex(index);
      });
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

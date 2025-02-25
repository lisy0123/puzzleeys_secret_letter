import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_screen_provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class PuzzleMainScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> puzzleData;
  final PuzzleType puzzleType;

  const PuzzleMainScreen({
    super.key,
    required this.index,
    required this.puzzleData,
    required this.puzzleType,
  });

  @override
  State<PuzzleMainScreen> createState() => _PuzzleMainScreenState();
}

class _PuzzleMainScreenState extends State<PuzzleMainScreen> {
  late PuzzleScreenProvider _screenProvider;
  bool isTimeZero = false;

  @override
  void initState() {
    super.initState();
    _screenProvider = context.read<PuzzleScreenProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenProvider.updateScreenOpacity(setToInitial: true);
    });

    final targetTime = DateTime.parse(widget.puzzleData['created_at'])
        .add(Duration(hours: 33));
    final now = DateTime.now().toUtc().add(Duration(hours: 9));

    if (targetTime.isBefore(now)) {
      setState(() => isTimeZero = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Selector<PuzzleScreenProvider, double>(
      selector: (_, provider) => provider.screenOpacity,
      builder: (_, opacity, __) {
        return _animatedOpacityContent(height, opacity);
      },
    );
  }

  Widget _animatedOpacityContent(double height, double opacity) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: opacity > 0.0
          ? _buildContent(height)
          : const SizedBox.shrink(key: ValueKey('hidden')),
    );
  }

  Widget _buildContent(double height) {
    return Stack(
      key: const ValueKey('visible'),
      children: [
        GestureDetector(onTap: () => Navigator.pop(context)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 200.0.w).copyWith(
            top: (height - 760.0.h) / 2,
          ),
          child: Column(
            children: [
              PuzzleDetail(
                puzzleData: widget.puzzleData,
                puzzleType: widget.puzzleType,
              ),
              SizedBox(height: 200.0.w),
              _buildReplyButton(),
            ],
          ),
        ),
        if (isTimeZero)
          Positioned.fill(
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(color: Colors.transparent),
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(color: Colors.transparent),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildReplyButton() {
    late String parentId;

    if (widget.puzzleType != PuzzleType.personal) {
      parentId = widget.puzzleData['author_id'];
    } else {
      parentId = widget.puzzleData['sender_id'];
    }

    return CustomButton(
      iconName: 'btn_mail',
      iconTitle: CustomStrings.reply,
      onTap: () {
        PuzzleScreenHandler.navigateScreen(
          barrierColor: Colors.white38,
          child: PuzzleWritingScreen(
            puzzleType: widget.puzzleType,
            index: widget.index,
            parentId: parentId,
            parentColor: widget.puzzleData['color'],
          ),
          context: context,
        );
        _screenProvider.updateScreenOpacity();
      },
    );
  }
}

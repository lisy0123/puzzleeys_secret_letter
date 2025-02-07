import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/countdown_timer.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class PuzzleDetailScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> puzzleData;
  final PuzzleType puzzleType;

  const PuzzleDetailScreen({
    super.key,
    required this.index,
    required this.puzzleData,
    required this.puzzleType,
  });

  @override
  State<PuzzleDetailScreen> createState() => _PuzzleDetailScreenState();
}

class _PuzzleDetailScreenState extends State<PuzzleDetailScreen> {
  Color _puzzleButtonColor = Colors.white;
  late BeadProvider _beadProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _beadProvider = context.read<BeadProvider>();
      final bool isExist =
          _beadProvider.beadIds.contains(widget.puzzleData['id']);

      context.read<WritingProvider>().updateOpacity(setToInitial: true);
      if (isExist) {
        setState(() {
          _puzzleButtonColor = widget.puzzleData['color'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Selector<WritingProvider, double>(
      selector: (_, provider) => provider.opacity,
      builder: (context, opacity, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: opacity > 0.0
              ? Stack(
                  key: const ValueKey('visible'),
                  children: [
                    GestureDetector(onTap: () => Navigator.pop(context)),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 200.0.w,
                        right: 200.0.w,
                        top: (height - 760.0.h) / 2,
                      ),
                      child: Column(
                        children: [
                          _buildPuzzleDetails(),
                          SizedBox(height: 200.0.w),
                          _buildReplyButton(),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('hidden')),
        );
      },
    );
  }

  Widget _buildPuzzleDetails() {
    return GestureDetector(
      onDoubleTap: _getPuzzle,
      child: Container(
        height: 3000.0.w,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 60.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTopContent(),
            SizedBox(height: 40.0.w),
            _buildMidContent(),
            SizedBox(height: 40.0.w),
            _buildBottomContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContent() {
    return Stack(
      children: [
        _buildParentPost(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0.w),
              child: CountdownTimer(createdAt: widget.puzzleData['created_at']),
            ),
            PuzzleScreenHandler().buildIconButton(
              iconName: 'btn_alarm',
              text: CustomStrings.report,
              onTap: () => BuildDialog.show(
                iconName: 'report',
                puzzleId: widget.puzzleData['id'],
                puzzleType: widget.puzzleType,
                simpleDialog: true,
                context: context,
              ),
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParentPost() {
    if (widget.puzzleType == PuzzleType.personal &&
        widget.puzzleData['parent_post_color'] != null) {
      final int iconIndex = switch (widget.puzzleData['parent_post_type']) {
        'global' => 0,
        'subject' => 1,
        _ => 2,
      };

      return Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 80.0.w),
            Transform.rotate(
              angle: -pi / 4,
              child: CustomPaint(
                size: Size(180.0.w, 180.0.w),
                painter: TiltedPuzzlePiece(
                  puzzleColor: ColorUtils.colorMatch(
                    stringColor: widget.puzzleData['parent_post_color'],
                  ),
                  strokeWidth: 1.2,
                ),
              ),
            ),
            if (iconIndex != 2) SizedBox(width: 20.0.w),
            SvgPicture.asset(
              'assets/imgs/icon_${iconIndex.toString()}.svg',
              height: (iconIndex == 2) ? 160.0.w : 150.0.w,
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildMidContent() {
    return Container(
      alignment: Alignment.center,
      height: 2320.0.w,
      child: RawScrollbar(
        radius: Radius.circular(10),
        thumbColor: ColorUtils.colorMatch(
          baseColor: widget.puzzleData['color'],
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0.w),
            child: Text(
              widget.puzzleData['content'].replaceAll(r'\n', '\n'),
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent() {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 10.0.w),
      constraints: BoxConstraints(),
      onPressed: _getPuzzle,
      icon: SizedBox(
        width: 600.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -pi / 4,
              child: CustomPaint(
                size: Size(200.0.w, 200.0.w),
                painter: TiltedPuzzlePiece(
                  puzzleColor: _puzzleButtonColor,
                  strokeWidth: 1.5,
                ),
              ),
            ),
            SizedBox(width: 40.0.w),
            CustomText.textDisplay(text: CustomStrings.get, context: context),
          ],
        ),
      ),
    );
  }

  void _getPuzzle() async {
    if (_puzzleButtonColor == Colors.white) {
      setState(() {
        _puzzleButtonColor = widget.puzzleData['color'];
      });
      CustomOverlay.show(
        text: MessageStrings.overlayMessages[OverlayType.getPuzzle]![1],
        puzzleVis: true,
        puzzleNum: MessageStrings.overlayMessages[OverlayType.getPuzzle]![0],
        context: context,
      );
      _beadProvider.putIntoBead(widget.puzzleData, widget.puzzleType);
    } else {
      CustomOverlay.show(
        text: MessageStrings.puzzleExistOverlay,
        context: context,
      );
    }
  }

  Widget _buildReplyButton() {
    final String? parentId;

    if (widget.puzzleType == PuzzleType.global ||
        widget.puzzleType == PuzzleType.subject) {
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
        context.read<WritingProvider>().updateOpacity();
      },
    );
  }
}

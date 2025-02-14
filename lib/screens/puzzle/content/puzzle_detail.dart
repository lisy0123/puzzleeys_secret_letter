import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/countdown_timer.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/parent_puzzle_widget.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class PuzzleDetail extends StatefulWidget {
  final Map<String, dynamic> puzzleData;
  final PuzzleType puzzleType;

  const PuzzleDetail({
    super.key,
    required this.puzzleData,
    required this.puzzleType,
  });

  @override
  State<PuzzleDetail> createState() => _PuzzleDetailState();
}

class _PuzzleDetailState extends State<PuzzleDetail> {
  late Color _puzzleButtonColor;
  late BeadProvider _beadProvider;

  @override
  void initState() {
    super.initState();
    _beadProvider = context.read<BeadProvider>();
    _puzzleButtonColor = _beadProvider.isExist(widget.puzzleData['id'])
        ? widget.puzzleData['color']
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
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
    final bool isExist = widget.puzzleType == PuzzleType.personal &&
        widget.puzzleData['parent_post_color'] != null;

    return Stack(
      children: [
        if (isExist)
          ParentPuzzleWidget(
            parentPostColor: widget.puzzleData['parent_post_color'],
            parentPostType: widget.puzzleData['parent_post_type'],
          ),
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
                iconName: 'reportPost',
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
          padding: EdgeInsets.symmetric(horizontal: 60.0.w),
          child: Text(
            widget.puzzleData['content'].replaceAll(r'\n', '\n'),
            style: Theme.of(context).textTheme.displayLarge,
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
      icon: Row(
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
    );
  }

  void _getPuzzle() async {
    if (_puzzleButtonColor == Colors.white) {
      setState(() => _puzzleButtonColor = widget.puzzleData['color']);
      CustomOverlay.show(
        text: MessageStrings.overlayMessages[OverlayType.getPuzzle]![1],
        puzzleVis: true,
        puzzleNum: MessageStrings.overlayMessages[OverlayType.getPuzzle]![0],
        context: context,
      );
      _beadProvider.addPuzzleToBead(widget.puzzleData, widget.puzzleType);
    } else {
      CustomOverlay.show(
        text: MessageStrings.puzzleExistOverlay,
        context: context,
      );
    }
  }
}

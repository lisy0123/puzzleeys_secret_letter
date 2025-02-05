import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/check_screen_provider.dart';
import 'package:puzzleeys_secret_letter/providers/read_puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_content.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_config.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_scale_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PuzzleBackground extends StatefulWidget {
  final PuzzleType puzzleType;
  final List<Map<String, dynamic>> puzzleList;

  const PuzzleBackground({
    super.key,
    required this.puzzleType,
    required this.puzzleList,
  });

  @override
  State<PuzzleBackground> createState() => _PuzzleBackgroundState();
}

class _PuzzleBackgroundState extends State<PuzzleBackground> {
  late final StreamSubscription _authSubscription;
  late Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    final PuzzleProvider puzzleProvider = context.read<PuzzleProvider>();

    super.initState();
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      puzzleProvider.initializeColors(widget.puzzleType);
      puzzleProvider.initializeHasSubject();
      if (mounted) {
        context.read<PuzzleScaleProvider>().initialize();
        _initialize();
      }
    });
  }

  void _initialize() {
    final CheckScreenProvider checkProvider =
        context.read<CheckScreenProvider>();
    final bool check = checkProvider.check;

    if (check && widget.puzzleType == PuzzleType.personal) {
      checkProvider.toggleCheck(false);
      context.read<ReadPuzzleProvider>().initialize(widget.puzzleList);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _authSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = context.watch<PuzzleScaleProvider>().scaleFactor;
    final PuzzleConfig config = PuzzleConfig(
      scaleFactor: scaleFactor,
      puzzleWidth: 840.0.w,
      puzzleHeight: 510.0.w,
      horizontalSpacing: -345.0.w,
      verticalSpacing: -15.0.w,
      itemsPerRow: 9,
      totalRows: 18,
    );

    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _dragOffset = _calculateNewOffset(details.delta, config);
            });
          },
          child: CustomMultiChildLayout(
            delegate: PuzzleLayoutDelegate(
              config: config,
              dragOffset: _dragOffset,
            ),
            children: List.generate(
              config.totalItems,
              (index) => PuzzleContent(
                key: ValueKey(index),
                row: index ~/ config.itemsPerRow,
                column: index % config.itemsPerRow,
                index: index,
                puzzleHeight: config.puzzleHeight,
                scaleFactor: scaleFactor,
                puzzleType: widget.puzzleType,
                puzzleData: widget.puzzleList[index],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Offset _calculateNewOffset(Offset delta, PuzzleConfig config) {
    final double maxDragX = config.maxDragDistanceX;
    final double maxDragY = config.maxDragDistanceY;
    final Offset newOffset = _dragOffset + delta;

    return Offset(
      newOffset.dx.clamp(-maxDragX, maxDragX),
      newOffset.dy.clamp(-maxDragY, maxDragY),
    );
  }
}

class PuzzleLayoutDelegate extends MultiChildLayoutDelegate {
  final PuzzleConfig config;
  final Offset dragOffset;

  PuzzleLayoutDelegate({
    required this.config,
    required this.dragOffset,
  });

  @override
  void performLayout(Size size) {
    final Offset startOffset = config.calculateStartOffset(size, dragOffset);

    for (int index = 0; index < config.totalItems; index++) {
      final Offset itemPosition =
          config.calculateItemPosition(index, startOffset);

      if (hasChild(index)) {
        layoutChild(
          index,
          BoxConstraints.tight(Size(
            config.puzzleWidth * config.scaleFactor,
            config.puzzleHeight * config.scaleFactor,
          )),
        );
        positionChild(index, itemPosition);
      }
    }
  }

  @override
  bool shouldRelayout(PuzzleLayoutDelegate oldDelegate) {
    return config != oldDelegate.config || dragOffset != oldDelegate.dragOffset;
  }
}

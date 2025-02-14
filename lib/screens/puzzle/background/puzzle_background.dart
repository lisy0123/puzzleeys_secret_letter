import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_screen_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_offset_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/read_puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_content.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_config.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_scale_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (mounted) {
        context.read<PuzzleProvider>().initializeColors(widget.puzzleType);
        _initialize();
      }
    });
  }

  void _initialize() {
    final PuzzleScreenProvider checkProvider =
        context.read<PuzzleScreenProvider>();
    final bool check = checkProvider.screenCheck;

    if (check && widget.puzzleType == PuzzleType.personal) {
      checkProvider.screenCheckToggle(false);
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
            context.read<PuzzleOffsetProvider>().updateOffset(
                  details.delta,
                  config,
                );
          },
          child: Selector<PuzzleOffsetProvider, Offset>(
            selector: (_, provider) => provider.dragOffset,
            builder: (_, dragOffset, __) {
              return CustomMultiChildLayout(
                delegate: PuzzleLayoutDelegate(
                  config: config,
                  dragOffset: dragOffset,
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
              );
            },
          ),
        ),
      ],
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
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
  late WritingProvider _writingProvider;

  @override
  void initState() {
    _writingProvider = context.read<WritingProvider>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _writingProvider.updateOpacity(setToInitial: true);
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
                          PuzzleDetail(
                            puzzleData: widget.puzzleData,
                            puzzleType: widget.puzzleType,
                          ),
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
        _writingProvider.updateOpacity();
      },
    );
  }
}

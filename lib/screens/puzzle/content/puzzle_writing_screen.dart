import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class PuzzleWritingScreen extends StatefulWidget {
  final PuzzleType puzzleType;
  final int? index;
  final bool reply;
  final String? parentId;
  final Color? parentColor;

  const PuzzleWritingScreen({
    super.key,
    required this.puzzleType,
    this.index,
    this.reply = true,
    this.parentId,
    this.parentColor,
  });

  @override
  State<PuzzleWritingScreen> createState() => _PuzzleWritingScreenState();
}

class _PuzzleWritingScreenState extends State<PuzzleWritingScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double get _dynamicHeight => _focusNode.hasFocus ? 1200.0.w : 2800.0.w;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => Utils.dismissKeyboard(focusNode: _focusNode),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 200.0.w).copyWith(
              top: (height - 786.0.h) / 2,
            ),
            child: Column(
              children: [
                _buildBackButton(),
                _buildMidContent(),
                SizedBox(height: 200.0.w),
                CustomButton(
                  iconName: 'btn_puzzle',
                  iconTitle: CustomStrings.putEmotion,
                  onTap: _handlePutButtonTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: PuzzleScreenHandler().buildIconButton(
        iconName: 'btn_back',
        text: CustomStrings.back,
        onTap: () => BuildDialog.show(
          iconName: 'cancel',
          simpleDialog: true,
          context: context,
        ),
        context: context,
      ),
    );
  }

  Widget _buildMidContent() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _dynamicHeight,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: widget.reply ? 0.7 : 0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80.0.w),
        child: _buildTextField(),
      ),
    );
  }

  Widget _buildTextField() {
    return RawScrollbar(
      controller: _scrollController,
      radius: Radius.circular(10),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          style: Theme.of(context).textTheme.displayLarge,
          decoration: InputDecoration(
            hintText: _getHintText(),
            hintStyle: Theme.of(context).textTheme.labelSmall,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  String _getHintText() {
    if (widget.reply) return MessageStrings.writingReplyMessage;
    return {
      PuzzleType.global: MessageStrings.writingGlobalMessage,
      PuzzleType.subject: MessageStrings.writingSubjectMessage,
      PuzzleType.personal: MessageStrings.writingToOtherMessage,
      PuzzleType.me: MessageStrings.writingToMeMessage,
    }[widget.puzzleType]!;
  }

  void _handlePutButtonTap() {
    if (_textController.text.trim().length < 10) {
      BuildDialog.show(iconName: 'limit', simpleDialog: true, context: context);
    } else {
      final Map<String, dynamic> puzzleData = {'content': _textController.text};
      if (widget.reply) {
        puzzleData['receiver_id'] = widget.parentId;
        puzzleData['parent_post_color'] =
            ColorUtils.colorToString(widget.parentColor!);
        puzzleData['parent_post_type'] = Utils.getType(widget.puzzleType);
      }

      BuildDialog.show(
        iconName: _getIconName(),
        puzzleData: puzzleData,
        context: context,
      );
    }
  }

  String _getIconName() {
    if (widget.reply) return 'putReply';
    return {
      PuzzleType.global: 'putGlobal',
      PuzzleType.subject: 'putSubject',
      PuzzleType.personal: 'putPersonal',
      PuzzleType.me: 'putMe',
    }[widget.puzzleType]!;
  }
}

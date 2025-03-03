import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
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
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
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
        body: _buildContent(height),
      ),
    );
  }

  Widget _buildContent(double height) {
    return Center(
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
          maxLength: 1000,
          inputFormatters: [LengthLimitingTextInputFormatter(1000)],
          style: Theme.of(context).textTheme.displayLarge,
          decoration: InputDecoration(
            hintText: '${_typeToHintText()}${MessageStrings.limitReplyMessage}',
            hintStyle: Theme.of(context).textTheme.labelSmall,
            border: InputBorder.none,
            counterText: '',
          ),
        ),
      ),
    );
  }

  void _handlePutButtonTap() {
    if (Utils.containsProfanity(_textController.text)) {
      BuildDialog.show(
          iconName: 'profanity', simpleDialog: true, context: context);
    } else {
      if (_textController.text.trim().length < 10) {
        BuildDialog.show(
            iconName: 'limit', simpleDialog: true, context: context);
      } else {
        final Map<String, dynamic> puzzleData = {
          'content': _textController.text
        };
        if (widget.reply) {
          puzzleData['receiver_id'] = widget.parentId;
          puzzleData['parent_post_color'] =
              ColorUtils.colorToString(widget.parentColor!);
          puzzleData['parent_post_type'] =
              GetPuzzleType.typeToString(widget.puzzleType);
        }

        BuildDialog.show(
          iconName: _typeToIconName(),
          puzzleData: puzzleData,
          context: context,
        );
      }
    }
  }

  String _typeToHintText() {
    if (widget.reply) return MessageStrings.writingReplyMessage;

    switch (widget.puzzleType) {
      case PuzzleType.global:
        return MessageStrings.writingGlobalMessage;
      case PuzzleType.subject:
        return MessageStrings.writingSubjectMessage;
      case PuzzleType.personal:
        return MessageStrings.writingToOtherMessage;
      default:
        return MessageStrings.writingToMeMessage;
    }
  }

  String _typeToIconName() {
    if (widget.reply) return 'putReply';

    switch (widget.puzzleType) {
      case PuzzleType.global:
        return 'putGlobal';
      case PuzzleType.subject:
        return 'putSubject';
      case PuzzleType.personal:
        return 'putPersonal';
      case PuzzleType.me:
      default:
        return 'putMe';
    }
  }
}

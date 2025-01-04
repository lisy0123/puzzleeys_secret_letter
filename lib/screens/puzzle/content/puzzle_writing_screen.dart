import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class PuzzleWritingScreen extends StatefulWidget {
  final PuzzleType puzzleType;
  final bool reply;

  const PuzzleWritingScreen({
    super.key,
    required this.puzzleType,
    this.reply = true,
  });

  @override
  State<PuzzleWritingScreen> createState() => _PuzzleWritingScreenState();
}

class _PuzzleWritingScreenState extends State<PuzzleWritingScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late double _height;

  @override
  void initState() {
    super.initState();
    _height = 2800.0.w;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _height = _focusNode.hasFocus ? 1200.0.w : 2800.0.w;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.dismissKeyboard(focusNode: _focusNode),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: 200.0.w,
              right: 200.0.w,
              top: (MediaQuery.of(context).size.height - 786.0.h) / 2,
            ),
            child: Column(
              children: [
                _buildBackButton(context),
                _buildMidContent(),
                SizedBox(height: 200.0.w),
                _buildPutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
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
    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: (widget.reply)
            ? Colors.white.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80.0.w, vertical: 10.0.w),
        child: _buildTextField(),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textEditingController,
      focusNode: _focusNode,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: null,
      style: Theme.of(context).textTheme.displayLarge,
      decoration: InputDecoration(
        hintText: _getHintText(),
        hintStyle: Theme.of(context).textTheme.labelSmall,
        border: InputBorder.none,
      ),
    );
  }

  String _getHintText() {
    if (widget.reply) {
      return MessageStrings.writingReplyMessage;
    }
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

  Widget _buildPutButton() {
    return CustomButton(
      iconName: 'btn_puzzle',
      iconTitle: CustomStrings.putEmotion,
      onTap: _handlePutButtonTap,
    );
  }

  void _handlePutButtonTap() {
    if (_textEditingController.text.length < 10) {
      BuildDialog.show(iconName: 'limit', simpleDialog: true, context: context);
    } else {
      BuildDialog.show(iconName: _getIconName(), context: context);
    }
  }

  String _getIconName() {
    if (widget.reply) {
      return 'putReply';
    }
    switch (widget.puzzleType) {
      case PuzzleType.global:
        return 'putGlobal';
      case PuzzleType.subject:
        return 'putSubject';
      case PuzzleType.personal:
        return 'putPersonal';
      case PuzzleType.me:
        return 'putMe';
      default:
        return 'putReply';
    }
  }
}

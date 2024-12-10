import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class PuzzleWritingScreen extends StatefulWidget {
  const PuzzleWritingScreen({super.key});

  @override
  State<PuzzleWritingScreen> createState() => _PuzzleWritingScreenState();
}

class _PuzzleWritingScreenState extends State<PuzzleWritingScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  int _maxLines = 21;

  @override
  void initState() {
    super.initState();
    _textFocusNode.addListener(() {
      setState(() {
        if (_textFocusNode.hasFocus) {
          _maxLines = 13;
        } else {
          _maxLines = 21;
        }
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_textFocusNode.hasFocus)
          FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(200.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(100.0.w),
                  child: PuzzleScreenHandler().buildIconButton(
                    iconName: 'btn_back',
                    text: '돌아가기',
                    onTap: () {
                      IconDialog(
                        iconName: 'cancel',
                        simpleDialog: true,
                      ).buildDialog(context);
                    },
                    context: context,
                  ),
                ),
                Container(
                  height: 2700.0.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 160.0.w,
                      vertical: 80.0.w,
                    ),
                    child: _buildTextField(context),
                  ),
                ),
                SizedBox(height: 200.0.w),
                _buildButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      focusNode: _textFocusNode,
      maxLines: _maxLines,
      maxLength: 1000,
      inputFormatters: [LengthLimitingTextInputFormatter(1000)],
      style: Theme.of(context).textTheme.displayMedium,
      decoration: InputDecoration(
        hintText: '답장을 써주세요...',
        hintStyle: Theme.of(context).textTheme.displaySmall,
        border: InputBorder.none,
        counterStyle: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return CustomButton(
      iconName: 'btn_puzzle',
      iconTitle: '감정 넣기',
      onTap: () {
        IconDialog(iconName: 'put').buildDialog(context);
      },
    );
  }
}

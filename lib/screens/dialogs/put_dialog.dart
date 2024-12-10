import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/get_dialog.dart';
import 'package:puzzleeys_secret_letter/utils/line_limiting_text_input_formatter.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/text_setting.dart';

class PutDialog extends StatefulWidget {
  final Color puzzleColor;

  const PutDialog({
    super.key,
    required this.puzzleColor,
  });

  @override
  State<PutDialog> createState() => _PutDialogState();
}

class _PutDialogState extends State<PutDialog> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textEditingController.dispose();
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
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.only(top: 90.0.h),
          padding: EdgeInsets.symmetric(
            vertical: 60.0.w,
            horizontal: 100.0.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => debugPrint('test'),
                child: _buildPuzzle(),
              ),
              _buildTextField(),
              CustomButton(
                iconName: 'btn_puzzle',
                iconTitle: '넣기',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => NextScreen(),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPuzzle() {
    return SizedBox(
      height: 600.0.w,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Center(
              child: GetDialog.puzzleImage(Colors.white),
            ),
          ),
          Center(
            child: TextSetting.textDisplay(
              text: '클릭해서 감정을 넣어주세요',
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textEditingController,
      focusNode: _textFocusNode,
      maxLines: 2,
      maxLength: 30,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
        LineLimitingTextInputFormatter(1),
      ],
      style: Theme.of(context).textTheme.displayMedium,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '제목을 써주세요...',
        hintStyle: Theme.of(context).textTheme.displaySmall,
        border: InputBorder.none,
        counterText: '',
      ),
    );
  }
}

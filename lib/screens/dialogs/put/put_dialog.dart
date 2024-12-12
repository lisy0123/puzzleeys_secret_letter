import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/get_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/color_picker.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/color_picker_provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/writing/writing_provider.dart';
import 'package:puzzleeys_secret_letter/utils/line_limiting_text_input_formatter.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<ColorPickerProvider>().updateOpacity(setToInitial: true);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.dismissKeyboard(focusNode: _focusNode),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.only(top: 90.0.h),
          padding: EdgeInsets.symmetric(horizontal: 100.0.w, vertical: 60.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () =>
                    context.read<ColorPickerProvider>().updateOpacity(),
                child: _buildPuzzle(context),
              ),
              _buildBottomContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPuzzle(BuildContext context) {
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

  // TODO
  Widget _buildBottomContent(BuildContext context) {
    final double opacity = context.watch<ColorPickerProvider>().opacity;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: opacity > 0.0
          ? Column(
              key: ValueKey('visible'),
              children: [
                _buildTextField(context),
                _buildPutButton(context),
              ],
            )
          : SizedBox(
              key: ValueKey('hidden'),
              child: ColorPicker(),
            ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      focusNode: _focusNode,
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

  Widget _buildPutButton(BuildContext context) {
    return CustomButton(
      iconName: 'btn_puzzle',
      iconTitle: '넣기',
      onTap: () {
        context.read<WritingProvider>().updateOpacity();
        Navigator.popUntil(context, (route) => route.isFirst);
        IconDialog(iconName: 'sent', simpleDialog: true).buildDialog(context);
      },
    );
  }
}

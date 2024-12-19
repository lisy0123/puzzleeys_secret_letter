import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/color_picker.dart';
import 'package:puzzleeys_secret_letter/providers/color_picker_provider.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/utils/line_limiting_text_input_formatter.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ColorPickerProvider>().updateOpacity(setToInitial: true);
      context.read<ColorPickerProvider>().updateColor(setToInitial: true);
    });
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText.textSmall(
              text: CustomStrings.chooseMessage,
              context: context,
            ),
            GestureDetector(
              onTap: () => context.read<ColorPickerProvider>().updateOpacity(),
              child: _buildPuzzle(context),
            ),
            SizedBox(
              height: 660.0.w,
              child: _buildBottomContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzle(BuildContext context) {
    final Color selectedColor =
        context.watch<ColorPickerProvider>().selectedColor;

    return SizedBox(
      height: 600.0.w,
      child: Stack(
        children: [
          Opacity(
            opacity: (selectedColor == Colors.white) ? 0.4 : 1.0,
            child: Center(
              child: TiltedPuzzle(puzzleColor: selectedColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    final double opacity = context.watch<ColorPickerProvider>().opacity;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: opacity > 0.0
          ? Column(
              key: const ValueKey('visible'),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTextField(context),
                _buildPutButton(context),
              ],
            )
          : const SizedBox(
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
      style: Theme.of(context).textTheme.displayLarge,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: CustomStrings.namingMessage,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        border: InputBorder.none,
        counterText: '',
      ),
    );
  }

  Widget _buildPutButton(BuildContext context) {
    return CustomButton(
      iconName: 'btn_puzzle',
      iconTitle: CustomStrings.put,
      onTap: () => _showDialog(context),
    );
  }

  void _showDialog(BuildContext context) {
    final Color color =
        Provider.of<ColorPickerProvider>(context, listen: false).selectedColor;

    if (color == Colors.white) {
      BuildDialog.show(
        iconName: 'emptyPuzzle',
        simpleDialog: true,
        context: context,
      );
    } else if (_textEditingController.text.isEmpty) {
      BuildDialog.show(
        iconName: 'emptyName',
        simpleDialog: true,
        context: context,
      );
    } else {
      context.read<WritingProvider>().updateOpacity();
      Navigator.popUntil(context, (route) => route.isFirst);
      BuildDialog.show(iconName: 'sent', simpleDialog: true, context: context);
    }
  }
}

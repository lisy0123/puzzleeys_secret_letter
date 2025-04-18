import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/bar_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/color_picker.dart';
import 'package:puzzleeys_secret_letter/providers/color_picker_provider.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/line_limiting_text_input_formatter.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/complete_puzzle.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class PutDialog extends StatefulWidget {
  final Map<String, dynamic> puzzleData;
  final PuzzleType puzzleType;

  const PutDialog({
    super.key,
    required this.puzzleData,
    required this.puzzleType,
  });

  @override
  State<PutDialog> createState() => _PutDialogState();
}

class _PutDialogState extends State<PutDialog> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final ColorPickerProvider _colorProvider;

  @override
  void initState() {
    _colorProvider = context.read<ColorPickerProvider>();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _colorProvider.updateOpacity(setToInitial: true);
      _colorProvider.updateColor(setToInitial: true);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomText.textSmall(
              text: MessageStrings.chooseMessage,
              context: context,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () => _colorProvider.updateOpacity(),
                  child: _buildPuzzle(context),
                ),
                SizedBox(
                  height: 700.0.w,
                  child: _buildBottomContent(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzle(BuildContext context) {
    return Selector<ColorPickerProvider, Color>(
      selector: (_, provider) => provider.selectedColor,
      builder: (_, selectedColor, __) {
        return SizedBox(
          height: 600.0.w,
          child: Opacity(
            opacity: (selectedColor == Colors.white) ? 0.4 : 1.0,
            child: Center(
              child: Utils.tiltedPuzzle(selectedColor),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return Selector<ColorPickerProvider, double>(
      selector: (_, provider) => provider.opacity,
      child: const ColorPicker(),
      builder: (_, opacity, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: opacity > 0.0
              ? Column(
                  key: const ValueKey('visible'),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: Center(child: _buildTextField(context)),
                    ),
                    _buildPutButton(context),
                  ],
                )
              : child,
        );
      },
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
        hintText: MessageStrings.namingMessage,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        border: InputBorder.none,
        counterText: '',
      ),
    );
  }

  Widget _buildPutButton(BuildContext context) {
    final int puzzleNums = context.read<BarProvider>().puzzleNums;
    final bool isNotZero = widget.puzzleType == PuzzleType.me || puzzleNums > 0;

    return CustomButton(
      iconName: isNotZero ? 'btn_puzzle' : 'btn_ad',
      iconTitle: isNotZero ? CustomStrings.put : CustomStrings.adPut,
      width: isNotZero ? 640.0 : 800.0,
      onTap: () => _showDialog(isNotZero, context),
    );
  }

  void _showDialog(bool isNotZero, BuildContext context) {
    final Color color = _colorProvider.selectedColor;

    if (color == Colors.white) {
      BuildDialog.show(
        iconName: 'emptyPuzzle',
        simpleDialog: true,
        context: context,
      );
    } else if (_textEditingController.text.trim().isEmpty) {
      BuildDialog.show(
        iconName: 'emptyName',
        simpleDialog: true,
        context: context,
      );
    } else {
      if (Utils.containsProfanity(_textEditingController.text)) {
        BuildDialog.show(
            iconName: 'profanity', simpleDialog: true, context: context);
      } else {
        _finalize(isNotZero, color);
      }
    }
  }

  void _finalize(bool isNotZero, Color color) async {
    widget.puzzleData['title'] = _textEditingController.text;
    widget.puzzleData['color'] = ColorUtils.colorToString(color);

    if (widget.puzzleType == PuzzleType.me) {
      BuildDialog.show(
        iconName: 'setDays',
        puzzleData: widget.puzzleData,
        context: context,
      );
    } else {
      CompletePuzzle(
        overlayType: _getOverlayType(),
        puzzleType: widget.puzzleType,
        puzzleData: widget.puzzleData,
        isNotZero: isNotZero,
        context: context,
      ).post();
    }
  }

  OverlayType _getOverlayType() {
    switch (widget.puzzleType) {
      case PuzzleType.global:
        return OverlayType.writeGlobalPuzzle;
      case PuzzleType.subject:
        return OverlayType.writeSubjectPuzzle;
      case PuzzleType.personal:
        return OverlayType.writePersonalPuzzle;
      case PuzzleType.me:
        return OverlayType.writePuzzleToMe;
      default:
        return OverlayType.writeReply;
    }
  }
}

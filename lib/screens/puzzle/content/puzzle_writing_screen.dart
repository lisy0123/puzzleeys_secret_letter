import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class PuzzleWritingScreen extends StatefulWidget {
  const PuzzleWritingScreen({super.key});

  @override
  State<PuzzleWritingScreen> createState() => _PuzzleWritingScreenState();
}

class _PuzzleWritingScreenState extends State<PuzzleWritingScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late double _height = 2800.0.w;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          _height = 1300.0.w;
        } else {
          _height = 2800.0.w;
        }
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
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
              top: MediaQuery.of(context).size.height / 7.5,
            ),
            child: Column(
              children: [
                _buldBackButton(context),
                _buildMidContent(context),
                SizedBox(height: 200.0.w),
                _buildPutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buldBackButton(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 50.0.w, horizontal: 20.0.w),
      child: PuzzleScreenHandler().buildIconButton(
        iconName: 'btn_back',
        text: CustomStrings.back,
        onTap: () {
          const IconDialog(iconName: 'cancel', simpleDialog: true)
              .buildDialog(context);
        },
        context: context,
      ),
    );
  }

  Widget _buildMidContent(BuildContext context) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 160.0.w, vertical: 80.0.w),
        child: _buildTextField(context),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      focusNode: _focusNode,
      maxLines: 21,
      maxLength: 1000,
      inputFormatters: [LengthLimitingTextInputFormatter(1000)],
      style: Theme.of(context).textTheme.displayMedium,
      decoration: InputDecoration(
        hintText: CustomStrings.writingMessage,
        hintStyle: Theme.of(context).textTheme.displaySmall,
        border: InputBorder.none,
        counterStyle: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }

  Widget _buildPutButton(BuildContext context) {
    return CustomButton(
      iconName: 'btn_puzzle',
      iconTitle: CustomStrings.putEmotion,
      onTap: () {
        const IconDialog(iconName: 'put').buildDialog(context);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
import 'package:puzzleeys_secret_letter/utils/countdown_timer.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({super.key});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  late Future<List<Map<String, dynamic>>?> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<List<Map<String, dynamic>>?> fetchData() async {
    try {
      final responseData =
          await apiRequest('/api/post/global_user', ApiType.get);

      if (responseData['code'] == 200) {
        final List<dynamic> data = responseData['result'] as List<dynamic>;
        return List<Map<String, dynamic>>.from(data);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PuzzleLoadingScreen(overlay: false);
        }
        if (snapshot.hasError) {
          return _buildErrorText(snapshot.error);
        }
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return _buildErrorText(null);
        } else {
          return _buildItem(snapshot);
        }
      },
    );
  }

  Widget _buildErrorText(Object? error) {
    if (error != null) {
      return Center(
        child: CustomText.textContent(
          text: 'Error: $error',
          context: context,
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/imgs/btn_trash.svg', height: 200.0.w),
        SizedBox(height: 80.0.w,),
        CustomText.textContent(
          text: MessageStrings.emptyWritingMessage,
          context: context,
        ),
      ],
    );
  }

  Widget _buildItem(AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
    return RawScrollbar(
      radius: Radius.circular(10),
      child: ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(
                height: 1200.0.w,
                child: _buildContent(snapshot.data![index]),
              ),
              Utils.dialogDivider(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(500.0.w, 500.0.w),
          painter: TiltedPuzzlePiece(
            puzzleColor: ColorMatch(stringColor: item['color'])(),
          ),
        ),
        SizedBox(
          width: 1400.0.w,
          child: CustomText.textContent(text: item['title'], context: context),
        ),
        SizedBox(
          width: 1000.0.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CountdownTimer(createdAt: item['created_at']),
              CustomButton(
                iconName: 'none',
                iconTitle: CustomStrings.deleteShort,
                height: 180,
                width: 360,
                borderStroke: 1.5,
                onTap: () {
                  BuildDialog.show(
                    iconName: 'delete',
                    simpleDialog: true,
                    context: context,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

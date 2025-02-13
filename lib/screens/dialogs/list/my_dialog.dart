import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/delete_dialog_provider.dart';
import 'package:puzzleeys_secret_letter/widgets/loading_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/countdown_timer.dart';
import 'package:puzzleeys_secret_letter/utils/request/fetch_request.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
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
    _futureData = FetchRequest.dialogData('/api/post/global_user');
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DeleteDialogProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, child) {
        if (!isLoading) {
          _futureData = FetchRequest.dialogData('/api/post/global_user');
        }
        return LoadingDialog(
          futureData: _futureData,
          buildErrorText: _buildErrorText(),
          buildItem: _buildItem,
        );
      },
    );
  }

  Widget _buildErrorText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/imgs/btn_trash.svg', height: 200.0.w),
        SizedBox(height: 80.0.w),
        CustomText.textContent(
          text: MessageStrings.emptyWritingMessage,
          context: context,
        ),
      ],
    );
  }

  Widget _buildItem(List<Map<String, dynamic>> data) {
    return RawScrollbar(
      radius: Radius.circular(10),
      child: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => Utils.dialogDivider(),
        itemBuilder: (context, index) {
          return SizedBox(height: 900.0.w, child: _buildContent(data[index]));
        },
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(400.0.w, 400.0.w),
          painter: TiltedPuzzlePiece(
            puzzleColor: ColorUtils.colorMatch(stringColor: item['color']),
            strokeWidth: 1.5,
          ),
        ),
        SizedBox(
          width: 1200.0.w,
          child: CustomText.dialogPuzzleText(item['title']),
        ),
        SizedBox(
          height: 180.0.w,
          width: 540.0.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: CountdownTimer(
              createdAt: item['created_at'],
              grayText: true,
            ),
          ),
        ),
      ],
    );
  }
}

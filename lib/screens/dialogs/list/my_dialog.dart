import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/delete_dialog_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_content_handler.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
import 'package:puzzleeys_secret_letter/utils/request/user_request.dart'
    show UserRequest;
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/loading_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/countdown_timer.dart';
import 'package:puzzleeys_secret_letter/utils/request/fetch_request.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/parent_puzzle_widget.dart';
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
    _futureData = FetchRequest.dialogData('/api/post/user');
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DeleteDialogProvider, bool>(
      selector: (_, provider) => provider.isLoading,
      builder: (_, isLoading, __) {
        if (!isLoading) {
          _futureData = FetchRequest.dialogData('/api/post/user');
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
          return _buildContent(data[index]);
        },
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> item) {
    final Map<String, dynamic> puzzleData = {
      ...Map.from(item)..remove('color'),
      'color': ColorUtils.colorMatch(stringColor: item['color']),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0.w),
          child: GestureDetector(
            onTap: () => _onTapPuzzle(puzzleData),
            child: CustomPaint(
              size: Size(340.0.w, 340.0.w),
              painter: TiltedPuzzlePiece(
                puzzleColor: puzzleData['color'],
                strokeWidth: 1.5,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.w),
          child: SizedBox(
            width: 1200.0.w,
            child: CustomText.dialogText(item['title']),
          ),
        ),
        SizedBox(
          width: 700.0.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CountdownTimer(createdAt: item['created_at']),
              ParentPuzzleWidget(parentPostType: item['post_type']),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0.w, bottom: 60.0.w),
          child: CustomButton(
            iconName: 'none',
            iconTitle: CustomStrings.deleteShort,
            height: 160,
            width: 300,
            borderStroke: 1.5,
            onTap: () {
              BuildDialog.show(
                iconName: 'deletePost',
                simpleDialog: true,
                puzzleId: item['id'],
                puzzleType: GetPuzzleType.stringToType(item['post_type']),
                context: context,
              );
            },
          ),
        ),
      ],
    );
  }

  void _onTapPuzzle(Map<String, dynamic> puzzleData) async {
    final PuzzleType puzzleType =
        GetPuzzleType.stringToType(puzzleData['post_type']);
    final String userId = await UserRequest.getUserId();

    if (puzzleType != PuzzleType.personal) {
      puzzleData['author_id'] = userId;
    } else {
      puzzleData['sender_id'] = userId;
    }

    if (mounted) {
      PuzzleContentHandler.handler(
        puzzleType: puzzleType,
        puzzleData: puzzleData,
        context: context,
      );
    }
  }
}

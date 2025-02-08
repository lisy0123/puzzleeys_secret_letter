import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/constants/vars.dart';
import 'package:puzzleeys_secret_letter/providers/delete_dialog_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/parent_widget.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class BeadDialog extends StatefulWidget {
  const BeadDialog({super.key});

  @override
  State<BeadDialog> createState() => _BeadDialogState();
}

class _BeadDialogState extends State<BeadDialog> {
  late Future<List<Map<String, dynamic>>?> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<List<Map<String, dynamic>>?> fetchData() async {
    try {
      final responseData = await apiRequest('/api/bead/user', ApiType.get);

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 1),
        Stack(
          children: [
            Container(
              width: 800.0.w,
              height: 800.0.w,
              decoration: BoxDecorations.bead(
                myGradientColors: CustomVars.myGradientColors,
              ),
            ),
            Image.asset('assets/imgs/puzzle_pattern.png', width: 800.0.w),
          ],
        ),
        SizedBox(height: 1500.0.w, child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    return Selector<DeleteDialogProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, child) {
        if (!isLoading) {
          _futureData = fetchData();
        }
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
      },
    );
  }

  Widget _buildErrorText(Object? error) {
    if (error != null) {
      return Center(
        child: CustomText.textContent(text: 'Error: $error', context: context),
      );
    }
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

  Widget _buildItem(AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
    final int puzzleCount = snapshot.data!.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText.textDisplay(
          text: '${puzzleCount.toString()}${CustomStrings.puzzleCount}',
          stroke: true,
          context: context,
        ),
        SizedBox(height: 40.0.w),
        Utils.dialogDivider(),
        SizedBox(
          height: 1300.0.w,
          child: RawScrollbar(
            radius: Radius.circular(10),
            child: ListView.builder(
              itemCount: puzzleCount,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildContent(snapshot.data![index]),
                    Utils.dialogDivider(),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(Map<String, dynamic> item) {
    final Color color = ColorUtils.colorMatch(stringColor: item['color']);

    return SizedBox(
      height: 500.0.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPaint(
            size: Size(360.0.w, 360.0.w),
            painter: TiltedPuzzlePiece(puzzleColor: color, strokeWidth: 1.5),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemTop(item),
                SizedBox(width: 1000.0.w, child: _text(item['title'])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTop(Map<String, dynamic> item) {
    final String date = Utils.convertUTCToKST(item['created_at'])
        .split(' ')[0]
        .replaceAll("-", "/");
    final PuzzleType puzzleType = GetPuzzleType.stringToType(item['post_type']);

    return SizedBox(
      width: 1000.0.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _text(date, date: true),
              ParentWidget(parentPostType: item['post_type']),
            ],
          ),
          GestureDetector(
            onTap: () => BuildDialog.show(
              iconName: 'report',
              puzzleId: item['id'],
              puzzleType: puzzleType,
              simpleDialog: true,
              context: context,
            ),
            child: SvgPicture.asset(
              'assets/imgs/btn_alarm.svg',
              height: 100.0.w,
            ),
          ),
        ],
      ),
    );
  }

  Text _text(String str, {bool date = false}) {
    return Text(
      str,
      style: TextStyle(
        color: date
            ? CustomColors.colorBase.withValues(alpha: 0.6)
            : CustomColors.colorBase,
        fontFamily: 'NANUM',
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
        fontSize: date ? 70.sp : 74.0.sp,
      ),
    );
  }
}

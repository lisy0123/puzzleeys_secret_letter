import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/loading_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
import 'package:puzzleeys_secret_letter/utils/request/fetch_request.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/parent_puzzle_widget.dart';
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
    _futureData = FetchRequest.dialogData('/api/bead/user');
  }

  @override
  Widget build(BuildContext context) {
    return Selector<BeadProvider, bool>(
      selector: (_, provider) => provider.isLoading,
      builder: (_, isLoading, __) {
        if (!isLoading) {
          _futureData = FetchRequest.dialogData('/api/bead/user');
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
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBead([Colors.white, Colors.white], 0),
        Utils.dialogDivider(),
        SizedBox(
          height: 1300.0.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/imgs/btn_trash.svg', height: 200.0.w),
              SizedBox(height: 80.0.w),
              CustomText.textContent(
                text: MessageStrings.emptyPuzzleMessage,
                context: context,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(List<Map<String, dynamic>> data) {
    final int puzzleCount = data.length;
    final List<Color> beadColor = context.read<BeadProvider>().beadColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBead(beadColor, puzzleCount),
        Utils.dialogDivider(),
        SizedBox(
          height: 1300.0.w,
          child: RawScrollbar(
            radius: Radius.circular(10),
            child: ListView.separated(
              itemCount: puzzleCount,
              separatorBuilder: (_, __) => Utils.dialogDivider(),
              itemBuilder: (context, index) {
                return _buildContent(data[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBead(List<Color> beadColor, int puzzleCount) {
    return SizedBox(
      height: 1100.0.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 800.0.w,
                height: 800.0.w,
                decoration: BoxDecorations.bead(gradientColors: beadColor),
              ),
              Image.asset('assets/imgs/puzzle_pattern.png', width: 800.0.w),
            ],
          ),
          CustomText.textDisplay(
            text: '${puzzleCount.toString()}${CustomStrings.puzzleCount}',
            stroke: true,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> item) {
    final String date = Utils.convertUTCToKST(item['created_at'])
        .split(' ')[0]
        .replaceAll("-", "/");

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTopContext(item),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.w),
          child: SizedBox(
            width: 1200.0.w,
            child: CustomText.dialogText(item['title']),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText.dialogText(date, gray: true),
            ParentPuzzleWidget(parentPostType: item['post_type']),
          ],
        ),
        _buildDeleteButton(item),
      ],
    );
  }

  Widget _buildTopContext(Map<String, dynamic> item) {
    final Color color = ColorUtils.colorMatch(stringColor: item['color']);
    final PuzzleType puzzleType = GetPuzzleType.stringToType(item['post_type']);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0.w, vertical: 30.0.w),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/imgs/btn_alarm.svg',
                height: 100.0.w,
              ),
              onTap: () => BuildDialog.show(
                iconName: 'reportBead',
                puzzleId: item['id'],
                puzzleType: puzzleType,
                simpleDialog: true,
                context: context,
              ),
            ),
          ),
          Center(
            child: CustomPaint(
              size: Size(340.0.w, 340.0.w),
              painter: TiltedPuzzlePiece(puzzleColor: color, strokeWidth: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0.w, bottom: 60.0.w),
      child: CustomButton(
        iconName: 'none',
        iconTitle: CustomStrings.deleteShort,
        height: 160,
        width: 300,
        borderStroke: 1.5,
        onTap: () {
          BuildDialog.show(
            iconName: 'deleteBead',
            simpleDialog: true,
            puzzleData: item,
            context: context,
          );
        },
      ),
    );
  }
}

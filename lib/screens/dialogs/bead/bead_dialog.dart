import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/bead/bead_colored.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
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
    return Selector<BeadProvider, bool>(
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBead(null),
        SizedBox(
          height: 1200.0.w,
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

  Widget _buildItem(AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
    final int puzzleCount = snapshot.data!.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBead(snapshot.data),
        SizedBox(
          height: 1200.0.w,
          child: RawScrollbar(
            radius: Radius.circular(10),
            child: ListView.builder(
              itemCount: puzzleCount,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 840.0.w,
                      child: _buildContent(snapshot.data![index]),
                    ),
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

  Widget _buildBead(List<Map<String, dynamic>>? item) {
    final int puzzleCount = (item == null) ? 0 : item.length;

    return SizedBox(
      height: 1200.0.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 1),
          BeadColored(item: item),
          CustomText.textDisplay(
            text: '${puzzleCount.toString()}${CustomStrings.puzzleCount}',
            stroke: true,
            context: context,
          ),
          Utils.dialogDivider(),
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
        SizedBox(
          width: 1200.0.w,
          child: CustomText.dialogPuzzleText(item['title']),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText.dialogPuzzleText(date, date: true),
            ParentWidget(parentPostType: item['post_type']),
          ],
        ),
      ],
    );
  }

  Widget _buildTopContext(Map<String, dynamic> item) {
    final Color color = ColorUtils.colorMatch(stringColor: item['color']);

    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: _buildReportButton(item['id'], item['post_type']),
        ),
        Center(
          child: CustomPaint(
            size: Size(400.0.w, 400.0.w),
            painter: TiltedPuzzlePiece(puzzleColor: color, strokeWidth: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildReportButton(String puzzleId, String postType) {
    return GestureDetector(
      child: SvgPicture.asset('assets/imgs/btn_alarm.svg', height: 100.0.w),
      onTap: () => BuildDialog.show(
        iconName: 'reportBead',
        puzzleId: puzzleId,
        puzzleType: GetPuzzleType.stringToType(postType),
        simpleDialog: true,
        context: context,
      ),
    );
  }
}

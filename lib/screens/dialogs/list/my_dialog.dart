import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
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
        } else if (snapshot.hasError) {
          return Center(
              child: CustomText.textContentTitle(
            text: 'Error: ${snapshot.error}',
            context: context,
          ));
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(
              child: CustomText.textContentTitle(
            text: 'No data found',
            context: context,
          ));
        } else {
          return RawScrollbar(
            radius: Radius.circular(10),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildItem(snapshot.data![index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0.w),
          child: SizedBox(
            height: 1000.0.w,
            child: _buildContent(item),
          ),
        ),
        Utils.dialogDivider(),
      ],
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
            puzzleColor: ColorMatch(stringColor: item['color'])(),
          ),
        ),
        SizedBox(
          width: 1000.0.w,
          child: CustomText.textContent(
            text: item['title'],
            context: context,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO: put timer
            CustomText.textContent(text: '00:00:00', context: context),
            SizedBox(width: 80.0.w),
            CustomButton(
              iconName: 'none',
              iconTitle: '삭 제',
              height: 180,
              width: 360,
              borderStroke: 1.5,
              onTap: () {},
              // TODO: delete dialog
            ),
          ],
        ),
      ],
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';

class BeadDialog extends StatelessWidget {
  const BeadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(context),
        Utils.dialogDivider(),
        _buildBead(context),
        Utils.dialogDivider(),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {},
          child: SvgPicture.asset('assets/imgs/btn_arrow.svg'),
        ),
        Text('data'),
        GestureDetector(
          onTap: () {},
          child: Transform.rotate(
            angle: pi,
            child: SvgPicture.asset('assets/imgs/btn_arrow.svg'),
          ),
        ),
      ],
    );
  }

  Widget _buildBead(BuildContext context) {
    return Text('data');
  }
}

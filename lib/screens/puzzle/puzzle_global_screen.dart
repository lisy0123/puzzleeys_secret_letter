import 'package:flutter/material.dart';

class PuzzleGlobalScreen extends StatefulWidget {
  const PuzzleGlobalScreen({super.key});

  @override
  State<PuzzleGlobalScreen> createState() => _PuzzleGlobalScreenState();
}

class _PuzzleGlobalScreenState extends State<PuzzleGlobalScreen> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    if (offset == Offset(0, 0)) {
      offset = Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      );
    }

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          offset = Offset(
              offset.dx + details.delta.dx, offset.dy + details.delta.dy);
        });
      },
      child: Container(
        color: Colors.greenAccent,
        child: Stack(
          children: [
            Transform.translate(
              offset: offset,
              child: Icon(
                Icons.favorite,
                size: 50.0,
              ),
            ),
          ],
        ),
      )
      ,
    );
  }
}

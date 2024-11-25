import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/styles/theme_setting.dart';
import 'package:puzzleeys_secret_letter/screens/home/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {

   return MaterialApp(
     theme: ThemeSetting.themeSetting(),
     home: HomeScreen(),
     );
 }
}


// class ZoomTestScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("줌인/줌아웃 테스트")),
//       body: Center(
//         child: Container(
//           color: Colors.grey[300], // 배경색
//           child: InteractiveViewer(
//             boundaryMargin: EdgeInsets.all(20.0), // 줌 이동 허용 범위
//             minScale: 0.5, // 최소 축소 비율
//             maxScale: 4.0, // 최대 확대 비율
//             child: Container(
//               width: 400, // 줌 테스트할 영역의 가로 크기
//               height: 400, // 줌 테스트할 영역의 세로 크기
//               color: Colors.blueAccent, // 테스트용 박스 색상
//               child: Center(
//                 child: Text(
//                   "줌 테스트 박스",
//                   style: TextStyle(color: Colors.white, fontSize: 24.0),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

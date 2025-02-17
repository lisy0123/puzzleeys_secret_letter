import 'package:puzzleeys_secret_letter/constants/enums.dart';

class GetPuzzleType {
  static String typeToString(PuzzleType puzzleType) {
    switch (puzzleType) {
      case PuzzleType.global:
        return 'global';
      case PuzzleType.subject:
        return 'subject';
      default:
        return 'personal';
    }
  }

  static PuzzleType stringToType(String puzzleType) {
    switch (puzzleType) {
      case 'global':
        return PuzzleType.global;
      case 'subject':
        return PuzzleType.subject;
      default:
        return PuzzleType.personal;
    }
  }

  static int stringToIndex(String puzzleType) {
    switch (puzzleType) {
      case 'global':
        return 0;
      case 'subject':
        return 1;
      default:
        return 2;
    }
  }

  static PuzzleType indexToType(int index) {
    switch (index) {
      case 0:
        return PuzzleType.global;
      case 1:
        return PuzzleType.subject;
      default:
        return PuzzleType.personal;
    }
  }
}

import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';

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

  static PuzzleType intToPuzzleType(int index) {
    switch (index) {
      case 0:
        return PuzzleType.global;
      case 1:
        return PuzzleType.subject;
      default:
        return PuzzleType.personal;
    }
  }

  static String typeToHintText({
    required PuzzleType puzzleType,
    required bool reply,
  }) {
    if (reply) return MessageStrings.writingReplyMessage;

    switch (puzzleType) {
      case PuzzleType.global:
        return MessageStrings.writingGlobalMessage;
      case PuzzleType.subject:
        return MessageStrings.writingSubjectMessage;
      case PuzzleType.personal:
        return MessageStrings.writingToOtherMessage;
      default:
        return MessageStrings.writingToMeMessage;
    }
  }

  static String typeToIconName({
    required PuzzleType puzzleType,
    required bool reply,
  }) {
    if (reply) return 'putReply';

    switch (puzzleType) {
      case PuzzleType.global:
        return 'putGlobal';
      case PuzzleType.subject:
        return 'putSubject';
      default:
        return 'putPersonal';
    }
  }
}

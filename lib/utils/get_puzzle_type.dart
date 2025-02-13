import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';

class GetPuzzleType {
  static String typeToString(PuzzleType puzzleType) {
    return {
          PuzzleType.global: 'global',
          PuzzleType.subject: 'subject',
        }[puzzleType] ??
        'personal';
  }

  static PuzzleType stringToType(String puzzleType) {
    return {
          'global': PuzzleType.global,
          'subject': PuzzleType.subject,
        }[puzzleType] ??
        PuzzleType.personal;
  }

  static int stringToIndex(String puzzleType) {
    return {
          'global': 0,
          'subject': 1,
        }[puzzleType] ??
        2;
  }

  static PuzzleType intToPuzzleType(int index) {
    return {
      0: PuzzleType.global,
      1: PuzzleType.subject,
      2: PuzzleType.personal,
    }[index]!;
  }

  static String typeToHintText({
    required PuzzleType puzzleType,
    required bool reply,
  }) {
    if (reply) return MessageStrings.writingReplyMessage;
    return {
      PuzzleType.global: MessageStrings.writingGlobalMessage,
      PuzzleType.subject: MessageStrings.writingSubjectMessage,
      PuzzleType.personal: MessageStrings.writingToOtherMessage,
      PuzzleType.me: MessageStrings.writingToMeMessage,
    }[puzzleType]!;
  }

  static String typeToIconName({
    required PuzzleType puzzleType,
    required bool reply,
  }) {
    if (reply) return 'putReply';
    return {
      PuzzleType.global: 'putGlobal',
      PuzzleType.subject: 'putSubject',
      PuzzleType.personal: 'putPersonal',
      PuzzleType.me: 'putMe',
    }[puzzleType]!;
  }
}

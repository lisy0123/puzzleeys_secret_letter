enum WarningType { cancel, limit, emptyName, emptyPuzzle }

enum OverlayType {
  attendance,
  getPuzzle,
  writeSubjectPuzzle,
  writeGlobalPuzzle,
  writePersonalPuzzle,
  writePuzzleToMe,
  writeReply;
}

class OverlayMessage {
  final int num;
  final String message;

  const OverlayMessage(this.num, this.message);
}

enum MissionType {
  attendance,
  writeSubjectPuzzle,
  writeGlobalPersonalPuzzle,
  getPuzzle,
  writeReply;
}

enum QuestType { attendance, writePuzzle, getPuzzle, writeReply }

class QuestData {
  final int count;
  final int goal;

  const QuestData(this.count, this.goal);
}

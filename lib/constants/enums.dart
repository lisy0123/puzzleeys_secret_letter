enum WarningType { cancel, limit, emptyName, emptyPuzzle }

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

enum OverlayType {
  attendance,
  getPuzzle,
  writeSubjectPuzzle,
  writeGlobalPuzzle,
  writePersonalPuzzle,
  writePuzzleToMe,
  writeReply;
}

enum LoadingType { login, setting, sending }

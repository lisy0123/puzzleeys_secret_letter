import 'package:puzzleeys_secret_letter/constants/enums.dart';

class CustomStrings {
  static const String email = 'puzzleey@puzzleletter.com';
  static const String snsX = 'https://x.com/puzzleey_app';

  static const String howToUseUrl =
      'https://puzzleey.notion.site/1a5056190a05802fb47ec48016cfea9d';
  static const String termsUrl =
      'https://puzzleey.notion.site/1a5056190a0580df8396d5e041463494';
  static const String privacyPolicyUrl =
      'https://puzzleey.notion.site/1a5056190a0580fda462cb5b814310c3';
  static const String copyRightPolicyUrl =
      'https://puzzleey.notion.site/1a5056190a0580eaa418f5926c78ca44';

  static const String title = 'PUZZLEEY';
  static const String slogan = '퍼즐에 감정을 담다';
  static const String googleLogin = 'Google로 시작하기';
  static const String appleLogin = 'Apple로 시작하기';

  static const List<String> pageNameLists = ['전체', '주제', '개인', '상점', '더보기'];

  static const Map<String, String> dialogNameLists = {
    'bead': '감정 퍼즐 구슬',
    'list': preview,
    'puzzlePreview': '감정 보기',
    'puzzleSubject': '오늘의 주제',
    'putGlobal': putEmotion,
    'putSubject': putEmotion,
    'putPersonal': putEmotion,
    'putMe': putEmotion,
    'putReply': putEmotion,
    'setDays': '언제 받을까요?',
    'terms': terms,
    'agreeToTerms': terms,

    '0': '계 정',
    '1': '내 글',
    '2': '알 람',
    '3': '임 무',
    '4': '???',
    '5': '업 적',
    '6': '공 지',
    '7': '문 의',
    '8': '설 정',
  };

  static const String userId = '회원 번호';
  static const String userCreatedAt = '가입 날짜';
  static const String userPuzzleeyDays = '퍼즐이가 된 지';
  static const String dayCount = '일째';
  static const String day = '일 뒤';

  static const String start = '시작하기';
  static const String howToUse = '이용 안내';
  static const String feedback = '문의하기';

  static const String version = '버 전';
  static const String copyRight = 'Copyright 2025 Puzzleey';

  static const String terms = '서비스 이용약관';
  static const String privacyPolicy = '개인정보 처리방침';
  static const String copyRightPolicy = '회원 저작물의 지적재산권';

  static const String termsAgree = '서비스 이용약관 동의';
  static const String privacyPolicyAgree = '개인정보 처리방침 동의';
  static const String copyRightPolicyAgree = '회원 저작물의 지적재산권에\n대한 동의 (선택)';
  static const String agreeAll = '전체 동의';
  static const String hasAgreed = '동의 완료';

  static const String reply = '답 장';
  static const String report = '신고하기';
  static const String back = '돌아가기';
  static const String putEmotion = '감정 넣기';
  static const String preview = '더 보 기';
  static const String put = '넣 기';
  static const String adPut = '광고 보고 넣기';
  static const String send = '보내기';
  static const String adSend = '광고 보고 보내기';
  static const String get = '퍼즐 담기';

  static const String logout = '로그아웃';
  static const String deleteUser = '회원 탈퇴';
  static const String deleteShort = '삭 제';
  static const String deleteLong = '삭제하기';

  static const String sendToWho = '누구에게 보낼 건가요?';
  static const String sendToOther = '누군가에게';
  static const String sendToMe = '미래의 나에게';

  static const String addToday = '오늘 하루';
  static const String puzzleCount = '개의 감정 퍼즐을 담았어요!';

  static List<String> questUnits = ['일', '회'];
  static Map<bool, String> questButtons = {false: '완료 보상', true: '보상 받기'};
}

class MessageStrings {
  static String writingGlobalMessage = '전하고 싶은 감정을 자유롭게 적어주세요.';
  static String writingSubjectMessage = '주제에 대해 자유롭게 적어주세요.';
  static String writingToOtherMessage = '누군가에게 전하고 싶은 감정을 적어주세요.';
  static String writingToMeMessage = '미래의 나에게 전하고 싶은 감정을 적어주세요.';
  static String writingReplyMessage = '답장을 적어주세요.';
  static String limitReplyMessage = '\n(1000자 이하)';

  static String chooseMessage = '퍼즐을 클릭해서 감정을 골라주세요.';
  static String namingMessage = '감정에 이름을 붙여주세요.\n(30자 이하)';
  static String setDaysMessage = '받을 날짜를 골라주세요.';

  static String emptyWritingMessage = '작성한 글이 없어요!';
  static String emptyPuzzleMessage = '담은 감정 퍼즐이 없어요!';

  static String deleteMessage = '지금 당장\n삭제할까요?';
  static String reportMessage = '해당 글을\n신고할까요?';

  static String logoutMessage = '로그아웃할까요?';
  static String deleteUserMessage = '회원 탈퇴할까요?';

  static Map<Enum, String> warningMessages = {
    WarningType.cancel: '돌아가면\n감정이 지워져요!',
    WarningType.limit: '최소 10자 이상\n작성해주세요!',
    WarningType.emptyName: '감정에\n이름을 붙여주세요!',
    WarningType.emptyPuzzle: '퍼즐에\n감정을 넣어주세요!',
    WarningType.isExists: '이미 오늘의 주제에\n감정 퍼즐을 공유했어요!',
  };

  static Map<Enum, String> missionMessages = {
    MissionType.attendance: '오늘도 출석하기',
    MissionType.writeSubjectPuzzle: '오늘의 감정 퍼즐 보내기',
    MissionType.writeGlobalPersonalPuzzle: '감정 퍼즐 보내기',
    MissionType.getPuzzle: '감정 퍼즐 담기',
    MissionType.writeReply: '답장 보내기',
  };

  static Map<Enum, String> questMessages = {
    QuestType.attendance: '출석',
    QuestType.writePuzzle: '퍼즐 보내기',
    QuestType.getPuzzle: '퍼즐 담기',
    QuestType.writeReply: '답장 보내기',
  };

  static Map<Enum, List<dynamic>> overlayMessages = {
    OverlayType.attendance: [3, '출석했어요!'],
    OverlayType.getPuzzle: [1, '감정 퍼즐을 담았어요!'],
    OverlayType.writeGlobalPuzzle: [-1, '감정 퍼즐을 공유했어요!'],
    OverlayType.writeSubjectPuzzle: [-1, '오늘의 주제에 감정 퍼즐을 공유했어요!'],
    OverlayType.writePersonalPuzzle: [-1, '누군가에게 감정 퍼즐을 보냈어요!'],
    OverlayType.writePuzzleToMe: [-1, '미래의 나에게 감정 퍼즐을 보냈어요!'],
    OverlayType.writeReply: [1, '답장을 보냈어요!'],
  };
  static String userIdOverlay = '회원 번호를 복사했어요!';
  static String puzzleExistOverlay = '이미 담은 감정 퍼즐이에요!';
  static String reportOverlay = '해당 감정 퍼즐을 신고했어요!';
}

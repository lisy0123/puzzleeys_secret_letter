import 'package:puzzleeys_secret_letter/constants/enums.dart';

class CustomStrings {
  static const List<String> pageNameLists = ['전체', '주제', '개인', '상점', '더보기'];

  static const Map<String, String> dialogNameLists = {
    'list': '더 보 기',
    'bead': '감정 퍼즐 구슬',
    'alarm': '신고하기',
    'get': '감정 담기',
    'put': '감정 넣기',
    '0': '계 정',
    '1': '내 글',
    '2': '알 람',
    '3': '임 무',
    '4': '???',
    '5': '업 적',
    '6': '공 지',
    '7': '지 원',
    '8': '설 정',
  };

  static String slogan = '퍼즐에 감정을 담다';
  static String googleLogin = '구글로 시작하기';
  static String appleLogin = '애플로 시작하기';

  static String userId = '회원 번호';
  static String userCreatedAt = '가입 날짜';
  static String userPuzzleeyDays = '퍼즐이가 된 지';
  static String userPuzzleeyDayCount = '일째';
  static String userIdOverlay = '회원 번호를 복사했어요!';

  static String reply = '답 장';
  static String alarm = '신고하기';
  static String back = '돌아가기';
  static String putEmotion = '감정 넣기';
  static String get = '담 기';
  static String put = '넣 기';
  static String logout = '로그아웃';

  static List<String> questUnits = ['일', '회'];
  static Map<bool, String> questButtons = {false: '완료 보상', true: '보상 받기'};
}

class MessageStrings {
  static String writingMessage = '답장을 적어주세요.';
  static String chooseMessage = '퍼즐을 클릭해서 감정을 골라주세요.';
  static String namingMessage = '감정에 이름을 붙여주세요.';
  static String sentMessage = '감정 퍼즐을 보냈어요!';

  static Map<Enum, String> warningMessages = {
    WarningType.cancel: '돌아가면\n편지가 지워져요!',
    WarningType.limit: '최소 10자 이상\n작성해주세요!',
    WarningType.emptyName: '감정에\n이름을 붙여주세요!',
    WarningType.emptyPuzzle: '퍼즐에\n감정을 넣어주세요!',
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
    OverlayType.attendance: [1, '출석했어요!'],
    OverlayType.getPuzzle: [1, '감정 퍼즐을 담았어요!'],
    OverlayType.writeSubjectPuzzle: [1, '오늘의 감정 퍼즐을 보냈어요!'],
    OverlayType.writeGlobalPuzzle: [1, '감정 퍼즐을 보냈어요!'],
    OverlayType.writePersonalPuzzle: [-1, '누군가에게 감정 퍼즐을 보냈어요!'],
    OverlayType.writePuzzleToMe: [-1, '나에게 감정 퍼즐을 보냈어요!'],
    OverlayType.writeReply: [-1, '답장을 보냈어요!'],
  };

  static Map<Enum, String> loadingMessages = {
    LoadingType.login: '로그인 중',
    LoadingType.setting: '감정 불러오는 중',
    LoadingType.sending: '보내는 중',
  };
}
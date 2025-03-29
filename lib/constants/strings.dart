import 'package:puzzleeys_secret_letter/constants/enums.dart';

class UrlStrings {
  static const String email = 'puzzleey@puzzleletter.com';
  static const String snsInsta = 'https://www.instagram.com/puzzleey._.app';
  static const String snsX = 'https://x.com/puzzleey_app';

  static const String howToUseUrl =
      'https://puzzleey.notion.site/1a5056190a05802fb47ec48016cfea9d';
  static const String termsUrl =
      'https://puzzleey.notion.site/1a5056190a0580df8396d5e041463494';
  static const String privacyPolicyUrl =
      'https://puzzleey.notion.site/1a5056190a0580fda462cb5b814310c3';
  static const String copyRightPolicyUrl =
      'https://puzzleey.notion.site/1a5056190a0580eaa418f5926c78ca44';
}

class CustomStrings {
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
  static const String deleteShort = '삭제';
  static const String deleteLong = '삭제하기';

  static const String sendToWho = '누구에게 보낼 건가요?';
  static const String sendToOther = '누군가에게';
  static const String sendToMe = '미래의 나에게';

  static const String addToday = '오늘 하루';
  static const String puzzleCount = '개의 감정 퍼즐을 담았어요!';

  static const List<String> questUnits = ['일', '회'];
  static const Map<bool, String> questButtons = {false: '완료 보상', true: '보상 받기'};

  static const String profanityKorean =
      r'([시씨씪슈쓔쉬쉽쒸쓉](?:[0-9]*|[0-9]+ *)[바발벌빠빡빨뻘파팔펄]|[섊좆좇졷좄좃좉졽썅춍봊]|[ㅈ조][0-9]*까|ㅅㅣㅂㅏㄹ?|ㅂㅕㅇㅅㅣㄴ?|ㅂ[0-9]*ㅅ|[ㅄᄲᇪᄺᄡᄣᄦᇠ]|[ㅅㅆᄴ][0-9]*[ㄲㅅㅆᄴㅂ]|[존좉좇][0-9 ]*나|[자보][0-9]+지|보빨|[봊봋봇봈볻봁봍] *[빨이]|[후훚훐훛훋훗훘훟훝훑][장앙]|[엠앰]창|애[미비]|애자|[가-힣]색기|(?:[샊샛세쉘쉨쉒객갞갟갯갰갴겍겎겏겤곅곆곇곗곘곜걕걖걗걧걨걬] *[끼키퀴])|새 *[키퀴]|[병븅][0-9]*[신딱딲]|미친[가-닣닥-힣]|[믿밑]힌|[염옘][0-9]*병|[샊샛샜샠섹섺셋셌셐셱솃솄솈섁섂섓섔섘]기|[섹섺섻쎅쎆쎇쎽쎾쎿섁섂섃썍썎썏][스쓰]|[지야][0-9]*랄|니[애에]미|갈[0-9]*보[^가-힣]|[뻐뻑뻒뻙뻨][0-9]*[뀨큐킹낑]|꼬[0-9]*추|곧[0-9]*휴|[가-힣]슬아치|자[0-9]*박꼼|빨통|[사싸](?:이코|가지|[0-9]*까시)|육[0-9]*시[랄럴]|육[0-9]*실[알얼할헐]|즐[^가-힣]|찌[0-9]*(?:질이|랭이)|찐[0-9]*따|찐[0-9]*찌버거|창[녀놈]|[가-힣]{2,}충[^가-힣]|[가-힣]{2,}츙|부녀자|화냥년|환[양향]년|호[0-9]*[구모]|조[선센][징]|조센|[쪼쪽쪾](?:[발빨]이|[바빠]리)|盧|무현|찌끄[레래]기|하악{2,}|하[앍앜]|[낭당랑앙항남담람암함][ ]?[가-힣]+[띠찌]|느[금급]마|文在|在寅|(?<=[^\n])[家哥]|속냐|[tT]l[qQ]kf|Wls|[ㅂ]신|[ㅅ]발|[ㅈ]밥|한[0-9]*남|한[0-9]*녀|페[0-9]*미|일[0-9]*베|오[0-9]*줌)';
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
    WarningType.profanity: '욕설이 포함되어 있어요!',
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
}

class OverlayStrings {
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

class UpdateStrings {
  static const String content = '새로운\n업데이트가 있어요!';
  static const String update = '업데이트';
}

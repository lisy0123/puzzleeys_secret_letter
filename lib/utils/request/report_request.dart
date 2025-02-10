import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';

class ReportRequest {
  static Future<Map<String, dynamic>> fetch({
    required PuzzleType puzzleType,
    required String puzzleId,
    required String api,
  }) async {
    final url = {
      PuzzleType.global: '/api/$api/global_report/$puzzleId',
      PuzzleType.subject: '/api/$api/subject_report/$puzzleId',
      PuzzleType.personal: '/api/$api/personal_report/$puzzleId',
    }[puzzleType]!;
    return await apiRequest(url, ApiType.post);
  }
}

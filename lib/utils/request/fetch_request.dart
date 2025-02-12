import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';

class FetchRequest {
  static Future<Map<String, dynamic>> report({
    required PuzzleType puzzleType,
    required String puzzleId,
    required String router,
  }) async {
    final url = {
      PuzzleType.global: '/api/$router/global_report/$puzzleId',
      PuzzleType.subject: '/api/$router/subject_report/$puzzleId',
      PuzzleType.personal: '/api/$router/personal_report/$puzzleId',
    }[puzzleType]!;
    return await apiRequest(url, ApiType.post);
  }

  static Future<List<Map<String, dynamic>>?> dialogData(String url) async {
    try {
      final responseData = await apiRequest(url, ApiType.get);

      if (responseData['code'] == 200) {
        final List<dynamic> data = responseData['result'] as List<dynamic>;
        return List<Map<String, dynamic>>.from(data);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}

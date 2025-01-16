import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/secure_storage_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';

class UserRequest {
  static Future<(String, String)> reloadUserData() async {
    try {
      final responseData = await apiRequest('/api/auth/me', ApiType.get);

      if (responseData['code'] == 200) {
        final userData = responseData['result'];
        final createdAt = Utils.convertUTCToKST(userData['created_at']);
        await Future.wait([
          SecureStorageUtils.save('userId', userData['user_id']),
          SecureStorageUtils.save('createdAt', createdAt),
        ]);

        final results = await Future.wait([
          SecureStorageUtils.get('userId'),
          SecureStorageUtils.get('createdAt'),
        ]);
        final String userId = results[0]!;
        final String userCreatedAt = results[1]!;

        return (userId, userCreatedAt);
      } else {
        throw Exception('Error: ${responseData['message']}');
      }
    } catch (error) {
      throw 'Error reloading user data: $error';
    }
  }
}

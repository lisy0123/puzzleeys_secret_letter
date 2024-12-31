import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/secure_storage_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';

class UserRequest {
  static Future<(String, String)> reloadUserData() async {
    try {
      final userData = await apiRequest('/api/auth/me', ApiType.get);

      if (userData['code'] == 200) {
        await SecureStorageUtils.save('userId', userData['result']['user_id']);
        await SecureStorageUtils.save('createdAt',
            Utils.convertUTCToKST(userData['result']['created_at']));

        final String userId = (await SecureStorageUtils.get('userId'))!;
        final String userCreatedAt =
            (await SecureStorageUtils.get('createdAt'))!;

        return (userId, userCreatedAt);
      } else {
        throw Exception('Error: ${userData['message']}');
      }
    } catch (error) {
      throw Exception('Error loading user data: $error');
    }
  }
}

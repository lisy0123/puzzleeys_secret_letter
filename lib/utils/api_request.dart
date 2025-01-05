import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

enum ApiType { post, get, delete, patch, put }

Future<Map<String, dynamic>> apiRequest(
  String endPoint,
  ApiType method, {
  Map<String, String>? headers,
  Map<String, String>? bodies,
}) async {
  final token = Supabase.instance.client.auth.currentSession?.accessToken;
  if (token == null) {
    throw Exception('No authentication token found');
  }

  final uri = Uri.parse('${dotenv.env['PROJECT_URL']}/functions/v1$endPoint');
  final requestHeaders = {'Authorization': 'Bearer $token', ...?headers};
  final requestBody = bodies != null ? jsonEncode(bodies) : null;

  try {
    late http.Response response;

    switch (method) {
      case ApiType.post:
        response =
            await http.post(uri, headers: requestHeaders, body: requestBody);
        break;
      case ApiType.delete:
        response =
            await http.delete(uri, headers: requestHeaders, body: requestBody);
        break;
      case ApiType.get:
      default:
        response = await http.get(uri, headers: requestHeaders);
        break;
    }

    final responseData = jsonDecode(response.body);
    if (responseData['code'] == 200) {
      return responseData;
    } else {
      throw Exception('Error: ${responseData['message']}');
    }
  } catch (error) {
    throw Exception('Error during request: $error');
  }
}

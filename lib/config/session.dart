///
/// Session: 세션을 관리하는 파일
///

import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const String _storageKey = "sessionToken";
  static String? _token;

  Future<String> get() async {
    if (_token != null) {
      return _token!;
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString(_storageKey);

    if (_token == null) {
      throw Exception("No Session");
    }

    return _token!;
  }

  Future<bool> set(String token) async {
    final preferences = await SharedPreferences.getInstance();
    _token = token;
    return preferences.setString(_storageKey, token);
  }

  Future<bool> clear() async {
    final preferences = await SharedPreferences.getInstance();
    _token = null;
    return preferences.remove(_storageKey);
  }
}

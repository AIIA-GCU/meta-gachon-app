import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const String _storageKey = "sessionToken";
  static String? _token;

  Future<String> get() async {
    if (_token != null) {
      return _token!;
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? first = preferences.getBool('firstTime');
    _token = preferences.getString(_storageKey);

    if (first == null || first == true) {
      throw true;
    } else if (_token == null) {
      throw Exception("No Session");
    }

    debugPrint("token = $_token");
    return Future(() => _token!);
  }

  Future<bool> set(String token) async {
    final preferences = await SharedPreferences.getInstance();
    _token = token;
    return preferences.setString(_storageKey, token);
  }

  Future<bool> clear() async {
    debugPrint("Called Session.clear()");
    final preferences = await SharedPreferences.getInstance();
    _token = null;
    return preferences.remove(_storageKey);
  }
}

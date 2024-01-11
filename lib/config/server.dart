///
/// Session: 세션을 관리하는 파일
///


import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
//import 'package:package_info_plus/package_info_plus.dart';
//import 'package:shared_preferences/shared_preferences.dart';

enum HTTPMethod { GET, POST, PUT, DELETE }
const int SUCCESS_CODE = 200;
const int FAILURE_CODE = 400;

// 임시
int uid = 0;
User my_info = User('국희근', 202334418, 2, 0, 12, []);
List<Book> books = [];
List<Comfirm> comfirms = [];
List<Notifi> notifis = [];

class Session {
  static const String _storageKey = "sessionToken";
  static String? _token;

  Future<String> get() async {
    if (_token != null) {
      return _token!;
    }

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    //_token = preferences.getString(_storageKey);

    if (_token == null) {
      throw Exception("No Session");
    }

    return _token!;
  }

  Future<bool> set(String token) async {
    // final preferences = await SharedPreferences.getInstance();
    // _token = token;
    // return preferences.setString(_storageKey, token);
    return true;
  }

  Future<bool> clear() async {
    // final preferences = await SharedPreferences.getInstance();
    // _token = null;
    // return preferences.remove(_storageKey);
    return true;
  }
}

class APIRequest {
  static const String _BASE_URL = "http://210.102.178.161:22/"; // API URL로 수정(마지막 / 붙여야 함)
  static const String _SESSION_COOKIE_NAME = "JSESSIONID";

  static late String _appVersion;
  late String _path;
  late Map<String, String> _cookies;

  String get appVersion => _appVersion;
  String get path => _path;
  Map<String, String> get cookies => _cookies;

  set setPath(String val) => _path = val;
  set setCookies(Map<String, String> val) => _cookies = val;

  APIRequest(this._path) {
    // _getAppVersion();
  }

  // Future<void> _getAppVersion() async {
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   _appVersion = packageInfo.version;
  // }

  Future<Map<String, dynamic>> send(HTTPMethod method,
      {Map<String, dynamic>? params}) async {
    try {
      // final session = Session();

      final uri = Uri.parse(_BASE_URL + _path);
      http.Request request;

      switch (method) {
        case HTTPMethod.GET:
          request = http.Request('GET', uri);
          break;
        case HTTPMethod.POST:
          request = http.Request('POST', uri);
          break;
        case HTTPMethod.PUT:
          request = http.Request('PUT', uri);
          break;
        case HTTPMethod.DELETE:
          request = http.Request('DELETE', uri);
          break;
      }

      try {
        // final sessionToken = await session.get();
        // cookies[_SESSION_COOKIE_NAME] = sessionToken;
      } catch (_) {
        // Pass
      }

      final headers = {
        // 'User-Agent': 'MetaGachonClient/$appVersion',
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Cookie': _encodeCookie(),
      };

      request.headers.addAll(headers);

      if (params != null) {
        request.body = jsonEncode(params); // 파라미터가 있으면 JSON으로 인코딩하여 body에 추가
      }

      final response = await http.Client().send(request);
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);

        // // 쿠키 파싱, 토큰 설정
        // final Map<String, String> serverCookies =
        // _parseServerCookies(await http.Response.fromStream(response));
        // if (serverCookies.containsKey(_SESSION_COOKIE_NAME)) {
        //   final newToken = serverCookies[_SESSION_COOKIE_NAME]!;
        //   if (session.get() != newToken) {
        //     session.set(newToken);
        //   }
        // }

        return jsonResponse;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  String _encodeCookie() {
    List<String> cookieList = [];
    cookies.forEach((key, value) {
      cookieList.add('$key=$value');
    });
    return cookieList.join('; ');
  }

  Map<String, String> _parseServerCookies(http.Response response) {
    Map<String, String> serverCookies = {};
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      List<String> cookies = rawCookie.split(',');
      cookies.forEach((cookie) {
        List<String> values = cookie.split(';');
        String cookieValue = values[0];
        List<String> keyValue = cookieValue.split('=');
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        serverCookies[key] = value;
      });
    }
    return serverCookies;
  }
}

class User {
  static APIRequest _userAPI = APIRequest('/user');

  final String _name;
  final int _stu_num;
  int _rating;
  int _negative;
  int _positive;
  List<Notifi> _notifis;

  String get name => _name;
  int get stu_num => _stu_num;
  int get rating => _rating;
  int get negative => _negative;
  int get positive => _positive;
  List<Notifi> get notifis => _notifis;

  set setRating(int val) => _rating = val;
  set setNegative(int val) => _negative = val;
  set setPositive(int val) => _positive = val;
  set setNotifis(List<Notifi> val) => _notifis = val;

  User(this._name, this._stu_num, this._rating, this._negative, this._positive, this._notifis);

  factory User.fromJson(Map<String, dynamic> json) {
    var notifis = (json['notifi'] as List).map((e) {
      return Notifi(e['category'], e['message']);
    }).toList();
    return User(
        json['name'],
        json['stu_num'],
        json['rating'],
        json['negative'],
        json['positive'],
        notifis
    );
  }
  String toJson() {
    return jsonEncode({
      'name': _name,
      'stu_num': _stu_num,
      'rating': _rating,
      'negative': _negative,
      'positive': _positive,
      'notifi': _notifis.map((e) => e.toJson()).toList()
    });
  }
}

class Book {
  static APIRequest _bookAPI = APIRequest('/books');

  final String _reservationID;
  final String _name;
  final int _stu_num;
  final String _room;
  final DateTime _start;
  final int _duration;

  String get reservationID => _reservationID;
  String get name => _name;
  int get stu_num => _stu_num;
  String get room => _room;
  DateTime get start => _start;
  int get duration => _duration;

  Book(this._reservationID, this._name, this._stu_num, this._room, this._start, this._duration);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        json['reservationID'],
        json['name'],
        json['stu_num'],
        json['room'],
        json['start'],
        json['duration']
    );
  }
  String toJson() {
    return jsonEncode({
      ''
    });
  }
}

class Comfirm {
  final String _name;
  final int _stu_num;
  final String _room;
  final DateTime _start;
  final int _duration;
  final String _review;

  String get name => _name;
  int get stu_num => _stu_num;
  String get room => _room;
  DateTime get start => _start;
  int get duration => _duration;
  String get review => _review;

  Comfirm(this._name, this._stu_num, this._room, this._start, this._duration, this._review);

  factory Comfirm.fromJson(Map<String, dynamic> json) {
    return Comfirm(
        json['name'],
        json['stu_num'],
        json['room'],
        json['start'],
        json['duration'],
        json['review']
    );
  }
}

class Notifi {
  final String _category;
  final String _message;

  Notifi(this._category, this._message);

  String get category => _category;
  String get message => _message;

  factory Notifi.fromJson(Map<String, dynamic> json) {
    return Notifi(json['category'], json['message']);
  }
  String toJson() {
    return jsonEncode({
      'category': _category,
      'message': _message
    });
  }
}
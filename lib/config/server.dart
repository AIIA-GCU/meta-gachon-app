///
/// Session: 세션을 관리하는 파일
/// - Stateless: 로그인 후, 글쓰기 요청을 하면
///
/// Todo
/// @ room 종류: ["405-4", "405-5", "405-6"] 중 하나
/// @ date 형식: "yyyy-MM-dd HH:mm"
/// @ photoExtension: *.jpg, *.png
/// @ 쿠기 저장하기 (w현교)
/// @ 예약/인증 추가에 leader의 정보는 X
///   member의 정보는 "(학번) (이름) (학번) (이름) ..."
///

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HTTPMethod { GET, POST, PATCH, DELETE }

const int SUCCESS_CODE = 200;
const int FAILURE_CODE = 400;

// 임시
late User myInfo;
List<Notice> notifis = [];

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

class APIRequest {
  static const String _BASE_URL = "http://210.102.178.161:22/";
  static const String _SESSION_COOKIE_NAME = "JSESSIONID";

  // static late String _appVersion;
  late String _path;
  late Map<String, String> _cookies;

  // String get appVersion => _appVersion;

  String get path => _path;

  Map<String, String> get cookies => _cookies;

  // set setAppVersion(String val) => _appVersion = val;

  set setPath(String val) => _path = val;

  set setCookies(Map<String, String> val) => _cookies = val;

  APIRequest(this._path) {
    // _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    // final packageInfo = await PackageInfo.fromPlatform();
    // setAppVersion = packageInfo.version;
    // debugPrint(appVersion);
  }

  Future<dynamic> send(HTTPMethod method,
      {Map<String, dynamic>? params}) async {
    try {
      final session = Session();

      final uri = Uri.parse(_BASE_URL + _path);
      http.Request request;

      switch (method) {
        case HTTPMethod.GET:
          request = http.Request('GET', uri);
          break;
        case HTTPMethod.POST:
          request = http.Request('POST', uri);
          break;
        case HTTPMethod.PATCH:
          request = http.Request('PATCH', uri);
          break;
        case HTTPMethod.DELETE:
          request = http.Request('DELETE', uri);
          break;
      }

      try {
        final sessionToken = await session.get();
        setCookies = {_SESSION_COOKIE_NAME: sessionToken};
      } catch (_) {
        setCookies = {};
      }

      final info = await PackageInfo.fromPlatform();

      final headers = {
        'User-Agent': 'MetaGachonClient/${info.version}',
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': _encodeCookie(),
      };

      request.headers.addAll(headers);
      // request.headers['Content-Type'] = 'application/json';

      if (params != null) {
        request.body = jsonEncode(params); // 파라미터가 있으면 JSON으로 인코딩하여 body에 추가
      }

      final httpReturned = await http.Client().send(request);
      if (httpReturned.statusCode == 200) {
        final response = await http.Response.fromStream(httpReturned);
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        debugPrint("[api] returned: ${jsonResponse.toString()}");

        // 쿠키 파싱, 토큰 설정
        final Map<String, String> serverCookies = _parseServerCookies(response);
        if (serverCookies.containsKey(_SESSION_COOKIE_NAME)) {
          final newToken = serverCookies[_SESSION_COOKIE_NAME]!;
          if (session.get() != newToken) {
            session.set(newToken);
          }
        }

        return jsonResponse;
      } else {
        debugPrint('Status Code: ${httpReturned.statusCode}');
        throw Exception('\n[Error] related http response: ${httpReturned.statusCode}');
        // return null;
      }
    } catch (e) {
      throw Exception('[Error] api send: $e');
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

class RestAPI {
  RestAPI._();

  /// 로그인
  static Future<User?> login({
    required String id,
    required String pw
  }) async {
    try {
      final api = APIRequest('user');
      Map<String, dynamic> response = await api.send(
          HTTPMethod.POST,
          params: {"ID": id, "PW": pw}
      );
      final preference = await SharedPreferences.getInstance();
      if (preference.getBool('firstTime')! == true) {
        preference.setBool('firstTime', false);
        debugPrint("You logined at first!");
      }
      return User.fromJson(response);
    } catch(_) {
      return null;
    }
  }

  /// 내 모든 예약
  static Future<List<Reservate>?> getAllReservation() async {
    final api = APIRequest('books');
    List<dynamic> response = await api.send(HTTPMethod.GET);

    if (response.isEmpty) {
      return null;
    } else {
      final result = response.map((e) {
            final temp = e as Map<String, dynamic>;
            return Reservate.fromJson(temp);
          }).toList();
      return result;
    }
  }

  /// 예약 가능한 시간대
  static Future<Map<int, bool>?> getAvailableTime({
    required String room,
    required String date
  }) async {
    final api = APIRequest(
        'books/available?room=${room}&date=${date}');
    Map<String, dynamic> response = await api.send(HTTPMethod.GET);
    if (response.isEmpty) {
      return null;
    } else {
      Map<String, dynamic> result = response['disableTime'];
      return result.map((key, value) => MapEntry(int.parse(key), value));
    }
  }

  ///
  /// 예약 추가
  ///
  static Future<int?> addReservation({
    required String room,
    required String startTime,
    required String endTime,
    required String member
  }) async {
    final api = APIRequest('book');
    Map<String, dynamic> response = await api.send(
      HTTPMethod.POST,
      params: {
        'room': room,
        'startTime': startTime,
        'endTime': endTime,
        'member': member,
        // 'purpose': '공부'
      }
    );
    if (response.isEmpty) {
      return null;
    } else {
      return response['reservationID'];
    }
  }

  /// 
  /// 예약 수정
  /// [!] member에 빈 값을 넣으면 문제가 생기는 듯
  /// 
  static Future<int?> patchReservation({
    required int reservationId,
    required String room,
    required String startTime,
    required String endTime,
    required String leader,
    required String member
  }) async {
    final api = APIRequest('book');
    Map<String, dynamic> response = await api.send(
        HTTPMethod.PATCH,
        params: {
          "reservationId": reservationId,
          "room": room,
          "startTime": startTime,
          "endTime": endTime,
          "leaderInfo": leader,
          "memberInfo": 'string',
          "purpose": "String"
        }
    );
    if (response.isEmpty) {
      return null;
    } else {
      return response['reservationID'];
    }
  }

  /// 예약 삭제
  static Future<int?> delReservation({
    required int reservationId
  }) async {
    final api = APIRequest('book/$reservationId');
    Map<String, dynamic> response = await api.send(HTTPMethod.DELETE);
    if (response.isEmpty) {
      return null;
    } else {
      return response['reservationID'];
    }
  }

  /// 예약 연장
  static Future<int?> prolongReservation({
    required int reservationId
  }) async {
    final api = APIRequest('book/prolong/$reservationId');
    Map<String, dynamic> response = await api.send(HTTPMethod.PATCH);
    if (response.isEmpty) {
      return null;
    } else {
      return response['reservationId'];
    }
  }

  /// 모든 인증
  static Future<List<Admit>?> getAllAdmission() async {
    final api = APIRequest('admits');
    List<dynamic> response = await api.send(HTTPMethod.GET);

    if (response.isEmpty) {
      return null;
    } else {
      final result = response.map((e) {
        final temp = e as Map<String, dynamic>;
        return Admit.fromJson(temp);
      }).toList();
      return result;
    }
  }

  /// 내 인증
  static Future<List<Admit>?> getMyAdmission() async {
    final api = APIRequest('admits/me');
    List<dynamic> response = await api.send(HTTPMethod.GET);

    if (response.isEmpty) {
      return null;
    } else {
      final result = response.map((e) {
        final temp = e as Map<String, dynamic>;
        return Admit.fromJson(temp);
      }).toList();
      return result;
    }
  }

  /// 인증 추가
  static Future<int?> addAdmission({
    required String review,
    required String photo,
    required String photoExtension
  }) async {
    final api = APIRequest('admit');
    Map<String, dynamic> response = await api.send(
      HTTPMethod.POST,
      params: {
        'review': review,
        'photo': photo,
        'photoExtension': photoExtension
      }
    );
    if (response.isEmpty) {
      return null;
    } else {
      return response['admissionID'];
    }
  }

  /// 열람하지 않은 알림의 여부
  static Future<bool?> hasUnopendNotice() async {
    final api = APIRequest('notice');
    Map<String, dynamic> response = await api.send(HTTPMethod.GET);
    if (response.isEmpty) {
      return null;
    } else {
      return response['hasNotice'];
    }
  }

  /// 내 모든 알림
  static Future<List<Notice>?> getNotices() async {
    final api = APIRequest('notices');
    List<Map<String, dynamic>> response = await api.send(HTTPMethod.GET);
    if (response.isEmpty) {
      return null;
    } else {
      return response.map((e) => Notice.fromJson(e)).toList();
    }
  }
}

class User {
  final String _name;
  final int _stuNum;
  int _rating;
  int _negative;
  int _positive;

  String get name => _name;

  int get stuNum => _stuNum;

  int get rating => _rating;

  int get negative => _negative;

  int get positive => _positive;

  set setRating(int val) => _rating = val;

  set setNegative(int val) => _negative = val;

  set setPositive(int val) => _positive = val;

  User(this._name,
      this._stuNum,
      this._rating,
      this._negative,
      this._positive);

  ///
  /// EX) User 객체의 response
  /// - "name": "김가천"
  /// - "stuNum": 202300001
  /// - "rating": 2 (1 ~ 5)
  /// - "negative": 5
  /// - "positive": 10
  ///
  factory User.fromJson(Map<String, dynamic> json) => User(
        json['name'],
        json['stuNum'],
        json['rating'],
        json['negative'],
        json['positive']
    );
}

class Reservate {
  final int _reservationId;
  final String _leaderInfo;
  final String _room;
  final String _date;
  final String _time;
  // final String _member;

  int get reservationId => _reservationId;

  String get leaderInfo => _leaderInfo;

  String get room => _room;

  String get date => _date;

  String get time => _time;

  // String get member => _member;

  Reservate(
      this._reservationId,
      this._leaderInfo,
      this._room,
      this._date,
      this._time,
      // this._member
      );

  ///
  /// EX) Reservate 객체의 response
  /// - "reservationId": 55
  /// - "LeaderInfo": "202300001 김가천"
  /// - "room":" 404 - 5"
  /// - "date": "2023. 01. 01 목요일"
  /// - "time": "06:00 ~ 15:00"
  ///
  factory Reservate.fromJson(Map<String, dynamic> json) => Reservate(
        json['reservationId'],
        json['leaderInfo'],
        json['room'],
        json['date'],
        json['time'],
        // json['member']
    );
}

class Admit {
  final int _admisstionId;
  final String _leaderInfo;
  final String _room;
  final String _date;
  final String _time;
  // final List<String> _members;
  final String _review;
  final ByteData _photo;

  int get admissionId => _admisstionId;

  String get leaderInfo => _leaderInfo;

  String get room => _room;

  String get date => _date;

  String get time => _time;

  // List<String> get members => _members;

  String get review => _review;

  ByteData get photo => _photo;

  Admit(
      this._admisstionId,
      this._leaderInfo,
      this._room,
      this._date,
      this._time,
      // this._members,
      this._review,
      this._photo
      );

  ///
  /// EX) Admit 객체의 response
  /// - "admissionId": 66
  /// - "leaderInfo": "202300001 김가천"
  /// - "room": "405 - 5"
  /// - "date": "2023. 01. 01. 목요일"
  /// - "time": "06:00 ~ 15:00"
  /// - "review": "잘 썼습니다!"
  /// - "photo": "9 9JdiONJDJIOFofjdijf...." (base64 포멧)
  ///
  factory Admit.fromJson(Map<String, dynamic> json) => Admit(
      json['admissionId'],
      json['leaderInfo'],
      json['room'],
      json['date'],
      json['time'],
      // json['membersInfo'],
      json['review'],
      json['photo']
  );
}

class Notice {
  final int _noticeId;
  final String _category;
  final String _content;
  final String _time;

  int get noticeId => _noticeId;

  String get category => _category;

  String get content => _content;

  String get time => _time;

  Notice(this._noticeId, this._category, this._content, this._time);

  ///
  /// 2104u902
  /// "에약"
  /// "ㅏ머ㅗㄹㅇㅁ냐루ㅐㅁ\nㅇㄹ먀ㅜ럄"
  /// "01/20 10:40"
  ///
  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
      json['noticeId'],
      json['category'],
      json['content'],
      json['time']
  );
}
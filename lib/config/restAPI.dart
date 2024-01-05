///
/// REST API: 서버와 통신하기 위한 파일
///

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mata_gachon/config/session.dart';

enum HTTPMethod { GET, POST, PUT, DELETE }

class APIRequest {
  static const String BASE_URL = ""; // API URL로 수정(마지막 / 붙여야 함)
  static const String SESSION_COOKIE_NAME = "JSESSIONID";

  static late String appVersion;
  final String path;
  late Map<String, String> cookies;

  APIRequest(this.path) {
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  Future<Map<String, dynamic>> send(HTTPMethod method,
      {Map<String, dynamic>? params}) async {
    try {
      final session = Session();

      final uri = Uri.parse(BASE_URL + path);
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
        final sessionToken = await session.get();
        cookies[SESSION_COOKIE_NAME] = sessionToken;
      } catch (_) {
        // Pass
      }

      final headers = {
        'User-Agent': 'MetaGachonClient/$appVersion',
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': _encodeCookie(),
      };

      request.headers.addAll(headers);

      if (params != null) {
        request.body = json.encode(params); // 파라미터가 있으면 JSON으로 인코딩하여 body에 추가
      }

      final response = await http.Client().send(request);
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);

        // 쿠키 파싱, 토큰 설정
        final Map<String, String> serverCookies =
            _parseServerCookies(await http.Response.fromStream(response));
        if (serverCookies.containsKey(SESSION_COOKIE_NAME)) {
          final newToken = serverCookies[SESSION_COOKIE_NAME]!;
          if (session.get() != newToken) {
            session.set(newToken);
          }
        }

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

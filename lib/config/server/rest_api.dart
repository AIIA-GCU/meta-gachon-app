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

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'session.dart';

/// http method
enum HTTPMethod { get, post, patch, delete }

class APIRequest {
  static const String _baseUrl = "https://meta.aiia-gcu.com/";
  static const String _sessionCookieName = "JSESSIONID";

  late String _path;
  late Map<String, String> _cookies;

  APIRequest(this._path);

  String get path => _path;

  Map<String, String> get cookies => _cookies;

  set setPath(String val) => _path = val;

  set setCookies(Map<String, String> val) => _cookies = val;

  Future<dynamic> send(HTTPMethod method, {Map<String, dynamic>? params}) async {
    try {
      final session = Session();

      final uri = Uri.parse(_baseUrl + _path);
      http.Request request;

      switch (method) {
        case HTTPMethod.get:
          request = http.Request('GET', uri);
          break;
        case HTTPMethod.post:
          request = http.Request('POST', uri);
          break;
        case HTTPMethod.patch:
          request = http.Request('PATCH', uri);
          break;
        case HTTPMethod.delete:
          request = http.Request('DELETE', uri);
          break;
      }

      try {
        final sessionToken = await session.get();
        setCookies = {_sessionCookieName: sessionToken};
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

      if (params != null) request.body = jsonEncode(params);

      final httpReturned = await http.Client()
          .send(request).timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(httpReturned);

      if (httpReturned.statusCode != 500) {
        dynamic jsonResponse = response.bodyBytes.isNotEmpty
            ? json.decode(utf8.decode(response.bodyBytes))
            : null;
        jsonResponse = {"body": jsonResponse};

        if (httpReturned.statusCode == 200) {
          jsonResponse['status'] = 200;
          debugPrint("[api] success receiving data (200)");

          // 쿠키 파싱, 토큰 설정
          final Map<String, String> serverCookies = _parseServerCookies(response);
          if (serverCookies.containsKey(_sessionCookieName)) {
            final newToken = serverCookies[_sessionCookieName]!;
            if (session.get() != newToken) {
              session.set(newToken);
            }
          }
        } else {
          jsonResponse['status'] = 400;
          debugPrint("[api] client error (400)");
        }

        debugPrint("[api] returned: ${jsonResponse.toString()}");
        return jsonResponse;
      } else {
        debugPrint('[api] server error (500)');
        return {'status': 500};
      }
    } on TimeoutException {
      throw TimeoutException('[Error] api send: timeout');
    } catch (e) {
      throw '\n[Error] api send:$e';
    }
  }

  String _encodeCookie() {
    List<String> cookieList = [];
    cookies.forEach((key, value) => cookieList.add('$key=$value'));
    return cookieList.join('; ');
  }

  Map<String, String> _parseServerCookies(http.Response response) {
    Map<String, String> serverCookies = {};
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      List<String> cookies = rawCookie.split(',');
      for (var cookie in cookies) {
        List<String> values = cookie.split(';');
        String cookieValue = values[0];
        List<String> keyValue = cookieValue.split('=');
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        serverCookies[key] = value;
      }
    }
    return serverCookies;
  }
}
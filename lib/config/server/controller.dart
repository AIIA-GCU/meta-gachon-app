///
/// controller.dart
/// 2024.03.07
/// by. @protaku
///
/// ALL HTTP API functions of this service
///
/// Change
/// - Added Comments
///
/// Content
/// [*] Class
///   - [RestAPI]
///

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/enum.dart';
import '../app/interface.dart';
import 'objects.dart';
import 'rest_api.dart';

class RestAPI {
  RestAPI._();

  /// 로그인
  /// Todo: 추후 통합 로그인용으로 바꿔야 함
  static Future<User?> signIn({
    required String id,
    required String pw,
    required String token,
  }) async {
    try {
      final api = APIRequest('user');
      Map<String, dynamic> response = await api.send(
          HTTPMethod.post,
          params: {"ID": id, "PW": pw, "fcmToken": token}
      );
      final preference = await SharedPreferences.getInstance();
      if (preference.getBool('firstTime')! == true) {
        preference.setBool('firstTime', false);
        debugPrint("You logined at first!");
      }
      return User.fromJson(response);
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    } catch(_) {
      return null;
    }
  }

  /// 현재 이용이 끝나지 않은 예약들
  static Future<List<Reserve>?> getRemainReservation() async {
    try {
      final api = APIRequest('books/remain');
      List<dynamic> response = await api.send(HTTPMethod.get);
      if (response.isEmpty) {
        return null;
      } else {
        List<Reserve> result = response.map((e) {
          final temp = e as Map<String, dynamic>;
          return Reserve.fromJson(temp);
        }).toList();
        result.sort((a, b) => a.startTime.compareTo(b.startTime));
        return result;
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 이용이 끝났지만, 인증되지 않은 예약들
  static Future<List<Reserve>?> getPriorAdmittedReservation() async {
    try {
      final api = APIRequest('books');
      List<dynamic> response = await api.send(HTTPMethod.get);
      if (response.isEmpty) {
        return null;
      } else {
        List<Reserve> result = response.map((e) {
          final temp = e as Map<String, dynamic>;
          return Reserve.fromJson(temp);
        }).toList();
        result.sort((a, b) => a.startTime.compareTo(b.startTime));
        return result;
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 예약 추가
  static Future<Map<String, dynamic>?> addReservation({
    required ServiceType service,
    required String? place,
    required String startTime,
    required String endTime,
    required String? professor,
    required String member,
    required String purpose
  }) async {
    try {
      late String path;
      late Map<String, dynamic> params;
      switch (service) {
        case ServiceType.aiSpace:
          path = "book/meta";
          params = {
            'room': place,
            'startTime': startTime,
            'endTime': endTime,
            'member': member,
            'purpose': purpose
          };
          break;
        case ServiceType.computer:
          path = "book/gpu";
          params = {
            'room': place,
            'startTime': startTime,
            'endTime': endTime,
            'professor': professor,
            'member': member,
            'purpose': purpose
          };
          break;
        case ServiceType.lectureRoom:
          path = 'book/lecture';
          params = {
            'startTime': startTime,
            'endTime': endTime,
            'member': member,
            'purpose': purpose,
          };
          break;
        default:
          break;
      }
      final api = APIRequest(path);
      Map<String, dynamic> response = await api
          .send(HTTPMethod.post, params: params);
      return response;
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 예약 수정
  /// Todo: member에 빈 값을 넣으면 문제가 생기는 듯
  static Future<Map<String, dynamic>?> patchReservation({
    required int reservationId,
    required ServiceType service,
    required String? place,
    required String startTime,
    required String endTime,
    required String leader,
    required String member,
    required String purpose,
    required String? professor
  }) async {
    try {
      late String path;
      late Map<String, dynamic> params;
      switch (service) {
        case ServiceType.aiSpace:
          path = "book/meta";
          params = {
            'reservationId': reservationId,
            'room': place,
            'startTime': startTime,
            'endTime': endTime,
            'member': member,
            'purpose': purpose
          };
          break;
        case ServiceType.lectureRoom:
          path = 'book/lecture';
          params = {
            'reservationId': reservationId,
            'startTime': startTime,
            'endTime': endTime,
            'member': member,
            'purpose': purpose,
          };
          break;
        default:
          break;
      }
      final api = APIRequest(path);
      Map<String, dynamic> response = await api
          .send(HTTPMethod.post, params: params);
      return response;
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 예약 삭제
  static Future<int?> delReservation({
    required int reservationId
  }) async {
    try {
      final api = APIRequest('book/$reservationId');
      Map<String, dynamic> response = await api.send(HTTPMethod.delete);
      return response['reservationID'];
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 예약 연장
  static Future<int?> prolongReservation({
    required int reservationId
  }) async {
    try {
      final api = APIRequest('book/prolong/$reservationId');
      Map<String, dynamic> response = await api.send(HTTPMethod.patch);
      return response['reservationId'];
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 현재 예약의 상태
  /// . 0: 사용 전 (예약 변경 X, QR X)
  /// . 1: 사용 전 (예약 변경 X, QR O)
  /// . 2: 사용 전 (예약 변경 O)
  /// . 3: 사용 중 (연장 X)
  /// . 4: 사용 중 (연장 O)
  /// . 5: 사용 끝 (인증 X)
  /// . 6: 사용 끝 (인증 O)
  static Future<int?> currentReservationStatus({
    required int reservationId
  }) async {
    try {
      final api = APIRequest('book/$reservationId');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);
      return response['status'];
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 예약 가능한 시간대
  static Future<Map<int, bool>?> getAvailableTime({
    required String room,
    required String date
  }) async {
    try {
      final api = APIRequest('books/available?room=${room}&date=${date}');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);
      if (response.isEmpty) {
        return null;
      } else {
        Map<String, dynamic> result = response['disableTime'];
        return result.map((key, value) => MapEntry(int.parse(key), value));
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 서비스에 따른 예약 장소 반환
  static Future<List<String>?> placeForService(ServiceType service) async {
    try {
      late int type;
      switch (service) {
        case ServiceType.aiSpace:
          type = 1;
          break;
        case ServiceType.lectureRoom:
          type = 2;
          break;
        case ServiceType.computer:
          type = 3;
          break;
      }
      final api = APIRequest('book/items/$type');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);
      if (response.isEmpty) {
        return null;
      } else {
        List<dynamic> temp = response['availableRoom'];
        return temp.map((e) => e as String).toList();
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// QR 인증
  static Future<bool> qrCheck(String uri) async {
    try {
      final api = APIRequest('book/qrcheck');
      Map<String, dynamic> response = await api.send(HTTPMethod.post);
      if (response.isEmpty) return false;
      return true;
    } catch(e) {
      throw Exception(e);
    }
  }

  /// 모든 인증
  static Future<List<Admit>?> getAllAdmission() async {
    try {
      final api = APIRequest('admits');
      List<dynamic> response = await api.send(HTTPMethod.get);

      if (response.isEmpty) {
        return null;
      } else {
        List<Admit> result = response.map((e) {
          final temp = e as Map<String, dynamic>;
          return Admit.fromJson(temp);
        }).toList();
        result.sort((a, b) {
          late int temp;
          if ((temp = a.date.compareTo(b.date)) == 0) {
            return a.time.compareTo(b.time);
          } else return temp;
        });
        return result;
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 내 인증
  static Future<List<Admit>?> getMyAdmission() async {
    try {
      final api = APIRequest('admits/me');
      List<dynamic> response = await api.send(HTTPMethod.get);

      if (response.isEmpty) {
        return null;
      } else {
        List<Admit> result = response.map((e) {
          final temp = e as Map<String, dynamic>;
          return Admit.fromJson(temp);
        }).toList();
        result.sort((a, b) {
          late int temp;
          if ((temp = a.date.compareTo(b.date)) == 0) {
            return a.time.compareTo(b.time);
          } else return temp;
        });
        return result;
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 인증 추가
  /// Note. 인증은 반드시 끝나는 시간이 지나고 해야 오류가 없음
  static Future<int?> addAdmission({
    required int reservationId,
    required String review,
    required String photo,
    required String photoExtension
  }) async {
    try {
      final api = APIRequest('admit');
      Map<String, dynamic> response = await api.send(HTTPMethod.post, params: {
        'reservationId': reservationId,
        'review': review,
        'photo': photo,
        'photoExtension': photoExtension
      });
      return response['admissionID'];
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 열람하지 않은 알림의 여부
  static Future<bool?> hasUnopendNotice() async {
    try {
      final api = APIRequest('notice');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);
      return response['hasNotice'];
    } on TimeoutException {
      return null;
    }
  }

  /// 내 모든 알림
  static Future<List<Notice>?> getNotices() async {
    try {
      final api = APIRequest('notices');
      List<dynamic> response = await api.send(HTTPMethod.get);
      if (response.isEmpty) {
        return null;
      } else {
        return response
            .map((e) => Notice.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

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
      switch (response['status']) {
        case 200:
          final preference = await SharedPreferences.getInstance();
          if (preference.getBool('firstTime')! == true) {
            preference.setBool('firstTime', false);
            debugPrint("You logined at first!");
          }
          return User.fromJson(response['body']);
        case 400:
          return null;
        default:
          throw Exception("[Error] 알 수 없는 이유로 로그인 할 수 없습니다!");
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    } catch(e) {
      throw Exception(e);
    }
  }

  /// 현재 이용이 끝나지 않은 예약들
  static Future<List<Reserve>?> getRemainReservation() async {
    try {
      final api = APIRequest('books/remain');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);
      if (response['status'] != 200) {
        return null;
      } else {
        final result = response['body'].map((e) {
          final temp = e as Map<String, dynamic>;
          return Reserve.fromJson(temp);
        }).toList();
        final cvtResult = List<Reserve>.from(result);
        cvtResult.sort((a, b) => a.startTime.compareTo(b.startTime));
        return cvtResult;
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 이용이 끝났지만, 인증되지 않은 예약들
  static Future<List<Reserve>?> getPreAdmittedReservation() async {
    try {
      final api = APIRequest('books');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);
      if (response['status'] != 200) {
        return null;
      } else {
        final result = response['body'].map((e) {
          final temp = e as Map<String, dynamic>;
          return Reserve.fromJson(temp);
        }).toList();
        final cvtResult = List<Reserve>.from(result);
        cvtResult.sort((a, b) => a.startTime.compareTo(b.startTime));
        return cvtResult;
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
    required String memberInfo,
    required String purpose,
    required bool? instant
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
            'memberInfo': memberInfo,
            'purpose': purpose,
            'instant': instant
          };
          break;
        case ServiceType.computer:
          path = "book/gpu";
          params = {
            'room': place,
            'startTime': startTime,
            'endTime': endTime,
            'professor': professor,
            'memberInfo': memberInfo,
            'purpose': purpose
          };
          break;
        case ServiceType.lectureRoom:
          path = 'book/lecture';
          params = {
            'startTime': startTime,
            'endTime': endTime,
            'memberInfo': memberInfo,
            'purpose': purpose,
          };
          break;
        default:
          break;
      }
      final api = APIRequest(path);
      Map<String, dynamic> response = await api
          .send(HTTPMethod.post, params: params);
      if (response['status'] == 200) return response['body'];
      return null;
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 예약 수정
  static Future<Map<String, dynamic>?> patchReservation({
    required int reservationId,
    required ServiceType service,
    required String? place,
    required String startTime,
    required String endTime,
    required String leader,
    required String memberInfo,
    required String purpose,
    required String? professor,
    required bool? instant
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
            'memberInfo': memberInfo,
            'purpose': purpose,
            'instant': instant
          };
          break;
        case ServiceType.lectureRoom:
          path = 'book/lecture';
          params = {
            'reservationId': reservationId,
            'startTime': startTime,
            'endTime': endTime,
            'memberInfo': memberInfo,
            'purpose': purpose,
          };
          break;
        default:
          break;
      }
      final api = APIRequest(path);
      Map<String, dynamic> response = await api
          .send(HTTPMethod.patch, params: params);
      if (response['status'] == 200) return response['body'];
      return null;
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 예약 삭제
  static Future<int> delReservation({
    required int reservationId
  }) async {
    try {
      final api = APIRequest('book/$reservationId');
      Map<String, dynamic> response = await api.send(HTTPMethod.delete);
      return response['status'];
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 예약 연장
  static Future<int> prolongReservation({
    required int reservationId
  }) async {
    try {
      final api = APIRequest('book/prolong/$reservationId');
      Map<String, dynamic> response = await api.send(HTTPMethod.patch);
      return response['status'];
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
      if (response['status'] == 200) return response['body']['status'];
      return null;
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
      if (response['status'] != 200) {
        return null;
      } else {
        Map<String, dynamic> result = response['body']['disableTime'];
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
      if (response['status'] != 200) {
        return null;
      } else {
        List<dynamic> temp = response['body']['availableRoom'];
        return temp.map((e) => e as String).toList();
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// QR 인증
  static Future<bool> qrCheck(String? qrStr, int reservationId) async {
    try {
      final api = APIRequest('book/qrcheck?QR=$qrStr&reservationId=$reservationId');
      Map<String, dynamic> response = await api.send(HTTPMethod.post);
      return response['status'] == 200;
    } catch(e) {
      throw Exception(e);
    }
  }

  /// 모든 인증
  static Future<List<Admit>?> getAllAdmission() async {
    try {
      final api = APIRequest('admits');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);

      if (response['status'] != 200) {
        return null;
      } else {
        final result = response['body'].map((e) {
          final temp = e as Map<String, dynamic>;
          return Admit.fromJson(temp);
        }).toList();
        final cvtResult = List<Admit>.from(result);
        cvtResult.sort((a, b) {
          late int temp;
          if ((temp = a.date.compareTo(b.date)) == 0) {
            return a.time.compareTo(b.time);
          } else {
            return temp;
          }
        });
        return cvtResult;
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 내 인증
  static Future<List<Admit>?> getMyAdmission() async {
    try {
      final api = APIRequest('admits/me');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);

      if (response['status'] != 200) {
        return null;
      } else {
        final result = response['body'].map((e) {
          final temp = e as Map<String, dynamic>;
          return Admit.fromJson(temp);
        }).toList();
        final cvtResult = List<Admit>.from(result);
        cvtResult.sort((a, b) {
          late int temp;
          if ((temp = a.date.compareTo(b.date)) == 0) {
            return a.time.compareTo(b.time);
          } else {
            return temp;
          }
        });
        return cvtResult;
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
      if (response['status'] == 200) return response['body']['admissionID'];
      return null;
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    }
  }

  /// 열람하지 않은 알림의 여부
  static Future<bool?> hasUnopenedNotice() async {
    try {
      final api = APIRequest('notice');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);
      if (response['status'] == 200) return response['body']['hasNotice'];
      return null;
    } on TimeoutException {
      return null;
    }
  }

  /// 내 모든 알림
  static Future<List<Notice>?> getNotices() async {
    try {
      final api = APIRequest('notices');
      Map<String, dynamic> response = await api.send(HTTPMethod.get);
      if (response['status'] != 200) {
        return null;
      } else {
        return List<Notice>.from(response['body']
            .map((e) => Notice.fromJson(e as Map<String, dynamic>))
            .toList()
        );
      }
    } on TimeoutException {
      throw TimeoutException('transmission rate is too slow!');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

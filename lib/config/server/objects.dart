///
/// objects.dart
/// 2024.03.07
/// by. @protaku
///
/// Resources of our service
/// They are also used as dto to transmit with server
///
/// Change
/// - Added comments
///
/// Content
/// [*] Class
///   - User
///   - Reserve
///   - Admit
///   - Notice
///

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/enum.dart';
import '../app/interface.dart';
import '../app/load_assets.dart';

///
/// User
///
/// Client's human info
///
/// Parameters
/// - ratingName(String): User's rating name
/// - ratingImg(String): Path of image matched with rating
/// - name(String): User's name
/// - stuNum(int): User's student number
/// - negative(int): Count of admissions evaluated negatively
/// - positive(int): Count of admissions evaluated positively
///
class User {
  late final String _ratingName;
  late final AssetImage _ratingImg;
  final String _name;
  // final String _major;
  final int _stuNum;
  final int _rating;
  final int _negative;
  final int _positive;

  User(this._name,
      // this._depart,
      this._stuNum,
      this._rating,
      this._negative,
      this._positive) {
    // Following rating, determine variables of this object
    switch (_rating) {
      case 1:
        _ratingImg = const AssetImage(ImgPath.grayLv);
        _ratingName = "GRAY";
        break;
      case 2:
        _ratingImg = const AssetImage(ImgPath.stoneLv);
        _ratingName = "STONE";
        break;
      case 4:
        _ratingImg = const AssetImage(ImgPath.skyLv);
        _ratingName = "SKY";
        break;
      case 5:
        _ratingImg = const AssetImage(ImgPath.aquaLv);
        _ratingName = "AQUA";
        break;
      case 3:
      default:
        _ratingImg = const AssetImage(ImgPath.cobaltLv);
        _ratingName = "COBALT";
        break;
    }
  }

  // getters
  String get ratingName => _ratingName;
  AssetImage get ratingImg => _ratingImg;
  String get name => _name;
  // String get major => _major;
  int get stuNum => _stuNum;
  int get rating => _rating;
  int get negative => _negative;
  int get positive => _positive;

  ///
  /// factory User.fromJson
  ///
  /// Get [User] instance from decoded json
  ///
  /// Parameter:
  /// - json(Map<String, dynamic>):
  ///   data decoded json
  ///
  /// Return:
  /// - [User] instance
  ///
  factory User.fromJson(Map<String, dynamic> json) => User(
      json['name'],         // "김가천"
      // json['major'],     // "소프트웨어학과(소프트웨어전공)"
      json['stuNum'],       // 202300001
      json['rating'],       // 2 (1 ~ 5)
      json['negative'],     // 5
      json['positive']      // 20
  );

  ///
  /// bool match
  ///
  /// When tapping reservation item, check if it's leader match client's info
  ///
  /// Parameters:
  /// - userInfo(String): client's info
  ///
  /// Return:
  /// - bool data
  ///
  bool match(String userInfo) {
    return '$_stuNum $_name' == userInfo;
  }
}

///
/// Reserve
///
/// Reservation object
///
/// Parameters
/// - uid(int): item's unique id
/// - leaderInfo(String): leader's info (Ex. 202300001 김가천)
/// - 
///
class Reserve {
  final int _uid;
  final String _leaderInfo;
  final String? _place;
  final DateTime _startTime;
  final DateTime _endTime;
  final String _memberInfo;
  final String? _professor;

  Reserve(
      this._uid,
      this._leaderInfo,
      this._place,
      this._startTime,
      this._endTime,
      this._memberInfo,
      this._professor
      ) {
    assert(
      !(service == ServiceType.computer && _professor == null),
      'Professor must enter in reservation of GPU computer'
    );
  }

  int get reservationId => _uid;

  String get leaderInfo => _leaderInfo;

  String? get place => _place;

  DateTime get startTime => _startTime;

  DateTime get endTime => _endTime;

  String get memberInfo => _memberInfo;

  String? get professor => _professor;

  String startToDate1() => dateFormat1.format(_startTime);

  String startToDate2() => dateFormat2.format(_startTime);

  String endToDate1() => dateFormat1.format(_endTime);

  String endToDate2() => dateFormat2.format(_endTime);

  String toDuration() {
    if (service == ServiceType.computer) {
      var s = dateFormat2.format(_startTime);
      var e = dateFormat2.format(_endTime);
      return '$s ~ $e';
    } else {
      var s = timeFormat.format(_startTime);
      var e = timeFormat.format(_endTime);
      return '$s ~ $e';
    }
  }

  ///
  /// EX) Reservate 객체의 response
  /// - "reservationId": 55
  /// - "LeaderInfo": "202300001 김가천"
  /// - "room":" 404 - 5"
  /// - "date": "2023. 01. 01 목요일"
  /// - "time": "06:00 ~ 15:00"
  ///
  factory Reserve.fromJson(Map<String, dynamic> json) {
    String date = (json['date'] as String).split(' ')[0];
    List<String> time = (json['time'] as String).split(' ~ ');
    return Reserve(
        json['reservationId'],
        json['leaderInfo'],
        json['room'],
        stdFormat2.parse('$date ${time[0]}'),
        stdFormat2.parse('$date ${time[1]}'),
        json['memberInfo'] ?? '',
        json['professor'] ?? ''
    );
  }
}

class Admit {
  final int _admisstionId;
  final String _leaderInfo;
  final String _room;
  final String _date;
  final String _time;
  final String _memberInfo;
  final String _review;
  final Uint8List _photo;

  Admit(
      this._admisstionId,
      this._leaderInfo,
      this._room,
      this._date,
      this._time,
      this._memberInfo,
      this._review,
      this._photo
      );

  int get admissionId => _admisstionId;

  String get leaderInfo => _leaderInfo;

  String get place => _room;

  String get date => _date;

  String get time => _time;

  String get memberInfo => _memberInfo;

  String get review => _review;

  Uint8List get photo => _photo;

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
  factory Admit.fromJson(Map<String, dynamic> json) {
    return Admit(
      json['admissionID'],
      json['leaderInfo'],
      json['room'],
      json['date'],
      json['time'],
      json['memberInfo'] ?? '',
      json['review'],
      base64Decode(json['photo'])
    );
  }
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
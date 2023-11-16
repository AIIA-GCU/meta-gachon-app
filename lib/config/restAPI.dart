///
/// REST API: 서버와 통신하기 위한 파일
///

import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class Credential {
  final String id;
  final String pw;

  Credential(this.id, this.pw);

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(json['ID'], json['PW']);
  }
}

class User {
  final String name;
  final int stu_num;
  final int rating;
  final int negative;
  final int positive;
  final List<Notifi> notifis;

  User(this.name, this.stu_num, this.rating, this.negative, this.positive, this.notifis);

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
}

class Book {
  final Long reservationID;
  final String name;
  final int stu_num;
  final String room;
  final DateTime start;
  final int duraion;

  Book(this.reservationID, this.name, this.stu_num, this.room, this.start, this.duraion);

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
}

class Comfirm {
  final String name;
  final int stu_num;
  final String room;
  final DateTime start;
  final int duration;
  final String review;

  Comfirm(this.name, this.stu_num, this.room, this.start, this.duration, this.review);

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
  final String category;
  final String message;

  Notifi(this.category, this.message);
  
  factory Notifi.fromJson(Map<String, dynamic> json) {
    return Notifi(json['category'], json['message']);
  }
}

const BASE_URL = "";

Future<http.Response> login(Credential credential) {
  return http.post(
    Uri.parse(BASE_URL+""),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'ID': credential.id,
      'PW': credential.pw
    })
  );
}
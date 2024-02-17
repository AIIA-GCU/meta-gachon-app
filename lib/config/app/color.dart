
import 'dart:ui';

import 'enum.dart';
import 'interface.dart';

class MGColor {
  MGColor._();

  static const Color _brand1Primary = Color(0xFF1762DB);
  static const Color _brand1Secondary = Color(0xFF4985E6);
  static const Color _brand1Tertiary = Color(0xFFE3EDFD);

  static const Color _brand2Primary = Color(0xFF5C30D9);
  static const Color _brand2Secondary = Color(0xFF7C59E0);
  static const Color _brand2Tertiary = Color(0xFFE7E0F9);

  static const Color _brand3Primary = Color(0xFF0097C6);
  static const Color _brand3Secondary = Color(0xFF33ACD2);
  static const Color _brand3Tertiary = Color(0xFFD9F0F7);

  static const Color systemError = Color(0xFFE03616);
  static const Color systemOk = Color(0xFF00AF54);
  static const Color barrier = Color(0x40000000);
  static const Color school = Color(0xFF0D4D91);

  static const Color base1 = Color(0xFF000000);
  static const Color base2 = Color(0xFF333232);
  static const Color base3 = Color(0xFF7C7C7C);
  static const Color base4 = Color(0xFFABABAB);
  static const Color base5 = Color(0xFFC9C9C9);
  static const Color base6 = Color(0xFFDDDDDD);
  static const Color base7 = Color(0xFFEDEEF1);
  static const Color base8 = Color(0xFFE7E7E7);
  static const Color base9 = Color(0xFFF4F5F8);
  static const Color base10 = Color(0xFFEDEEF1);

  static Color get brand1Primary => _brand1Primary;
  static Color get brand1Secondary => _brand1Secondary;
  static Color get brand1Tertiary => _brand1Tertiary;

  static Color primaryColor() {
    switch (service) {
      case ServiceType.aiSpace:
        return _brand1Primary;
      case ServiceType.lectureRoom:
        return _brand2Primary;
      case ServiceType.computer:
        return _brand3Primary;
    }
  }

  static Color secondaryColor() {
    switch (service) {
      case ServiceType.aiSpace:
        return _brand1Secondary;
      case ServiceType.lectureRoom:
        return _brand2Secondary;
      case ServiceType.computer:
        return _brand3Secondary;
    }
  }

  static Color tertiaryColor() {
    switch (service) {
      case ServiceType.aiSpace:
        return _brand1Tertiary;
      case ServiceType.lectureRoom:
        return _brand2Tertiary;
      case ServiceType.computer:
        return _brand3Tertiary;
    }
  }
}
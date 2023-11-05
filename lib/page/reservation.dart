///추호성이꺼

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';

class Reservation extends StatelessWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Icon(AppinIcon.back, size: 24),
            ),
            SizedBox(width: 10),
            Text("강의실 예약하기",style: TextStyle(color: Colors.black,fontSize: 18))
          ],
        ),
      ),
      body: Center(
        child: Column(//여기
          children: [
            Container(
              height: 52,
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 0,    // 위쪽 마진
                bottom: 12, // 아래쪽 마진
                left: 16,    // 왼쪽 마진
                right: 16,  // 오른쪽 마진
              ),
              padding: EdgeInsets.only(
                top: 10,    // 위쪽
                bottom: 10, // 아래쪽
                left: 16,    // 왼쪽
                right: 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 5,
                      child: Text("강의실", style: KR.parag1,)
                  ),
                  Positioned(
                    left: 64,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 5,    // 위쪽
                        bottom: 0, // 아래쪽
                        left: 37,    // 왼쪽
                        right: 37,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MGcolor.brand_orig, // 테두리 색상
                          width: 1.0,          // 테두리 두께
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: 120,
                      height: 32,
                      child: Text("404 - 1", style: KR.parag2,),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 198,
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 0,    // 위쪽 마진
                bottom: 12, // 아래쪽 마진
                left: 16,    // 왼쪽 마진
                right: 16,  // 오른쪽 마진
              ),
              padding: EdgeInsets.only(
                top: 10,    // 위쪽
                bottom: 10, // 아래쪽
                left: 16,    // 왼쪽
                right: 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 56,
                    child: Container(
                      height: 116,

                    ),
                  ),
                  ///달력 드가자
                  Positioned(
                    child: Container(),
                    /*child: Container(
                      width: 297,
                      height: 15,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Text(
                              'M',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7C7C7C),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 49,
                            top: 0,
                            child: Text(
                              'T',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7C7C7C),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 95,
                            top: 0,
                            child: Text(
                              'W',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7C7C7C),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 145,
                            top: 0,
                            child: Text(
                              'T',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7C7C7C),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 193,
                            top: 0,
                            child: Text(
                              'F',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7C7C7C),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 241,
                            top: 0,
                            child: Text(
                              'S',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7C7C7C),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 289,
                            top: 0,
                            child: Text(
                              'S',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7C7C7C),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ),
                  Positioned(
                    left: 0,
                    top: 5,
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'October',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '~',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'November',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 73,
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 0,    // 위쪽 마진
                bottom: 12, // 아래쪽 마진
                left: 16,    // 왼쪽 마진
                right: 16,  // 오른쪽 마진
              ),
              padding: EdgeInsets.only(
                top: 10,    // 위쪽
                bottom: 10, // 아래쪽
                left: 16,    // 왼쪽
                right: 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 5,
                    child: Text("예약 시간", style: KR.parag1,)
                  ),
                  Positioned(
                    left: 64,
                    top: 0,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,    // 위쪽
                            bottom: 0, // 아래쪽
                            left: 37,    // 왼쪽
                            right: 37,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MGcolor.brand_orig, // 테두리 색상
                              width: 1.0,          // 테두리 두께
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: 120,
                          height: 32,
                          child: Text("00 : 00", style: KR.parag2,),
                        ),
                        Container(
                          width: 22,
                          child: Center(child: Text("~"))
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,    // 위쪽
                            bottom: 0, // 아래쪽
                            left: 37,    // 왼쪽
                            right: 37,
                            ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MGcolor.brand_orig, // 테두리 색상
                              width: 1.0,          // 테두리 두께
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: 120,
                          height: 32,
                          child: Text("00 : 00", style: KR.parag2,),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 64,
                    top: 35,
                    child: Text('예약은 최대 3시간 까지 가능합니다!',
                      style: TextStyle(
                        color: Color(0xFF1662DA),
                        fontSize: 12,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      )
                    )
                  )
                ]
              ),
            ),
            Container(
              height: 52,
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 0,    // 위쪽 마진
                bottom: 12, // 아래쪽 마진
                left: 16,    // 왼쪽 마진
                right: 16,  // 오른쪽 마진
              ),
              padding: EdgeInsets.only(
                top: 10,    // 위쪽
                bottom: 10, // 아래쪽
                left: 16,    // 왼쪽
                right: 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 5,
                    child: Text(
                      '대표자',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w500,
                        height: 0,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 64,
                    top: 5,
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '20230001',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: -0.32,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '김가천',
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 14,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: -0.32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// 인증 홈 페이지
/// - 홈 프레임
/// - 페이지 이동 버튼
/// - 카드
///

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/page/services/check_my_certification.dart';
import 'package:mata_gachon/page/services/reservation.dart';

class CertificationPage extends StatelessWidget {
  const CertificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ShaderMask(
        shaderCallback: hazyBottom,
        blendMode: BlendMode.dstOut,
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: flexibleSize(context, Size.fromWidth(16)).width),
              child: Column(children: [
                // 상단 위젯(<내 인증 확인하기> & <인증하러 가기>가 있는 위젯) 생성
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(
                      flexibleSize(context, Size.fromHeight(16)).height),
                  height: flexibleSize(context, Size.fromHeight(140)).height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 인트로
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              ImgPath.home_img5,
                              height:
                              MediaQuery.of(context).size.height *
                                  0.0536312849162011,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.0256410256410256,
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                '강의실 이용 끝!',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.0156424581005587,
                                    color: Colors.grey),
                              ),
                              Text(
                                '이제 인증하러 가볼까요?',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .height *
                                      0.0201117318435754,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: flexibleSize(context, Size.fromHeight(16)).height),
                      // 버튼
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // <내 인증 확인하기>
                          PageMigrateButton(
                            targetPage: MyCertification(),
                            text: '내 인증 확인하기',
                            color: MGcolor.btn_inactive,
                            fontcolor: MGcolor.btn_active,
                          ),
                          SizedBox(width: flexibleSize(context, Size.fromHeight(8)).height),
                          // <인증하러 가기>
                          PageMigrateButton(
                            targetPage: Reservation(),
                            text: '인증하러 가기',
                            color: MGcolor.btn_active,
                            fontcolor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 리스트
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: flexibleSize(context, Size.fromHeight(30)).height),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        // 타이틀
                        Text('다른 친구들 인증 보기', style: KR.subtitle1),
                        // 메인
                        ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) => AnotherGuyWidget(
                              where: '404 - ${index + 1}',
                              name: '김가천',
                              date: '2024.03.2${index}'),
                        ),
                      ]
                  ),
                )
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class PageMigrateButton extends StatelessWidget {
  const PageMigrateButton({
    Key? key,
    required this.targetPage,
    required this.text,
    required this.color,
    required this.fontcolor
  }) : super(key: key);

  final Widget targetPage;
  final String text;
  final Color color;      // buttton color
  final Color fontcolor;  // text color

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      width: flexibleSize(context, Size.fromWidth(159)).width,
      height: flexibleSize(context, Size.fromHeight(40)).height,
      child: TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (context) => targetPage));
        },
        child: Text(text, style: TextStyle(
            color: fontcolor,
            fontSize: flexibleSize(context, Size.fromHeight(14)).height
          )
        ),
      ),
    );
  }
}

class AnotherGuyWidget extends StatelessWidget {
  const AnotherGuyWidget({
    Key? key,
    required this.where,
    required this.name,
    required this.date
  }) : super(key: key);

  final String where;
  final String name;
  final String date;

  ///
  /// 예약 카드 보이기
  ///
  void showCard(BuildContext ctx) => showDialog(
    context: ctx,
    barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            height: flexibleSize(context, Size.fromHeight(518)).height,
            width: flexibleSize(context, Size.fromWidth(326)).width,
          ),
        ],
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCard(context),
      child: Container(
        margin: EdgeInsets.only(
          top: flexibleSize(context, Size.fromHeight(12)).height),
        padding: EdgeInsets.symmetric(
          vertical: flexibleSize(context, Size.fromHeight(12)).height,
          horizontal: flexibleSize(context, Size.fromWidth(16)).width
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        height: flexibleSize(context, Size.fromHeight(98)).height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 회의실
                Text(where, style: TextStyle(
                  fontSize: flexibleSize(context, Size.fromHeight(16)).height,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'KR'
                )),
                SizedBox(height: flexibleSize(context, Size.fromHeight(8)).height),
                // 대표자 이름
                Text(name, style: TextStyle(
                    fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'KR'
                )),
                SizedBox(height: flexibleSize(context, Size.fromHeight(4)).height),
                // 날짜
                Text(date, style: TextStyle(
                    fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'KR'
                )),
              ],
            ),
            // 사진
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MGcolor.base5,
              ),
              height: flexibleSize(context, Size.fromHeight(74)).width,
              width: flexibleSize(context, Size.fromWidth(74)).width
            )
          ],
        ),
      ),
    );
  }
}

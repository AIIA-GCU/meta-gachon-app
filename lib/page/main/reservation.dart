///
/// 예약 홈 페이지
/// - 홈 프레임

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mata_gachon/page/services/reservation.dart';
import 'package:mata_gachon/widget/certificate_widget.dart';


// 예약 페이지
class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  // 렌더링 최적화
  bool get wantKeepAlive => false;
  // 사용자의 예약 존재 여부 확인
  bool isExist = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ShaderMask(
        shaderCallback: hazyBottom,
        blendMode: BlendMode.dstOut,
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal:flexibleSize(context, Size.fromWidth(16)).width),
              child: Column(
                children: [
                  // 상단에 위치한 회의실 예약 위젯
                  GestureDetector( // 위젯 터치 시 예약 페이지로 이동
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => Reservation()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: flexibleSize(context, Size.fromWidth(16)).width),
                      height: flexibleSize(context, Size.fromHeight(60)).height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  ImgPath.home_img4,
                                  height: flexibleSize(context, Size.fromHeight(36)).height,
                                ),
                              ),
                              Container(
                                width: flexibleSize(context, Size.fromWidth(8)).width
                              ),
                              AutoSizeText(
                                '강의실 예약하기',
                                style: TextStyle(
                                  fontSize:flexibleSize(context, Size.fromHeight(16)).height,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  color: MGcolor.base1,
                                ),
                              ),
                              Transform.rotate(
                                angle: 180 * pi / 180,
                                child: Icon(
                                  AppinIcon.back,
                                  size: flexibleSize(context, Size.fromHeight(24)).height,
                                  color: MGcolor.base3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: flexibleSize(context, Size.fromHeight(30)).height,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExist = !isExist; //테스트 버튼 테스트 (내 예약 확인하기 글자 클릭 시 토글)
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '내 예약 확인하기(click to test)',
                        style: TextStyle(
                          fontSize: flexibleSize(context, Size.fromHeight(18)).height,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: flexibleSize(context, Size.fromHeight(18)).height,
                  ),
                  isExist
                      ? ListView.builder( //예약 존재 시 내 예약 리스트 표시
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) => MyReservationWidget(
                        where: '404 - ${index + 1}',
                        time: '15:${index}0 ~ 18:0${index}',
                        date: '2024.03.2${index} 목요일',
                        name: '2023000${index + 1} 김가천'),
                  )
                      : Transform.translate( // 예약 미 존재 시 표시
                    offset: Offset(
                      0,flexibleSize(context, Size.fromHeight(227)).height,
                    ), // 디바이스의 정 중앙에 배치
                    child: Center(
                      child: AutoSizeText(
                        '아직 예약 내역이 없어요!',
                        style: TextStyle(
                          fontSize: flexibleSize(context, Size.fromHeight(16)).height,
                          color: MGcolor.base4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );


  }
}


// 페이지 이동 버튼 위젯
class pageMigrateButton extends StatelessWidget {
  const pageMigrateButton(
      {Key? key,
      required this.targetPage,
      required this.text,
      required this.color,
      required this.fontcolor})
      : super(key: key);

  final Widget targetPage;
  final String text;
  final Color color;
  final Color fontcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      width: MediaQuery.of(context).size.width * 0.4076923076923077,
      height: MediaQuery.of(context).size.height * 0.0446927374301676,
      child: TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => targetPage), //targetPage로 이동
          );
        },
        child: AutoSizeText(
          text,
          style: TextStyle(
              color: fontcolor,
              fontSize:
                  MediaQuery.of(context).size.height * 0.0156424581005587),
        ),
      ),
    );
  }
}

///
/// 메타가천 메인 파일
/// - 앱 초기화
/// - 메인 레이아웃
///

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:auto_size_text/auto_size_text.dart';

import ' reservation.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "메타가천",
      theme: ThemeData(
          scaffoldBackgroundColor: MGcolor.base7,
          appBarTheme: AppBarTheme(
              backgroundColor: MGcolor.base7,
              elevation: 0,
              foregroundColor: MGcolor.base4,
              toolbarHeight: 56),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedLabelStyle: TextStyle(
                color: MGcolor.base2,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Ko'),
            selectedIconTheme:
                IconThemeData(size: 24, color: MGcolor.btn_active),
            unselectedLabelStyle: TextStyle(
                color: MGcolor.base2,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                fontFamily: 'Ko'),
            unselectedIconTheme:
                IconThemeData(size: 24, color: MGcolor.btn_inactive),
            showSelectedLabels: true,
            showUnselectedLabels: true,
          )),
      home: MainFrame(),
    );
  }
}

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;
  bool isExist = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      child: Scaffold(
          body: Center(
        child: Container(
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: ListView(children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        MediaQuery.of(context).size.width * 0.041025641025641),
                child: Column(
                  children: [
                    GestureDetector(
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
                            horizontal: MediaQuery.of(context).size.height *
                                0.017877094972067),
                        height: MediaQuery.of(context).size.height *
                            0.0670391061452514,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    ImgPath.home_img5,
                                    height: MediaQuery.of(context).size.height *
                                        0.0402234636871508,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.0205128205128205,
                                ),
                                AutoSizeText(
                                  '강의실 예약하기',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.017877094972067,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    color: Colors.black,
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 180 * pi / 180,
                                  child: Icon(
                                    AppinIcon.back,
                                    size: MediaQuery.of(context).size.height *
                                        0.0268156424581006,
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
                      height: MediaQuery.of(context).size.height *
                          0.0335195530726257,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExist = !isExist; //테스트 버튼 테스트
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '내 예약 확인하기(click to test)',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                0.0201117318435754,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.0089385474860335,
                    ),
                    isExist
                        ? ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) => anotherGuyWidget(
                                where: '404 - ${index + 1}',
                                time: '15:00 ~ 18:00',
                                date: '2024.03.2${index} 목요일'),
                          )
                        : Transform.translate(
                            offset: Offset(
                              0,
                              MediaQuery.of(context).size.height *
                                  0.2536312849162011,
                            ), // 디바이스의 정 중앙에 배치
                            child: Center(
                              child: AutoSizeText(
                                '아직 예약 내역이 없어요!',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.017877094972067,
                                  color: MGcolor.base4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.0558659217877095,
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      )),
    );
  }
}

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
            MaterialPageRoute(builder: (context) => targetPage),
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

class anotherGuyWidget extends StatelessWidget {
  const anotherGuyWidget(
      {Key? key, required this.where, required this.time, required this.date})
      : super(key: key);

  final String where;
  final String time;
  final String date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.041025641025641,
                  MediaQuery.of(context).size.height * 0.0335195530726257,
                  MediaQuery.of(context).size.width * 0.041025641025641,
                  MediaQuery.of(context).size.height * 0.0335195530726257),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              actions: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height:
                      MediaQuery.of(context).size.height * 0.5787709497206704,
                  width: MediaQuery.of(context).size.width * 0.8358974358974359,
                  child: Container(),
                ),
              ],
            );
          },
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height * 0.1094972067039106,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      where,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.height *
                            0.0212290502793296,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.0089385474860335,
                    ),
                    AutoSizeText(date,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height *
                              0.0156424581005587,
                          fontWeight: FontWeight.w400,
                          color: MGcolor.base3,
                        )),
                    AutoSizeText(time,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height *
                              0.0156424581005587,
                          fontWeight: FontWeight.w400,
                          color: MGcolor.base3,
                        )),
                  ],
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Transform.translate(
                  offset: Offset(
                    0,
                    -1 * MediaQuery.of(context).size.height * 0.023463687150838,
                  ),
                  child: Transform.rotate(
                    angle: 180 * pi / 180,
                    child: Icon(
                      AppinIcon.back,
                      size: MediaQuery.of(context).size.height *
                          0.0268156424581006,
                      color: MGcolor.base3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.0134078212290503,
          ),
        ],
      ),
    );
  }
}

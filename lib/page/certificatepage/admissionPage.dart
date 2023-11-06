///
/// 메타가천 메인 파일
/// - 앱 초기화
/// - 메인 레이아웃
///

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mata_gachon/page/certificatepage/checkmyadm.dart';

import 'admroom.dart';

class admissionPage extends StatelessWidget {
  const admissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => false;

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
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xFFF4F5F8),
                      Color(0xFFF4F5F8),
                    ],
                    stops: [
                      0.90,
                      0.93,
                      1.0
                    ], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: ListView(children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width *
                              0.041025641025641),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height *
                                    0.017877094972067),
                            height: MediaQuery.of(context).size.height *
                                0.1564245810055866,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.0223463687150838,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    pageMigrateButton(
                                      targetPage: myAdmission(),
                                      text: '내 인증 확인하기',
                                      color: Color(0xFFE3EDFD),
                                      fontcolor: Color(0xFF1762DB),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.0205128205128205,
                                    ),
                                    pageMigrateButton(
                                      targetPage: doAdmission(),
                                      text: '인증하러 가기',
                                      color: Color(0xFF0063D1),
                                      fontcolor: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.0335195530726257,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '다른 친구들 인증 보기',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height:
                            MediaQuery.of(context).size.height * 0.00893,
                          ),
                          ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) => anotherGuyWidget(
                                where: '404 - ${index + 1}',
                                name: '김가천',
                                date: '2024.03.2${index}'),
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
            ),
          ),),
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
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => targetPage),);
        },
        child: AutoSizeText(
          text,
          style: TextStyle(
              color: fontcolor,
              fontSize:
              MediaQuery.of(context).size.height * 0.0446927374301676),
        ),
      ),
    );
  }
}

class anotherGuyWidget extends StatelessWidget {
  const anotherGuyWidget(
      {Key? key, required this.where, required this.name, required this.date})
      : super(key: key);

  final String where;
  final String name;
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
                  width: MediaQuery.of(context).size.width * 0.3642458100558659,
                  child: Container(

                  ),
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
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height *
                            0.0212290502793296,
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    AutoSizeText(name,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height *
                              0.0156424581005587,
                        )),
                    AutoSizeText(date,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height *
                              0.0156424581005587,
                        )),
                  ],
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFD9D9D9),
                  ),
                  height:
                  MediaQuery.of(context).size.height * 0.0826815642458101,
                  width:
                  MediaQuery.of(context).size.height * 0.0826815642458101,
                )
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

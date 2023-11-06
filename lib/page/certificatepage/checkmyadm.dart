///
/// 메타가천 메인 파일
/// - 앱 초기화
/// - 메인 레이아웃
///

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mata_gachon/page/certificatepage/admissionPage.dart';
import 'package:mata_gachon/page/certificatepage/checkmyadm.dart';

import '../../main.dart';

class myAdmission extends StatefulWidget {
  const myAdmission({super.key});

  @override
  State<myAdmission> createState() => _myAdmissionState();
}

class _myAdmissionState extends State<myAdmission> {

  bool isExist = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.transparent),
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
          ),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Transform.translate(
            offset: Offset(
                -1 * MediaQuery.of(context).size.width * 0.0358974358974359,
                0),
            child: Row(
              children: [
                IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(AppinIcon.back, size: 24),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(
                        PageRouteBuilder(
                          transitionsBuilder:
                          // secondaryAnimation: 화면 전화시 사용되는 보조 애니메이션효과
                          // child: 화면이 전환되는 동안 표시할 위젯을 의미(즉, 전환 이후 표시될 위젯 정보를 의미)
                              (context, animation, secondaryAnimation, child) {
                            // Offset에서 x값 1은 오른쪽 끝 y값 1은 아래쪽 끝을 의미한다.
                            // 애니메이션이 시작할 포인트 위치를 의미한다.
                            var begin = const Offset(1.0, 0);
                            var end = Offset.zero;
                            // Curves.ease: 애니메이션이 부드럽게 동작하도록 명령
                            var curve = Curves.ease;
                            // 애니메이션의 시작과 끝을 담당한다.
                            var tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(
                              CurveTween(
                                curve: curve,
                              ),
                            );
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          // 함수를 통해 Widget을 pageBuilder에 맞는 형태로 반환하게 해야한다.
                          pageBuilder: (context, animation,
                              secondaryAnimation) =>
                          // (DetailScreen은 Stateless나 Stateful 위젯으로된 화면임)
                          admissionPage(),
                          // 이것을 true로 하면 dialog로 취급한다.
                          // 기본값은 false
                          fullscreenDialog: false,
                        ),
                      );
                    }),
                AutoSizeText(
                  '내 인증',
                  style: TextStyle(
                    fontSize:
                    MediaQuery.of(context).size.height * 0.0201117318435754,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExist = !isExist; //테스트 버튼 테스트
                });
              },
              child: Icon(AppinIcon.not, size: 24),
            ),
            SizedBox(
              width: 16,
            )
          ],
        ),
        body: isExist
            ? Center(
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
                          0.80,
                          0.93,
                          1.0
                        ], // 10% purple, 80% transparent, 10% purple
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior(),
                      child: ListView(children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width *
                                  0.041025641025641),
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) => anotherGuyWidget(
                                where: '404 - ${index + 1}',
                                name: '김가천',
                                date: '2024.03.2${index}'),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height *
                              0.0502793296089385,
                        )
                      ]),
                    ),
                  ),
                ),
              )
            : Transform.translate(
                offset: Offset(0, -1 * AppBar().preferredSize.height),
                // 디바이스의 정 중앙에 배치
                child: Center(
                  child: AutoSizeText(
                    '아직 인증이 없어요!',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          0.017877094972067,
                      color: Color(0xFF7C7C7C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
    return Column(
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
                height: MediaQuery.of(context).size.height * 0.0826815642458101,
                width: MediaQuery.of(context).size.height * 0.0826815642458101,
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.0134078212290503,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/admission.dart';

class MyCertification extends StatefulWidget {
  const MyCertification({super.key});

  @override
  State<MyCertification> createState() => _MyCertificationState();
}

class _MyCertificationState extends State<MyCertification> {

  // 인증이 존재하는지 추적하기 위한 변수
  bool isExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 26,
        leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(AppinIcon.back, size: 24),
            onPressed: () {
              // 슬라이드 애니메이션을 통해 인증 페이지로 이동
              Navigator.of(context, rootNavigator: true).pop(
                PageRouteBuilder(
                  transitionsBuilder: slideRigth2Left,  // 전환 애니메이션.
                  pageBuilder: (context, animation, secondaryAnimation)
                  => CertificationPage(), // 타깃 페이지(인증 페이지)
                  fullscreenDialog: false,
                ),
              );
            }
        ),
        title: Text('내 인증', style: TextStyle(
            fontSize: flexibleSize(context, Size.fromHeight(18)).height,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: "KR"
        ),
        ),
        actions: [
          // 'isExist' 상태를 변경하기 위한 GestureDetector.
          GestureDetector(
            onTap: () {
              setState(() {
                isExist = !isExist; // 'isExist' 상태를 토글
              });
            },
            child: Icon(AppinIcon.not, size: 24),
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: isExist // 'isExist'를 통해 인증이 존재하는지 알아보고, 존재여부에 따라 토글
          ? Center(
        child: Container(
          child: ShaderMask(
            shaderCallback: (Rect rect) {
              // 리스트 뷰에 그라디언트 효과 적용
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xFFF4F5F8),
                  Color(0xFFF4F5F8),
                ],
                stops: [0.80, 0.93, 1.0],
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
                  // 위젯 추가
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
          : Transform.translate( // 인증이 없으면 나오는 위젯
        offset: Offset(0, -1 * AppBar().preferredSize.height),
        child: Center(
          // 인증이 없을 때 표시되는 텍스트
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
    );
  }
}

// 다른 사용자의 개별 인증 항목을 표시하기 위한 위젯
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

///
/// 홈 페이지
/// - <예약하기> 바로가기
/// - <인증하기> 바로가기
/// - <등급 확인하기> 바로가기
/// - <예약 확인하기> 바로가기
/// - <내 인증 확인하기> 바로가기
///
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    // 스크롤 동작 설정
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          flexibleSize(context, Size.fromWidth(16)).width,
          0,
          flexibleSize(context, Size.fromWidth(16)).width,
          flexibleSize(context, Size.fromWidth(16)).width,
        ),
        children: [
          // 홈 페이지 내용
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // <예약하기> & <인증하기>
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // <예약하기>
                  Container(
                    width: flexibleSize(context, Size.fromWidth(173)).width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(
                      flexibleSize(context, Size.fromWidth(12)).width,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            ImgPath.home_img3,
                            width: flexibleSize(context, Size.fromWidth(149)).width,
                            height: flexibleSize(context, Size.fromWidth(149)).width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                            height: flexibleSize(context, Size.fromHeight(8)).height),
                        Text(
                          "강의실을 빌려\n편하게 공부해요!",
                          style: KR.subtitle4.copyWith(
                            color: MGcolor.base1,
                            fontSize: flexibleSize(context, Size.fromWidth(16)).width,
                          ),
                        ),
                        SizedBox(
                            height: flexibleSize(context, Size.fromHeight(12)).height),
                        Material(
                          child: InkWell(
                            onTap: () {},
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    flexibleSize(context, Size.fromHeight(8)).height)),
                            child: Ink(
                              width: flexibleSize(context, Size.fromWidth(77)).width,
                              decoration: BoxDecoration(
                                color: MGcolor.btn_active,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  flexibleSize(context, Size.fromWidth(16)).width,
                                  vertical:
                                  flexibleSize(context, Size.fromHeight(8)).height),
                              child: Center(
                                  child: Text(
                                    "예약하기",
                                    style: KR.label1.copyWith(
                                        color: Colors.white,
                                        fontSize:
                                        flexibleSize(context, Size.fromHeight(12)).height,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // <인증하기>
                  Container(
                    width: flexibleSize(context, Size.fromWidth(173)).width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.all(
                        flexibleSize(context, Size.fromWidth(12)).width),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            ImgPath.home_img2,
                            width: flexibleSize(context, Size.fromWidth(149)).width,
                            height: flexibleSize(context, Size.fromWidth(149)).width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                            height: flexibleSize(context, Size.fromHeight(8)).height),
                        Text(
                          "강의실 이용 후\n인증을 올려주세요!",
                          style: KR.subtitle4.copyWith(
                            color: MGcolor.base1,
                            fontSize: flexibleSize(context, Size.fromWidth(16)).width,
                          ),
                        ),
                        SizedBox(
                            height: flexibleSize(context, Size.fromHeight(12)).height),
                        Material(
                          child: InkWell(
                            onTap: () {},
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    flexibleSize(context, Size.fromHeight(8)).height)),
                            child: Ink(
                              width: flexibleSize(context, Size.fromWidth(77)).width,
                              decoration: BoxDecoration(
                                color: MGcolor.btn_active,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                  flexibleSize(context, Size.fromWidth(16)).width,
                                  vertical:
                                  flexibleSize(context, Size.fromHeight(8)).height),
                              child: Center(
                                  child: Text(
                                    "인증하기",
                                    style: KR.label1.copyWith(
                                        color: Colors.white,
                                        fontSize:
                                        flexibleSize(context, Size.fromHeight(12)).height,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: flexibleSize(context, Size.fromHeight(30)).height),
              // <등급 확인하기> & <예약 확인하기> & <내 인증 확인하기>
              Text(
                "내 정보를 빠르게 확인해요!",
                style: KR.subtitle1.copyWith(color: MGcolor.base1),
              ),
              Container(
                height: flexibleSize(context, Size.fromHeight(444)).height,
                padding: EdgeInsets.only(
                    top: flexibleSize(context, Size.fromHeight(8)).height),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // <등급 확인하기>
                    Container(
                      height: flexibleSize(context, Size.fromHeight(140)).height,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: LayoutBuilder(builder: (context, constrains) =>
                          Stack(children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  ImgPath.home_img5,
                                  width: constrains.maxHeight,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: flexibleSize(context, Size.fromWidth(128)).width,
                              child: Text(
                                "현재 나의 등급은?",
                                style: KR.label2.copyWith(
                                    color: MGcolor.base1,
                                    fontSize: flexibleSize(
                                        context, Size.fromHeight(16)).height),
                              ),
                            ),
                            Positioned(
                              top: flexibleSize(context, Size.fromHeight(27)).height,
                              left: flexibleSize(context, Size.fromWidth(128)).width,
                              child: Text(
                                "나는 지금 강의실을 얼마나\n잘 사용하고 있을지 확인해요!",
                                style: KR.label2.copyWith(
                                    color: MGcolor.base3,
                                    fontSize: flexibleSize(
                                        context, Size.fromHeight(12)).height),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 128,
                                child: Material(
                                  child: InkWell(
                                    onTap: () {},
                                    customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            flexibleSize(
                                                context, Size.fromHeight(8)).height)),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: MGcolor.btn_active,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: flexibleSize(
                                              context, Size.fromWidth(16)).width,
                                          vertical: flexibleSize(
                                              context, Size.fromHeight(8)).height),
                                      child: Center(
                                          child: Text(
                                            "등급 확인하기",
                                            style: KR.label1.copyWith(
                                                color: Colors.white,
                                                fontSize: flexibleSize(
                                                    context, Size.fromHeight(12)).height,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ),
                                  ),
                                )
                            )
                          ]),
                      ),
                    ),
                    // <예약 확인하기>
                    Container(
                      height: flexibleSize(context, Size.fromHeight(140)).height,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: LayoutBuilder(builder: (context, constrains) =>
                          Stack(children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  ImgPath.home_img4,
                                  width: constrains.maxHeight,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: flexibleSize(context, Size.fromWidth(128)).width,
                              child: Text(
                                "내가 언제 예약했더라?",
                                style: KR.label2.copyWith(
                                    color: MGcolor.base1,
                                    fontSize: flexibleSize(
                                        context, Size.fromHeight(16)).height),
                              ),
                            ),
                            Positioned(
                              top: flexibleSize(context, Size.fromHeight(27)).height,
                              left: flexibleSize(context, Size.fromWidth(128)).width,
                              child: Text(
                                "내가 예약한 강의실과\n예약 시간을 확인해요!",
                                style: KR.label2.copyWith(
                                    color: MGcolor.base3,
                                    fontSize: flexibleSize(
                                        context, Size.fromHeight(12)).height),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 128,
                                child: Material(
                                  child: InkWell(
                                    onTap: () {},
                                    customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            flexibleSize(
                                                context, Size.fromHeight(8)).height)),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: MGcolor.btn_active,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: flexibleSize(
                                              context, Size.fromWidth(16)).width,
                                          vertical: flexibleSize(
                                              context, Size.fromHeight(8)).height),
                                      child: Center(
                                          child: Text(
                                            "예약 확인하기",
                                            style: KR.label1.copyWith(
                                                color: Colors.white,
                                                fontSize: flexibleSize(
                                                    context, Size.fromHeight(12)).height,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ),
                                  ),
                                )
                            )
                          ]),
                      ),
                    ),
                    // <내 인증 확인하기>
                    Container(
                      height: flexibleSize(context, Size.fromHeight(140)).height,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: LayoutBuilder(builder: (context, constrains) =>
                          Stack(children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  ImgPath.home_img1,
                                  width: constrains.maxHeight,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: flexibleSize(context, Size.fromWidth(128)).width,
                              child: Text(
                                "과연 나의 깔끔 점수는?",
                                style: KR.label2.copyWith(
                                    color: MGcolor.base1,
                                    fontSize: flexibleSize(
                                        context, Size.fromHeight(16)).height),
                              ),
                            ),
                            Positioned(
                              top: flexibleSize(context, Size.fromHeight(27)).height,
                              left: flexibleSize(context, Size.fromWidth(128)).width,
                              child: Text(
                                "내가 올린 인증 사진 점수는\n과연 몇 점일지 확인해요!",
                                style: KR.label2.copyWith(
                                    color: MGcolor.base3,
                                    fontSize: flexibleSize(
                                        context, Size.fromHeight(12)).height),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                left: 128,
                                child: Material(
                                  child: InkWell(
                                    onTap: () {},
                                    customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            flexibleSize(
                                                context, Size.fromHeight(8)).height)),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: MGcolor.btn_active,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: flexibleSize(
                                              context, Size.fromWidth(16)).width,
                                          vertical: flexibleSize(
                                              context, Size.fromHeight(8)).height),
                                      child: Center(
                                          child: Text(
                                            "내 인증 확인하기",
                                            style: KR.label1.copyWith(
                                                color: Colors.white,
                                                fontSize: flexibleSize(
                                                    context, Size.fromHeight(12)).height,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ),
                                  ),
                                )
                            )
                          ]),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

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
import 'package:mata_gachon/page/certificate_page/check_my_certification.dart';
import 'package:mata_gachon/page/certificate_page/reservation.dart';
import 'package:mata_gachon/widget/certificate_widget.dart';
import 'package:mata_gachon/widget/small_widgets.dart';


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
                // <내 인증 확인하기> & <인증하러 가기>
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
                              height: flexibleSize(context, Size.fromHeight(48))
                                  .height,
                            ),
                          ),
                          Container(
                            width:
                            flexibleSize(context, Size.fromWidth(10)).width,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                '강의실 이용 끝!',
                                style: TextStyle(
                                    fontSize: flexibleSize(
                                        context, Size.fromHeight(14))
                                        .height,
                                    fontWeight: FontWeight.w400,
                                    color: MGcolor.base3),
                              ),
                              Text(
                                '이제 인증하러 가볼까요?',
                                style: TextStyle(
                                  fontSize:
                                  flexibleSize(context, Size.fromHeight(18))
                                      .height,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                          height: flexibleSize(context, Size.fromHeight(16))
                              .height),
                      // 버튼
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // <내 인증 확인하기>
                          PageMigrateButton(
                            isPopUp: true,
                            buttonSize: 159,
                            targetPage: MyCertification(),
                            text: '내 인증 확인하기',
                            color: MGcolor.btn_inactive,
                            fontcolor: MGcolor.btn_active,
                          ),
                          SizedBox(
                              width: flexibleSize(context, Size.fromHeight(8))
                                  .height),
                          // <인증하러 가기>
                          PageMigrateButton(
                            isPopUp: true,
                            buttonSize: 159,
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
                      vertical:
                      flexibleSize(context, Size.fromHeight(30)).height),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 타이틀
                        Text('다른 친구들 인증 보기', style: KR.subtitle1),

                        Container(
                          height:
                          flexibleSize(context, Size.fromHeight(8)).height,
                        ),

                        // 메인
                        ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) => AnotherGuyWidget(
                              where: '404 - ${index + 1}',
                              name: '김가천',
                              date: '2024.03.2${index}',
                              time: '1${index}:00 ~ 1${index}:00'),
                        ),
                      ]),
                )
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

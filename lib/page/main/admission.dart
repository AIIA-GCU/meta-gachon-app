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
import 'package:mata_gachon/page/services/my_admission.dart';
import 'package:mata_gachon/page/services/reservation.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

class AdmissionListPage extends StatelessWidget {
  const AdmissionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                        height: MediaQuery.of(context).size.height *
                            0.0536312849162011,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.0256410256410256,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          '강의실 이용 끝!',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height *
                                  0.0156424581005587,
                              color: Colors.grey),
                        ),
                        Text(
                          '이제 인증하러 가볼까요?',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                0.0201117318435754,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                    height: flexibleSize(context, Size.fromHeight(16)).height),
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
                    SizedBox(
                        width:
                            flexibleSize(context, Size.fromHeight(8)).height),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // 타이틀
              Text('다른 친구들 인증 보기', style: KR.subtitle1),
              // 메인
              ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) => CustomListItem(
                        where: '404 - ${index + 1}',
                        name: '2023000${index + 1} 김가천',
                        begin: DateTime.now().add(Duration(days: index)),
                        duration: Duration(hours: index + 1),
                        admission: true,
                      )),
            ]),
          )
        ]),
      ),
    );
  }
}

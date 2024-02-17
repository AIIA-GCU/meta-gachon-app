import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/select_service_page.dart';

import 'term_page.dart';
import 'setting_page.dart';
import 'my_admission_list_page.dart';
import '../widgets/button.dart';
import '../widgets/layout.dart';
import '../widgets/popup_widgets.dart';

class MyPage extends StatelessWidget {
  const MyPage({
    super.key,
    required this.manager,
    required this.moveToReserList
  });

  final bool manager;
  final VoidCallback moveToReserList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
          ratio.width * 16,
          ratio.height * 31,
          ratio.width * 16,
          ratio.height * 23
      ),
      child: Column(
          children: [
            /// 프로필
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                    children: [
                      /// 이미지
                      /// Todo: 바꿀 필요 있음
                      Container(
                        width: ratio.width * 170,
                        height: ratio.width * 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: myInfo.ratingImg,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter
                            )
                        ),
                      ),

                      SizedBox(width: ratio.width * 9),

                      /// 텍스트
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(myInfo.name, style: KR.title3),
                            SizedBox(height: ratio.height * 20),
                            Text(
                              'AI소프트웨어학과',
                              style: KR.parag2.copyWith(
                                color: MGColor.base3,
                                letterSpacing: 0.32
                              )
                            ),
                            Text(
                                myInfo.stuNum.toString(),
                                style: KR.parag2.copyWith(color: MGColor.base3)
                            ),
                            SizedBox(height: ratio.height * 20),
                            Row(
                                children: [
                                  Text(
                                      myInfo.ratingName,
                                      style: KR.parag1.copyWith(color: MGColor.base3)
                                  ),
                                  SizedBox(width: ratio.width * 11),
                                  InkWell(
                                    onTap: () => _showGradePopup(context),
                                    customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: ratio.height * 5,
                                          horizontal: ratio.width * 11
                                      ),
                                      decoration: BoxDecoration(
                                          color: MGColor.base4.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(100)
                                      ),
                                      child: Text(
                                          '등급 확인',
                                          style: KR.parag2.copyWith(color: Colors.white)
                                      ),
                                    ),
                                  )
                                ]
                            )
                          ]
                      )
                    ]
                ),
              ),
            ),

            /// 옵션
            TileButtonCard(items: [
              /// 예약 정보 확인
              TileButton(
                  onTap: moveToReserList,
                  padding: EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: ratio.width * 22
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.search, size: ratio.width * 24),
                      SizedBox(width: ratio.width * 16),
                      Text(
                          '예약 정보 확인',
                          style: KR.subtitle4.copyWith(color: MGColor.base2)
                      )
                    ],
                  )
              ),

              /// 내 인증 확인
              TileButton(
                onTap: () => _floatMyAdmissionPage(context),
                padding: EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: ratio.width * 22
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.edit_document, size: ratio.width * 24),
                    SizedBox(width: ratio.width * 16),
                    Text(
                        '내 인증 확인',
                        style: KR.subtitle4.copyWith(color: MGColor.base2)
                    )
                  ],
                ),
              ),

              /// 서비스 변경
              TileButton(
                onTap: () => _backToSelectingPage(context),
                padding: EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: ratio.width * 22
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.arrow_circle_left, size: ratio.width * 24),
                    SizedBox(width: ratio.width * 16),
                    Text('서비스 변경', style: KR.subtitle4)
                  ],
                ),
              ),

              /// 설정
              TileButton(
                  onTap: () => _floatSettingPage(context),
                  padding: EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: ratio.width * 22
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.settings, size: ratio.width * 24),
                      SizedBox(width: ratio.width * 16),
                      Text(
                          '설정',
                          style: KR.subtitle4.copyWith(color: MGColor.base2)
                      )
                    ],
                  )
              )
            ]),

            /// 앱 정보
            TileButtonCard(items: [
              TileButton(
                onTap: () => _floatTermPage(context, Term.usingService),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: ratio.width * 22
                ),
                child: Text(
                    '이용약관',
                    style: KR.parag2.copyWith(color: MGColor.base3)
                ),
              ),
              TileButton(
                  onTap: () => _floatTermPage(
                      context, Term.personalInfomationCollection),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: ratio.width * 22
                  ),
                  child: Text(
                      '개인정보 수집 및 이용',
                      style: KR.parag2.copyWith(color: MGColor.base3)
                  )
              ),
              TileButton(
                padding: EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: ratio.width * 22
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('버전', style: KR.parag2.copyWith(color: MGColor.base3)),
                    Text(
                        '1.0.0',
                        style: EN.parag2.copyWith(color: MGColor.base3)
                    ),
                  ],
                ),
              )
            ])
          ]
      ),
    );
  }

  void _showGradePopup(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (context) => const GradePopup()
    );
  }

  void _floatMyAdmissionPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyAdmissionPage()));
  }
  
  void _backToSelectingPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SelectingServicePage()));
  }

  void _floatSettingPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SettingPage()));
  }

  void _floatTermPage(BuildContext context, Term term) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TermPage(term: term))
    );
  }
}


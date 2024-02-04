import 'package:flutter/material.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/services/my_admission.dart';
import 'package:mata_gachon/page/services/setting.dart';
import 'package:mata_gachon/page/services/term.dart';
import 'package:mata_gachon/widget/popup.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

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
      physics: ClampingScrollPhysics(),
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
              padding: EdgeInsets.symmetric(vertical: ratio.height * 8),
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
                            Text('?????전공', style: KR.parag2.copyWith(color: MGcolor.base3)),
                            Text(
                                myInfo.stuNum.toString(),
                                style: KR.parag2.copyWith(color: MGcolor.base3)
                            ),
                            SizedBox(height: ratio.height * 20),
                            Row(
                                children: [
                                  Text(
                                      myInfo.ratingName,
                                      style: KR.parag1.copyWith(color: MGcolor.base3)
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
                                          color: MGcolor.base4.withOpacity(0.5),
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
                      vertical: ratio.height * 12,
                      horizontal: ratio.width * 22
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.search, size: ratio.width * 24),
                      SizedBox(width: ratio.width * 16),
                      Text(
                          '예약 정보 확인',
                          style: KR.subtitle4.copyWith(color: MGcolor.base2)
                      )
                    ],
                  )
              ),

              /// 내 인증 확인
              TileButton(
                onTap: () => _floatMyAdmissionPage(context),
                padding: EdgeInsets.symmetric(
                    vertical: ratio.height * 12,
                    horizontal: ratio.width * 22
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.edit_document, size: ratio.width * 24),
                    SizedBox(width: ratio.width * 16),
                    Text(
                        '내 인증 확인',
                        style: KR.subtitle4.copyWith(color: MGcolor.base2)
                    )
                  ],
                ),
              ),

              /// 내 작품 확인
              TileButton(
                onTap: () {},
                padding: EdgeInsets.symmetric(
                    vertical: ratio.height * 12,
                    horizontal: ratio.width * 22
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                        Icons.photo,
                        size: ratio.width * 24,
                        color: MGcolor.base5
                    ),
                    SizedBox(width: ratio.width * 16),
                    Text(
                        '내 작품 확인',
                        style: KR.subtitle4.copyWith(color: MGcolor.base5)
                    )
                  ],
                ),
              ),

              /// 설정
              TileButton(
                  onTap: () => _floatSettingPage(context),
                  padding: EdgeInsets.symmetric(
                      vertical: ratio.height * 12,
                      horizontal: ratio.width * 22
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.settings, size: ratio.width * 24),
                      SizedBox(width: ratio.width * 16),
                      Text(
                          '설정',
                          style: KR.subtitle4.copyWith(color: MGcolor.base2)
                      )
                    ],
                  )
              )
            ]),

            /// 관리자 페이지
            if (manager)
              TileButtonCard(items: [
                TileButton(
                    onTap: () {},
                    padding: EdgeInsets.symmetric(
                        vertical: ratio.height * 12,
                        horizontal: ratio.width * 22
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.phonelink_setup, size: ratio.width * 24, color: MGcolor.btn_active),
                          SizedBox(width: ratio.width * 16),
                          Text(
                              '관리 페이지',
                              style: KR.subtitle4.copyWith(color: MGcolor.btn_active)
                          )
                        ]
                    )
                )
              ]),

            /// 앱 정보
            TileButtonCard(items: [
              TileButton(
                onTap: () => _floatTermPage(context, Term.usingService),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    vertical: ratio.height * 12,
                    horizontal: ratio.width * 22
                ),
                child: Text(
                    '이용약관',
                    style: KR.parag2.copyWith(color: MGcolor.base3)
                ),
              ),
              TileButton(
                  onTap: () => _floatTermPage(
                      context, Term.personalInfomationCollection),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                      vertical: ratio.height * 12,
                      horizontal: ratio.width * 22
                  ),
                  child: Text(
                      '개인정보 수집 및 이용',
                      style: KR.parag2.copyWith(color: MGcolor.base3)
                  )
              ),
              TileButton(
                padding: EdgeInsets.symmetric(
                    vertical: ratio.height * 12,
                    horizontal: ratio.width * 22
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('버전', style: KR.parag2.copyWith(color: MGcolor.base3)),
                    Text(
                        '1.0.0',
                        style: EN.parag2.copyWith(color: MGcolor.base3)
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
        builder: (context) => GradePopup()
    );
  }

  void _floatMyAdmissionPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MyAdmissionPage()));
  }

  void _floatSettingPage(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SettingPage()));
  }

  void _floatTermPage(BuildContext context, Term term) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TermPage(term: term))
    );
  }
}


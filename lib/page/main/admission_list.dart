///
/// 인증 홈 페이지
/// - 홈 프레임
/// - 페이지 이동 버튼
/// - 카드
///

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/server.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/services/admission.dart';
import 'package:mata_gachon/page/services/my_admission.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

class AdmissionListPage extends StatefulWidget {
  const AdmissionListPage({super.key});

  @override
  State<AdmissionListPage> createState() => _AdmissionListPageState();
}

class _AdmissionListPageState extends State<AdmissionListPage> {
  final Stream<String> _stream = listListener.stream;

  @override
  void initState() {
    super.initState();
    _stream.listen((event) {
      if (event == "admission") {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
        child: Column(children: [
          /// <내 인증 확인하기> & <인증하러 가기>
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 16,
              vertical: ratio.height * 16
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 인트로
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        ImgPath.home_img5,
                        height: ratio.width * 48,
                      ),
                    ),
                    SizedBox(width: ratio.width * 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '강의실 이용 끝!',
                          style: KR.parag2.copyWith(color: MGcolor.base3)
                        ),
                        Text(
                          '이제 인증하러 가볼까요?',
                          style: KR.subtitle1
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: ratio.height * 16),

                /// 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// <내 인증 확인하기>
                    ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MyAdmission())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MGcolor.btn_inactive,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                        fixedSize: Size(ratio.width * 159, ratio.height * 40)
                      ),
                      child: Text(
                        '내 인증 확인하기',
                        style: KR.parag2.copyWith(color: MGcolor.brand_orig),
                      ),
                    ),
                    /// <인증하러 가기>
                    ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => Admission())),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MGcolor.btn_active,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fixedSize: Size(ratio.width * 160, ratio.height * 40)
                      ),
                      child: Text(
                        '인증하러 가기',
                        style: KR.parag2.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 리스트
          Padding(
            padding: EdgeInsets.symmetric(vertical: ratio.height * 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /// 타이틀
              Text('다른 친구들 인증 보기', style: KR.subtitle1),
              /// 메인
                  if (comfirms.isNotEmpty)
                    ...List.generate(
                        comfirms.length,
                            (index) => CustomListItem(
                            uid: '',
                            where: comfirms[index].room,
                            name: '${comfirms[index].stu_num} ${comfirms[index].name}',
                            begin: comfirms[index].start,
                            duration: Duration(hours: comfirms[index].duration),
                            admission: true,
                        )
                    )
                  else
                    Container(
                        height: ratio.height * 594,
                        alignment: Alignment.center,
                        child: Text(
                          "아직 예약 내역이 없어요!",
                          style: KR.subtitle4.copyWith(color: MGcolor.base3),
                        )
                    )
            ]),
          )
        ]),
      ),
    );
  }
}

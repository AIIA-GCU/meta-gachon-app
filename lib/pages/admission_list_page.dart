///
/// 인증 홈 페이지
/// - 홈 프레임
/// - 페이지 이동 버튼
/// - 카드
///

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mata_gachon/config/server.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/admit_page.dart';
import 'package:mata_gachon/pages/my_admission_list_page.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

class AdmissionListPage extends StatefulWidget {
  const AdmissionListPage({super.key});

  @override
  State<AdmissionListPage> createState() => _AdmissionListPageState();
}

class _AdmissionListPageState extends State<AdmissionListPage> {
  final Stream<StreamType> _stream = listListener.stream;

  late final FToast _fToast;
  late bool _isShownToast;

  @override
  void initState() {
    super.initState();
    _stream.listen((event) => _event(event));
    _fToast = FToast();
    _fToast.init(context);
    _isShownToast = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          .push(MaterialPageRoute(builder: (context) => MyAdmissionPage())),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MGcolor.tertiaryColor(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fixedSize: Size(ratio.width * 159, ratio.height * 40)
                      ),
                      child: Text(
                        '내 인증 확인하기',
                        style: KR.parag2.copyWith(color: MGcolor.primaryColor()),
                      ),
                    ),
                    /// <인증하러 가기>
                    ElevatedButton(
                      onPressed: _doAdmission,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MGcolor.primaryColor(),
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
              padding: EdgeInsets.only(top: ratio.height * 30),
              child: Text('다른 친구들 인증 보기', style: KR.subtitle1)
          ),
          Padding(
              padding: EdgeInsets.only(bottom: ratio.height * 30),
              child: FutureBuilder<List<Admit>?>(
                  future: admits.isEmpty ? RestAPI.getAllAdmission() : null,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                          height: ratio.height * 594,
                          alignment: Alignment.center,
                          child: Text(
                              '통신 속도가 너무 느립니다!',
                              style: KR.subtitle4.copyWith(color: MGcolor.base3)
                          )
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ProgressWidget();
                    }
                    if (snapshot.hasData) {
                      admits = snapshot.data!;
                    }
                    if (admits.isNotEmpty) {
                      return Column(
                          children: admits.map((e) {
                        List<String> temp = e.leaderInfo.split(' ');
                        return CustomListItem(admit: e);
                      }).toList());
                    } else {
                      return Container(
                          height: ratio.height * 218,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                              '아직 인증이 없어요!',
                              style: KR.subtitle4.copyWith(color: MGcolor.base3)
                          )
                      );
                    }
                  }
              )
          )
        ]),
      ),
    );
  }

  void _doAdmission() {
    late int idx;
    late String current;

    current = std3_format.format(DateTime.now());
    idx = reservates.indexWhere((e) => e.date.compareTo(current) > 0);

    if (idx != -1) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AdmitPage(reservate: reservates[idx])));
    } else {
      if (!_isShownToast) {
        _isShownToast = true;
        Future.delayed(Duration(seconds: 2)).then((_) => _isShownToast = false);

        _fToast.showToast(
          positionedToastBuilder: (context, widget) {
            return Positioned(
              bottom: kBottomNavigationBarHeight + 10,
              width: MediaQuery.of(context).size.width,
              child: widget,
            );
          },
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 6, horizontal: ratio.width * 12
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(100)
              ),
              child: Text(
                '인증해야 하는 이용 내역이 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                )
              ),
            ),
          )
        );
      }
    }
  }

  void _event(StreamType event) {
    if (mounted && event == StreamType.admit) {
      setState(() {
        admits.clear();
        myAdmits.clear();
      });
    }
  }
}

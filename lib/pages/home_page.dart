import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

import '../widgets/popup_widgets.dart';
import 'admit_page.dart';
import 'my_admission_list_page.dart';
import 'reservate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.movetoReserList, required this.movetoAdmisList});

  final VoidCallback movetoReserList;
  final VoidCallback movetoAdmisList;

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late final FToast _fToast;
  late bool _isShownToast;

  @override
  void initState() {
    _fToast = FToast();
    _fToast.init(context);
    _isShownToast = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          ratio.width * 16,
          0,
          ratio.width * 16,
          ratio.height * 16
        ),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// <예약하기> & <인증하기>
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// <예약하기>
                  _smallCard(
                    '강의실을 빌려\n편하게 공부해요!',
                    '예약하기',
                    ImgPath.home3,
                    doReservation
                  ),

                  /// <인증하기>
                  _smallCard(
                    "강의실 이용 후\n인증을 올려주세요!",
                    "인증하기",
                    ImgPath.home2,
                    doAdmission
                  )
                ],
              ),

              SizedBox(height: ratio.height * 30),

              /// <등급 확인하기> & <예약 확인하기> & <내 인증 확인하기>
              Text(
                "내 정보를 빠르게 확인해요!",
                style: KR.subtitle1.copyWith(color: MGColor.base1),
              ),
              Padding(
                padding: EdgeInsets.only(top: ratio.height * 8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// <등급 확인하기>
                      _largeCard(
                          "현재 나의 등급은?",
                          "나는 지금 강의실을 얼마나\n잘 사용하고 있을지 확인해요!",
                          "등급 확인하기",
                          ImgPath.home5,
                          checkRating
                      ),

                      SizedBox(height: ratio.height * 12),

                      /// <예약 확인하기>
                      _largeCard(
                          "내가 언제 예약했더라?",
                          "내가 예약한 강의실과\n예약 시간을 확인해요!",
                          "예약 확인하기",
                          ImgPath.home4,
                          widget.movetoReserList
                      ),

                      SizedBox(height: ratio.height * 12),

                      /// <내 인증 확인하기>
                      _largeCard(
                          "과연 나의 깔끔 점수는?",
                          "내가 올린 인증 사진 점수는\n과연 몇 점일지 확인해요!",
                          "내 인증 확인하기",
                          ImgPath.home1,
                          checkMyAdmission
                      )
                    ]
                ),
              )
            ]
        )
      ),
    );
  }

  Widget _smallCard(String title, String buttonText, String imgPath, void Function() onTap) {
    return Container(
      width: ratio.width * 173,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
      ),
      padding: EdgeInsets.symmetric(
          horizontal: ratio.width * 12,
          vertical: ratio.height * 12
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imgPath, fit: BoxFit.cover),
            ),
            SizedBox(height: ratio.height * 8),

            /// Text
            Text(title, style: KR.subtitle4.copyWith(color: MGColor.base1)),
            SizedBox(height: ratio.height * 12),

            /// Button
            Material(
              child: InkWell(
                onTap: onTap,
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Ink(
                  width: ratio.width * 77,
                  decoration: BoxDecoration(
                    color: MGColor.primaryColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ratio.width * 16, vertical: 8),
                  child: Center(child: Text(
                    buttonText,
                    style: KR.label1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                    ),
                  )),
                ),
              ),
            )
          ]
      ),
    );
  }

  Widget _largeCard(
      String title, String paragraph, String buttonText, String imgPath, void Function() onTap) {
    return Container(
        height: ratio.height * 140,
        padding: EdgeInsets.symmetric(
            horizontal: ratio.width * 12,
            vertical: ratio.height * 12
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        child: LayoutBuilder(builder: (context, constrains) =>
            Stack(children: [
              /// Image
              Positioned(
                top: 0,
                left: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imgPath,
                    height: constrains.maxHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// Text
              Positioned(
                top: 0,
                left: constrains.maxHeight + ratio.width * 12,
                child: Text(title,
                  style: KR.label2.copyWith(
                      color: MGColor.base1,
                      fontSize: ratio.height * 16
                  ),
                ),
              ),
              Positioned(
                top: ratio.height * 27,
                left: constrains.maxHeight + ratio.width * 12,
                child: Text(paragraph, style: KR.label2.copyWith(color: MGColor.base3)),
              ),

              /// Button
              Positioned(
                  bottom: 0,
                  left: constrains.maxHeight + ratio.width * 12,
                  child: Material(
                    child: InkWell(
                      onTap: onTap,
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: MGColor.primaryColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: ratio.height * 16,
                            vertical: 8
                        ),
                        child: Center(child: Text(
                          buttonText,
                          style: KR.label1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                          ),
                        )),
                      ),
                    ),
                  )
              )
            ])
        )
    );
  }

  void doReservation() {
    Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const ReservatePage()));
    widget.movetoReserList();
  }

  void doAdmission() {
    int idx = reservates.indexWhere((e) => e.endTime.compareTo(DateTime.now()) < 0);
    if (idx != -1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AdmitPage(reservate: reservates[idx])));
      widget.movetoAdmisList();
    } else {
      if (!_isShownToast) {
        _isShownToast = true;
        Future.delayed(const Duration(seconds: 2)).then((_) => _isShownToast = false);

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
                child: const Text(
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

  void checkRating() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) => const GradePopup()
    );
  }

  void checkMyAdmission() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MyAdmissionPage()));
    widget.movetoAdmisList();
  }
}
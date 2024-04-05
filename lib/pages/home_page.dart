import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/prior_admissions_page.dart';

import '../widgets/popup_widgets.dart';
import 'admit_page.dart';
import 'my_admission_list_page.dart';
import 'reserve_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.movetoReserList,
    required this.movetoAdmisList,
    required this.setLoading
  });

  final VoidCallback movetoReserList;
  final VoidCallback movetoAdmisList;
  final void Function(bool) setLoading;
  double mediaHeight(BuildContext context, double scale) => MediaQuery.of(context).size.height * scale;
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
          ratio.height * 12,
          ratio.width * 16,
          ratio.height * 30
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
                  Expanded(
                    child: _smallCard(
                      '공간과 컴퓨터를 빌려\n편하게 공부해요!',
                      '예약하기',
                      ImgPath.home3,
                      widget.movetoReserList,
                    ),
                  ),
                  SizedBox(width: 12),

                  /// <인증하기>
                  Expanded(
                    child: _smallCard(
                        "시설 이용 후\n인증을 올려주세요!",
                        "인증하기",
                        ImgPath.home2,
                        doAdmission
                    ),
                  )
                ]
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
                      /// <예약 확인하기>
                      _largeCard(
                          "내가 언제 예약했더라?",
                          "내가 예약한 강의실과\n예약 시간을 확인해요!",
                          "예약 확인하기",
                          ImgPath.home4,
                          widget.movetoReserList
                      ),
                      SizedBox(height: ratio.height * 12),
                      /// <등급 확인하기>
                      _largeCard(
                          "현재 나의 등급은?",
                          "나는 지금 강의실을 얼마나\n잘 사용하고 있을지 확인해요!",
                          "등급 확인하기",
                          ImgPath.home5,
                          checkRating
                      ),
                      SizedBox(height: ratio.height * 12),

                      /// <내 인증 확인하기>
                      _largeCard(
                          "과연 나의 깔끔 점수는?",
                          "내가 올린 인증 사진 점수는\n과연 몇 점일지 확인해요!",
                          "내 인증 확인하기",
                          ImgPath.home1,
                          checkMyAdmission
                      ),
                    ]
                ),
              )
            ]
        ),
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
            Text(
              title,
              style: MediaQuery.of(context).size.width <= 340
                  ? KR.subtitle5.copyWith(color: MGColor.base1)
                  : KR.subtitle4.copyWith(color: MGColor.base1),
            ),
            SizedBox(height: ratio.height * 12),

            /// Button
            Material(
              child: InkWell(
                onTap: onTap,
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child:Ink(
                  decoration: BoxDecoration(
                    color: MGColor.brandPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ratio.width * 16, vertical: 8),
                  child: IntrinsicWidth(
                    child: Center(child: Text(
                      buttonText,
                      style: KR.label1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    )),
                  ),
                )

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
                          color: MGColor.brandPrimary,
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

  Future<void> doReservation(ServiceType service) async {
    widget.setLoading(true);
    List<String>? temp = await RestAPI.placeForService(service);
    widget.setLoading(false);
    if (temp != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReservePage(service, availableRoom: temp))
      );
    } else {
      late String str;
      switch (service) {
        case ServiceType.aiSpace:
          str = "회의실이";
          break;
        case ServiceType.lectureRoom:
          str = "강의실이";
          break;
        case ServiceType.computer:
          str = "컴퓨터가";
          break;
      }
      showDialog(
          context: context,
          builder: (ctx) => CommentPopup(
              title: '현재 예약 가능한 $str 없습니다.',
              onPressed: () => Navigator.pop(ctx)
          )
      );
    }
  }

  Future<void> doAdmission() async {
    List<Reserve>? items = await RestAPI.getPreAdmittedReservation();
    if (items != null && items.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PriorAdmissionsPage(items)));
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
  }
}
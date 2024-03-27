import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/app/load_assets.dart';
import 'package:mata_gachon/config/server/_export.dart';

import '../pages/admit_page.dart';
import '../pages/reserve_page.dart';
import '../pages/qr_page.dart';
import 'button.dart';

class AlertPopup extends StatelessWidget {
  const AlertPopup({
    super.key,
    required this.title,
    this.cancelMsg = "닫기",
    required this.agreeMsg,
    required this.onAgreed
  });

  final String title;
  final String cancelMsg;
  final String agreeMsg;
  final VoidCallback onAgreed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 156,
        padding: EdgeInsets.fromLTRB(
          ratio.width * 12,
          40,
          ratio.width * 12,
          12
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: KR.subtitle4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MGColor.base7,
                    fixedSize: Size(ratio.width * 147, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text("닫기", style: KR.parag2.copyWith(color: MGColor.base3)),
                ),
                SizedBox(width: ratio.width * 8),
                ElevatedButton(
                  onPressed: onAgreed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MGColor.brandPrimary,
                      fixedSize: Size(ratio.width * 147, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text(agreeMsg, style: KR.parag2.copyWith(color: Colors.white)),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}

class CommentPopup extends StatelessWidget {
  CommentPopup({
    super.key,
    required this.title,
    this.buttonMsg = "확인",
    Color? buttonColor,
    required this.onPressed
  }) {
    buttonBackground = buttonColor ?? MGColor.brandPrimary;
  }

  final String title;
  final String buttonMsg;
  final VoidCallback onPressed;
  late final Color buttonBackground;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 156,
        padding: EdgeInsets.fromLTRB(
            ratio.width * 12,
            40,
            ratio.width * 12,
            12
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: KR.subtitle4),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackground,
                fixedSize: Size(ratio.width * 302, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              child: Text(buttonMsg, style: EN.parag1.copyWith(color: Colors.white)),
            )
          ],
        ),
      )
    );
  }
}

class ReservationPopup extends StatelessWidget {
  const ReservationPopup(this.item, this.status, this.setLoading, {super.key});

  final Reserve item;
  final int status;
  final void Function(bool) setLoading;

  @override
  Widget build(BuildContext context) {
    late Text place, time1, time2;
    late String statusMsg;
    late Widget button;
    late String path;
      switch (item.service) {
        case ServiceType.aiSpace:
          path = "graphic_meta";
          break;
        case ServiceType.lectureRoom:
          path = "graphic_class";
          break;
        case ServiceType.computer:
          path = "graphic_gpu";
          break;
      }

    if (item.service == ServiceType.lectureRoom && item.place == '-1') {
      place = Text('배정 중', style: KR.subtitle1.copyWith(color: Colors.red));
    } else {
      place = Text(item.place!, style: KR.subtitle1);
    }

    if (item.service == ServiceType.computer) {
      time1 = Text(item.startToDate2(), style: KR.parag2.copyWith(color: MGColor.base3));
      time2 = Text('~ ${item.endToDate2()}', style: KR.parag2.copyWith(color: MGColor.base3));
    } else {
      time1 = Text(item.startToDate2(), style: KR.parag2.copyWith(color: MGColor.base3));
      time2 = Text(item.toDuration(), style: KR.parag2.copyWith(color: MGColor.base3));
    }

    switch (status) {
      case 1:
        statusMsg = '곧 있음 예약한 시간이에요.\n회의실에서 QR코드 인증을 해주세요!';
        break;
      case 3:
        statusMsg = '현재 회의실을 사용 중이에요!';
        break;
      case 4:
        statusMsg = '곧 있음 이용 시간이 끝납니다.';
        break;
      case 5:
        statusMsg = '공간 이용 시간이 끝났습니다!\n인증 사진을 올려주세요.';
        break;
      default:
        statusMsg = '';
        break;
    }

    if (myInfo.match(item.leaderInfo)) {
      switch (status) {
        /// 사용 전 (예약 변경 X, QR O)
        case 0:
          button = Text(
              "사용 전날은 수정 및 취소가 불가합니다.",
              style: KR.label2.copyWith(color: MGColor.systemError)
          );
          break;

        /// 사용 전 (예약 변경 X, QR X)
        case 1:
          button = ElevatedButton(
              onPressed: () => _qr(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: MGColor.brandPrimary,
                  fixedSize: Size(
                      ratio.width * 145, ratio.height * 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
              ),
              child: Text("QR 코드 인증하기",
                  style: KR.parag1.copyWith(color: Colors.white))
          );
          break;

        /// 사용 전 (수정 O)
        case 2:
          if (item.service case ServiceType.computer) {
            button = ElevatedButton(
                onPressed: () => _del(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: MGColor.brandPrimary,
                    fixedSize: Size(
                        ratio.width * 145, ratio.height * 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))
                ),
                child: Text("예약 취소하기", style: KR.parag1.copyWith(
                    color: Colors.white))
            );
          } else {
            button = Column(children: [
              ElevatedButton(
                  onPressed: () => _edit(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MGColor.brandPrimary,
                      fixedSize: Size(
                          ratio.width * 145, ratio.height * 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text("예약 수정하기", style: KR.parag1.copyWith(
                      color: Colors.white))
              ),
              TextButton(
                  onPressed: () => _del(context),
                  style: TextButton.styleFrom(
                      fixedSize: Size(
                          ratio.width * 145, ratio.height * 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text("예약 취소하기", style: KR.parag1.copyWith(
                      color: MGColor.base3))
              )
            ]);
          }
          break;

        /// 사용 중 (연장 O)
        case 4:
          button = ElevatedButton(
              onPressed: () => _prolong(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: MGColor.brandPrimary,
                  fixedSize: Size(
                      ratio.width * 145, ratio.height * 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
              ),
              child: Text("예약 연장하기",
                  style: KR.parag1.copyWith(color: Colors.white))
          );
          break;

      /// 사용 끝 (인증 X)
        case 5:
          button = ElevatedButton(
              onPressed: () => _admit(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: MGColor.brandPrimary,
                  fixedSize: Size(
                      ratio.width * 145, ratio.height * 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
              ),
              child: Text("인증하기",
                  style: KR.parag1.copyWith(color: Colors.white))
          );
          break;

      /// 그 외
      /// - 사용 중 (연장 X)
      /// - 사용 끝 (인증 O)
        default:
          button = const SizedBox.shrink();
          break;
      }
    } else {
      button = const SizedBox.shrink();
    }


    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: ratio.width * 326,
        padding: EdgeInsets.symmetric(vertical: ratio.height * 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 이미지
            Container(
              width: ratio.height * 120,
              height: ratio.height * 120,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/$path.png')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))
              ),
            ),

            SizedBox(height: ratio.height * 16),

            /// 장소
            place,

            SizedBox(height: ratio.height * 20),

            /// 날짜 및 시간
            Column(
              children: [
                time1,
                SizedBox(height: ratio.height * 8),
                time2,
                if (statusMsg.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: ratio.height * 8),
                    child: Text(
                      statusMsg,
                      textAlign: TextAlign.center,
                      style: KR.label2.copyWith(color: MGColor.systemError),
                    )
                  )
              ],
            ),

            SizedBox(height: ratio.height * 20),

            /// 대표자
            Column(
              children: [
                Text("대표자", style: KR.parag2),
                SizedBox(height: ratio.height * 8),
                Text(item.leaderInfo, style: EN.parag2.copyWith(color: MGColor.base3)),
              ],
            ),

            SizedBox(height: ratio.height * 20),

            /// 사용 목적
            SizedBox(
              width: ratio.width * 220,
              child: Text(
                '나중에 바꾸기',
                textAlign: TextAlign.center,
                style: KR.label2.copyWith(color: MGColor.base3.withOpacity(0.6))
              )
            ),

            SizedBox(height: ratio.height * 28),

            /// 버튼
            /// 리더의 경우에만 됨
            button
          ]
        ),
      ),
    );
  }

  /// 예약 수정
  Future<void> _edit(BuildContext context) async {
    setLoading(true);
    Navigator.pop(context);
    List<String>? temp = await RestAPI.placeForService(item.service);
    debugPrint(temp.toString());
    setLoading(false);
    if (temp == null || temp.isEmpty) {
      late String place;
      switch (item.service) {
        case ServiceType.aiSpace:
          place = "회의실이";
          break;
        case ServiceType.lectureRoom:
          place = "강의실이";
          break;
        case ServiceType.computer:
          place = "컴퓨터가";
          break;
      }
      showDialog(
          context: context,
          builder: (ctx) => CommentPopup(
              title: '현재 예약 가능한 $place 없습니다.',
              onPressed: () => Navigator.pop(ctx)
          )
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ReservePage(
            item.service,
            availableRoom: temp,
            reserve: item
          )
        )
      );
    }
  }

  /// 예약 삭제
  void _del(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierColor: MGColor.barrier,
      builder: (context1) => AlertPopup(
          title: "예약을 취소하시겠습니까?",
          agreeMsg: "취소하기",
          onAgreed: () async {
            Navigator.pop(context1);
            try {
                int? uid = await RestAPI.delReservation(
                    reservationId: item.reservationId);
                if (uid == null) {
                  showDialog(
                      context: context,
                      barrierColor: MGColor.barrier,
                      builder: (context2) => CommentPopup(
                          title: "[Error] deleting reservation",
                          onPressed: () => Navigator.pop(context2)));
                } else {
                  showDialog(
                          context: context,
                          builder: (context2) => CommentPopup(
                              title: "예약이 취소되었습니다!",
                              onPressed: () => Navigator.pop(context2)))
                      .then((_) => listListener.add(StreamType.reserve));
                }
            } on TimeoutException {
              showDialog(
                  context: context,
                  barrierColor: MGColor.barrier,
                  builder: (context2) => CommentPopup(
                      title: "통신 속도가 너무 느립니다!",
                      onPressed: () => Navigator.pop(context2)));
            }
          }
      )
    );
  }

  /// QR 확인
  /// Todo: QR을 했다는 사실을 서버에 전송할 필요가 있지 않을까?
  void _qr(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)
      => QrScannerPage(reservationId: item.reservationId, room: item.place, onMatchedCode: () => Navigator.pop(context)))
    );
  }

  /// 예약 연장
  void _prolong(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierColor: MGColor.barrier,
      builder: (context1) => AlertPopup(
        title: '1시간 연장하시겠습니까?',
        agreeMsg: '연장하기',
        onAgreed: () async {
          Navigator.pop(context1);
          try {
            int? uid = await RestAPI.prolongReservation(
                reservationId: item.reservationId);
            if (uid == null) {
              showDialog(
                  context: context,
                  barrierColor: MGColor.barrier,
                  builder: (context2) => CommentPopup(
                      title: "[Error] prolonging reservation",
                      onPressed: () => Navigator.pop(context2)));
            } else {
              showDialog(
                  context: context,
                  builder: (context2) => CommentPopup(
                      title: "연장하기",
                      onPressed: () => Navigator.pop(context2))
              ).then((_) => listListener.add(StreamType.reserve));
            }
          } on TimeoutException {
            showDialog(
                context: context,
                barrierColor: MGColor.barrier,
                builder: (context2) => CommentPopup(
                    title: "통신 속도가 너무 느립니다!",
                    onPressed: () => Navigator.pop(context2)));
          }
        }
      )
    );
  }

  /// 인증으로
  void _admit(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => AdmitPage(reserve: item))
    );
  }
}

class AdmissionPopup extends StatelessWidget {
  const AdmissionPopup(this.item, {super.key});

  final Admit item;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: ratio.width * 326,
        padding: EdgeInsets.symmetric(vertical: ratio.height * 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Image
              GestureDetector(
                onTap: () => enlargePhoto(context),
                child: Container(
                  width: ratio.width * 246,
                  height: 200,
                  decoration: ShapeDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: MemoryImage(item.photo)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))
                  ),
                ),
              ),

              SizedBox(height: ratio.height * 16),

              /// 방
              Text(item.place, style: KR.subtitle1),

              SizedBox(height: ratio.height * 24),

              /// 날짜 및 시간
              Column(
                children: [
                  Text(item.date, style: KR.parag2.copyWith(color: MGColor.base3)),
                  SizedBox(height: ratio.height * 8),
                  Text(item.time, style: EN.parag2.copyWith(color: MGColor.base3)),
                ],
              ),

              SizedBox(height: ratio.height * 24),

              /// 대표자
              Column(
                children: [
                  Text("대표자", style: KR.parag2),
                  SizedBox(height: ratio.height * 8),
                  Text(item.leaderInfo, style: EN.parag2.copyWith(color: MGColor.base3)),
                ],
              ),

              SizedBox(height: ratio.height * 24),

              /// 사용 후기
              Container(
                constraints: BoxConstraints(
                  minWidth: ratio.width * 294,
                  minHeight: 60
                ),
                alignment: Alignment.topCenter,
                child: Text(
                  item.review,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 3,
                )
              ),

              SizedBox(height: ratio.height * 24),

              // 관리자 이용내역 평가
              if (item.me == '0')
                Container(
                    constraints: BoxConstraints(
                        minWidth: ratio.width * 294,
                        minHeight: 60
                    ),
                    alignment: Alignment.topCenter,
                    child: Text(
                      '확인된 인증입니다.',
                      style: KR.subtitle4.copyWith(color: MGColor.brandPrimary),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 3,
                    )
                )
              else if (item.me == '1')
                Container(
                    constraints: BoxConstraints(
                        minWidth: ratio.width * 294,
                        minHeight: 60
                    ),
                    alignment: Alignment.topCenter,
                    child: Text(
                      '경고를 받았습니다!',
                      style: KR.subtitle4.copyWith(color: MGColor.systemError),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 3,
                    )
                )
              else
                Container(
                    constraints: BoxConstraints(
                        minWidth: ratio.width * 294,
                        minHeight: 60
                    ),
                    alignment: Alignment.topCenter,
                    child: Text(
                      '아직 확인되지 않은 인증입니다.',
                      style: KR.subtitle4.copyWith(color: MGColor.base3),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 3,
                    )
                )
            ]
        ),
      ),
    );
  }

  void enlargePhoto(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) {
        return GestureDetector(
          child: Center(
            child: Image.memory(
              item.photo,
              height: ratio.height * 594,
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      }
    );
  }
}

class GradePopup extends StatelessWidget {
  const GradePopup({super.key});

  @override
  Widget build(BuildContext context) {
    bool showDuration = myInfo.rating != 3;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: ratio.width * 326,
          height: ratio.height * 560,
          padding: EdgeInsets.only(
            bottom: ratio.height * (myInfo.rating == 3 ? 68 : 32)),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: myInfo.ratingImg
            ),
            borderRadius: BorderRadius.circular(12)
          ),
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(myInfo.ratingName, style: EN.subtitle1),
            SizedBox(height: ratio.height * 40),
            if (myInfo.rating == 1)
              Text(
                '당신은 ${myInfo.ratingName} 등급입니다.\n2주간 예약을 할 수 없습니다.',
                style: KR.parag2.copyWith(color: MGColor.base2),
                textAlign: TextAlign.center,
              ),
            if (myInfo.rating == 2)
              Text(
                '당신은 ${myInfo.ratingName} 등급입니다.\n7일 예약을 할 수 없습니다.',
                style: KR.parag2.copyWith(color: MGColor.base2),
                textAlign: TextAlign.center,
              ),
            if (myInfo.rating == 3)
              Text(
                '당신은 ${myInfo.ratingName} 등급입니다.\n잘 하고 있어요!',
                style: KR.parag2.copyWith(color: MGColor.base2),
                textAlign: TextAlign.center,
              ),
            if (myInfo.rating == 4)
              Text(
                '당신은 ${myInfo.ratingName} 등급입니다.\n깨끗하게 사용중이네요!',
                style: KR.parag2.copyWith(color: MGColor.base2),
                textAlign: TextAlign.center,
              ),
            if (myInfo.rating == 5)
              Text(
                '당신은 ${myInfo.ratingName} 등급입니다.\n정말 깔끔해요!',
                style: KR.parag2.copyWith(color: MGColor.base2),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: ratio.height * 16),
            if (showDuration)
              Text(
                '등급 지속 시간: ${123}일',
                style: KR.parag2.copyWith(color: MGColor.brandPrimary),
              )
          ]),
        ),
      ),
    );
  }
}

class GradeExplainPopup extends StatelessWidget {
  const GradeExplainPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: ratio.width * 326,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.fromLTRB(
              ratio.width * 16,
              ratio.height * 26,
              ratio.width * 32,
              0
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: ratio.width * 70,
                    height: ratio. height * 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                         image: AssetImage(ImgPath.grayLv),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SizedBox(width: ratio.width * 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("GRAY",style: EN.subtitle2,),
                          SizedBox(
                            width: ratio.width * 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ratio.height * 1),
                            child: Text("경고",style: KR.grade3,),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ratio.height * 6.6,
                      ),
                      Text("한달에 10번 이상의 경고를 받음",style: KR.grade4,),
                      Text("2주간 예약 금지",style: KR.grade2,),
                    ],
                  ),
                ],
              ),

              SizedBox(height: ratio.height * 16),
              Divider(
                height: ratio.height * 1,
                color: MGColor.base6,
              ),
              SizedBox(height: ratio.height * 14),

              Row(
                children: [
                  Container(
                    width: ratio.width * 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/caution.png"),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SizedBox(width: ratio.width * 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("STONE",style: EN.subtitle2,),
                          SizedBox(
                            width: ratio.width * 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ratio.height * 1),
                            child: Text("주의",style: KR.grade3),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ratio.height * 6.6,
                      ),
                      Text("한달에 5번 이상의 경고를 받음",style: KR.grade4,),
                      Text("7일간 예약 금지",style: KR.grade2,),
                    ],
                  ),
                ],
              ),

              SizedBox(height: ratio.height * 16),
              Divider(
                height: ratio.height * 1,
                color: MGColor.base6,
              ),
              SizedBox(height: ratio.height * 14),

              Row(
                children: [
                  Container(
                    width: ratio.width * 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ImgPath.cobaltLv),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SizedBox(width: ratio.width * 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("COBALT",style: EN.subtitle2,),
                          SizedBox(
                            width: ratio.width * 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ratio.height * 1),
                            child: Text("기본",style: KR.grade5,),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ratio.height * 6.6,
                      ),
                      Text("기본 등급입니다",style: KR.grade4,),
                      Text("정말 깔끔하네요!",style: KR.grade6,),
                    ],
                  ),
                ],
              ),

              SizedBox(height: ratio.height * 16),
              Divider(
                height: ratio.height * 1,
                color: MGColor.base6,
              ),
              SizedBox(height: ratio.height * 14),

              Row(
                children: [
                  Container(
                    width: ratio.width * 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ImgPath.skyLv),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SizedBox(width: ratio.width * 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("SKY",style: EN.subtitle2,),
                          SizedBox(
                            width: ratio.width * 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ratio.height * 1),
                            child: Text("우수",style: KR.grade7,),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ratio.height * 6.6,
                      ),
                      Text("한 달에 7번 이상 우수한 사용을 함",style: KR.grade4,),
                      Text("예약 가능 시간 4시간으로 증가",style: KR.grade6,),
                    ],
                  ),
                ],
              ),

              SizedBox(height: ratio.height * 16),
              Divider(
                height: ratio.height * 1,
                color: MGColor.base6,
              ),
              SizedBox(height: ratio.height * 14),

              Row(
                children: [
                  Container(
                    width: ratio.width * 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ImgPath.aquaLv),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SizedBox(width: ratio.width * 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("AQUA",style: EN.subtitle2,),
                          SizedBox(
                            width: ratio.width * 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: ratio.height * 1),
                            child: Text("VIP",style: EN.grade7,),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ratio.height * 6.6,
                      ),
                      Text("한 달에 14번 이상 우수한 사용을 함",style: KR.grade4,),
                      Text("예약 가능 시간 5시간으로 증가",style: KR.grade6,),
                    ],
                  ),
                ],
              ),

              SizedBox(height: ratio.height * 26),

              _gradeButton(context),
              TextButton(child: Text("하루 동안 보지 않기",style: KR.grade1), onPressed: () => Navigator.pop(context),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _gradeButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.25),
            builder: (context) => const GradePopup()
        );
      },
      child: Container(
        width: 301,
        height: 40,
        decoration: BoxDecoration(
          color: MGColor.brandPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
              "내 등급 확인하기",
              style: KR.grade8
          ),
        ),
      ),
    );
  }
}

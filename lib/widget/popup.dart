import 'package:flutter/material.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/services/admit.dart';
import 'package:mata_gachon/page/services/reservate.dart';

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
        height: ratio.height * 180,
        padding: EdgeInsets.fromLTRB(
          ratio.width * 12,
          ratio.height * 40,
          ratio.width * 12,
          ratio.height * 12
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
                    backgroundColor: MGcolor.base6,
                    fixedSize: Size(ratio.width * 147, ratio.height * 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text("닫기", style: KR.parag2.copyWith(color: MGcolor.base3)),
                ),
                SizedBox(width: ratio.width * 8),
                ElevatedButton(
                  onPressed: onAgreed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.btn_active,
                      fixedSize: Size(ratio.width * 147, ratio.height * 40),
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
  const CommentPopup({
    super.key,
    required this.title,
    this.buttonMsg = "확인",
    required this.onPressed
  });

  final String title;
  final String buttonMsg;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            ratio.width * 12,
            ratio.height * 40,
            ratio.width * 12,
            ratio.height * 12
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: KR.subtitle4),
            SizedBox(height: ratio.height * 40),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: MGcolor.btn_active,
                fixedSize: Size(ratio.width * 302, ratio.height * 40),
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
  const ReservationPopup(this.item, {super.key});

  final Reservate item;

  static bool waiting = true;
  static bool qr = false;
  static bool prolong = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: ratio.width * 326,
        padding: EdgeInsets.symmetric(vertical: ratio.height * 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ratio.height * 120,
              height: ratio.height * 120,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(ImgPath.home_img4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))
              ),
            ),
            SizedBox(height: ratio.height * 16),
            Text(item.room, style: KR.subtitle1),
            SizedBox(height: ratio.height * 24),
            Column(
              children: [
                Text(item.date, style: KR.parag2.copyWith(color: MGcolor.base3)),
                SizedBox(height: ratio.height * 8),
                Text(item.time, style: EN.parag2.copyWith(color: MGcolor.base3)),
                if (qr)
                  ...[
                    SizedBox(height: ratio.height * 8),
                    Text(
                      '회의실 사용 시간이 다 되었어요.\n회의실에서 QR코드 인증을 해주세요!',
                      style: KR.label2.copyWith(color: MGcolor.system_error),
                      textAlign: TextAlign.center,
                    )
                  ],
                if (prolong)
                  ...[
                    SizedBox(height: ratio.height * 8),
                    Text(
                      '현재 회의실을 사용중이에요!\n남은 시간 : 85분',
                      style: KR.label2.copyWith(color: MGcolor.system_error),
                      textAlign: TextAlign.center,
                    )
                  ]
              ],
            ),
            SizedBox(height: ratio.height * 24),
            Column(
              children: [
                Text("대표자", style: KR.parag2),
                SizedBox(height: ratio.height * 8),
                Text(item.leaderInfo, style: EN.parag2.copyWith(color: MGcolor.base3)),
              ],
            ),
            SizedBox(height: ratio.height * 30),
            Column(children:
            waiting ? [
              ElevatedButton(
                onPressed: () => _editReservation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MGcolor.btn_active,
                  fixedSize: Size(ratio.width * 145, ratio.height * 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
                ),
                child: Text("예약 수정하기", style: KR.parag1.copyWith(color: Colors.white))
              ),
              TextButton(
                onPressed: () => _delReservation(context),
                style: TextButton.styleFrom(
                  fixedSize: Size(ratio.width * 145, ratio.height * 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
                ),
                child: Text("예약 취소하기", style: KR.parag1.copyWith(color: MGcolor.base3))
              ),
              ElevatedButton(
                  onPressed: () => _admit(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.btn_active,
                      fixedSize: Size(ratio.width * 145, ratio.height * 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text("※ 인증하기 ※", style: KR.parag1.copyWith(color: Colors.white))
              ),
            ] : qr ? [
              ElevatedButton(
                onPressed: () => _validateQR,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MGcolor.btn_active,
                  fixedSize: Size(ratio.width * 145, ratio.height * 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
                ),
                child: Text("QR 코드 인증하기", style: KR.parag1.copyWith(color: Colors.white))
              ),
            ] : prolong ? [
              ElevatedButton(
                onPressed: () => _prolong,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MGcolor.btn_active,
                  fixedSize: Size(ratio.width * 145, ratio.height * 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
                ),
                child: Text("예약 연장하기", style: KR.parag1.copyWith(color: Colors.white))
              ),
            ] : []
            )
          ]
        ),
      ),
    );
  }

  void _editReservation(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReservatePage(reservate: item)));
  }

  void _delReservation(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertPopup(
          title: "예약을 취소하시겠습니까?",
          agreeMsg: "취소하기",
          onAgreed: () async {
            Navigator.pop(context);
            int? uid = await RestAPI.delReservation(reservationId: item.reservationId);
            if (uid == null) {
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.25),
                builder: (context) => CommentPopup(
                  title: "[Error] deleting reservation",
                  onPressed: () => Navigator.pop(context)
                )
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => CommentPopup(
                  title: "예약이 취소되었습니다!",
                  onPressed: () => Navigator.pop(context)
                )
              ).then((_) => listListener.add(StreamType.reservate));
            }
          }
      )
    );
  }

  void _validateQR() {

  }

  void _prolong() {

  }

  void _admit(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => AdmitPage(reservate: item))
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
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => enlargePhoto(context),
                child: Container(
                  width: ratio.height * 246,
                  height: ratio.height * 200,
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
              Text(item.room, style: KR.subtitle1),
              SizedBox(height: ratio.height * 24),
              Column(
                children: [
                  Text(item.date, style: KR.parag2.copyWith(color: MGcolor.base3)),
                  SizedBox(height: ratio.height * 8),
                  Text(item.time, style: EN.parag2.copyWith(color: MGcolor.base3)),
                ],
              ),
              SizedBox(height: ratio.height * 24),
              Column(
                children: [
                  Text("대표자", style: KR.parag2),
                  SizedBox(height: ratio.height * 8),
                  Text(item.leaderInfo, style: EN.parag2.copyWith(color: MGcolor.base3)),
                ],
              ),
              SizedBox(height: ratio.height * 24),
              Container(
                constraints: BoxConstraints(
                  minWidth: ratio.width * 294,
                  minHeight: ratio.height * 60
                ),
                alignment: Alignment.topCenter,
                child: Text(
                  item.review,
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
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: ratio.height * 150,
            bottom: ratio.height * 44
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.memory(
                item.photo,
                height: ratio.height * 594,
                fit: BoxFit.fitWidth,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  foregroundColor: MGcolor.btn_active,
                  backgroundColor: MGcolor.btn_inactive,
                  fixedSize: Size(ratio.width * 48, ratio.width * 48)
                ),
                icon: Icon(AppinIcon.cross)
              )
            ]
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(myInfo.ratingName, style: EN.subtitle1),
              SizedBox(height: ratio.height * 40),
              Text(
                '당신은 ${myInfo.ratingName} 등급입니다.\n정말 깔끔하네요!',
                style: KR.parag2.copyWith(color: MGcolor.base2),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ratio.height * 16),
              if (showDuration)
                Text(
                  '등급 지속 시간: ${123}일',
                  style: KR.parag2.copyWith(color: MGcolor.brand_orig),
                )
            ]
          ),
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/admit_page.dart';
import 'package:mata_gachon/pages/reservate_page.dart';
import 'package:mata_gachon/pages/using_camera_page.dart';

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
                    backgroundColor: MGcolor.base7,
                    fixedSize: Size(ratio.width * 147, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text("닫기", style: KR.parag2.copyWith(color: MGcolor.base3)),
                ),
                SizedBox(width: ratio.width * 8),
                ElevatedButton(
                  onPressed: onAgreed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.primaryColor(),
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
      child: Container(
        height: 156,
        padding: EdgeInsets.fromLTRB(
            ratio.width * 12,
            40,
            ratio.width * 12,
            12
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: KR.subtitle4),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: MGcolor.primaryColor(),
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
  const ReservationPopup(this.item, this.status, {super.key});

  final Reservate item;
  final int status;

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
            /// 이미지
            Container(
              width: ratio.height * 120,
              height: ratio.height * 120,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(ImgPath.home_img4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))
              ),
            ),

            SizedBox(height: ratio.height * 16),

            /// 장소
            Text(item.room, style: KR.subtitle1),

            SizedBox(height: ratio.height * 20),

            /// 날짜 및 시간
            Column(
              children: [
                Text(item.date, style: KR.parag2.copyWith(color: MGcolor.base3)),
                SizedBox(height: ratio.height * 8),
                Text(item.time, style: EN.parag2.copyWith(color: MGcolor.base3)),
                Builder(builder: (context) {
                  late String msg;
                  switch (status) {
                    case 1:
                      msg = '곧 있음 예약한 시간이에요.\n회의실에서 QR코드 인증을 해주세요!';
                      break;
                    case 2:
                      msg = '현재 회의실을 사용 중이에요!';
                      break;
                    case 3:
                      msg = '곧 있음 이용 시간이 끝납니다.';
                      break;
                    case 4:
                      msg = '회의실 사용이 끝났습니다.\n사용 후 인증을 해주세요!';
                      break;
                    default:
                      return SizedBox.shrink();
                  }
                  return Padding(
                      padding: EdgeInsets.only(top: ratio.height * 8),
                      child: Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: KR.label2.copyWith(color: MGcolor.systemError),
                      )
                  );
                })
              ],
            ),

            SizedBox(height: ratio.height * 20),

            /// 대표자
            Column(
              children: [
                Text("대표자", style: KR.parag2),
                SizedBox(height: ratio.height * 8),
                Text(item.leaderInfo, style: EN.parag2.copyWith(color: MGcolor.base3)),
              ],
            ),

            SizedBox(height: ratio.height * 20),

            /// 사용 목적
            SizedBox(
              width: ratio.width * 220,
              child: Text(
                '나중에 바꾸기',
                textAlign: TextAlign.center,
                style: KR.label2.copyWith(color: MGcolor.base3.withOpacity(0.6))
              )
            ),

            SizedBox(height: ratio.height * 28),

            /// 버튼
            /// 리더의 경우에만 됨
            Builder(builder: (context) {
              if (myInfo.match(item.leaderInfo)) {
                switch (status) {
                /// 사용 전 (예약 변경 O)
                  case 1:
                    return Column(children: [
                      ElevatedButton(
                          onPressed: () => _edit(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MGcolor.primaryColor(),
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
                              color: MGcolor.base3))
                      )
                    ]);

                /// 사용 전 (예약 변경 X)
                  case 0:
                    return ElevatedButton(
                        onPressed: () => _qr,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MGcolor.primaryColor(),
                            fixedSize: Size(
                                ratio.width * 145, ratio.height * 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))
                        ),
                        child: Text("QR 코드 인증하기",
                            style: KR.parag1.copyWith(color: Colors.white))
                    );

                /// 사용 중 (연장 O)
                  case 3:
                    return ElevatedButton(
                        onPressed: () => _prolong,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MGcolor.primaryColor(),
                            fixedSize: Size(
                                ratio.width * 145, ratio.height * 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))
                        ),
                        child: Text("예약 연장하기",
                            style: KR.parag1.copyWith(color: Colors.white))
                    );

                /// 사용 끝 (인증 X)
                  case 4:
                    return ElevatedButton(
                        onPressed: () => _admit(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MGcolor.primaryColor(),
                            fixedSize: Size(
                                ratio.width * 145, ratio.height * 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))
                        ),
                        child: Text("인증하기",
                            style: KR.parag1.copyWith(color: Colors.white))
                    );

                /// 그 외
                /// - 사용 중 (연장 X)
                /// - 사용 끝 (인증 O)
                  default:
                    return SizedBox.shrink();
                }
              } else return SizedBox.shrink();
            })
          ]
        ),
      ),
    );
  }

  // 예약 수정
  void _edit(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReservatePage(reservate: item)));
  }

  // 예약 삭제
  void _del(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertPopup(
          title: "예약을 취소하시겠습니까?",
          agreeMsg: "취소하기",
          onAgreed: () async {
            Navigator.pop(context);
            try {
                int? uid = await RestAPI.delReservation(
                    reservationId: item.reservationId);
                if (uid == null) {
                  showDialog(
                      context: context,
                      barrierColor: MGcolor.barrier,
                      builder: (context) => CommentPopup(
                          title: "[Error] deleting reservation",
                          onPressed: () => Navigator.pop(context)));
                } else {
                  showDialog(
                          context: context,
                          builder: (context) => CommentPopup(
                              title: "예약이 취소되었습니다!",
                              onPressed: () => Navigator.pop(context)))
                      .then((_) => listListener.add(StreamType.reservate));
                }
            } on TimeoutException {
              showDialog(
                  context: context,
                  barrierColor: MGcolor.barrier,
                  builder: (context) => CommentPopup(
                      title: "통신 속도가 너무 느립니다!",
                      onPressed: () => Navigator.pop(context)));
            }
          }
      )
    );
  }

  // QR 확인
  // Todo: QR을 했다는 사실을 서버에 전송할 필요가 있지 않을까?
  void _qr(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context)
      => QrScannerPage(onMatchedCode: () => Navigator.pop(context)))
    );
  }

  // 예약 연장
  void _prolong(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierColor: MGcolor.barrier,
      builder: (context) => AlertPopup(
        title: '1시간 연장하시겠습니까?',
        agreeMsg: '연장하기',
        onAgreed: () async {
          Navigator.pop(context);
          try {
            int? uid = await RestAPI.prolongReservation(
                reservationId: item.reservationId);
            if (uid == null) {
              showDialog(
                  context: context,
                  barrierColor: MGcolor.barrier,
                  builder: (context) => CommentPopup(
                      title: "[Error] prolonging reservation",
                      onPressed: () => Navigator.pop(context)));
            } else {
              showDialog(
                  context: context,
                  builder: (context) => CommentPopup(
                      title: "연장하기",
                      onPressed: () => Navigator.pop(context)))
                  .then((_) => listListener.add(StreamType.reservate));
            }
          } on TimeoutException {
            showDialog(
                context: context,
                barrierColor: MGcolor.barrier,
                builder: (context) => CommentPopup(
                    title: "통신 속도가 너무 느립니다!",
                    onPressed: () => Navigator.pop(context)));
          }
        }
      )
    );
  }

  // 인증으로
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
              Text(item.room, style: KR.subtitle1),

              SizedBox(height: ratio.height * 24),

              /// 날짜 및 시간
              Column(
                children: [
                  Text(item.date, style: KR.parag2.copyWith(color: MGcolor.base3)),
                  SizedBox(height: ratio.height * 8),
                  Text(item.time, style: EN.parag2.copyWith(color: MGcolor.base3)),
                ],
              ),

              SizedBox(height: ratio.height * 24),

              /// 대표자
              Column(
                children: [
                  Text("대표자", style: KR.parag2),
                  SizedBox(height: ratio.height * 8),
                  Text(item.leaderInfo, style: EN.parag2.copyWith(color: MGcolor.base3)),
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
              )
            ]
        ),
      ),
    );
  }

  void enlargePhoto(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  foregroundColor: MGcolor.primaryColor(),
                  backgroundColor: MGcolor.tertiaryColor(),
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
                  style: KR.parag2.copyWith(color: MGcolor.primaryColor()),
                )
            ]
          ),
        ),
      ),
    );
  }
}
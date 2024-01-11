///
/// 타인 인증 리스트 위젯 (AnotherGuyWidget)
/// 내 인증 리스트 위젯(myReservationWidget)
/// 팝업 위젯 (popUpWidget)
/// 예약 취소 위젯 (CancelPopUp)
///

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mata_gachon/config/server.dart';

import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/services/reservation.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      width: screen.width,
      height: screen.height,
      color: Colors.black.withOpacity(0.25),
      alignment: Alignment.center,
      child: SizedBox(
          width: ratio.width * 48,
          height: ratio.height * 48,
          child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}

class CustomListItem extends StatelessWidget {
  CustomListItem(
      {super.key,
      required this.uid,
      required this.where,
      required this.name,
      required this.begin,
      required this.duration,
      this.admission}) {
    this._yMdE = yMdE_format.format(begin);
    this._begin_end = admission == null
        ? "${Hm_format.format(begin)} ~ ${Hm_format.format(begin.add(duration))}"
        : "${Hm_format.format(begin)}";
  }

  final String uid;
  final String where;
  final String name;
  final DateTime begin;
  final Duration duration;
  final bool? admission;
  late final String _yMdE;
  late final String _begin_end;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCard(context),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ratio.height * 4),
        padding: EdgeInsets.symmetric(
            horizontal: ratio.width * 16, vertical: ratio.height * 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(where, style: KR.subtitle1),
                SizedBox(height: ratio.height * 8),
                Text(_yMdE, style: KR.parag2.copyWith(color: MGcolor.base3)),
                Text(_begin_end,
                    style: KR.parag2.copyWith(color: MGcolor.base3))
              ],
            ),
            if (admission == null)
              Transform.translate(
                offset: Offset(0, -(ratio.height * 21)),
                child: Transform.rotate(
                  angle: pi,
                  child: Icon(
                    AppinIcon.back,
                    size: 24,
                    color: MGcolor.base3,
                  ),
                ),
              )
            else
              Container(
                  width: ratio.height * 74,
                  height: ratio.height * 74,
                  decoration: BoxDecoration(
                      color: MGcolor.base4,
                      borderRadius: BorderRadius.circular(8)))
          ],
        ),
      ),
    );
  }

  void showCard(BuildContext ctx) => showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return PopUpWidget(
            uid: this.uid,
            where: where,
            name: name,
            date: _yMdE,
            time: _begin_end,
            isMine: admission == null,
          );
        },
      );
}

class PopUpWidget extends StatelessWidget {
  const PopUpWidget(
      {Key? key,
      required this.uid,
      required this.where,
      required this.name,
      required this.date,
      required this.time,
      required this.isMine})
      : super(key: key);

  final String uid;
  final String where;
  final String name;
  final String date;
  final String time;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: (isMine ? 90 : 40) * ratio.width,
              vertical: 30 * ratio.height),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isMine
                    ? Image.asset(ImgPath.home_img4, height: ratio.height * 120)
                    : Container(
                        color: MGcolor.base4,
                        height: ratio.height * 200,
                        width: ratio.width * 246),
              ),
              SizedBox(height: ratio.height * 16),
              Text(where, style: KR.subtitle1),
              SizedBox(height: ratio.height * 24),
              Column(
                children: [
                  Text(date, style: KR.parag2.copyWith(color: MGcolor.base3)),
                  SizedBox(height: ratio.height * 8),
                  Text(time, style: KR.parag2.copyWith(color: MGcolor.base3)),
                ],
              ),
              SizedBox(height: ratio.height * 24),
              Column(
                children: [
                  Text('대표자', style: KR.parag2),
                  SizedBox(height: ratio.height * 8),
                  Text(name, style: KR.parag2.copyWith(color: MGcolor.base3)),
                ],
              ),
              if (isMine) ...[
                SizedBox(height: ratio.height * 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Reservation())
                  );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.btn_active,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(ratio.width * 160, ratio.height * 40)),
                  child: Text(
                    '예약 수정하기',
                    style: KR.parag2.copyWith(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          CancelPopUp(uid: this.uid, accept: false),
                    );
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(ratio.width * 160, ratio.height * 40)),
                  child: Text('예약 취소하기',
                      style: KR.parag2.copyWith(color: MGcolor.base3)),
                ),
              ] else ...[
                SizedBox(height: ratio.height * 24),
                ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ratio.height * 60),
                    child: Text('깨끗하게 잘 사용하고 나왔습니다!', style: KR.parag2)),
              ],
            ],
          ),
        ));
  }
}

class CancelPopUp extends StatelessWidget {
  const CancelPopUp({
    Key? key,
    required this.uid,
    required this.accept
  }) : super(key: key);

  final String uid;
  final bool accept; // 취소하기 버튼 누를 시 뜨는 팝업

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.fromLTRB(ratio.width * 12, ratio.height * 40,
              ratio.width * 12, ratio.height * 12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              accept ? '예약이 최소되었습니다!' : '예약을 취소하시겠습니까?',
              style: KR.subtitle2,
            ),
            SizedBox(height: ratio.height * 40),
            if (accept)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: MGcolor.brand_orig,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size(ratio.width * 302, ratio.height * 40)),
                child:
                    Text('확인', style: KR.parag1.copyWith(color: Colors.white)),
              )
            else
              Row(mainAxisSize: MainAxisSize.min, children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.base6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(ratio.width * 147, ratio.height * 40)),
                  child: Text('닫기',
                      style: KR.parag1.copyWith(color: MGcolor.base3)),
                ),
                SizedBox(width: ratio.width * 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    books.removeWhere((e) => e.reservationID == this.uid);
                    print(books);
                    listListener.add('reservation');
                    showDialog(
                      context: context,
                      builder: (context) => CancelPopUp(uid: this.uid, accept: true)
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.brand_orig,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(ratio.width * 147, ratio.height * 40)),
                  child: Text('확인하기',
                      style: KR.parag1.copyWith(color: Colors.white)),
                )
              ])
          ])
          // actions: [
          //   Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(12)),
          //     width: ratio.width * 326,
          //     height: ratio.height * 156,
          //     child: Column(
          //       children: [
          //         accept
          //             ? TextButton(
          //                 onPressed: () => Navigator.of(context).pop(),
          //                 child: Container(
          //                   height: ratio.height * 40,
          //                   decoration: ShapeDecoration(
          //                     color: MGcolor.brand_orig,
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(10),
          //                     ),
          //                   ),
          //                   child: Center(
          //                     child: Text(
          //                       '확인',
          //                       textAlign: TextAlign.center,
          //                       style: KR.parag2.copyWith(color: Colors.white)
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             : Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   TextButton(
          //                     onPressed: () {
          //                       Navigator.of(context).pop();
          //                     },
          //                     child: Container(
          //                       width: ratio.width * 147,
          //                       height: ratio.height * 40,
          //                       decoration: ShapeDecoration(
          //                         color: MGcolor.base6,
          //                         shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(10),
          //                         ),
          //                       ),
          //                       child: Center(
          //                         child: Text(
          //                           '닫기',
          //                           textAlign: TextAlign.center,
          //                           style: KR.parag2.copyWith(color: MGcolor.base3)
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   TextButton(
          //                     onPressed: () {
          //                       Navigator.of(context).pop();
          //                       showDialog(
          //                         context: context,
          //                         barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
          //                         builder: (BuildContext context) {
          //                           return CancelPopUp(
          //                             accept: true,
          //                           );
          //                         },
          //                       );
          //                     },
          //                     child: Container(
          //                       width: ratio.width * 147,
          //                       height: ratio.height * 40,
          //                       decoration: ShapeDecoration(
          //                         color: MGcolor.brand_orig,
          //                         shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(10),
          //                         ),
          //                       ),
          //                       child: Center(
          //                         child: Text(
          //                           '취소하기',
          //                           textAlign: TextAlign.center,
          //                           style: KR.parag2.copyWith(color: Colors.white)
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //       ],
          //     ),
          //   ),
          // ],
          ),
    );
  }
}

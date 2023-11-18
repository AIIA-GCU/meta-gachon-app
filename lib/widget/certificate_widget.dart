/// 타인 인증 리스트 위젯 (AnotherGuyWidget)
/// 내 인증 리스트 위젯(myReservationWidget)
/// 팝업 위젯 (popUpWidget)
/// 예약 취소 위젯 (CancelPopUp)
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mata_gachon/page/services/check_my_certification.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

import '../config/function.dart';
import '../config/variable.dart';

class AnotherGuyWidget extends StatelessWidget {
  const AnotherGuyWidget(
      {Key? key,
      required this.where,
      required this.name,
      required this.date,
      required this.time})
      : super(key: key);

  final String where;
  final String name;
  final String date;
  final String time;

  void showCard(BuildContext ctx) => showDialog(
    context: ctx,
    barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
    builder: (BuildContext context) {
      return PopUpWidget(
        where: where,
        name: name,
        date: date,
        time: time,
        isMine: false,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
          builder: (BuildContext context) {
            return PopUpWidget(
              where: where,
              name: name,
              date: date,
              time: time,
              isMine: false,
            );
          },
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      where,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: flexibleSize(context, Size.fromHeight(19)).height,
                      ),
                    ),
                    Container(
                      height: flexibleSize(context, Size.fromHeight(8)).height,
                    ),
                    AutoSizeText(name,
                        style: TextStyle(
                          fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                        )),
                    AutoSizeText(date,
                        style: TextStyle(
                          fontSize:flexibleSize(context, Size.fromHeight(14)).height,
                        )),
                  ],
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MGcolor.base4,
                  ),
                  height:flexibleSize(context, Size.fromHeight(74)).height,
                  width:flexibleSize(context, Size.fromHeight(74)).height,
                )
              ],
            ),
          ),
          Container(
            height: flexibleSize(context, Size.fromHeight(12)).height,
          ),
        ],
      ),
    );
  }
}

class MyReservationWidget extends StatelessWidget {
  const MyReservationWidget(
      {Key? key,
      required this.where,
      required this.time,
      required this.date,
      required this.name})
      : super(key: key);

  final String where;
  final String time;
  final String name;
  final String date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
          builder: (BuildContext context) {
            return PopUpWidget(
                where: where, name: name, date: date, time: time, isMine: true);
          },
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            height: flexibleSize(context, Size.fromHeight(98)).height,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      where,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: flexibleSize(context, Size.fromHeight(19)).height,
                      ),
                    ),
                    Container(
                      height: flexibleSize(context, Size.fromHeight(8)).height,
                    ),
                    AutoSizeText(date,
                        style: TextStyle(
                          fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                          fontWeight: FontWeight.w400,
                          color: MGcolor.base3,
                        )),
                    AutoSizeText(time,
                        style: TextStyle(
                          fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                          fontWeight: FontWeight.w400,
                          color: MGcolor.base3,
                        )),
                  ],
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Transform.translate(
                  offset: Offset(
                    0,
                    -1 * flexibleSize(context, Size.fromHeight(21)).height,
                  ),
                  child: Transform.rotate(
                    angle: 180 * pi / 180,
                    child: Icon(
                      AppinIcon.back,
                      size: flexibleSize(context, Size.fromHeight(24)).height,
                      color: MGcolor.base3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: flexibleSize(context, Size.fromHeight(12)).height,
          ),
        ],
      ),
    );
  }
}

class PopUpWidget extends StatelessWidget {
  const PopUpWidget(
      {Key? key,
      required this.where,
      required this.name,
      required this.date,
      required this.time,
      required this.isMine})
      : super(key: key);

  final String where;
  final String name;
  final String date;
  final String time;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        vertical: flexibleSize(context, Size.fromHeight(30)).height,
        horizontal: flexibleSize(context, Size.fromWidth(16)).width,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          width: flexibleSize(context, Size.fromWidth(326)).width,
          height: isMine
              ? flexibleSize(context, Size.fromHeight(456)).height
              : flexibleSize(context, Size.fromHeight(518)).height,
          child: Container(
            margin: isMine
                ? EdgeInsets.symmetric(
              horizontal:flexibleSize(context, Size.fromWidth(91)).width,
            )
                : EdgeInsets.symmetric(
              horizontal:flexibleSize(context, Size.fromWidth(1)).width,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    flexibleSize(context, Size.fromWidth(12)).width,
                    flexibleSize(context, Size.fromHeight(25)).height,
                    flexibleSize(context, Size.fromWidth(12)).width,
                    0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: isMine
                        ? Image.asset(
                      ImgPath.home_img4,
                      height: flexibleSize(context, Size.fromHeight(120)).height,
                    )
                        : Container(
                      color: MGcolor.base4,
                      height: flexibleSize(context, Size.fromHeight(200)).height,
                      width: flexibleSize(context, Size.fromWidth(246)).width,
                    ),
                  ),
                ),
                Container(
                  height:flexibleSize(context, Size.fromHeight(16)).height,
                ),
                AutoSizeText(
                  where,
                  style: TextStyle(
                    color: MGcolor.base1,
                    fontSize:flexibleSize(context, Size.fromHeight(18)).height,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height:flexibleSize(context, Size.fromHeight(24)).height,
                ),
                AutoSizeText(
                  date,
                  style: TextStyle(
                    color: MGcolor.base3,
                    fontSize:flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  height:flexibleSize(context, Size.fromWidth(8)).width,
                ),
                AutoSizeText(
                  time,
                  style: TextStyle(
                    color: MGcolor.base3,
                    fontSize:flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  height:flexibleSize(context, Size.fromHeight(24)).height,
                ),
                AutoSizeText(
                  '대표자',
                  style: TextStyle(
                    color: MGcolor.base1,
                    fontSize:flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  height:flexibleSize(context, Size.fromHeight(8)).height,
                ),
                AutoSizeText(
                  name,
                  style: TextStyle(
                    color: MGcolor.base3,
                    fontSize:flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                isMine
                    ? Column(
                  children: [
                    Container(
                      height: flexibleSize(context, Size.fromHeight(30)).height,
                    ),
                    PageMigrateButton(
                      targetPage: MyCertification(),
                      text: '예약 수정하기',
                      color: MGcolor.brand_orig,
                      fontcolor: Colors.white,
                    ),
                    Container(
                      height: flexibleSize(context, Size.fromHeight(12)).height,
                    ),
                    Container(
                      width: flexibleSize(context, Size.fromWidth(159))
                          .width,
                      height: flexibleSize(context, Size.fromHeight(40))
                          .height,
                      child: TextButton(
                        onPressed: () {

                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                            builder: (BuildContext context) {
                              return CancelPopUp(
                                accept: false,
                              );
                            },
                          );
                        },
                        child: Text(
                          '예약 취소하기',
                          style: TextStyle(
                              color: MGcolor.base3,
                              fontSize: flexibleSize(
                                  context, Size.fromHeight(14))
                                  .height,
                            fontWeight: FontWeight.w400,),
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    Container(
                      height: flexibleSize(context, Size.fromHeight(24)).height,
                    ),
                    Text(
                      '깨끗하게 잘 사용하고 나왔습니다!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MGcolor.base1,
                        fontSize:flexibleSize(context, Size.fromHeight(14)).height,
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CancelPopUp extends StatelessWidget {
  const CancelPopUp({Key? key, required this.accept}) : super(key: key);

  final bool accept; // 취소하기 버튼 누를 시 뜨는 팝업
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        vertical: flexibleSize(context, Size.fromHeight(30)).height,
        horizontal: flexibleSize(context, Size.fromWidth(16)).width,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          width: flexibleSize(context, Size.fromWidth(326)).width,
          height: flexibleSize(context, Size.fromHeight(156)).height,
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    flexibleSize(context, Size.fromWidth(64)).width,
                    flexibleSize(context, Size.fromHeight(40)).height,
                    flexibleSize(context, Size.fromWidth(64)).width,
                    0,
                  ),
                  child: accept
                      ? Text(
                    '예약이 취소되었습니다!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MGcolor.base1,
                      fontSize: flexibleSize(context, Size.fromHeight(16))
                          .height,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      : Text(
                    '예약을 취소하시겠습니까?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MGcolor.base1,
                      fontSize: flexibleSize(context, Size.fromHeight(16))
                          .height,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                accept
                    ? TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height:
                    flexibleSize(context, Size.fromHeight(40)).height,
                    decoration: ShapeDecoration(
                      color: MGcolor.brand_orig,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '확인',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                          flexibleSize(context, Size.fromHeight(14))
                              .height,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: flexibleSize(context, Size.fromWidth(147))
                            .width,
                        height: flexibleSize(context, Size.fromHeight(40))
                            .height,
                        decoration: ShapeDecoration(
                          color: MGcolor.base6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '닫기',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MGcolor.base3,
                              fontSize: flexibleSize(
                                  context, Size.fromHeight(14))
                                  .height,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                          builder: (BuildContext context) {
                            return CancelPopUp(
                              accept: true,
                            );
                          },
                        );
                      },
                      child: Container(
                        width: flexibleSize(context, Size.fromWidth(147))
                            .width,
                        height: flexibleSize(context, Size.fromHeight(40))
                            .height,
                        decoration: ShapeDecoration(
                          color: MGcolor.brand_orig,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '취소하기',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: MGcolor.base7,
                              fontSize: flexibleSize(
                                  context, Size.fromHeight(14))
                                  .height,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

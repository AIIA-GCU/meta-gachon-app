/// 타인 인증 리스트 위젯 (AnotherGuyWidget)
/// 내 인증 리스트 위젯(myReservationWidget)
/// 팝업 위젯 (popUpWidget)
/// 예약 취소 위젯 (CancelPopUp)
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mata_gachon/page/certificate_page/check_my_certification.dart';
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
                    Text(
                      where,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize:
                        flexibleSize(context, Size.fromHeight(19)).height,
                      ),
                    ),
                    Container(
                      height: flexibleSize(context, Size.fromHeight(8)).height,
                    ),
                    Text(name,
                        style: TextStyle(
                          fontSize:
                          flexibleSize(context, Size.fromHeight(14)).height,
                        )),
                    Text(date,
                        style: TextStyle(
                          fontSize:
                          flexibleSize(context, Size.fromHeight(14)).height,
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
                  height: flexibleSize(context, Size.fromHeight(74)).height,
                  width: flexibleSize(context, Size.fromHeight(74)).height,
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
                    Text(
                      where,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize:
                        flexibleSize(context, Size.fromHeight(19)).height,
                      ),
                    ),
                    Container(
                      height: flexibleSize(context, Size.fromHeight(8)).height,
                    ),
                    Text(date,
                        style: TextStyle(
                          fontSize:
                          flexibleSize(context, Size.fromHeight(14)).height,
                          fontWeight: FontWeight.w400,
                          color: MGcolor.base3,
                        )),
                    Text(time,
                        style: TextStyle(
                          fontSize:
                          flexibleSize(context, Size.fromHeight(14)).height,
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

class PopUpWidget extends StatefulWidget {
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
  State<PopUpWidget> createState() => _PopUpWidgetState();
}

class _PopUpWidgetState extends State<PopUpWidget> {
  bool isTimeExceed = false;
  bool isUsingRoom = false;
  bool canExtend = false;

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
          height: widget.isMine
              ? isUsingRoom
              ? canExtend
              ? flexibleSize(context, Size.fromHeight(468)).height
              : flexibleSize(context, Size.fromHeight(398)).height
              : isTimeExceed
              ? flexibleSize(context, Size.fromHeight(468)).height
              : flexibleSize(context, Size.fromHeight(456)).height
              : flexibleSize(context, Size.fromHeight(518)).height,
          child: Container(
            margin: widget.isMine
                ? EdgeInsets.symmetric(
              horizontal: flexibleSize(context, Size.fromWidth(72)).width,
            )
                : EdgeInsets.symmetric(
              horizontal: flexibleSize(context, Size.fromWidth(1)).width,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isUsingRoom = false;
                      isTimeExceed =
                      !isTimeExceed; //이미지 사진 클릭시 시간 만료 팝업으로 변경됨 Stateless -> Stateful로 변경한 이유(추후 필요없을 시 Stateless로 변경해도 됨)
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      isTimeExceed = false;
                      isUsingRoom =
                      !isUsingRoom; //이미지 사진 더블 클릭시 회의실 사용 중 팝업으로 변경됨 Stateless -> Stateful로 변경한 이유(추후 필요없을 시 Stateless로 변경해도 됨)
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      isTimeExceed = false;
                      canExtend = !canExtend;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      flexibleSize(context, Size.fromWidth(12)).width,
                      flexibleSize(context, Size.fromHeight(25)).height,
                      flexibleSize(context, Size.fromWidth(12)).width,
                      0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.isMine
                          ? Image.asset(
                        ImgPath.home_img4,
                        height:
                        flexibleSize(context, Size.fromHeight(120))
                            .height,
                      )
                          : Container(
                        color: MGcolor.base4,
                        height:
                        flexibleSize(context, Size.fromHeight(200))
                            .height,
                        width: flexibleSize(context, Size.fromWidth(246))
                            .width,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: flexibleSize(context, Size.fromHeight(16)).height,
                ),
                Text(
                  widget.where,
                  style: TextStyle(
                    color: MGcolor.base1,
                    fontSize: flexibleSize(context, Size.fromHeight(18)).height,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: flexibleSize(context, Size.fromHeight(24)).height,
                ),
                Text(
                  widget.date,
                  style: TextStyle(
                    color: MGcolor.base3,
                    fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  height: flexibleSize(context, Size.fromWidth(8)).width,
                ),
                Text(
                  widget.time,
                  style: TextStyle(
                    color: MGcolor.base3,
                    fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                isTimeExceed
                    ? Column(
                  children: [
                    Container(
                      height: flexibleSize(context, Size.fromHeight(8))
                          .height,
                    ),
                    Text(
                      '회의실 사용 시간이 다 되었어요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MGcolor.system_error,
                        fontSize:
                        flexibleSize(context, Size.fromHeight(12))
                            .height,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '회의실에서 QR코드 인증을 해주세요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MGcolor.system_error,
                        fontSize:
                        flexibleSize(context, Size.fromHeight(12))
                            .height,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      height: flexibleSize(context, Size.fromHeight(24))
                          .height,
                    ),
                  ],
                )
                    : isUsingRoom
                    ? Column(
                  children: [
                    Container(
                      height:
                      flexibleSize(context, Size.fromHeight(8))
                          .height,
                    ),
                    Text(
                      '현재 회의실을 사용중이에요!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MGcolor.system_error,
                        fontSize:
                        flexibleSize(context, Size.fromHeight(12))
                            .height,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '남은 시간 : 85분',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MGcolor.system_error,
                        fontSize:
                        flexibleSize(context, Size.fromHeight(12))
                            .height,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      height:
                      flexibleSize(context, Size.fromHeight(24))
                          .height,
                    ),
                  ],
                )
                    : Container(
                  height: flexibleSize(context, Size.fromHeight(24))
                      .height,
                ),
                Text(
                  '대표자',
                  style: TextStyle(
                    color: MGcolor.base1,
                    fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  height: flexibleSize(context, Size.fromHeight(8)).height,
                ),
                Text(
                  widget.name,
                  style: TextStyle(
                    color: MGcolor.base3,
                    fontSize: flexibleSize(context, Size.fromHeight(14)).height,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                widget.isMine
                    ? isTimeExceed
                    ? Column(
                  children: [
                    Container(
                      height:
                      flexibleSize(context, Size.fromHeight(30))
                          .height,
                    ),
                    PageMigrateButton(
                      isPopUp: false,
                      buttonSize: 169,
                      targetPage: MyCertification(),
                      text: 'QR 코드 인증하기',
                      color: MGcolor.brand_orig,
                      fontcolor: Colors.white,
                    ),
                  ],
                )
                    : isUsingRoom
                    ? canExtend
                    ? Column(
                  children: [
                    Container(
                      height: flexibleSize(
                          context, Size.fromHeight(30))
                          .height,
                    ),
                    PageMigrateButton(
                      isPopUp: true,
                      buttonSize: 145,
                      targetPage: CancelPopUp(
                        accept: false,
                        extendPopUp: true,
                      ),
                      text: '예약 연장하기',
                      color: MGcolor.brand_orig,
                      fontcolor: Colors.white,
                    ),
                  ],
                )
                    : Container()
                    : Column(
                  children: [
                    Container(
                      height: flexibleSize(
                          context, Size.fromHeight(30))
                          .height,
                    ),
                    PageMigrateButton(
                      isPopUp: false,
                      buttonSize: 145,
                      targetPage: MyCertification(),
                      text: '예약 수정하기',
                      color: MGcolor.brand_orig,
                      fontcolor: Colors.white,
                    ),
                    Container(
                      height: flexibleSize(
                          context, Size.fromHeight(12))
                          .height,
                    ),
                    PageMigrateButton(
                        isPopUp: true,
                        buttonSize: 145,
                        targetPage: CancelPopUp(accept: false, extendPopUp: false),
                        text: '예약 취소하기',
                        color: Colors.transparent,
                        fontcolor: MGcolor.base3)
                  ],
                )
                    : Column(
                  children: [
                    Container(
                      height: flexibleSize(context, Size.fromHeight(24))
                          .height,
                    ),
                    Text(
                      '깨끗하게 잘 사용하고 나왔습니다!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MGcolor.base1,
                        fontSize:
                        flexibleSize(context, Size.fromHeight(14))
                            .height,
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
  const CancelPopUp({Key? key, required this.accept, required this.extendPopUp})
      : super(key: key);

  final bool extendPopUp;
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
                      0),
                  child: accept
                      ? extendPopUp
                      ? Text(
                    '연장되었습니다!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MGcolor.base1,
                      fontSize:
                      flexibleSize(context, Size.fromHeight(16))
                          .height,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      : Text(
                    '예약이 취소되었습니다!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MGcolor.base1,
                      fontSize:
                      flexibleSize(context, Size.fromHeight(16))
                          .height,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      : extendPopUp
                      ? Text(
                    '1시간 연장하시겠습니까?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MGcolor.base1,
                      fontSize:
                      flexibleSize(context, Size.fromHeight(16))
                          .height,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                      : Text(
                    '예약을 취소하시겠습니까?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MGcolor.base1,
                      fontSize:
                      flexibleSize(context, Size.fromHeight(16))
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
                    : Container(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    flexibleSize(context, Size.fromHeight(12)).height,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width:
                          flexibleSize(context, Size.fromWidth(147))
                              .width,
                          height:
                          flexibleSize(context, Size.fromHeight(40))
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
                      Container(
                        width: flexibleSize(context, Size.fromWidth(8))
                            .width,
                      ),
                      PageMigrateButton(
                          isPopUp: true,
                          buttonSize: 147,
                          targetPage: extendPopUp
                              ? CancelPopUp(
                              accept: true, extendPopUp: true)
                              : CancelPopUp(
                              accept: true, extendPopUp: false),
                          text: extendPopUp ? '연장하기' : '취소하기',
                          color: MGcolor.brand_orig,
                          fontcolor: MGcolor.base7),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

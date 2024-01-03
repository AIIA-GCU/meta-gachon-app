///
/// 타인 인증 리스트 위젯 (AnotherGuyWidget)
/// 내 인증 리스트 위젯(myReservationWidget)
/// 팝업 위젯 (popUpWidget)
/// 예약 취소 위젯 (CancelPopUp)
///

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';

class PageMigrateButton extends StatelessWidget {
  const PageMigrateButton(
      {Key? key,
      required this.targetPage,
      required this.text,
      required this.color,
      required this.fontcolor})
      : super(key: key);

  final Widget targetPage;
  final String text;
  final Color color; // buttton color
  final Color fontcolor; // text color

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      width: flexibleSize(context, Size.fromWidth(159)).width,
      height: flexibleSize(context, Size.fromHeight(40)).height,
      child: TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (context) => targetPage));
        },
        child: Text(text,
            style: TextStyle(
                color: fontcolor,
                fontSize: flexibleSize(context, Size.fromHeight(14)).height)),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  CustomListItem(
      {super.key,
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
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(
            horizontal: flexibleSize(context, Size.fromWidth(16)).width,
            vertical: flexibleSize(context, Size.fromHeight(12)).height),
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
                Container(
                  height: flexibleSize(context, Size.fromHeight(8)).height,
                ),
                Text(_yMdE, style: KR.parag2.copyWith(color: MGcolor.base3)),
                Text(_begin_end,
                    style: KR.parag2.copyWith(color: MGcolor.base3))
              ],
            ),
            if (admission == null)
              Transform.translate(
                offset: Offset(
                    0, -1 * flexibleSize(context, Size.fromHeight(21)).height),
                child: Transform.rotate(
                  angle: pi,
                  child: Icon(
                    AppinIcon.back,
                    size: flexibleSize(context, Size.fromHeight(24)).height,
                    color: MGcolor.base3,
                  ),
                ),
              )
            else
              Container(
                  width: flexibleSize(context, Size.fromWidth(74)).width,
                  height: flexibleSize(context, Size.fromHeight(74)).height,
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
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
        builder: (BuildContext context) {
          return PopUpWidget(
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
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  flexibleSize(context, Size.fromWidth(isMine ? 90 : 40)).width,
              vertical: flexibleSize(context, Size.fromHeight(30)).height),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isMine
                    ? Image.asset(
                        ImgPath.home_img4,
                        height:
                            flexibleSize(context, Size.fromHeight(120)).height,
                      )
                    : Container(
                        color: MGcolor.base4,
                        height:
                            flexibleSize(context, Size.fromHeight(200)).height,
                        width: flexibleSize(context, Size.fromWidth(246)).width,
                      ),
              ),
              SizedBox(
                  height: flexibleSize(context, Size.fromHeight(16)).height),
              Text(
                where,
                style: TextStyle(
                  color: MGcolor.base1,
                  fontSize: flexibleSize(context, Size.fromHeight(18)).height,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                  height: flexibleSize(context, Size.fromHeight(24)).height),
              Column(
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: MGcolor.base3,
                      fontSize:
                          flexibleSize(context, Size.fromHeight(14)).height,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                      height: flexibleSize(context, Size.fromWidth(8)).width),
                  Text(
                    time,
                    style: TextStyle(
                      color: MGcolor.base3,
                      fontSize:
                          flexibleSize(context, Size.fromHeight(14)).height,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: flexibleSize(context, Size.fromHeight(24)).height),
              Column(
                children: [
                  Text(
                    '대표자',
                    style: TextStyle(
                      color: MGcolor.base1,
                      fontSize:
                          flexibleSize(context, Size.fromHeight(14)).height,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                      height: flexibleSize(context, Size.fromHeight(8)).height),
                  Text(
                    name,
                    style: TextStyle(
                      color: MGcolor.base3,
                      fontSize:
                          flexibleSize(context, Size.fromHeight(14)).height,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (isMine) ...[
                SizedBox(
                    height: flexibleSize(context, Size.fromHeight(30)).height),
                PageMigrateButton(
                  targetPage: Container(),
                  text: '예약 수정하기',
                  color: MGcolor.brand_orig,
                  fontcolor: Colors.white,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
                      builder: (BuildContext context) {
                        return CancelPopUp(accept: false);
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(
                          flexibleSize(context, Size.fromWidth(145)).width,
                          flexibleSize(context, Size.fromHeight(40)).height)),
                  child: Text('예약 취소하기',
                      style: KR.parag2.copyWith(color: MGcolor.base3)),
                ),
              ] else ...[
                SizedBox(
                    height: flexibleSize(context, Size.fromHeight(24)).height),
                ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 60),
                    child: Text('깨끗하게 잘 사용하고 나왔습니다!', style: KR.parag2)),
              ],
            ],
          ),
        ));
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
                                    color: MGcolor.base8,
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

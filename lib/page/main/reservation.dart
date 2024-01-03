///
/// 예약 홈 페이지
/// - 홈 프레임

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/services/reservation.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  bool get wantKeepAlive => false;

  bool isExist = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: flexibleSize(context, Size.fromWidth(16)).width),
          child: Column(children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => Reservation()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal:
                        flexibleSize(context, Size.fromWidth(16)).width),
                height: flexibleSize(context, Size.fromHeight(60)).height,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        ImgPath.home_img4,
                        height:
                            flexibleSize(context, Size.fromHeight(36)).height,
                      ),
                    ),
                    Container(
                        width: flexibleSize(context, Size.fromWidth(8)).width),
                    AutoSizeText(
                      '강의실 예약하기',
                      style: TextStyle(
                        fontSize:
                            flexibleSize(context, Size.fromHeight(16)).height,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Flexible(child: SizedBox.expand()),
                    Transform.rotate(
                      angle: pi,
                      child: Icon(
                        AppinIcon.back,
                        size: flexibleSize(context, Size.fromHeight(24)).height,
                        color: MGcolor.base3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical:
                        flexibleSize(context, Size.fromHeight(30)).height),
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => isExist = !isExist);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '내 예약 확인하기(click to test)',
                        style: KR.subtitle1,
                      ),
                    ),
                  ),
                  if (isExist)
                    ...List.generate(
                        15,
                        (index) => CustomListItem(
                            where: '404 - ${index + 1}',
                            name: '2023000${index + 1} 김가천',
                            begin: DateTime.now().add(Duration(days: index)),
                            duration: Duration(hours: index + 1)))
                  else
                    Container(
                        height:
                            flexibleSize(context, Size.fromHeight(600)).height,
                        alignment: Alignment.center,
                        child: Text(
                          "아직 예약 내역이 없어요!",
                          style: KR.subtitle4.copyWith(color: MGcolor.base3),
                        ))
                ]))
          ]),
        ),
      ]),
    );
  }
}

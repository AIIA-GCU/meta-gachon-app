///
/// 예약 홈 페이지
/// - 홈 프레임

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/services/reservate.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  final Stream<StreamType> _stream = listListener.stream;

  @override
  void initState() {
    super.initState();
    _stream.listen((event) => _event(event));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            /// 예약하기 카드
            GestureDetector(
              onTap: doReservation,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ratio.width * 16),
                height: ratio.height * 60,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        ImgPath.home_img4,
                        height: ratio.height * 36,
                      ),
                    ),
                    SizedBox(width: ratio.width * 8),
                    Text('강의실 예약하기', style: KR.subtitle3),
                    Flexible(child: SizedBox.expand()),
                    Transform.rotate(
                      angle: pi,
                      child: Icon(
                        AppinIcon.back,
                        size: 24,
                        color: MGcolor.base3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 리스트
            Padding(
              padding: EdgeInsets.only(top: ratio.height * 30),
              child: Text('내 예약 확인하기', style: KR.subtitle1),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: ratio.height * 30),
                child: FutureBuilder<List<Reservate>?>(
                    future: reservates.isEmpty ? RestAPI.getAllReservation() : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            height: ratio.height * 594,
                            alignment: Alignment.center,
                            child: Text(
                                '아직 예약 내역이 없어요!',
                                style: KR.subtitle4.copyWith(color: MGcolor.base3)
                            )
                        );
                      }

                      if (snapshot.hasData) {
                        reservates = snapshot.data!;
                      }
                      return Column(
                          children: reservates.map((e) {
                            List<String> temp = e.leaderInfo.split(' ');
                            return CustomListItem(
                              uid: e.reservationId,
                              name: temp[1],
                              stuNum: int.parse(temp[0]),
                              room: e.room,
                              date: e.date,
                              time: e.time,
                            );
                          }).toList()
                      );
                    }
                )
            )
          ]),
        ),
      ]),
    );
  }

  void _event(StreamType event) {
    if (mounted && event == StreamType.reservate) {
      setState(() => reservates.clear());
    }
  }

  void doReservation() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => ReservatePage()));
}

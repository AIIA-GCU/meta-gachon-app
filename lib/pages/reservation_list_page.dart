///
/// 예약 홈 페이지
/// - 홈 프레임

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/pages/reservate_page.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

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
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: ratio.width * 16),
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
                      if (snapshot.hasError) {
                        return Container(
                            height: 218,
                            alignment: Alignment.bottomCenter,
                            child: Text(
                                '통신 속도가 너무 느립니다!',
                                style: KR.subtitle4.copyWith(
                                    color: MGcolor.base3)
                            )
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ProgressWidget();
                      }
                      if (snapshot.hasData) {
                        reservates = snapshot.data!;
                      }
                      if (reservates.isNotEmpty) {
                        return Column(
                            children: reservates.map((e) {
                              List<String> temp = e.leaderInfo.split(' ');
                              return CustomListItem(
                                uid: e.reservationId,
                                name: temp[1],
                                stuNum: int.parse(temp[0]),
                                place: e.place,
                                date: e.date,
                                time: e.time,
                                members: e.memberInfo
                              );
                            }).toList()
                        );
                      } else {
                        return Container(
                            height: ratio.height * 594,
                            alignment: Alignment.center,
                            child: Text(
                                '아직 예약 내역이 없어요!',
                                style: KR.subtitle4.copyWith(
                                    color: MGcolor.base3)
                            )
                        );
                      }
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

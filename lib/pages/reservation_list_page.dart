///
/// 예약 홈 페이지
/// - 홈 프레임

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

import '../widgets/popup_widgets.dart';
import 'reservate_page.dart';
import '../widgets/small_widgets.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  final Stream<StreamType> _stream = listListener.stream;
  late bool _loading;

  @override
  void initState() {
    _loading = false;
    _stream.listen((event) => _event(event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                /// 예약하기 카드
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
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
                              ImgPath.home4,
                              height: ratio.height * 36,
                            ),
                          ),
                          SizedBox(width: ratio.width * 8),
                          Text('강의실 예약하기', style: KR.subtitle3),
                          const Flexible(child: SizedBox.expand()),
                          Transform.rotate(
                            angle: pi,
                            child: const Icon(
                              MGIcon.back,
                              size: 24,
                              color: MGColor.base3,
                            ),
                          ),
                        ],
                      ),
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
                                        color: MGColor.base3)
                                )
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) return const ProgressWidget();
                          if (snapshot.hasData) reservates = snapshot.data!;
                          if (reservates.isNotEmpty) {
                            return Column(children: reservates.map((e) => _listItem(e)).toList());
                          } else {
                            return Container(
                                height: ratio.height * 594,
                                alignment: Alignment.center,
                                child: Text(
                                    '아직 예약 내역이 없어요!',
                                    style: KR.subtitle4.copyWith(
                                        color: MGColor.base3)
                                )
                            );
                          }
                        }
                    )
                )
              ]),
            ),
          ]),
        ),

        if (_loading)
          const ProgressScreen()
      ],
    );
  }

  Widget _listItem(Reservate reservate) {
    late EdgeInsetsGeometry margin, padding;
    late Text firstText, secondText, thirdText;

    if (service == ServiceType.computer) {
      margin = const EdgeInsets.symmetric(vertical: 16);
      padding = EdgeInsets.symmetric(
          horizontal: ratio.width * 16, vertical: 26);
      secondText = Text(
        '${reservate.startToDate2()} ~ ${reservate.endToDate2()}',
        style: KR.parag2.copyWith(color: MGColor.base3),
      );
      thirdText = Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '전담 교수님 ',
                style: KR.parag2.copyWith(color: MGColor.base3)
            ),
            TextSpan(
                text: reservate.professor,
                style: KR.parag2.copyWith(color: MGColor.secondaryColor())
            ),
          ],
        ),
      );
    } else {
      margin = const EdgeInsets.symmetric(vertical: 4);
      padding = EdgeInsets.symmetric(
          horizontal: ratio.width * 16, vertical: 12);
      secondText = Text(reservate.startToDate1(),
          style: KR.parag2.copyWith(color: MGColor.base3));
      thirdText = Text(reservate.toDuration(),
          style: KR.parag2.copyWith(color: MGColor.base3));
    }

    if (service == ServiceType.lectureRoom && reservate.place == '-1') {
      firstText = Text('배정 중', style: KR.subtitle3.copyWith(color: Colors.red));
    } else {
      firstText = Text(reservate.place!, style: KR.subtitle3);
    }

    return GestureDetector(
      onTap: () async {
        int? status = await RestAPI.currentReservationStatus(reservationId: reservate.reservationId);
        showDialog(
          context: context,
          builder: (_) => ReservationPopup(reservate, status!, _setLoading)
        );
      },
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            border: stdFormat3.format(reservate.startTime) == today
                ? Border.all(color: MGColor.primaryColor()) : null
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                firstText,
                SizedBox(height: ratio.height * 8),
                secondText,
                SizedBox(height: ratio.height * 4),
                thirdText
              ],
            ),
            Transform.translate(
              offset: Offset(0, -(ratio.height * 21)),
              child: Transform.rotate(
                angle: pi,
                child: const Icon(
                  MGIcon.back,
                  size: 24,
                  color: MGColor.base3,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _setLoading(bool val) => setState(() => _loading = val);

  void _event(StreamType event) {
    if (mounted && event == StreamType.reservate) {
      setState(() => reservates.clear());
    }
  }

  Future<void> doReservation() async {
    _setLoading(true);
    List<String>? temp = await RestAPI.placeForService();
    if (temp != null || temp!.isEmpty) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ReservatePage(availableRoom: temp)));
    } else {
      late String place;
      switch (service) {
        case ServiceType.aiSpace:
          place = "회의실";
          break;
        case ServiceType.lectureRoom:
          place = "강의실";
          break;
        case ServiceType.computer:
          place = "컴퓨터";
          break;
      }
      showDialog(
          context: context,
          builder: (ctx) => CommentPopup(
              title: '현재 예약 가능한 $place가 없습니다.',
              onPressed: () => Navigator.pop(ctx)
          )
      );
    }
  }
}

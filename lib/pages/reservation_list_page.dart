///
/// 예약 홈 페이지
/// - 홈 프레임

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

import '../widgets/popup_widgets.dart';
import 'reserve_page.dart';
import '../widgets/small_widgets.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key, required this.setLoading});

  final void Function(bool) setLoading;

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  final _scrollCtr = ScrollController();
  final Stream<StreamType> _stream = listListener.stream;

  @override
  void initState() {
    _stream.listen((event) => _event(event));
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("dispose");
    _scrollCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
      child: NestedScrollView(
        controller: _scrollCtr,
        floatHeaderSlivers: true,
        headerSliverBuilder: _headerSliver,
        body: _list()
      ),
    );
  }

  List<Widget> _headerSliver(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverAppBar(
        forceElevated: innerBoxIsScrolled,
        flexibleSpace: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: ratio.height * 12),
            _moveToPageCard(ServiceType.lectureRoom),
            const SizedBox(height: 12),
            _moveToPageCard(ServiceType.aiSpace),
            const SizedBox(height: 12),
            _moveToPageCard(ServiceType.computer),
            const SizedBox(height: 12)
          ]
        ),
        expandedHeight: 232,
        collapsedHeight: 232,
      ),

      SliverAppBar(
        floating: true,
        pinned: true,
        snap: true,
        forceElevated: innerBoxIsScrolled,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: GestureDetector(
            onTap: () {
              _scrollCtr.animateTo(0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.ease
              );
            },
            child: Text('내 예약 확인하기', style: KR.subtitle1)
          ),
        ),
        toolbarHeight: 52,
      )
    ];
  }

  Widget _list() {
    return FutureBuilder<List<Reserve>?>(
      future: reserves.isEmpty ? RestAPI.getRemainReservation() : null,
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
        if (snapshot.hasData) reserves = snapshot.data!;
        if (reserves.isNotEmpty) {
          return RefreshIndicator(
            displacement: 0,
            color: MGColor.brandPrimary,
            onRefresh: _onRefreshed,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics()
                  .applyTo(const BouncingScrollPhysics()),
              itemCount: reserves.length,
              itemBuilder: (_, index) => _listItem(reserves[index])
            ),
          );
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
    );
  }

  Widget _moveToPageCard(ServiceType service) {
    final String place = service == ServiceType.aiSpace
        ? "AI 인큐베이터" : service == ServiceType.lectureRoom
        ? "강의실" : "GPU 컴퓨터";
    late String path;
    switch (service) {
      case ServiceType.aiSpace:
        path = "meta2";
        break;
      case ServiceType.lectureRoom:
        path = "class2";
        break;
      case ServiceType.computer:
        path = "gpu2";
        break;
    }
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => doReservation(service),
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
                     'assets/images/$path.png',
                   height: ratio.height * 36,
                 ),
              ),
              SizedBox(width: ratio.width * 8),
              Text('$place 예약하기', style: KR.subtitle3),
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
    );
  }

  Widget _listItem(Reserve reserve) {
    late final Text firstText, secondText, thirdText;

    if (reserve.service == ServiceType.computer) {
      secondText = Text(
        '${reserve.startToDate2()} ~ ${reserve.endToDate2()}',
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
                text: reserve.professor,
                style: KR.parag2.copyWith(color: MGColor.brandSecondary)
            ),
          ],
        ),
      );
    } else {
      secondText = Text(reserve.startToDate1(),
          style: KR.parag2.copyWith(color: MGColor.base3));
      thirdText = Text(reserve.toDuration(),
          style: KR.parag2.copyWith(color: MGColor.base3));
    }

    if (reserve.service == ServiceType.lectureRoom && reserve.place == '-1') {
      firstText = Text('배정 중', style: KR.subtitle3.copyWith(color: Colors.red));
    } else {
      firstText = Text(reserve.place!, style: KR.subtitle3);
    }

    return GestureDetector(
      onTap: () async {
        int? status = await RestAPI.currentReservationStatus(reservationId: reserve.reservationId);
        showDialog(
          context: context,
          builder: (_) => ReservationPopup(reserve, status!, widget.setLoading)
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding:  EdgeInsets.symmetric(
            horizontal: ratio.width * 16, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            border: stdFormat3.format(reserve.startTime) == today
                ? Border.all(color: MGColor.brandPrimary) : null
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

  void _event(StreamType event) {
    if (mounted && event == StreamType.reserve) {
      setState(() => reserves.clear());
    }
  }

  Future<void> doReservation(ServiceType service) async {
    widget.setLoading(true);
    List<String>? temp = await RestAPI.placeForService(service);
    widget.setLoading(false);
    if (temp != null || temp!.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReservePage(service, availableRoom: temp))
      );
    } else {
      late String str;
      switch (service) {
        case ServiceType.aiSpace:
          str = "회의실이";
          break;
        case ServiceType.lectureRoom:
          str = "강의실이";
          break;
        case ServiceType.computer:
          str = "컴퓨터가";
          break;
      }
      showDialog(
          context: context,
          builder: (ctx) => CommentPopup(
              title: '현재 예약 가능한 $str 없습니다.',
              onPressed: () => Navigator.pop(ctx)
          )
      );
    }
  }

  Future<void> _onRefreshed() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => reserves.clear());
  }
}

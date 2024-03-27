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
      padding: EdgeInsets.symmetric(horizontal: ratio.width * 16, vertical: ratio.height * 12),
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

            _moveToPageCard(ServiceType.lectureRoom),
            const SizedBox(height: 12),
            _moveToPageCard(ServiceType.aiSpace),
            const SizedBox(height: 12),
            _moveToPageCard(ServiceType.computer),
            const SizedBox(height: 12)
          ]
        ),
        expandedHeight: 204,
        collapsedHeight: 204,
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
              alignment: Alignment.center,
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

    bool notTouched = true;
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) {
            if (service == ServiceType.aiSpace) {
              switch (myInfo.rating) {
                case 1:
                  return CommentPopup(
                    title: "GRAY 등급입니다. \n 2주간 예약이 불가능합니다.",
                    onPressed: () => Navigator.pop(context),
                  );
                case 2:
                  return CommentPopup(
                    title: "STONE 등급입니다. \n 7일간 예약이 불가능합니다.",
                    onPressed: () => Navigator.pop(context),
                  );
                case 4:
                  return CommentPopup(
                    title: "AQUA 등급입니다. \n 예약 가능 시간은 5시간입니다.",
                    onPressed: () {
                      Navigator.pop(context);
                      notTouched = false;
                      doReservation(service);
                    },
                  );
                case 5:
                  return CommentPopup(
                    title: "COBALT 등급입니다. \n 예약 가능 시간은 3시간입니다.",
                    onPressed: () {
                      Navigator.pop(context);
                      notTouched = false;
                      doReservation(service);
                    },
                  );
                default:
                  return CommentPopup(
                    title: "SKY 등급입니다. \n 예약 가능 시간은 4시간입니다.",
                    onPressed: () {
                      Navigator.pop(context);
                      notTouched = false;
                      doReservation(service);
                    },
                  );
              }
            } else {
              if (myInfo.rating == 1) {
                return CommentPopup(
                  title: "GRAY 등급입니다. \n 2주간 예약이 불가능합니다.",
                  onPressed: () => Navigator.pop(context),
                );
              } else if (myInfo.rating == 2) {
                return CommentPopup(
                  title: "STONE 등급입니다. \n 7일간 예약이 불가능합니다.",
                  onPressed: () => Navigator.pop(context),
                );
              }
              return CommentPopup(title: "깨끗한 이용 부탁드려요!", onPressed: () {
                Navigator.pop(context);
                notTouched = false;
                doReservation(service);
              });
            }
          }
        ).then((value) {
          if (notTouched && myInfo.rating > 2) doReservation(service);
        }),

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

  Widget? _listItem(Reserve reserve) {
    late final Text? firstText, secondText, thirdText;
    late final placeName = reserve.place;


    if (reserve.service == ServiceType.computer) {

      late final computers = placeName!.split('-')[1];
      firstText = Text("$computers번 GPU", style: KR.subtitle3);
      secondText = Text(
        '${reserve.startToDate2()} ~ ${reserve.endToDate2()}',
        style: KR.parag2.copyWith(color: MGColor.base3),
      );
      thirdText = null;
    }

    if (reserve.service == ServiceType.lectureRoom || reserve.service == ServiceType.aiSpace) {
      secondText = Text(reserve.startToDate1(),
          style: KR.parag2.copyWith(color: MGColor.base3));
      thirdText = Text(reserve.toDuration(),
          style: KR.parag2.copyWith(color: MGColor.base3));
    }

    if (reserve.service == ServiceType.lectureRoom && reserve.place == '-1') {
      firstText = Text('배정중...', style: KR.subtitle3.copyWith(color: MGColor.base3));
    } else if(reserve.service == ServiceType.lectureRoom && reserve.place == '0') { // 배정이 불가할 때 조교님이 강의실에 0을 입력하는 방식
      firstText = Text('배정 불가', style: KR.subtitle3.copyWith(color: Colors.red),);
    } else if (reserve.service == ServiceType.lectureRoom || reserve.service == ServiceType.aiSpace) {
      firstText = Text("${placeName}호 회의실", style: KR.subtitle3);
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
                firstText ?? SizedBox.shrink(),
                SizedBox(height: ratio.height * 8),
                secondText ?? SizedBox.shrink(),
                SizedBox(height: ratio.height * 4),
                thirdText ?? SizedBox.shrink()
              ],
            ),
            Transform.rotate(
              angle: pi,
              child: const Icon(
                MGIcon.back,
                size: 24,
                color: MGColor.base3,
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

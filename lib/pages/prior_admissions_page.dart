import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../config/app/_export.dart';
import '../config/server/_export.dart';
import '../widgets/small_widgets.dart';
import 'admission_list_page.dart';
import '../widgets/popup_widgets.dart';


class PriorAdmissionsPage extends StatefulWidget {
  const PriorAdmissionsPage({super.key, required this.setLoading});
  final void Function(bool) setLoading;

@override
  State<PriorAdmissionsPage> createState() => _PriorAdmissionsPageState();
}

class _PriorAdmissionsPageState extends State<PriorAdmissionsPage> {
  late List<Reserve> _list;

  @override
  void initState() {
    _list = reserves
        .where((e) => DateTime.now().isAfter(e.endTime))
        .toList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PriorAdmissionsPage oldWidget) {
    _list = reserves
        .where((e) => DateTime.now().isAfter(e.endTime))
        .toList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 48,
            leading: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(MGIcon.back, size: 24),
                onPressed: _onPressed
            ),
            title: Text('인증하기', style: KR.subtitle1.copyWith(color: MGColor.base1))
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
            child: RefreshIndicator(
              displacement: 0,
              color: MGColor.brandPrimary,
              onRefresh: _onRefreshed,
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: ratio.height * 18),
                  physics: const AlwaysScrollableScrollPhysics()
                      .applyTo(const BouncingScrollPhysics()),
                  itemCount: _list.length,
                  itemBuilder: (_, index) => _listItem(_list[index])
              ),
            )
          ),
        )
    );
  }

  Widget _listItem(Reserve reserve) {
    return GestureDetector(
      onTap: () async {
        int? status = await RestAPI.currentReservationStatus(reservationId: reserve.reservationId);
        showDialog(
            context: context,
            builder: (_) => ReservationPopup(reserve, status!, widget.setLoading)
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            border: stdFormat3.format(reserve.startTime) == today
                ? Border.all(color: MGColor.brandPrimary) : null
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Transform.translate(
              offset: Offset(0, -(ratio.height * 21)),
              child: Transform.rotate(
                angle: pi,
                child: Container(
                  alignment: Alignment.center,
                  child: const Icon(
                    MGIcon.back,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onPressed() {
    Navigator.of(context, rootNavigator: true).pop(
      PageRouteBuilder(
        fullscreenDialog: false,
        transitionsBuilder: slideRigth2Left,
        pageBuilder: (context, animation, secondaryAnimation) => const AdmissionListPage(),
      ),
    );
  }

  Future<void> _onRefreshed() async {
    Future.delayed(const Duration(milliseconds: 200));
    setState(() {});
  }
}
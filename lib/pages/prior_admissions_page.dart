import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../config/app/_export.dart';
import '../config/server/_export.dart';
import '../widgets/small_widgets.dart';
import 'admission_list_page.dart';

class PriorAdmissionsPage extends StatefulWidget {
  const PriorAdmissionsPage({super.key});

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
      onTap: () {},
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(
          ratio.width * 16,
          0,
          ratio.width * 16,
          12
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ratio.width * 16,
          vertical: 16
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reserve.place!, style: EN.subtitle2),
                SizedBox(height: 8),
                Text(reserve.startToDate2(), style: EN.subtitle3)
              ],
            ),
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
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../config/app/_export.dart';
import '../config/server/_export.dart';
import '../widgets/small_widgets.dart';
import 'admission_list_page.dart';
import 'admit_page.dart';

class PriorAdmissionsPage extends StatefulWidget {
  const PriorAdmissionsPage(this.items, {super.key});

  final List<Reserve> items;

  @override
  State<PriorAdmissionsPage> createState() => _PriorAdmissionsPageState();
}

class _PriorAdmissionsPageState extends State<PriorAdmissionsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 48,
            leading: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(MGIcon.back, size: 24),
                onPressed: _back
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
                  itemCount: widget.items.length,
                  itemBuilder: (_, index) => _listItem(widget.items[index])
              ),
            )
          ),
        )
    );
  }

  Widget _listItem(Reserve reserve) {
    return GestureDetector(
      onTap: () => _moveToAdmitPage(reserve),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reserve.place!, style: EN.subtitle2),
                const SizedBox(height: 8),
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

  void _back() {
    Navigator.of(context, rootNavigator: true).pop(
      PageRouteBuilder(
        fullscreenDialog: false,
        transitionsBuilder: slideRigth2Left,
        pageBuilder: (_, __, ___) => const AdmissionListPage(),
      ),
    );
  }

  void _moveToAdmitPage(Reserve reserve) {
    Navigator.of(context).push(
      PageRouteBuilder(
        fullscreenDialog: false,
        transitionsBuilder: slideRigth2Left,
        pageBuilder: (_, __, ___) => AdmitPage(reserve: reserve)
      )
    );
  }

  Future<void> _onRefreshed() async {
    Future.delayed(const Duration(milliseconds: 200));
    setState(() {});
  }
}
///
/// 내 인증 확인하기 페이지
///

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/admission_list.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

class MyAdmissionPage extends StatefulWidget {
  const MyAdmissionPage({super.key});

  @override
  State<MyAdmissionPage> createState() => _MyAdmissionPageState();
}

class _MyAdmissionPageState extends State<MyAdmissionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 26,
            leading: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(AppinIcon.back, size: 24),
                onPressed: _onPressed),
            title: Text('내 인증', style: KR.subtitle1.copyWith(color: MGcolor.base1))
        ),
        body: FutureBuilder<List<Admit>?>(
            future: myAdmits.isEmpty ? RestAPI.getMyAdmission() : null,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                    height: ratio.height * 594,
                    alignment: Alignment.center,
                    child: Text(
                        '통신 속도가 너무 느려요!',
                        style: KR.subtitle4.copyWith(color: MGcolor.base3)
                    )
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ProgressWidget();
              }
              if (snapshot.hasData) {
                myAdmits = snapshot.data!;
              }
              if (myAdmits.isNotEmpty) {
                return Column(
                    children: myAdmits.map((e) {
                  List<String> temp = e.leaderInfo.split(' ');
                  return CustomListItem(
                    uid: e.admissionId,
                    name: temp[1],
                    stuNum: int.parse(temp[0]),
                    room: e.room,
                    date: e.date,
                    time: e.time,
                    members: e.memberInfo,
                    photo: e.photo,
                    review: e.review,
                  );
                }).toList());
              } else {
                return Container(
                    height: ratio.height * 594,
                    alignment: Alignment.center,
                    child: Text(
                        '아직 인증이 없어요!',
                        style: KR.subtitle4.copyWith(color: MGcolor.base3)
                    )
                );
              }
            }
        )
    );
  }

  void _onPressed() {
    Navigator.of(context, rootNavigator: true).pop(
      PageRouteBuilder(
        transitionsBuilder: slideRigth2Left, // animation
        pageBuilder: (context, animation, secondaryAnimation) =>
            AdmissionListPage(),
        fullscreenDialog: false, // No Dialog
      ),
    );
  }
}

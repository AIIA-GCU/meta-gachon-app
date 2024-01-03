///
/// 내 인증 확인하기 페이지
///

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/function.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/admission.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

class MyCertification extends StatefulWidget {
  const MyCertification({super.key});

  @override
  State<MyCertification> createState() => _MyCertificationState();
}

class _MyCertificationState extends State<MyCertification> {
  bool isExist = false;

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
        title: Text('내 인증',
            style: TextStyle(
                fontSize: flexibleSize(context, Size.fromHeight(18)).height,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: "KR")),
        actions: [
          GestureDetector(
            onTap: () => setState(() => isExist = !isExist),
            child: Icon(AppinIcon.not, size: 24),
          ),
          SizedBox(width: 16)
        ],
      ),
      body: isExist
          ? ListView.separated(
          padding: EdgeInsets.fromLTRB(
            flexibleSize(context, Size.fromWidth(16)).width,
            0,
            flexibleSize(context, Size.fromWidth(16)).width,
            flexibleSize(context, Size.fromHeight(30)).height
          ),
          shrinkWrap: true,
          itemCount: 10,
          separatorBuilder: (context, index) => SizedBox(height: 4),
          itemBuilder: (context, index) => CustomListItem(
            where: '404 - ${index + 1}',
            name: '김가천',
            begin: DateTime.now().add(Duration(days: index)),
            duration: Duration(hours: index + 1),
            admission: true,
          ))
          : Center(
        child: Text('아직 인증이 없어요!',
            style: KR.subtitle3.copyWith(color: MGcolor.base3)),
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

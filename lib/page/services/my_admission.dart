///
/// 내 인증 확인하기 페이지
///

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/animation.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/page/main/admission_list.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

class MyAdmission extends StatefulWidget {
  const MyAdmission({super.key});

  @override
  State<MyAdmission> createState() => _MyAdmissionState();
}

class _MyAdmissionState extends State<MyAdmission> {
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
        title: Text('내 인증', style: KR.subtitle1),
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
            ratio.width * 16,
            0,
            ratio.width * 16,
            ratio.height * 16
          ),
          shrinkWrap: true,
          itemCount: 10,
          separatorBuilder: (context, index) => SizedBox(height: 4),
          itemBuilder: (context, index) => CustomListItem(
            uid: '',
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

///
/// 비교적 간단한 위젯을 모아 둔 파일
/// - 코드 길이 30줄 미만
///
/// 페이지 이동 위젯 (PageMigrateButton)

import 'package:flutter/material.dart';

import '../config/function.dart';

class PageMigrateButton extends StatelessWidget {
  const PageMigrateButton(
      {Key? key,
      required this.targetPage,
      required this.text,
      required this.color,
      required this.fontcolor})
      : super(key: key);

  final Widget targetPage;
  final String text;
  final Color color; // buttton color
  final Color fontcolor; // text color

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      width: flexibleSize(context, Size.fromWidth(159)).width,
      height: flexibleSize(context, Size.fromHeight(40)).height,
      child: TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (context) => targetPage));
        },
        child: Text(text,
            style: TextStyle(
                color: fontcolor,
                fontSize: flexibleSize(context, Size.fromHeight(14)).height)),
      ),
    );
  }
}

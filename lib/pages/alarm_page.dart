import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

import '../widgets/message.dart';
import '../widgets/small_widgets.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}
class _AlarmState extends State<Alarm> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 48,
        leading: IconButton(
          icon: const Icon(MGIcon.back, color: MGColor.base4),
          onPressed: () => Navigator.of(context).pop(),
        )
      ),
      body: SafeArea(
        child: FutureBuilder<List<Notice>?>(
          future: RestAPI.getNotices(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const ProgressWidget();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          '통신 속도가 너무 느려요!',
                          style: KR.subtitle4.copyWith(color: MGColor.base3)
                      )
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: snapshot.data!
                          .map((e) => Message(notifi: e))
                          .toList()
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      '아직 알림이 없어요!',
                      style: KR.subtitle4.copyWith(color: MGColor.base3)
                    )
                  );
                }
            }
          }
        ),
      )
    );
  }
}
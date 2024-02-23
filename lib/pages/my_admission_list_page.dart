import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';

import 'admission_list_page.dart';
import '../widgets/popup_widgets.dart';
import '../widgets/small_widgets.dart';

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
            leadingWidth: 48,
            leading: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(MGIcon.back, size: 24),
                onPressed: _onPressed
            ),
            title: Text('내 인증', style: KR.subtitle1.copyWith(color: MGColor.base1))
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
          child: FutureBuilder<List<Admit>?>(
              future: myAdmits.isEmpty ? RestAPI.getMyAdmission() : null,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        '통신 속도가 너무 느려요!',
                        style: KR.subtitle4.copyWith(color: MGColor.base3)
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) return const ProgressWidget();
                if (snapshot.hasData) myAdmits = snapshot.data!;
                if (myAdmits.isNotEmpty) {
                  return Column(children: myAdmits.map((e) => _listItem(e)).toList());
                } else {
                  return Center(
                    child: Text(
                        '아직 인증이 없어요!',
                        style: KR.subtitle4.copyWith(color: MGColor.base3)
                    ),
                  );
                }
              }
          ),
        )
    );
  }

  Widget _listItem(Admit admit) {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          barrierColor: MGColor.barrier,
          builder: (ctx) => AdmissionPopup(admit)
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(
            horizontal: ratio.width * 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(admit.place, style: KR.subtitle3),
                SizedBox(height: ratio.height * 8),
                Text(admit.date, style: KR.parag2.copyWith(color: MGColor.base3)),
                SizedBox(height: ratio.height * 4),
                Text(admit.time, style: KR.parag2.copyWith(color: MGColor.base3))
              ],
            ),
            Container(
                width: ratio.height * 74,
                height: ratio.height * 74,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: MemoryImage(admit.photo),
                        fit: BoxFit.fill
                    )
                )
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
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/pages/prior_admissions_page.dart';
import 'package:mata_gachon/widgets/button.dart';
import 'package:mata_gachon/widgets/popup_widgets.dart';

import 'admit_page.dart';
import 'my_admission_list_page.dart';
import '../widgets/small_widgets.dart';


class AdmissionListPage extends StatefulWidget {
  const AdmissionListPage({super.key});

  @override
  State<AdmissionListPage> createState() => _AdmissionListPageState();
}

class _AdmissionListPageState extends State<AdmissionListPage> {
  final Stream<StreamType> _stream = listListener.stream;

  late final FToast _fToast;
  late bool _isShownToast;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _stream.listen((event) => _event(event));
    _fToast = FToast();
    _fToast.init(context);
    _isShownToast = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        /// <내 인증 확인하기> & <인증하러 가기>
        SizedBox(height: ratio.height * 11),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 16,
              vertical: ratio.height * 16
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 인트로
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      ImgPath.small1,
                      height: ratio.width * 48,
                    ),
                  ),
                  SizedBox(width: ratio.width * 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '강의실 이용 끝!',
                          style: KR.parag2.copyWith(color: MGColor.base3)
                      ),
                      Text(
                          '이제 인증하러 가볼까요?',
                          style: KR.subtitle1
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: ratio.height * 16),

              /// 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButtons.bigButton(
                      '내 인증 확인하기',
                      MGColor.brandTertiary,
                      MGColor.brandPrimary,
                      () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const MyAdmissionPage()))
                  ),
                  CustomButtons.bigButton(
                      '인증하러 가기',
                      MGColor.brandPrimary,
                      MGColor.brandTertiary,
                      _doAdmission
                  )
                ],
              ),
            ],
          ),
        ),

        /// 리스트
        Padding(
            padding: EdgeInsets.only(top: ratio.height * 30),
            child: Text('다른 친구들 인증 보기', style: KR.subtitle1)
        ),
        Expanded(
          child: FutureBuilder<List<Admit>?>(
              future: admits.isEmpty ? RestAPI.getAllAdmission() : null,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                      height: ratio.height * 594,
                      alignment: Alignment.center,
                      child: Text(
                          '통신 속도가 너무 느립니다!',
                          style: KR.subtitle4.copyWith(color: MGColor.base3)
                      )
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) return const ProgressWidget();
          
                if (snapshot.hasData) admits = snapshot.data!;
          
                if (admits.isNotEmpty) {
                  return RefreshIndicator(
                    displacement: 0,
                    color: MGColor.brandPrimary,
                    onRefresh: _onRefreshed,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics()
                          .applyTo(const BouncingScrollPhysics()),
                      itemCount: admits.length,
                      itemBuilder: (_, index) => _listItem(admits[index])
                    )
                  );

                } else {
                  return Container(
                      height: ratio.height * 218,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                          '아직 인증이 없어요!',
                          style: KR.subtitle4.copyWith(color: MGColor.base3)
                      ),

                  );
                }
              }
          ),
        )
      ]),
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
            borderRadius: BorderRadius.circular(14)),
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

  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> _doAdmission() async {
    List<Reserve>? result = await RestAPI.getPriorAdmittedReservation();
    if (result != null && result.isNotEmpty) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PriorAdmissionsPage(result)));
    } else {
      if (!_isShownToast) {
        /// show toast during 2s
        _isShownToast = true;
        Future.delayed(const Duration(seconds: 2)).then((_) => _isShownToast = false);

        _fToast.showToast(
          positionedToastBuilder: (context, widget) => Positioned(
              bottom: kBottomNavigationBarHeight + 10,
              width: MediaQuery.of(context).size.width,
              child: widget,
            ),
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 6, horizontal: ratio.width * 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(100)),
              child: const Text(
                '인증해야 하는 이용 내역이 없습니다',
                style: TextStyle(fontSize: 16, color: Colors.white)
              ),
            ),
          )
        );
      }
    }
  }

  void _event(StreamType event) {
    if (mounted && event == StreamType.admit) {
      setState(() {
        admits.clear();
        myAdmits.clear();
      });
    }
  }

  Future<void> _onRefreshed() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => admits.clear());
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app/_export.dart';
import '../config/server/_export.dart';
import '../widgets/popup_widgets.dart';
import '../widgets/small_widgets.dart';
import 'admission_list_page.dart';
import '../widgets/button.dart';
import 'qr_page.dart';

class AdmitPage extends StatefulWidget {
  const AdmitPage({Key? key, required this.reserve}) : super(key: key);

  final Reserve reserve;

  @override
  State<AdmitPage> createState() => _AdmitPageState();
}

class _AdmitPageState extends State<AdmitPage> {
  final TextEditingController _textCtr = TextEditingController();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  late String? place;
  late String leaderInfo;
  late Widget time;
  late bool loading;

  String? _picturePath;

  @override
  void initState() {
    loading = false;

    place = widget.reserve.place;
    leaderInfo = widget.reserve.leaderInfo;

    if (widget.reserve.service == ServiceType.computer) {
      time = RichText(text: TextSpan(
        style: EN.parag2.copyWith(color: MGColor.base3),
        children: [
          TextSpan(text: widget.reserve.startToDate2()),
          TextSpan(text: ' | ', style: EN.parag1.copyWith(color: MGColor.base1)),
          TextSpan(text: widget.reserve.endToDate2())
        ]
      ));
    } else {
      time = RichText(text: TextSpan(
        style: EN.parag2.copyWith(color: MGColor.base3),
        children: [
          TextSpan(text: widget.reserve.startToDate2()),
          TextSpan(text: ' | ', style: EN.parag1.copyWith(color: MGColor.base1)),
          TextSpan(text: widget.reserve.toDuration())
        ]
      ));
    }

    _controller = CameraController(camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (MediaQuery.of(context).viewInsets.bottom > 0) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
                titleSpacing: 0,
                leadingWidth: 48,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(MGIcon.back),
                  iconSize: 24,
                ),
                title: Text('사용 인증하기',
                    style: KR.subtitle1.copyWith(color: MGColor.base1))),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 80,
                child: Stack(children: [
                  /// 예약 정보 입력
                  SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// 사진
                          Container(
                            width: ratio.width * 358,
                            height: ratio.height * 312,
                            padding: EdgeInsets.symmetric(
                              horizontal: ratio.width * 16,
                              vertical: ratio.height * 16
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('인증 사진', style: KR.subtitle3),
                                SizedBox(height: ratio.height * 10),
                                Text(
                                  '회의실 전체가 다 보이도록 사진을 찍어 올려주세요!',
                                  style: KR.label2.copyWith(color: MGColor.brandPrimary),
                                ),
                                SizedBox(height: ratio.height * 4),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _startCamera,
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MGColor.base7,
                                        borderRadius: BorderRadius.circular(8),
                                        image: _picturePath == null ? null :
                                            DecorationImage(
                                              image: FileImage(File(_picturePath!)),
                                              fit: BoxFit.fitWidth
                                            )
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            MGIcon.camera,
                                            size: 24,
                                            color: _picturePath == null
                                                ? MGColor.base4
                                                : MGColor.base2
                                          ),
                                          SizedBox(height: ratio.height * 4),
                                          Text("사진 업로드", style: KR.parag2.copyWith(
                                            color: _picturePath == null
                                                ? MGColor.base4
                                                : MGColor.base2
                                          ))
                                        ]
                                      ),
                                    )
                                  ),
                                )
                              ]
                            )
                          ),

                          SizedBox(height: ratio.height * 12),

                          /// 회의실
                          Container(
                            width: ratio.width * 358,
                            height: ratio.height * 60,
                            padding: EdgeInsets.symmetric(
                              horizontal: ratio.width * 16,
                              vertical: ratio.height * 16
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Text('회의실', style: KR.parag1.copyWith(color: Colors.black)),
                                SizedBox(width: ratio.width * 26),
                                Text(place!, style: KR.parag2.copyWith(color: MGColor.base3))
                              ],
                            )
                          ),

                          SizedBox(height: ratio.height * 12),

                          /// 사용 일시
                          Container(
                              width: ratio.width * 358,
                              height: ratio.height * 60,
                              padding: EdgeInsets.symmetric(
                                horizontal: ratio.width * 16,
                                vertical: ratio.height * 16
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Text('사용 일시', style: KR.parag1.copyWith(color: Colors.black)),
                                  SizedBox(width: ratio.width * 10),
                                  time
                                ],
                              )
                          ),

                          SizedBox(height: ratio.height * 12),

                          /// 대표자
                          Container(
                              width: ratio.width * 358,
                              height: ratio.height * 60,
                              padding: EdgeInsets.symmetric(
                                horizontal: ratio.width * 16,
                                vertical: ratio.height * 16
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Text('대표자', style: KR.parag1.copyWith(color: Colors.black)),
                                  SizedBox(width: ratio.width  * 26),
                                  Text(leaderInfo, style: KR.parag2.copyWith(color: MGColor.base3))
                                ],
                              )
                          ),

                          SizedBox(height: ratio.height * 12),

                          /// 사용 후기
                          Container(
                            width: ratio.width * 358,
                            height: 150,
                            padding: EdgeInsets.symmetric(
                              horizontal: ratio.width * 16,
                              vertical: ratio.height * 16
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('사용 후기', style: KR.subtitle3.copyWith(color: Colors.black)),
                                SizedBox(height: ratio.height * 10),
                                Expanded(child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ratio.width * 12,
                                    vertical: ratio.height * 10
                                  ),
                                  decoration: BoxDecoration(
                                    color: MGColor.base7,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.topLeft,
                                  child: TextField(
                                    controller: _textCtr,
                                    maxLength: 70,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: KR.parag2,
                                    decoration: InputDecoration(
                                      hintText: '후기를 입력해주세요!',
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      hintStyle: KR.parag2.copyWith(color: MGColor.base3)
                                    ),
                                  )
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  /// 인증하기 버튼
                  Positioned(
                    bottom: ratio.height * 10,
                    left: ratio.width * 16,
                    child: CustomButtons.bottomButton(
                      '인증하기',
                      MGColor.brandPrimary,
                      doubleCheck
                    )
                  )
                ]),
              ),
            ),
          ),
        ),

        ///
        if (loading)
          const ProgressScreen()
      ],
    );
  }

  Future<void> _startCamera() async {
    try {
      await _initializeControllerFuture;
      if (_controller.value.isInitialized) {
        final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          setState(() => _picturePath = pickedFile.path);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void doubleCheck() {
    if (_picturePath == null) {
      showDialog(
        context: context,
        barrierColor: MGColor.barrier,
        builder: (context) => CommentPopup(
          title: '인증 사진을 업로드해주세요!',
          onPressed: () => Navigator.pop(context)
        )
      );
    } else if (_textCtr.text.isEmpty) {
      showDialog(
        context: context,
        barrierColor: MGColor.barrier,
        builder: (context) => CommentPopup(
          title: '후기를 입력해주세요!',
          onPressed: () => Navigator.pop(context)
        )
      );
    } else {
      showDialog(
        context: context,
        barrierColor: MGColor.barrier,
        builder: (context) => AlertPopup(
          title: '인증은 수정할 수 없습니다\n정말 업로드 하시겠습니까?',
          agreeMsg: '인증하기',
          onAgreed: () {
            Navigator.pop(context);
            admit();
          }
        )
      );
    }
  }

  Future<void> admit() async {
    bool allClear = false;
    late final String title;
    late final Function() onPressed;

    setState(() => loading = true);

    final expension = _picturePath!.substring(_picturePath!.lastIndexOf('.'));
    final bytes = await File(_picturePath!).readAsBytes();
    debugPrint("""
      [reservation Info]
        . room: $place
        . startTime: ${widget.reserve.startToDate1()}
        . endTime: ${widget.reserve.endToDate1()}
        . leader: $leaderInfo
        . review: ${_textCtr.text}
        . photo: $bytes""");

    try {
      int? uid = await RestAPI.addAdmission(
          reservationId: widget.reserve.reservationId,
          review: _textCtr.text,
          photo: base64Encode(bytes),
          photoExtension: expension
      );
      if (uid == null) {
        title = 'Not found';
        onPressed = () => Navigator.pop(context);
      } else {
        allClear = true;
        title = '인증했습니다!';
        onPressed = () {
          listListener.add(StreamType.reserve);
          listListener.add(StreamType.admit);
          Navigator.popUntil(context, (route) => route.isFirst);
        };
      }
    } on TimeoutException{
      title = '통신 속도가 너무 느려요!';
      onPressed = () => Navigator.pop(context);
    } catch(_) {
      title = '[400] 서버와의 통신에 문제가 있습니다.';
      onPressed = () => Navigator.pop(context);
    }

    setState(() {
      loading = false;
      showDialog(
          context: context,
          barrierColor: MGColor.barrier,
          builder: (context) => CommentPopup(
              title: title, onPressed: onPressed)
      ).then((_) {
        if (allClear) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    });
  }
}

class NewAdmitPage extends StatefulWidget {
  const NewAdmitPage({super.key, required this.setLoading});
  final void Function(bool) setLoading;
  @override
  State<NewAdmitPage> createState() => _NewAdmitPageState();
}

class _NewAdmitPageState extends State<NewAdmitPage> {
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
        body:
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ratio.width * 16),
          child:  FutureBuilder<List<Reserve>?>(
              future: reserves.isEmpty ? RestAPI.getAllReservation() : null,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                      height: 218,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                          '통신 속도가 너무 느립니다!',
                          style: KR.subtitle4.copyWith(
                              color: MGColor.base3)
                      )
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) return const ProgressWidget();
                if (snapshot.hasData) reserves = snapshot.data!;
                if (reserves.isNotEmpty) {
                  return RefreshIndicator(
                    displacement: 0,
                    color: MGColor.brandPrimary,
                    onRefresh: _onRefreshed,
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: ratio.height * 30),
                        physics: const AlwaysScrollableScrollPhysics()
                            .applyTo(const BouncingScrollPhysics()),
                        itemCount: reserves.length,
                        itemBuilder: (_, index) => _listItem(reserves[index])
                    ),
                  );
                } else {
                  return Container(
                      height: ratio.height * 594,
                      alignment: Alignment.center,
                      child: Text(
                          '아직 예약 내역이 없어요!',
                          style: KR.subtitle4.copyWith(
                              color: MGColor.base3)
                      )
                  );
                }
              }
          )
        )
    );
  }

  Widget _listItem(Reserve reserve) {
    late EdgeInsetsGeometry margin, padding;
    late Text firstText, secondText, thirdText;

    if (reserve.service == ServiceType.computer) {
      margin = const EdgeInsets.symmetric(vertical: 16);
      padding = EdgeInsets.symmetric(
          horizontal: ratio.width * 16, vertical: 26);
      secondText = Text(
        '${reserve.startToDate2()} ~ ${reserve.endToDate2()}',
        style: KR.parag2.copyWith(color: MGColor.base3),
      );
      thirdText = Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '전담 교수님 ',
                style: KR.parag2.copyWith(color: MGColor.base3)
            ),
            TextSpan(
                text: reserve.professor,
                style: KR.parag2.copyWith(color: MGColor.brandSecondary)
            ),
          ],
        ),
      );
    } else {
      margin = const EdgeInsets.symmetric(vertical: 4);
      padding = EdgeInsets.symmetric(
          horizontal: ratio.width * 16, vertical: 12);
      secondText = Text(reserve.startToDate1(),
          style: KR.parag2.copyWith(color: MGColor.base3));
      thirdText = Text(reserve.toDuration(),
          style: KR.parag2.copyWith(color: MGColor.base3));
    }

    if (reserve.service == ServiceType.lectureRoom && reserve.place == '-1') {
      firstText = Text('배정 중', style: KR.subtitle3.copyWith(color: Colors.red));
    } else {
      firstText = Text(reserve.place!, style: KR.subtitle3);
    }

    return GestureDetector(
      onTap: () async {
        int? status = await RestAPI.currentReservationStatus(reservationId: reserve.reservationId);
        showDialog(
            context: context,
            builder: (_) => ReservationPopup(reserve, status!, widget.setLoading)
        );
      },
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            border: stdFormat3.format(reserve.startTime) == today
                ? Border.all(color: MGColor.brandPrimary) : null
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                firstText,
                SizedBox(height: ratio.height * 8),
                secondText,
                SizedBox(height: ratio.height * 4),
                thirdText
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
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => reserves.clear());
  }
}

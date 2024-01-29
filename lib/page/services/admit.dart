import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widget/popup.dart';
import 'package:mata_gachon/widget/small_widgets.dart';
import 'package:mata_gachon/page/services/using_camera.dart';



class AdmitPage extends StatefulWidget {
  const AdmitPage({Key? key, required this.reservate}) : super(key: key);

  final Reservate reservate;

  @override
  State<AdmitPage> createState() => _AdmitPageState();
}

class _AdmitPageState extends State<AdmitPage> {
  final TextEditingController _textCtr = TextEditingController();

  late String room;
  late String leaderInfo;
  late String date;
  late String begin;
  late String end;
  late bool loading;

  String? _picturePath;

  @override
  void initState() {
    super.initState();
    loading = false;

    room = widget.reservate.room;
    leaderInfo = widget.reservate.leaderInfo;
    // Todo
    // 효율성 개편
    final temp1 = widget.reservate.date.split(' ').first;
    date = date2_format.format(std2_format.parse(temp1));
    final temp2 = widget.reservate.time.split(' ~ ');
    begin = temp2[0];
    end = temp2[1];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///
        Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(AppinIcon.back),
                iconSize: 24,
              ),
              title: Text("강의실 인증하기",
                  style: KR.subtitle1.copyWith(color: MGcolor.base1))),
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
                                style: KR.label2.copyWith(color: MGcolor.brand_orig),
                              ),
                              SizedBox(height: ratio.height * 4),
                              Expanded(
                                child: GestureDetector(
                                  onTap: moveToCamera,
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: MGcolor.base6,
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
                                          AppinIcon.camera,
                                          size: 24,
                                          color: _picturePath == null
                                              ? MGcolor.base4
                                              : MGcolor.base2
                                        ),
                                        SizedBox(height: ratio.height * 4),
                                        Text("사진 업로드", style: KR.parag2.copyWith(
                                          color: _picturePath == null
                                              ? MGcolor.base4
                                              : MGcolor.base2
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
                              Text(room, style: KR.parag2.copyWith(color: MGcolor.base3))
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
                                RichText(text: TextSpan(
                                  style: EN.parag2.copyWith(color: MGcolor.base3),
                                  children: [
                                    TextSpan(text: date),
                                    TextSpan(text: ' | ', style: EN.parag1.copyWith(color: MGcolor.base1)),
                                    TextSpan(text: '$begin ~ $end')
                                  ]
                                ))
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
                                Text(leaderInfo, style: KR.parag2.copyWith(color: MGcolor.base3))
                              ],
                            )
                        ),

                        SizedBox(height: ratio.height * 12),

                        /// 사용 후기
                        Container(
                          width: ratio.width * 358,
                          height: ratio.height * 150,
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
                                  color: MGcolor.base6,
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
                                    hintStyle: KR.parag2.copyWith(color: MGcolor.base3)
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
                  child: ElevatedButton(
                    onPressed: doubleCheck,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MGcolor.brand_orig,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                      fixedSize: Size(ratio.width * 358, ratio.height * 48)
                    ),
                    child: Text(
                      "인증하기",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16 * ratio.height,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  )
                )
              ]),
            ),
          ),
        ),

        ///
        if (loading)
          ProgressScreen()
      ],
    );
  }

  void moveToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
           takenPictrue: (path) {
             setState(() => this._picturePath = path);
           }
        )
      )
    );
  }

  void doubleCheck() {
    if (_picturePath == null) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (context) => CommentPopup(
          title: '인증 사진을 업로드해주세요!',
          onPressed: () => Navigator.pop(context)
        )
      );
    } else if (_textCtr.text.isEmpty) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (context) => CommentPopup(
          title: '후기를 입력해주세요!',
          onPressed: () => Navigator.pop(context)
        )
      );
    } else {
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.25),
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
        . room: $room
        . startTime: $date $begin
        . endTime: $date $end
        . leader: $leaderInfo
        . member: ???
        . review: ${_textCtr.text}
        . photo: ${bytes}""");

    try {
      int? uid = await RestAPI.addAdmission(
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
          listListener.add(StreamType.reservate);
          listListener.add(StreamType.admit);
          Navigator.popUntil(context, (route) => route.isFirst);
        };
      }
    } catch(_) {
      title = '[400] 서버와의 통신에 문제가 있습니다.';
      onPressed = () => Navigator.pop(context);
    }

    setState(() {
      loading = false;
      showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.25),
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


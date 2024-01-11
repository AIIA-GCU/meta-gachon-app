import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mata_gachon/config/variable.dart';



class Admission extends StatefulWidget {
  const Admission({Key? key}) : super(key: key);

  @override
  State<Admission> createState() => _AdmissionState();
}

class _AdmissionState extends State<Admission> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Expanded(child: Container(
                            decoration: BoxDecoration(
                              color: MGcolor.base6,
                              borderRadius: BorderRadius.circular(8)
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(AppinIcon.edit, size: 24, color: MGcolor.base4),
                                SizedBox(height: ratio.height * 4),
                                Text("사진 업로드", style: KR.parag2.copyWith(color: MGcolor.base4))
                              ],
                            ),
                          ))
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
                          Text('404 - 1', style: KR.parag2.copyWith(color: MGcolor.base3))
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
                                TextSpan(text: '2024.1.6'),
                                TextSpan(text: ' | ', style: EN.parag1.copyWith(color: MGcolor.base1)),
                                TextSpan(text: '13:00 ~ 16:00')
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
                            Text('202300001 김가천', style: KR.parag2.copyWith(color: MGcolor.base3))
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

            ///예약하기 버튼
            Positioned(
              bottom: ratio.height * 10,
              left: ratio.width * 16,
              child: ElevatedButton(
                onPressed: () {

                },
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
    );
  }
}


import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';

class HOME extends StatefulWidget {
  @override
  _HOMEState createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;


    return Scaffold(

      body: Stack(
        children: [
          Container(
            color: MGcolor.base6,
          ),
          Positioned(
            left: screenWidth/18-7,
            top: screenHeight-710,
            child: Icon(MGLogo.logo_typo_hori, color:MGcolor.base4 ,size: 25),
          ),
          Positioned(
            left: screenWidth/18+330,
            top: screenHeight-710,
            child: Icon( AppinIcon.not, color:MGcolor.base4 ,size: 25),
          ),
          //첫 번째
          Stack(
            children: [
              Positioned(
                left: screenWidth / 18 - 7,
                top: screenHeight / 5 - 50,
                child: Container(
                  width: 173,
                  height: screenHeight / 4 + 26,
                  decoration: BoxDecoration(
                    color: MGcolor.base7,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth / 18+8,  // 조절 필요
                top: screenHeight / 5 - 40,  // 조절 필요
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // 조절 필요
                  child: Image.asset(
                    ImgPath.home_img3,
                    width: screenWidth / 3 + 13,
                    height: screenHeight / 7 + 9,
                    fit: BoxFit.cover, // 이미지의 적절한 크기 조절
                  ),
                ),
              ),
              Positioned(
                left: screenWidth / 18+7,  // 조절 필요
                top: screenHeight / 4+45,  // 조절 필요
                child: Text(
                  '강의실을 빌려',
                  style: KR.subtitle3,
                ),
              ),
              Positioned(
                left: screenWidth / 18 +7,  // 조절 필요
                top: screenHeight / 3+3,  // 조절 필요
                child: Text(
                  '편하게 공부해요!',
                  style: KR.subtitle3,
                ),
              ),
              Positioned(
                left:screenWidth / 18 +7,
                top:screenHeight / 3+22,
                child:ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MGcolor.btn_active,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(16, 30),
                  ),
                  child: Text(
                    '예약하기',
                    style: KR.subtitle3.copyWith(
                      color: MGcolor.btn_inactive,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //두 번째
          Stack(
            children: [
              Positioned(
                left: screenWidth / 1.8 - 15,
                top: screenHeight / 5 - 50,
                child: Container(
                  width: 173,
                  height: screenHeight / 4 + 26,
                  decoration: BoxDecoration(
                    color: MGcolor.base7,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          Positioned(
            left: screenWidth /1.8-1,  // 조절 필요
            top: screenHeight / 5 - 40,  // 조절 필요
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // 조절 필요
              child: Image.asset(
                ImgPath.home_img2,
                width: screenWidth / 3 + 13,
                height: screenHeight / 7 + 9,
                fit: BoxFit.cover, // 이미지의 적절한 크기 조절
              ),
            ),
          ),
          Positioned(
            left: screenWidth / 1.8-1,  // 조절 필요
            top: screenHeight / 4+45,  // 조절 필요
            child: Text(
              '강의실 이용 후',
              style: KR.subtitle3,
            ),
          ),
          Positioned(
            left: screenWidth / 1.8 -1,  // 조절 필요
            top: screenHeight / 3+2,  // 조절 필요
            child: Text(
              '인증을 올려주세요!',
              style: KR.subtitle3,
            ),
          ),
          Positioned(
            left:screenWidth / 1.8 -1,
            top:screenHeight / 3+22,
            child:ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: MGcolor.btn_active,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(16, 30),
              ),
              child: Text(
                '인증하기',
                style: KR.subtitle3.copyWith(
                  color: MGcolor.btn_inactive,
                ),
              ),
            ),
          ),
        ],
      ),
          Positioned(
            left: screenWidth/18-7,
            top: screenHeight/5+175,
            child: Text(
              '내 정보를 빠르게 확인해요!',
              style: KR.subtitle1,
            ),
          ),
          //세 번째
          Stack(
            children: [
              Positioned(
                left: screenWidth - 375,
                top: screenHeight - 420,
                child: Container(
                  width: 358,
                  height: screenHeight / 7,
                  decoration: BoxDecoration(
                    color: MGcolor.base7,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                left:  screenWidth - 365,  // 조절 필요
                top: screenHeight - 410,  // 조절 필요
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // 조절 필요
                  child: Image.asset(
                    ImgPath.home_img5,
                    width: screenWidth / 3 - 14,
                    height: screenHeight / 9 + 7,
                    fit: BoxFit.cover, // 이미지의 적절한 크기 조절
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 413,  // 조절 필요
                child: Text(
                  '현재 나의 등급은?',
                  style: KR.subtitle3,
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 388,  // 조절 필요
                child: Text(
                  '나는 지금 강의실을 얼마나',
                  style: KR.label1.copyWith(
                      color:MGcolor.base3
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 373,  // 조절 필요
                child: Text(
                  '잘 사용하고 있을지 확인해요!',
                  style: KR.label1.copyWith(
                      color:MGcolor.base3
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,
                top:screenHeight - 355,
                child:ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MGcolor.btn_active,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(102, 30),
                  ),
                  child: Text(
                    '등급 확인하기',
                    style: KR.subtitle3.copyWith(
                      color: MGcolor.btn_inactive,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //네 번째
          Stack(
            children: [
              Positioned(
                left: screenWidth - 375,
                top: screenHeight - 300,
                child: Container(
                  width: 358,
                  height: screenHeight / 7,
                  decoration: BoxDecoration(
                    color: MGcolor.base7,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                left:  screenWidth - 365,  // 조절 필요
                top: screenHeight - 290,  // 조절 필요
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // 조절 필요
                  child: Image.asset(
                    ImgPath.home_img4,
                    width: screenWidth / 3 - 14,
                    height: screenHeight / 9 + 7,
                    fit: BoxFit.cover, // 이미지의 적절한 크기 조절
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 292,  // 조절 필요
                child: Text(
                  '내가 언제 예약했더라?',
                  style: KR.subtitle3,
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 265,  // 조절 필요
                child: Text(
                  '내가 예약한 강의실과',
                  style: KR.label1.copyWith(
                      color:MGcolor.base3
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 250,  // 조절 필요
                child: Text(
                  '예약 시간을 확인해요!',
                  style: KR.label1.copyWith(
                      color:MGcolor.base3
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,
                top:screenHeight - 235,
                child:ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MGcolor.btn_active,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(102, 30),
                  ),
                  child: Text(
                    '내 예약 확인하기',
                    style: KR.subtitle3.copyWith(
                      color: MGcolor.btn_inactive,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 다섯 번째
          Stack(
            children: [
              Positioned(
                left: screenWidth - 375,
                top: screenHeight - 180,
                child: Container(
                  width: 358,
                  height: screenHeight / 7,
                  decoration: BoxDecoration(
                    color: MGcolor.base7,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                left:  screenWidth - 365,  // 조절 필요
                top: screenHeight - 170,  // 조절 필요
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // 조절 필요
                  child: Image.asset(
                    ImgPath.home_img1,
                    width: screenWidth / 3 - 14,
                    height: screenHeight / 9 + 7,
                    fit: BoxFit.cover, // 이미지의 적절한 크기 조절
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 172,  // 조절 필요
                child: Text(
                  '과연 나의 깔끔 점수는?',
                  style: KR.subtitle3,
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 145,  // 조절 필요
                child: Text(
                  '내가 올린 인증 사진 점수는',
                  style: KR.label1.copyWith(
                      color:MGcolor.base3
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,  // 조절 필요
                top: screenHeight - 130,  // 조절 필요
                child: Text(
                  '과연 몇 점일지 확인해요!',
                  style: KR.label1.copyWith(
                      color:MGcolor.base3
                  ),
                ),
              ),
              Positioned(
                left: screenWidth - 240,
                top:screenHeight - 115,
                child:ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MGcolor.btn_active,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(102, 30),
                  ),
                  child: Text(
                    '내 인증 확인하기',
                    style: KR.subtitle3.copyWith(
                      color: MGcolor.btn_inactive,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() => currentPageIndex = index);
        },
        backgroundColor: MGcolor.base7,
        selectedItemColor: MGcolor.base1,
        unselectedItemColor: MGcolor.base4,
        selectedIconTheme: IconThemeData(color:MGcolor.btn_active),
        unselectedIconTheme: IconThemeData(color: MGcolor.base4),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(AppinIcon.home),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppinIcon.res),
            label: "예약",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppinIcon.cert),
            label: "인증",
          ),
          BottomNavigationBarItem(
            icon: Icon(AppinIcon.my),
            label: "마이",
          ),
        ],
        showUnselectedLabels: true,
      ),
    );
  }
}

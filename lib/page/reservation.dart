///추호성이꺼

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widget/calender.dart';
import 'package:mata_gachon/main.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

/*
  W * H

  screen : 390*895

  강의실 : 358*52
  캘린더 : 358*198
  예약시간 : 358*73
  대표자 : 358*52
  이용자 : 358*()
*/

class Reservation extends StatefulWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  ///기기 스크린 사이즈
  late Size screenSize;

  ///강의실 목록
  late List<String> rooms;

  ///시간 드롭다운메뉴 아이템들
  late List<String> times;

  ///유저가 선택한 저장변수들
  String? selectedRoom;
  String? selectedEnter;
  String? selectedExit;

  @override
  void initState() {
    super.initState();

    // times 리스트 초기화
    times = List.generate(
        17, (index) => "${(6 + index).toString().padLeft(2, '0')}:00");
    // rooms 리스트 초기화
    rooms = [
      '402 - 1',
      '402 - 2',
      '402 - 3',
      '402 - 4',
      '402 - 5',
    ];
    /*//화면 크기 불러오기, 비율계산
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        screenSize = MediaQuery.of(context).size;
        ratio = 390 / screenSize.width;
      });
    });*/
  }

  ///textfield controllor
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(AppinIcon.back, size: 24*ratio),
              ),
              SizedBox(width: 16*ratio),
              Text("강의실 예약하기",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18*ratio,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
              )
            ],
          ),
        ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //여기
            children: [
              ///회의실 선택
              MyContainer(title: "회의실", height: 52, content: [
                CustomDropdownMenu(
                  hint: "선택",
                  items: rooms,
                  onChanged: (value) {
                    setState(() {
                      selectedRoom = value;
                    });
                  },
                  selectedItem: selectedRoom,
                )
              ], additionalContent: []),

              ///날짜 선택
              MyContainer(
                title: 'October',
                height: 198,
                content: [],
                additionalContent: [
                  Positioned(
                    top: 43 * ratio,
                    left: 11 * ratio,
                    child: CustomCalender(
                      first: DateTime.now(),
                      last: DateTime.now().add(Duration(days: 13)),
                      rowHeight: 32 * ratio,
                      rowWidth: 38 * ratio,
                      cellStyle: CellStyle(
                        fieldTextStyle:
                            EN.label1.copyWith(color: MGcolor.base3),
                        normalDateTextStyle:
                            EN.parag1.copyWith(color: MGcolor.base1),
                        normalDateBoxDecoration: BoxDecoration(
                            color: MGcolor.base6,
                            borderRadius: BorderRadius.circular(4)),
                        selectedDateTextStyle:
                            EN.parag1.copyWith(color: Colors.white),
                        selelctedDateBoxDecoration: BoxDecoration(
                            color: MGcolor.btn_active,
                            borderRadius: BorderRadius.circular(4)),
                        todayTextStyle:
                            EN.parag1.copyWith(color: MGcolor.btn_active),
                        todayBoxDecoration: BoxDecoration(
                            color: MGcolor.base6,
                            borderRadius: BorderRadius.circular(4)),
                        rangeOutDateTextStyle:
                            EN.parag1.copyWith(color: MGcolor.base5),
                        rangeOutDateBoxDecoration: BoxDecoration(
                            color: MGcolor.base6,
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  )
                ],
              ),

              ///예약 시간 선택
              MyContainer(
                title: "예약 시간",
                height: 73,
                content: [
                  CustomDropdownMenu(
                    hint: "입실",
                    items: times,
                    onChanged: (value) {
                      setState(() {
                        selectedEnter = value;
                      });
                    },
                    selectedItem: selectedEnter,
                  ),
                  Container(width: 22 * ratio, child: Center(child: Text("~"))),
                  CustomDropdownMenu(
                    hint: "퇴실",
                    items: times,
                    onChanged: (value) {
                      setState(() {
                        selectedExit = value;
                      });
                    },
                    selectedItem: selectedExit,
                  ),
                ],
                additionalContent: [
                  Positioned(
                      left: 80 * ratio,
                      top: 46 * ratio,
                      child: Text('예약은 최대 3시간 까지 가능합니다!',
                          style: TextStyle(
                            color: Color(0xFF1662DA),
                            fontSize: 12 * ratio,
                            fontFamily: 'Noto Sans KR',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          )))
                ],
              ),

              MyContainer(
                title: "대표자",
                height: 52,
                content: [],
                additionalContent: [
                  Positioned(
                      left: 80 * ratio,
                      top: 16 * ratio,
                      child: Row(
                        children: [
                          Text(
                            '20230001',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 14 * ratio,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: -0.32,
                            ),
                          ),
                          SizedBox(width: 4 * ratio),
                          Text(
                            '김가천',
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 14 * ratio,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: -0.32,
                            ),
                          ),
                        ],
                      ))
                ],
              ),

              MyContainer(title: "이용자", height: 100, content: [
                SizedBox(
                  width: 122 * ratio,
                  height: 32 * ratio,
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 27, right: 27, top: 8, bottom: 7),
                      border: OutlineInputBorder(
                        // 테두리 스타일
                        borderRadius: BorderRadius.circular(4),
                        // 모서리 둥글기
                        borderSide: BorderSide(
                          color: Color(0xFF1762DB), // 테두리 색상
                          width: 1, // 테두리 두께
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // 테두리 스타일
                        borderRadius: BorderRadius.circular(4),
                        // 모서리 둥글기
                        borderSide: BorderSide(
                          color: Color(0xFF1762DB), // 테두리 색상
                          width: 1, // 테두리 두께
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      print("Text changed: $text");
                    },
                  ),
                ),
                SizedBox(width: 8 * ratio),
                SizedBox(
                  width: 92 * ratio,
                  height: 32 * ratio,
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -0.32,
                    ),
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 27, right: 27, top: 8, bottom: 7),
                      border: OutlineInputBorder(
                        // 테두리 스타일
                        borderRadius: BorderRadius.circular(4),
                        // 모서리 둥글기
                        borderSide: BorderSide(
                          color: Color(0xFF1762DB), // 테두리 색상
                          width: 1, // 테두리 두께
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // 테두리 스타일
                        borderRadius: BorderRadius.circular(4),
                        // 모서리 둥글기
                        borderSide: BorderSide(
                          color: Color(0xFF1762DB), // 테두리 색상
                          width: 1, // 테두리 두께
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      print("Text changed: $text");
                    },
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

///커스텀 컨테이너
class MyContainer extends StatelessWidget {
  final List<Widget> content;
  final List<Widget>? additionalContent;
  final String title;
  final int height;

  const MyContainer({
    required this.title,
    required this.height,
    required this.content,
    this.additionalContent, // 생성자를 통해 ratio를 받음
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 0,
        bottom: 12 * ratio,
        left: 0,
        right: 0,
      ),
      width: 358 * ratio,
      height: height * ratio,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(children: [
        Positioned(
          left: 16 * ratio,
          top: 16 * ratio,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w500,
              height: 0,
              letterSpacing: -0.32,
            ),
          ),
        ),
        Positioned(
          left: 80 * ratio,
          top: 10 * ratio,
          child: Row(
            children: content, // combined 리스트를 사용합니다.
          ),
        ),
        ...?additionalContent
      ]),
    );
  }
}

///커스텀 드롭다운메뉴위젯
class CustomDropdownMenu extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? selectedItem;
  final Function(String?) onChanged;

  const CustomDropdownMenu({
    Key? key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.selectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120 * ratio,
      height: 32 * ratio,

      ///드롭다운메뉴 위젯
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          alignment: Alignment.center,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 14 * ratio,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: _addDividersAfterItems(items),
          value: selectedItem,
          onChanged: onChanged,

          ///드롭버튼(선택된 항목) 디자인
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.all(0),
            height: 40 * ratio,
            width: 140 * ratio,
            decoration: BoxDecoration(
              color: Colors.white, // 배경 색상
              borderRadius: BorderRadius.circular(4), // 모서리 둥글기
              border: Border.all(
                color: Color(0xFF1762DB), // 테두리 색상
                width: 1, // 테두리 두께
              ),
            ),
          ),

          ///드롭아이콘 디자인
          iconStyleData: IconStyleData(
            iconSize: 0, //아이콘 표시x
          ),

          ///메뉴창 디자인
          dropdownStyleData: DropdownStyleData(
              offset: Offset(0, -4),
              //위치조정
              padding: EdgeInsets.all(0),
              maxHeight: 85 * ratio,
              //최대크기
              elevation: 0,
              //그림자 없앰
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ], color: Colors.white.withOpacity(0.9) //배경투명도
                  )),

          ///메뉴들(선택지들) 디자인
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            customHeights: _getCustomItemsHeights(items),
          ),
        ),
      ),
    );
  }

  ///드롭다운메뉴창에 아이템(선택지)을 넣어주는 메소드입니다. 리턴값은 아이템이 각각 위젯형태로 들어간 리스트입니다.
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> inItems) {
    final List<DropdownMenuItem<String>> menuItems = [];

    ///아이템 개수만큼 반복합니다.
    for (final String item in inItems) {
      menuItems.addAll(
        [
          ///위젯형태의 아이템(선택지) 넣기
          DropdownMenuItem<String>(
              value: item,
              child: Center(
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: (item == selectedItem)
                        ? Colors.black
                        : Color(0xFF7C7C7C),
                    fontSize: 14 * ratio,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
              )),
          //If it's last item, we will not add Divider after it.
          ///아이템 하나마다 끝에 divider 넣기
          if (item != inItems.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                color: Color(0xFFDDDDDD),
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  ///드롭다운메뉴창에 item(선택지)의 크기를 지정해주는 메소드입니다.
  List<double> _getCustomItemsHeights(List<String> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      ///짝수 인덱스(0,2,4, ...)에 아이템이 있겠죠?
      if (i.isEven) {
        itemsHeights.add(24 * ratio);
      }

      ///홀수 인덱스에 divider가 있겠죠?
      if (i.isOdd) {
        itemsHeights.add(1);
      }
    }
    return itemsHeights;
  }
}

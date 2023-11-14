///추호성이꺼

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widget/calender.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class Reservation extends StatefulWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  State<Reservation> createState() => _ReservationState();
}
class _ReservationState extends State<Reservation> {

  ///강의실 드롭다운메뉴 아이템들(선택지들)
  final List<String> rooms = [
    '402 - 1',
    '402 - 2',
    '402 - 3',
    '402 - 4',
    '402 - 5',
  ];
  ///시간 드롭다운메뉴 아이템들
  final List<String> times = [];
  _ReservationState() {
    for(int i = 6; i <= 22; i++) {
      times.add("${i.toString().padLeft(2, '0')}:00");
    }
  }

  ///유저가 선택한 저장변수들
  String? selectedRoom;
  String? selectedEnter;
  String? selectedExit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(AppinIcon.back, size: 24)
        ),
        title: Text("강의실 예약하기",
            style: TextStyle(color: Colors.black, fontSize: 18))
      ),
      body: Center(
        child: Column(
          //여기
          children: [
            ///강의실 선택란
            Container(
              height: 52,
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 0, // 위쪽 마진
                bottom: 12, // 아래쪽 마진
                left: 16, // 왼쪽 마진
                right: 16, // 오른쪽 마진
              ),
              padding: EdgeInsets.only(
                top: 10, // 위쪽
                bottom: 10, // 아래쪽
                left: 16, // 왼쪽
                right: 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 5,
                      child: Text(
                        "강의실",
                        style: KR.parag1,
                      )),
                  Positioned(
                    left: 64,
                    top: 0,
                    child: CustomDropdownMenu(
                      hint: "선택",
                      items: rooms,
                      onChanged: (value){
                        setState(() {
                          selectedRoom = value;
                        });
                      },
                      selectedItem: selectedRoom,
                    )
                  ),
                ],
              ),
            ),

            ///캘린더
            Container(
              height: 198,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 월
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'October',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '~',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'November',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    )
                  ),
                  // 달력
                  Container(
                    width: 358,
                    height: 166,
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: CustomCalender(
                      first: DateTime.now(),
                      last:  DateTime.now().add(Duration(days: 13)),
                      rowHeight: 32,
                      cellStyle: CellStyle(
                        fieldTextStyle: EN.label1.copyWith(color: MGcolor.base3),
                        normalDateTextStyle: EN.parag1.copyWith(color: MGcolor.base1),
                        normalDateBoxDecoration: BoxDecoration(
                            color: MGcolor.base6, borderRadius: BorderRadius.circular(4)),
                        selectedDateTextStyle: EN.parag1.copyWith(color: Colors.white),
                        selelctedDateBoxDecoration: BoxDecoration(
                            color: MGcolor.btn_active, borderRadius: BorderRadius.circular(4)),
                        todayTextStyle: EN.parag1.copyWith(color: MGcolor.btn_active),
                        todayBoxDecoration: BoxDecoration(
                            color: MGcolor.base6, borderRadius: BorderRadius.circular(4)),
                        rangeOutDateTextStyle: EN.parag1.copyWith(color: MGcolor.base5),
                        rangeOutDateBoxDecoration: BoxDecoration(
                            color: MGcolor.base6, borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  )
                ],
              ),
            ),

            ///예약 시간
            Container(
              height: 73,
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 0, // 위쪽 마진
                bottom: 12, // 아래쪽 마진
                left: 16, // 왼쪽 마진
                right: 16, // 오른쪽 마진
              ),
              padding: EdgeInsets.only(
                top: 10, // 위쪽
                bottom: 10, // 아래쪽
                left: 16, // 왼쪽
                right: 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(children: [
                Positioned(
                    top: 5,
                    child: Text(
                      "예약 시간",
                      style: KR.parag1,
                    )),
                Positioned(
                  left: 64,
                  top: 0,
                  child: Row(
                    children: [
                      CustomDropdownMenu(
                        hint: "입실",
                        items: times,
                        onChanged: (value){
                          setState(() {
                            selectedEnter = value;
                          });
                        },
                        selectedItem: selectedEnter,
                      ),
                      Container(width: 22, child: Center(child: Text("~"))),
                      CustomDropdownMenu(
                        hint: "퇴실",
                        items: times,
                        onChanged: (value){
                          setState(() {
                            selectedExit = value;
                          });
                        },
                        selectedItem: selectedExit,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    left: 64,
                    top: 35,
                    child: Text('예약은 최대 3시간 까지 가능합니다!',
                        style: TextStyle(
                          color: Color(0xFF1662DA),
                          fontSize: 12,
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        )))
              ]),
            ),

            ///대표자
            Container(
              height: 52,
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 0, // 위쪽 마진
                bottom: 12, // 아래쪽 마진
                left: 16, // 왼쪽 마진
                right: 16, // 오른쪽 마진
              ),
              padding: EdgeInsets.only(
                top: 0, // 위쪽
                bottom: 0, // 아래쪽
                left: 0, // 왼쪽
                right: 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Text('대표자',
                      style: KR.parag1
                    ),
                  ),
                  Positioned(
                    left: 80,
                    top: 16,
                    child: Container(
                      width: 108,
                      height: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '20230001',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: -0.32,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '김가천',
                            style: TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 14,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: -0.32,
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
      width: 120,
      height: 32,
      ///드롭다운메뉴 위젯
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          alignment: Alignment.center,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: _addDividersAfterItems(items),
          value: selectedItem,
          onChanged: onChanged,
          ///드롭버튼(선택된 항목) 디자인
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.all(0),
            height: 40,
            width: 140,
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
            iconSize: 0,//아이콘 표시x
          ),
          ///메뉴창 디자인
          dropdownStyleData: DropdownStyleData(
              offset: Offset(0,-4),//위치조정
              padding: EdgeInsets.all(0),
              maxHeight: 85,//최대크기
              elevation: 0,//그림자 없앰
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    )
                  ],
                color: Colors.white.withOpacity(0.9)//배경투명도
              )
          ),
          ///메뉴들(선택지들) 디자인
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            customHeights: _getCustomItemsHeights(items),
          ),
        ),
      ),
      /*DropdownButtonFormField2<String>(
                        alignment: Alignment.center,

                        isExpanded: true,

                        decoration: InputDecoration(

                          // Add Horizontal padding using menuItemStyleData.padding so it matches
                          // the menu padding when button's width is not specified.
                          contentPadding: EdgeInsets.all(0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(width: 0, color: Color(0xFF1762DB)),
                          ),
                          // Add more decoration..
                        ),
                        hint: Text(
                          '선택',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: _addDividersAfterItems(items),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select gender.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when selected item is changed.

                          print("change");
                        },
                        onSaved: (value) {
                          selectedValue = value.toString();
                          print("save");
                        },
                        ///드롭 전 기본박스 디자인인가?
                        buttonStyleData: ButtonStyleData(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white, // 배경 색상
                            borderRadius: BorderRadius.circular(4), // 모서리 둥글기
                            border: Border.all(
                              color: Color(0xFF1762DB), // 테두리 색상
                              width: 1, // 테두리 두께
                            ),
                          ),
                          padding: EdgeInsets.only(right: 0),
                        ),
                        ///드롭 버튼 아이콘
                        iconStyleData:  IconStyleData(
                          iconSize: 0,
                        ),
                        ///드롭다운 메뉴창 디자인인가?
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 85,
                          decoration: BoxDecoration(
                            color: Color(0xFFEDEEF1), // 배경 색상
                            borderRadius: BorderRadius.circular(4), // 모서리 둥글기
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x19000000), // 그림자 색상
                                blurRadius: 4, // 흐림 정도
                                offset: Offset(0, 2), // 그림자 위치
                                spreadRadius: 0, // 그림자 범위
                              ),
                            ],
                          ),
                          elevation: 0,
                        ),
                        ///드롭다운 메뉴창 안에 아이템들 디자인인가?
                        menuItemStyleData: MenuItemStyleData(
                          customHeights: _getCustomItemsHeights(),
                          padding: EdgeInsets.all(4),
                          height: 24,
                        ),
                      ),*/
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
                    color: (item == selectedItem) ? Colors.black : Color(0xFF7C7C7C),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.32,
                  ),
                ),
              )
          ),
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
        itemsHeights.add(24);
      }
      ///홀수 인덱스에 divider가 있겠죠?
      if (i.isOdd) {
        itemsHeights.add(1);
      }
    }
    return itemsHeights;
  }
}

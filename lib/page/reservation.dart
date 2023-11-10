///추호성이꺼

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Reservation extends StatefulWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {

  ///캘린더 설정
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  ///dropdown menu items
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Icon(AppinIcon.back, size: 24),
            ),
            SizedBox(width: 10),
            Text("강의실 예약하기",
                style: TextStyle(color: Colors.black, fontSize: 18))
          ],
        ),
      ),
      body: Center(
        child: Column(
          //여기
          children: [
            ///강의실
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
                    child: SizedBox(
                      width: 120,
                      height: 32,
                      child: DropdownButtonFormField2<String>(
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
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Container(
                            width: 120,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 37,
                                  top: 4,
                                  child: Text(
                                    item,
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
                                ),
                                Positioned(
                                  left: 4,
                                  top: 24,
                                  child: Container(
                                    width: 112,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          strokeAlign: BorderSide.strokeAlignCenter,
                                          color: Color(0xFFDDDDDD),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select gender.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when selected item is changed.
                        },
                        onSaved: (value) {
                          selectedValue = value.toString();
                        },
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
                        iconStyleData:  IconStyleData(
                          iconSize: 0,
                        ),
                        dropdownStyleData: DropdownStyleData(
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
                        menuItemStyleData: MenuItemStyleData(
                          padding: EdgeInsets.all(4),
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ///캘린더
            Container(
              height: 288,
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
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 56,
                      child: Container(
                        height: 116,
                      ),
                    ),

                    ///달력 드가자
                    Column(
                      children: [
                        SizedBox(height: 61,),
                        Center(
                          child: SizedBox(
                            width: 326,
                            height: 300,
                            child: TableCalendar(
                              firstDay: DateTime.now(),
                              lastDay: DateTime.now().add(Duration(days: 14)),
                              focusedDay: DateTime.now(),
                              headerVisible: false,
                              daysOfWeekVisible: false,

                              startingDayOfWeek: StartingDayOfWeek.monday,
                              weekendDays: [DateTime.sunday,6],
                              calendarBuilders: CalendarBuilders(

                              ),
                              rowHeight: 43,
                              /*rangeStartDay: ,
                              rangeEndDay: ,*/
                              calendarStyle: CalendarStyle(


                                cellMargin: EdgeInsets.all(5),
                                cellPadding: EdgeInsets.all(0),
                                // tableBorder: TableBorder(borderRadius: BorderRadius(5)),
                                ///기본 day 스타일
                                rowDecoration: BoxDecoration(
                                  // border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid),
                                ),
                                defaultDecoration: BoxDecoration(
                                  // border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color(0xFFEDEEF1)
                                ),
                                defaultTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                                ///day 선택시
                                selectedDecoration: BoxDecoration(
                                  color: Color(0xFF1662DA),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                                ///today
                                todayDecoration: BoxDecoration(
                                  color: Color(0xFFEDEEF1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                todayTextStyle: TextStyle(
                                  color: Color(0xFF1662DA),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                                ///주말 day
                                weekendDecoration:  BoxDecoration(
                                  // border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFFEDEEF1)
                                ),
                                weekendTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),

                              ),


                              ///events
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                                });
                              },
                            ),


                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      ),
                    ),
                  ],
                ),
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
                      Container(
                        padding: EdgeInsets.only(
                          top: 5, // 위쪽
                          bottom: 0, // 아래쪽
                          left: 37, // 왼쪽
                          right: 37,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MGcolor.brand_orig, // 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: 120,
                        height: 32,
                        child: Text(
                          "00 : 00",
                          style: KR.parag2,
                        ),
                      ),
                      Container(width: 22, child: Center(child: Text("~"))),
                      Container(
                        padding: EdgeInsets.only(
                          top: 5, // 위쪽
                          bottom: 0, // 아래쪽
                          left: 37, // 왼쪽
                          right: 37,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MGcolor.brand_orig, // 테두리 색상
                            width: 1.0, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: 120,
                        height: 32,
                        child: Text(
                          "00 : 00",
                          style: KR.parag2,
                        ),
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

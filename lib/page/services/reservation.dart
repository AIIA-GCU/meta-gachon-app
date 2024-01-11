import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mata_gachon/config/server.dart';
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
  const Reservation({Key? key, this.book}) : super(key: key);

  final Book? book;

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  ///강의실 목록
  final List<String> rooms = [
    '402 - 1',
    '402 - 2',
    '402 - 3',
    '402 - 4',
    '402 - 5',
  ];

  ///시간 드롭다운메뉴 아이템들
  final List<String> times = List.generate(
      17, (index) => "${(6 + index).toString().padLeft(2, '0')}:00");

  ///textfield controllor
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  late int leaderNumber; //대표자 학번
  late String leaderName; //대표자 이름
  late bool isSolo;

  ///유저가 선택한 정보변수들
  String? selectedRoom; //강의실
  String? selectedDate; //이용날짜
  String? selectedEnter; //입실시간
  String? selectedExit; //퇴실시간
  List<String> usersList = []; //이용자리스트

  /// 이용자 위젯리스트
  List<Widget> usersWidgets = [];

  ///이용자 컨데이너 안내메세지
  String alertMessege = "대표자를 제외한 이용자의 학번과 이름을 입력해주세요!";

  @override
  void initState() {
    super.initState();

    if (widget.book != null) {
      uid = int.parse(widget.book!.reservationID);
      selectedRoom = widget.book!.room;
      leaderNumber = widget.book!.stu_num;
      leaderName = widget.book!.name;
      selectedDate = yMdE_format.format(widget.book!.start);
      selectedEnter = Hm_format.format(widget.book!.start);
      selectedExit = Hm_format
          .format(widget.book!.start.add(Duration(hours: widget.book!.duration)));
    }

    else {
      leaderNumber = my_info.stu_num;
      leaderName = my_info.name;
      isSolo = false;
    }
  }

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
          title: Text("강의실 예약하기",
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
                    ///회의실 선택
                    CustomContainer(title: "회의실", height: 52, content: [
                      CustomDropdown(
                        hint: "선택",
                        items: rooms,
                        onChanged: (value) {
                          setState(() {
                            selectedRoom = value;
                          });
                        },
                        selectedItem: selectedRoom,
                      )
                    ]),

                    /// 날짜 선택
                    Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: CustomCalender(
                          first: DateTime.now(),
                          last: DateTime.now().add(Duration(days: 13)),
                          rowHeight: 32 * ratio.height,
                          rowWidth: 38 * ratio.width,
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
                          onSelected: (value) => selectedDate = value,
                        )
                    ),

                    ///예약 시간 선택
                    CustomContainer(
                      title: "예약 시간",
                      height: 73,
                      content: [
                        CustomDropdown(
                          hint: "입실",
                          items: times,
                          onChanged: (value) {
                            setState(() => selectedEnter = value);
                          },
                          selectedItem: selectedEnter,
                        ),
                        SizedBox(
                            width: 22 * ratio.width,
                            child: Center(child: Text("~"))
                        ),
                        CustomDropdown(
                          hint: "퇴실",
                          items: times,
                          onChanged: (value) {
                            setState(() => selectedExit = value);
                          },
                          selectedItem: selectedExit,
                        ),
                      ],
                      additionalContent: [
                        Positioned(
                            left: 80 * ratio.width,
                            top: 46 * ratio.height,
                            child: Text(
                                '예약은 최대 3시간 까지 가능합니다!',
                                style: KR.label2.copyWith(color: MGcolor.brand_orig)
                            )
                        )
                      ],
                    ),

                    ///대표자
                    CustomContainer(
                      title: "대표자",
                      height: 52,
                      content: [],
                      additionalContent: [
                        Positioned(
                            left: 80 * ratio.width,
                            top: 16 * ratio.height,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "$leaderNumber",
                                  style:
                                      KR.parag2.copyWith(color: MGcolor.base3),
                                ),
                                SizedBox(width: 4 * ratio.width),
                                Text(
                                  leaderName,
                                  style: KR.parag2.copyWith(color: MGcolor.base3),
                                ),
                              ],
                            )
                        )
                      ],
                    ),

                    ///이용자
                    Container(
                      margin: EdgeInsets.only(bottom: 12 * ratio.height),
                      width: 358 * ratio.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Input
                          SizedBox(
                            width: 358 * ratio.width,
                            height: 63 * ratio.height,
                            child: Stack(children: [
                              Positioned(
                                left: 16 * ratio.width,
                                top: 16 * ratio.height,
                                child: Text('이용자', style: KR.parag1.copyWith(color: MGcolor.base1)),
                              ),
                              Positioned(
                                left: 80 * ratio.width,
                                top: 10 * ratio.height,
                                child: Row(
                                  children: [
                                    MyTextField(
                                      enabled: !isSolo,
                                      width: 122,
                                      height: 32,
                                      controller: _controllerNumber,
                                      hint: '202300001',
                                      format: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        //숫자만 허용
                                        LengthLimitingTextInputFormatter(9),
                                        //9글자만 허용
                                      ],
                                    ),
                                    SizedBox(width: 8 * ratio.width),
                                    MyTextField(
                                      enabled: !isSolo,
                                      width: 92,
                                      height: 32,
                                      controller: _controllerName,
                                      hint: '김가천',
                                      format: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]')),
                                      ],
                                    ),
                                    SizedBox(width: 8 * ratio.width),
                                    Material(
                                      child: InkWell(
                                        onTap: validateAddingUser,
                                        customBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Ink(
                                            width: 32 * ratio.width,
                                            height: 32 * ratio.height,
                                            decoration: BoxDecoration(
                                              color: MGcolor.base6,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                                child: Icon(Icons.add, size: 16))),
                                      ),
                                    )
                                  ], // combined 리스트를 사용합니다.
                                ),
                              ),
                              Positioned(
                                  left: 80 * ratio.width,
                                  top: 46 * ratio.height,
                                  child: Text(alertMessege,
                                      style: KR.label2.copyWith(
                                          color: isSolo
                                              ? MGcolor.base3
                                              : MGcolor.brand_orig))
                              ),
                            ]),
                          ),

                          /// registers
                          Container(
                            width: 274 * ratio.width,
                            margin: EdgeInsets.only(
                                left: 68 * ratio.width,
                                bottom: 12 * ratio.height
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  children: usersWidgets,
                                ),
                                SizedBox(height: 8 * ratio.height),
                                Padding(
                                  padding: EdgeInsets.only(left: 12 * ratio.width),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => isSolo = !isSolo);
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.transparent,
                                          child: Checkbox(
                                              value: isSolo,
                                              shape: CircleBorder(),
                                              side: BorderSide(
                                                  color: MGcolor.base3,
                                                  width: 1.6
                                              ),
                                              activeColor: MGcolor.brand_orig,
                                              onChanged: (bool? value) {
                                                setState(() => isSolo = value!);
                                              }),
                                        ),
                                        SizedBox(width: 6 * ratio.width),
                                        Text('추가 이용자가 없습니다.',
                                            style: KR.label2.copyWith(
                                                color: MGcolor.base3)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: ratio.height * 68)
                  ],
                ),
              ),
            ),

            ///예약하기 버튼
            Positioned(
              bottom: 10 * ratio.height,
              left: 16 * ratio.width,
              child: ElevatedButton(
                  onPressed: reservate,
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

  void validateAddingUser() {
    print("clicked");
    if (_controllerName.text.isEmpty && _controllerNumber.text.length < 9) {
      setState(() => alertMessege = "정확한 학번과 이름을 입력해 주세요");
    } else if (usersWidgets
        .any((widget) => widget.key == Key(_controllerNumber.text))) {
      // 같은 Key를 가진 위젯이 이미 존재하면 추가하지 않습니다.
      print('Same key already exists.');
      setState(() => alertMessege = '이미 등록된 이용자입니다!');
    } else if (_controllerNumber.text == leaderNumber) {
      setState(() => alertMessege = '대표자를 제외한 이용자의 학번과 이름을 입력해주세요!');
    } else {
      setState(() {
        alertMessege = "정상적으로 추가됐습니다";
        usersWidgets
            .add(_MyUserBox(_controllerNumber.text, _controllerName.text));
      });
    }
  }

  void reservate() {
    late OverlayEntry overlayEntry;
    if (selectedRoom == null) {
      overlayEntry = createOverlayEntry('회의실을 입력해주세요!', true);
    } else if (selectedDate == null) {
      overlayEntry = createOverlayEntry('날짜를 선택해주세요!', true);
    } else if (selectedEnter == null || selectedExit == null) {
      overlayEntry = createOverlayEntry('예약 시간을 입력해주세요!', true);
    } else if (!isSolo && usersList.isEmpty) {
      overlayEntry = createOverlayEntry('이용자를 입력해주세요!', true);
    } else {
      books.add(Book(
          '${++uid}',
          leaderName,
          leaderNumber,
          selectedRoom!,
          yMdEHm_format.parse('$selectedDate $selectedEnter'),
          Hm_format.parse(selectedExit!).difference(Hm_format.parse(selectedEnter!)).inHours
      ));
      print(books.last.reservationID);
      overlayEntry = createOverlayEntry('예약되었습니다!', false);
    }
    // 플로팅 메세지 표시
    Overlay.of(context).insert(overlayEntry);
  }

  ///이용자 등록표시 위젯
  Widget _MyUserBox(String number, String name) {
    return Container(
      key: Key(number),
      width: 133 * ratio.width,
      height: 26 * ratio.height,
      margin: EdgeInsets.only(top: 8 * ratio.height),
      decoration: ShapeDecoration(
        color: MGcolor.brand_orig,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4 * ratio.height,
            left: 10 * ratio.width,
            width: 93 * ratio.width,
            child: Text(
              '$number $name',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: KR.label2.copyWith(color: Colors.white)
            ),
          ),
          Positioned(
            top: 3 * ratio.height,
            right: 5 * ratio.width,
            child: GestureDetector(
                onTap: () {
                  setState(() => usersWidgets
                      .removeWhere((widget) => widget.key == Key(number)));
                },
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}

///커스텀 컨테이너
class CustomContainer extends StatelessWidget {
  final List<Widget> content;
  final List<Widget>? additionalContent;
  final String title;
  final int height;

  const CustomContainer({
    required this.title,
    required this.height,
    required this.content,
    this.additionalContent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12 * ratio.height),
      width: 358 * ratio.width,
      height: height * ratio.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(children: [
        Positioned(
          left: 16 * ratio.width,
          top: 16 * ratio.height,
          child: Text(title, style: KR.parag1),
        ),
        Positioned(
          left: 80 * ratio.width,
          top: 10 * ratio.height,
          child: Row(
            children: content, // combined 리스트를 사용합니다.
          ),
        ),
        ...?additionalContent //추가 위젯들 들어가는 곳
      ]),
    );
  }
}

///커스텀 드롭다운메뉴위젯
class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? selectedItem;
  final Function(String?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.selectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120 * ratio.width,
      height: 32 * ratio.height,
      ///드롭다운메뉴 위젯
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          alignment: Alignment.center,
          isExpanded: true,
          hint: Text(hint, style: EN.parag2.copyWith(color: MGcolor.base3)),
          items: _addDividersAfterItems(items),
          value: selectedItem,
          onChanged: onChanged,

          ///드롭버튼(선택된 항목) 디자인
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.all(0),
            height: 40 * ratio.height,
            width: 140 * ratio.width,
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
              maxHeight: 85 * ratio.height,
              //최대크기
              elevation: 0,
              //그림자 없앰
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    )
                  ],
                  color: Colors.white.withOpacity(0.9) //배경투명도
              )
          ),

          ///메뉴들(선택지들) 디자인
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 4 * ratio.width),
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
                  style: EN.parag2.copyWith(
                      color: (item == selectedItem)
                          ? Colors.black
                          : Color(0xFF7C7C7C)
                  )
                ),
              )),
          //If it's last item, we will not add Divider after it.
          ///아이템 하나마다 끝에 divider 넣기
          if (item != inItems.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(color: MGcolor.base5),
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
      if (i.isEven) {
        itemsHeights.add(24 * ratio.height);
      } else {
        itemsHeights.add(1);
      }
    }
    return itemsHeights;
  }
}

///커스텀 텍스트필드위젯
class MyTextField extends StatelessWidget {
  final bool enabled;
  final int width;
  final int height;
  final TextEditingController controller;
  final String hint;
  final List<TextInputFormatter>? format;

  const MyTextField({
    required this.enabled,
    required this.width,
    required this.height,
    required this.controller,
    required this.hint,
    this.format,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * ratio.width,
      height: height * ratio.height,
      child: TextField(
        enabled: enabled,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: KR.parag2,
        controller: controller,
        inputFormatters: format,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: MGcolor.brand_orig, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: MGcolor.brand_orig, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: MGcolor.base4, width: 1.2),
          ),
        )
      ),
    );
  }
}

///예약하기 버튼 클릭시 표시되는 플로팅 메세지
OverlayEntry createOverlayEntry(String text, bool isError) {
  late OverlayEntry obj;
  obj = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black.withOpacity(0.25),
      child: Center(
        child: Container(
          width: 326 * ratio.width,
          height: 156 * ratio.height,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40 * ratio.height),
              Text(text, style: KR.subtitle4),
              SizedBox(height: 42 * ratio.height),
              GestureDetector(
                onTap: () {
                  if (!isError) {
                    Navigator.pop(context);
                    listListener.add('reservation');
                  }
                  obj.remove();
                },
                child: Container(
                  width: 302 * ratio.width,
                  height: 40 * ratio.height,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: MGcolor.brand_orig,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('확인', style: KR.parag2.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  return obj;
}
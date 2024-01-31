import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widget/select_time.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mata_gachon/widget/popup.dart';
import 'package:mata_gachon/widget/small_widgets.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({Key? key, this.reservate}) : super(key: key);

  final Reservate? reservate;

  @override
  State<ReservatePage> createState() => _ReservatePageState();
}

class _ReservatePageState extends State<ReservatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();

  ///강의실 목록
  final List<String> rooms = ['405-4', '405-5', '405-6'];

  ///textfield controllor
  final TextEditingController _controllerNumber = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  late int leaderNumber; //대표자 학번
  late String leaderName; //대표자 이름
  late bool isSolo, loading, canTime;
  late Color addUserGuideline;

  ///유저가 선택한 정보변수들
  String? selectedRoom; //강의실
  String? selectedDate; //이용날짜
  int? selectedEnter; //입실시간
  int? selectedExit; //퇴실시간
  List<String> usersList = []; //이용자리스트

  /// 이용자 위젯리스트
  List<Widget> usersWidgets = [];

  ///이용자 컨데이너 안내메세지
  String alertMessege = "대표자를 제외한 이용자의 학번과 이름을 입력해주세요!";

  @override
  void initState() {
    super.initState();

    this.isSolo = this.loading = this.canTime = false;
    this.addUserGuideline = MGcolor.brand_orig;
    if (widget.reservate != null) {
      List<String> temp;
      temp = widget.reservate!.leaderInfo.split(' ');
      this.leaderName = temp[1];
      this.leaderNumber = int.parse(temp[0]);
      this.selectedRoom = widget.reservate!.room;
      temp = widget.reservate!.date.split(' ');
      this.selectedDate = temp.first;
      temp = widget.reservate!.time.split(' ~ ');
      this.selectedEnter = int.parse(temp[0].substring(0, 2));
      this.selectedExit = int.parse(temp[1].substring(0, 2));
      this.isSolo = true;
      this.canTime = true;
      // if (widget.reservate!.member.isEmpty) {
      //   this.isSolo = true;
      // } else {
      //   this.isSolo = false;
      //   temp = widget.reservate!.member.split(' ');
      //   for (int i=0 ; i < temp.length ; i++) {
      //     usersList.add('${temp[i]} ${temp[i+1]}');
      //   }
      //   usersWidgets = usersList.map((e) => _MyUserBox(e)).toList();
      // }
    }
    else {
      this.leaderNumber = myInfo.stuNum;
      this.leaderName = myInfo.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
                titleSpacing: 0,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(AppinIcon.back),
                  iconSize: 24,
                ),
                title: Text("강의실 예약하기",
                    style: KR.subtitle1.copyWith(color: MGcolor.base1))),
            body: CustomScrollView(
              slivers: [
                SliverList.list(children: [
                  /// 예약 정보 입력
                  CustomContainer(
                      title: "회의실",
                      height: 52,
                      margin: EdgeInsets.fromLTRB(
                        ratio.width * 16,
                        0,
                        ratio.width * 16,
                        ratio.height * 12
                      ),
                      content: Row(
                        children: [
                          CustomDropdown(
                            hint: "선택",
                            items: rooms,
                            onChanged: (value) {
                              setState(() {
                                selectedRoom = value;
                                if (selectedRoom != null && selectedDate != null) {
                                  setState(() {
                                    selectedEnter = selectedExit = null;
                                    if (!canTime) {
                                      canTime = true;
                                      _listKey.currentState!.insertAllItems(0, 3);
                                    }
                                  });
                                }
                              });
                            },
                            selectedItem: selectedRoom,
                          )
                        ]
                      )
                  ),

                  /// 날짜 선택
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          ratio.width * 16,
                          0,
                          ratio.width * 16,
                          ratio.height * 12
                      ),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: CustomCalender(
                        init: selectedDate,
                        first: DateTime.now(),
                        last: DateTime.now().add(Duration(days: 13)),
                        rowHeight: 32,
                        rowWidth: 38 * ratio.width,
                        cellStyle: CellStyle(
                          fieldTextStyle:
                          EN.label1.copyWith(color: MGcolor.base3),
                          normalDateTextStyle:
                          EN.parag1.copyWith(color: MGcolor.base1),
                          normalDateBoxDecoration: BoxDecoration(
                              color: MGcolor.base7,
                              borderRadius: BorderRadius.circular(4)),
                          selectedDateTextStyle:
                          EN.parag1.copyWith(color: Colors.white),
                          selelctedDateBoxDecoration: BoxDecoration(
                              color: MGcolor.btn_active,
                              borderRadius: BorderRadius.circular(4)),
                          todayTextStyle:
                          EN.parag1.copyWith(color: MGcolor.btn_active),
                          todayBoxDecoration: BoxDecoration(
                              color: MGcolor.base7,
                              borderRadius: BorderRadius.circular(4)),
                          rangeOutDateTextStyle:
                          EN.parag1.copyWith(color: MGcolor.base5),
                          rangeOutDateBoxDecoration: BoxDecoration(
                              color: MGcolor.base8,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        onSelected: (value) {
                          selectedDate = value;
                          if (selectedRoom != null && selectedDate != null) {
                            setState(() {
                              selectedEnter = selectedExit = null;
                              if (!canTime) {
                                canTime = true;
                                _listKey.currentState!.insertAllItems(0, 3);
                              }
                            });
                          }
                        },
                      )
                  )
                ]),
                SliverAnimatedList(
                  key: _listKey,
                  initialItemCount: canTime ? 3 : 0,
                  itemBuilder: (context, index, animation) {
                    final List<Widget> temp = [
                      ///예약 시간 선택
                      FutureBuilder<List<bool>>(
                        future: availableTime(),
                        builder: (context, snapshot) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(
                              ratio.width * 16,
                              0,
                              ratio.width * 16,
                              ratio.height * 12
                            ),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                            child: snapshot.hasData
                                ? CustomTimePicker(
                                    start: selectedEnter,
                                    end: selectedExit,
                                    availableTimes: snapshot.data!,
                                    setStart: (index) => selectedEnter = index,
                                    setEnd: (index) => selectedExit = index + 1,
                                  )
                                : null
                          );
                        }
                      ),

                      ///대표자
                      CustomContainer(
                        title: "대표자",
                        height: 52,
                        content: SizedBox.shrink(),
                        margin: EdgeInsets.fromLTRB(
                            ratio.width * 16,
                            0,
                            ratio.width * 16,
                            ratio.height * 12
                        ),
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
                        margin: EdgeInsets.fromLTRB(
                            ratio.width * 16,
                            0,
                            ratio.width * 16,
                            ratio.height * 12
                        ),
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
                                  child: Form(
                                    key: _formKey,
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
                                          validator: (str) {
                                            if (str!.isEmpty || str.length != 9) {
                                              return alertMessege = "정확한 학번과 이름을 입력해 주세요";
                                            } else if(leaderNumber.toString() == str) {
                                              return alertMessege = '대표자를 제외한 이용자의 학번과 이름을 입력해주세요!';
                                            } else if (usersWidgets.any((e) => (e.key! as ValueKey<String>).value.contains(str))) {
                                              return alertMessege = "이미 등록된 이용자입니다!";
                                            } else {
                                              return null;
                                            }
                                          },
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
                                          validator: (str) {
                                            if (str!.isEmpty) {
                                              return alertMessege = "정확한 학번과 이름을 입력해 주세요";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        SizedBox(width: 8 * ratio.width),
                                        Material(
                                          child: InkWell(
                                            onTap: isSolo ? null : validateAddingUser,
                                            customBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(12)),
                                            child: Ink(
                                              width: 32 * ratio.width,
                                              height: 32 * ratio.height,
                                              decoration: BoxDecoration(
                                                color: isSolo ? MGcolor.base6
                                                    : MGcolor.brand_orig,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  AppinIcon.plus,
                                                  size: 16,
                                                  color: isSolo ? MGcolor.base4
                                                      : Colors.white,
                                                )
                                              )
                                            ),
                                          ),
                                        )
                                      ]
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 80 * ratio.width,
                                    top: 46 * ratio.height,
                                    child: Text(
                                      alertMessege,
                                      style: KR.label2.copyWith(
                                        color: isSolo
                                            ? MGcolor.base4
                                            : addUserGuideline
                                      )
                                    )
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
                                              style: KR.label2.copyWith(color: MGcolor.base3)),
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
                    ];
                    return SizeTransition(
                      sizeFactor: animation,
                      child: temp[index],
                    );
                  },
                ),
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(children: [
                      Spacer(),

                      ///예약하기 버튼
                      AnimatedOpacity(
                        opacity: canTime ? 1 : 0,
                        duration: Duration(milliseconds: 200),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: ratio.height * 10),
                          child: ElevatedButton(
                              onPressed: reservate,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: MGcolor.brand_orig,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  fixedSize: Size(ratio.width * 358, ratio.height * 48)
                              ),
                              child: Text(
                                "예약하기",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16 * ratio.height,
                                  fontFamily: 'Noto Sans KR',
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                          ),
                        ),
                      ),
                    ])
                )
              ]
            ),
          ),

          /// 로딩 중
          if (loading)
            ProgressScreen()
        ],
      ),
    );
  }

  void validateAddingUser() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
        }
        alertMessege = "정상적으로 추가됐습니다";
        addUserGuideline = MGcolor.brand_orig;
        usersList.add("${_controllerNumber.text} ${_controllerName.text}");
        usersWidgets.add(_MyUserBox("${_controllerNumber.text} ${_controllerName.text}"));
        _controllerNumber.clear();
        _controllerName.clear();
      } else {
        addUserGuideline = MGcolor.system_error;
      }
    });
  }

  bool _isSame() {
    final temp = widget.reservate!.date.split(' ').first;
    return widget.reservate!.room == selectedRoom!
    && temp == selectedDate!
    && widget.reservate!.time == '$selectedEnter ~ $selectedExit';
  }

  Future<List<bool>> availableTime() async {
    List<bool> result = List.generate(26, (index) => false);
    // if (selectedRoom != null && selectedDate != null) {
    //   try {
    //     Map<int, bool>? times = await RestAPI
    //         .getAvailableTime(room: selectedRoom!, date: selectedDate!);
    //     int a = times!.keys.first, b = times.keys.last;
    //     for (a - 1; a < b; a++) {
    //       result[a] = !times[a]!;
    //     }
    //
    //     if (widget.reservate != null) {
    //       for (a = selectedEnter! - 1; a < selectedExit!; a++) {
    //         result[a] = true;
    //       }
    //     }
    //   } catch(e) {}
    // }
    // debugPrint('available times: $result');
    return result;
  }

  Widget _MyUserBox(String memberInfo) {
    return Container(
      key: ValueKey<String>(memberInfo),
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
              memberInfo,
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
                      .removeWhere((widget) => widget.key == Key(memberInfo)));
                },
                child: Icon(
                  AppinIcon.cross,
                  size: 20,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  Future<void> reservate() async {
    bool allClear = false;
    late String title;
    late Function() onPressed;

    setState(() => loading = true);

    if (selectedRoom == null) {
      title = '회의실을 선택해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (selectedDate == null) {
      title = '날짜를 선택해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (selectedEnter == null || selectedExit == null) {
      title = '예약 시간을 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (!isSolo && usersList.isEmpty) {
      title = '추가 이용자를 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (widget.reservate != null && _isSame()) {
      title = '이전 내용과 같습니다.';
      onPressed = () => Navigator.pop(context);
    } else {
      final startTime =
          '$selectedDate ${selectedEnter! < 9 ? '0$selectedEnter': selectedEnter!}:00';
      final endTime =
          '$selectedDate ${selectedExit! < 9 ? '0$selectedExit' : selectedExit}:00';
      String member = usersList.toString();
      member = member.substring(1, member.length-1);
      debugPrint("""
      [reservation Info]
        . room: $selectedRoom
        . startTime: $startTime
        . endTime: $endTime
        . leader: $leaderNumber $leaderName
        . member: $member""");

      try {
        int? uid = widget.reservate != null
            ? await RestAPI.patchReservation(
            reservationId: widget.reservate!.reservationId,
            room: selectedRoom!,
            startTime: startTime,
            endTime: endTime,
            leader: widget.reservate!.leaderInfo,
            member: member
        )
            : await RestAPI.addReservation(
            room: selectedRoom!,
            startTime: startTime,
            endTime: endTime,
            member: member
        );
        if (uid == null) {
          title = 'Not found';
          onPressed = () => Navigator.pop(context);
        } else {
          allClear = true;
          title = '예약되었습니다!';
          onPressed = () {
            listListener.add(StreamType.reservate);
            Navigator.popUntil(context, (route) => route.isFirst);
          };
        }
      } on TimeoutException {
        title = '통신 속도가 너무 느립니다!';
        onPressed = () => Navigator.pop(context);
      } catch(_) {
        title = '[400] 서버와의 통신에 문제가 있습니다.';
        onPressed = () => Navigator.pop(context);
      }
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

///커스텀 컨테이너
class CustomContainer extends StatelessWidget {
  final EdgeInsets? margin;
  final Widget content;
  final List<Widget>? additionalContent;
  final String title;
  final int height;

  const CustomContainer({
    required this.title,
    required this.height,
    required this.content,
    this.additionalContent,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 12 * ratio.height),
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
          width: 262 * ratio.width,
          height: 32 * ratio.height,
          child: content
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
          isExpanded: true,
          alignment: Alignment.center,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(width: 1, color: MGcolor.brand_orig),
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
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? format;

  const MyTextField({
    required this.enabled,
    required this.width,
    required this.height,
    required this.controller,
    required this.hint,
    this.validator,
    this.format,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * ratio.width,
      height: height * ratio.height,
      child: TextFormField(
        enabled: enabled,
        validator: validator,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: KR.parag2,
        controller: controller,
        inputFormatters: format,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: hint,
          errorStyle: TextStyle(fontSize: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: MGcolor.brand_orig, width: 1),
          ),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: MGcolor.system_error, width: 1)
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: MGcolor.system_error, width: 2)
          )
        )
      ),
    );
  }
}
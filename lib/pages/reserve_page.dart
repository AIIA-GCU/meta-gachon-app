import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app/_export.dart';
import '../config/server/_export.dart';

import '../widgets/button.dart';
import '../widgets/calender_widget.dart';
import '../widgets/layout.dart';
import '../widgets/popup_widgets.dart';
import '../widgets/select_place_widget.dart';
import '../widgets/select_time_widgets.dart';
import '../widgets/small_widgets.dart';
import '../widgets/text_field.dart';

class ReservePage extends StatefulWidget {
  const ReservePage(this.service, {
    Key? key,
    required this.availableRoom,
    this.reserve
  }) : super(key: key);

  final ServiceType service;
  final List<String> availableRoom;
  final Reserve? reserve;

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();

  ///textfield controllor
  final TextEditingController _purposeCtr = TextEditingController();
  final TextEditingController _professorCtr = TextEditingController();
  final TextEditingController _numberCtr = TextEditingController();
  final TextEditingController _userNumCtr = TextEditingController();

  /// 고정 데이터
  late final int _leaderNumber; //대표자 학번
  late final String _leaderName; //대표자 이름
  late final List<String> _places; // 강의실 목록
  final List<Widget> _firstWidgets = []; // 화면에 표시되는 위젯 목록

  /// 기타
  late bool _isSolo, _loading, _canTime, _existError; // for utility
  late Color _addUserGuideline; // for widget

  /// 예약 정보
  String? _selectedPlace; //강의실
  String? _selectedDate; //날짜
  DateTime? _selectedEnter, _selectedEnd; // 이용 시작, 끝
  late List<String> _numberList; // 이용자 수 리스트
  late List<String> _userNumList; // 이용자 학번 리스트

  ///이용자 컨데이너 안내메세지
  String alertMessege = "대표자를 제외한 이용자의 인원 수를 입력해 주세요!";
  String elseMessage = "대표자를 제외한 이용자의 학번을 입력해 주세요!";

  @override
  void initState() {
    // init
    _places = widget.availableRoom;
    _loading = _isSolo = _canTime = _existError = false;
    _addUserGuideline = MGColor.brandPrimary;
    _leaderNumber = myInfo.stuNum;
    _leaderName = myInfo.name;
    _numberList = [];
    _userNumList = [];

    // if modifing
    if (widget.reserve != null) {
      _selectedPlace = widget.reserve!.place;
      _selectedDate = stdFormat3.format(widget.reserve!.startTime);
      _selectedEnter = widget.reserve!.startTime;
      _selectedEnd = widget.reserve!.endTime;
      if (widget.reserve!.memberInfo.isNotEmpty) {
        _isSolo = false;
        List<String> temp = widget.reserve!.memberInfo.split(' ');
        for (int i = 0; i < temp.length; i += 2) {
          _numberList.add('${temp[i]} ${temp[i + 1]}');
        }
      } else {
        _isSolo = true;
      }
      _purposeCtr.text = widget.reserve!.purpose;
      _canTime = true;
    }

    _initPage();
    super.initState();
  }

  @override
  void dispose() {
    _purposeCtr.dispose();
    _numberCtr.dispose();
    _userNumCtr.dispose();
    _professorCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    switch (widget.service) {
      case ServiceType.aiSpace:
        title = "회의실 예약하기";
        break;
      case ServiceType.computer:
        title = "GPU 컴퓨터 예약하기";
        break;
      case ServiceType.lectureRoom:
        title = "강의실 예약하기";
        break;
    }
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
                centerTitle: false,
                titleSpacing: 0,
                leadingWidth: 48,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(MGIcon.back),
                  iconSize: 24,
                ),
                title: Text(title,
                    style: KR.subtitle1.copyWith(color: MGColor.base1))),
            body: SafeArea(
              child: CustomScrollView(slivers: [
                SliverList.list(children: _firstWidgets),
                SliverAnimatedList(
                  key: _listKey,
                  initialItemCount: _canTime ? 4 : 0,
                  itemBuilder: (context, index, animation) {
                    List<Widget> temp = [];

                    /// 만약 GPU 컴퓨터 예약이면, 전담 교수님 추가 위젯
                    /// 아니면, 시간 선택 위젯
                    if (widget.service == ServiceType.computer) {
                      temp.add(Container(
                          margin: EdgeInsets.fromLTRB(ratio.width * 16, 0,
                              ratio.width * 16, ratio.height * 12),
                          padding: EdgeInsets.symmetric(
                              horizontal: ratio.width * 16, vertical: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// Title
                                Text('전담 교수님', style: KR.parag1),

                                SizedBox(width: ratio.width * 36),

                                /// Textfield
                                CustomTextField(
                                  enabled: true,
                                  width: 100 * ratio.width,
                                  height: 32,
                                  controller: _professorCtr,
                                  hint: '김가천',
                                  format: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[ㄱ-ㅎㅏ-ㅣ가-힣]')),
                                    //외국 교수님 일단 배제
                                  ],
                                ),

                                SizedBox(width: ratio.width * 10),

                                Text('교수님', style: KR.parag1),
                              ])));
                    } else {
                      temp.add(Container(
                          margin: EdgeInsets.fromLTRB(ratio.width * 16, 0,
                              ratio.width * 16, ratio.height * 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: CustomTimePicker(widget.service,
                            place: _selectedPlace,
                            date: _selectedDate!,
                            begin: _selectedEnter?.hour,
                            end: _selectedEnd?.hour,
                            setStart: (index) {
                              DateTime temp = stdFormat3.parse(_selectedDate!);
                              _selectedEnter = DateTime(
                                  temp.year, temp.month, temp.day, index);
                            },
                            setEnd: (index) {
                              DateTime temp = stdFormat3.parse(_selectedDate!);
                              _selectedEnd = DateTime(
                                  temp.year, temp.month, temp.day, index + 1);
                            },
                          )));
                    }

                    /// 나머지 모두
                    temp.addAll([
                      ///대표자
                      CustomContainer(
                        title: "대표자",
                        height: 52,
                        margin: EdgeInsets.fromLTRB(ratio.width * 16, 0,
                            ratio.width * 16, ratio.height * 12),
                        content: const SizedBox.shrink(),
                        additionalContent: [
                          Positioned(
                              left: 80 * ratio.width,
                              top: 16,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "$_leaderNumber",
                                    style: KR.parag2
                                        .copyWith(color: MGColor.base3),
                                  ),
                                  SizedBox(width: 4 * ratio.width),
                                  Text(
                                    _leaderName,
                                    style: KR.parag2
                                        .copyWith(color: MGColor.base3),
                                  ),
                                ],
                              ))
                        ],
                      ),

                      ///이용자
                      if (widget.service == ServiceType.lectureRoom)
                        Container(
                          margin: EdgeInsets.fromLTRB(ratio.width * 16, 0,
                              ratio.width * 16, ratio.height * 12),
                          width: 358 * ratio.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 358 * ratio.width,
                            height: 32 + 41 * ratio.height,
                            padding: EdgeInsets.symmetric(
                              vertical: ratio.height * 10
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 16 * ratio.width,
                                  top: 6 * ratio.height,
                                  child: Text('이용자',
                                      style: KR.parag1
                                          .copyWith(color: MGColor.base1)),
                                ),
                                Positioned(
                                  left: 80 * ratio.width,
                                  child: Form(
                                    key: _formKey,
                                    child: Row(children: [
                                      CustomTextField(
                                        enabled: !_isSolo,
                                        width: ratio.width * 122,
                                        height: 32,
                                        controller: _numberCtr,
                                        keyboard: TextInputType.number,
                                        hint: '인원 수',
                                        format: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(2),
                                        ],
                                        validator: (str) {
                                          if (str!.isEmpty ||
                                              str == "0" ||
                                              str == "00") {
                                            return alertMessege =
                                            "인원 수를 정확히 입력해 주세요";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ]),
                                  ),
                                ),
                                Positioned(
                                    left: 80 * ratio.width,
                                    bottom: 0,
                                    child: Text(alertMessege,
                                        style: KR.label2.copyWith(
                                            color: _isSolo
                                                ? _addUserGuideline =
                                                MGColor.systemError
                                                : _addUserGuideline))),
                              ]
                            ),
                          ),
                        )
                      else
                        Container(
                          margin: EdgeInsets.fromLTRB(ratio.width * 16, 0,
                              ratio.width * 16, ratio.height * 12),
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
                                height: 32 + 31 * ratio.height,
                                child: Stack(children: [
                                  Positioned(
                                    left: 16 * ratio.width,
                                    top: 16 * ratio.height,
                                    child: Text('이용자',
                                        style: KR.parag1
                                            .copyWith(color: MGColor.base1)),
                                  ),
                                  Positioned(
                                    left: 80 * ratio.width,
                                    top: 10 * ratio.height,
                                    child: Form(
                                      key: _formKey,
                                      child: Row(children: [
                                        CustomTextField(
                                          enabled: !_isSolo,
                                          width: ratio.width * 120,
                                          height: 32,
                                          controller: _numberCtr,
                                          keyboard: TextInputType.number,
                                          hint: '학번',
                                          format: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(9),
                                          ],
                                          validator: (str) {
                                            _existError = true;
                                            if (str!.isEmpty || str.length != 9) {
                                              return elseMessage = "정확한 학번을 입력해 주세요!";
                                            } else if (_leaderNumber.toString() == str) {
                                              return elseMessage = "대표자를 제외한 이용자의 학번을 입력해 주세요!";
                                            } else if (_numberList.any((e) => e.contains(str))) {
                                              return elseMessage = "이미 등록된 이용자입니다.";
                                            } else {
                                              _existError = false;
                                              return null;
                                            }
                                          },
                                        ),
                                        SizedBox(width: ratio.width * 110),
                                        Material(
                                          child: InkWell(
                                            onTap: _isSolo
                                                ? null
                                                : _validateAddingUser,
                                            customBorder:
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12)),
                                            child: Ink(
                                              width: 32 * ratio.width,
                                              height: 32 * ratio.width,
                                              decoration: BoxDecoration(
                                                color: _isSolo
                                                    ? MGColor.base6
                                                    : MGColor.brandPrimary,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  MGIcon.plus,
                                                  size: 16,
                                                  color: _isSolo
                                                      ? MGColor.base4
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                  Positioned(
                                      left: 80 * ratio.width,
                                      top: 32 + ratio.height * 14,
                                      child: Text(
                                          elseMessage,
                                          style: KR.label2.copyWith(color: _addUserGuideline)
                                      )
                                  ),
                                ]),
                              ),

                              /// registers
                              Container(
                                width: 274 * ratio.width,
                                margin: EdgeInsets.only(
                                    left: 78 * ratio.width,
                                    bottom: 12 * ratio.height),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: ratio.width * 274,
                                      child: Wrap(
                                        spacing: 8,
                                        alignment: WrapAlignment.start,
                                        children: _userNumList
                                            .map((e) => _myUserBox(e))
                                            .toList(),
                                      ),
                                    ),
                                    SizedBox(height: 8 * ratio.height),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isSolo = !_isSolo;
                                          if (_isSolo) {
                                            elseMessage = "추가 이용자가 없습니다.";
                                            _addUserGuideline = MGColor.base4;
                                          } else {
                                            elseMessage = "대표자를 제외한 이용자의 학번을 입력해 주세요!";
                                            _addUserGuideline = MGColor.brandPrimary;
                                          }
                                        });
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.transparent,
                                            child: Checkbox(
                                                value: _isSolo,
                                                shape: const CircleBorder(),
                                                side: const BorderSide(
                                                    color: MGColor.base3,
                                                    width: 1.6),
                                                activeColor:
                                                MGColor.brandPrimary,
                                                onChanged: (bool? value) {
                                                  setState(
                                                          () => _isSolo = value!);
                                                }),
                                          ),
                                          SizedBox(width: 10 * ratio.width),
                                          Text('추가 이용자가 없습니다.',
                                              style: KR.label2.copyWith(
                                                  color: MGColor.base3)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      /// 사용 목적
                      if (widget.service == ServiceType.aiSpace)
                        LargeTextField(
                            title: '사용 목적',
                            hint: '회의실을 예약하는 목적을 입력해 주세요',
                            controller: _purposeCtr)
                      else if (widget.service == ServiceType.computer)
                        LargeTextField(
                            title: '사용 목적',
                            hint: 'GPU를 예약하는 목적을 입력해 주세요',
                            controller: _purposeCtr)
                      else if (widget.service == ServiceType.lectureRoom)
                          LargeTextField(
                              title: '사용 목적',
                              hint: '강의실을 예약하는 목적을 입력해 주세요',
                              controller: _purposeCtr)
                    ]);

                    return SizeTransition(
                      sizeFactor: animation,
                      child: temp[index],
                    );
                  },
                ),
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(children: [
                      const Spacer(),

                      ///예약하기 버튼
                      Padding(
                          padding: EdgeInsets.only(bottom: ratio.height * 10),
                          child: CustomButtons.bottomButton(
                              '예약하기',
                              MGColor.brandPrimary,
                              () => _canTime ? _reserve() : null,
                              disableBackground: MGColor.base6
                          )
                      )
                    ]))
              ]),
            ),
          ),

          /// 로딩 중
          if (_loading) const ProgressScreen()
        ],
      ),
    );
  }

  /// 맨 처음 보이는 위젯
  void _initPage() {
    debugPrint(_selectedPlace);
    /// 장소 선택란
    if (widget.service == ServiceType.lectureRoom) {
      _firstWidgets.add(Padding(
        padding: EdgeInsets.only(
            top: ratio.height * 8,
            left: ratio.width * 20,
            bottom: ratio.height * 12
        ),
        child: Text(
          '강의실 위치는 예약 시 조교 확인 후 배정해드립니다.',
          style: TextStyle(
            fontSize: 11,
            color: MGColor.brandPrimary,
            fontFamily: 'Ko'
          ),
        ),
      ));
    } else if (widget.service == ServiceType.computer) {
      _firstWidgets.add(SelectingComputerWidget(
        _selectedEnter == null ? null : widget.availableRoom,
        onSelected: (com) {
          _selectedPlace = com;
          if (_selectedPlace != null && _selectedEnter != null) {
            setState(() {
              if (!_canTime) {
                _canTime = true;
                _listKey.currentState!.insertAllItems(0, 4);
              }
            });
          }
        },
      ));
    } else {
      _firstWidgets.add(CustomContainer(
          title: widget.service == ServiceType.aiSpace ? '회의실' : '컴퓨터',
          height: 52,
          margin: EdgeInsets.fromLTRB(
              ratio.width * 16, 0, ratio.width * 16, ratio.height * 12),
          content: Row(children: [
            CustomDropdown(
              value: _selectedPlace,
              hint: "선택",
              items: _places,
              onChanged: (value) {
                _selectedPlace = value;
                if (_selectedPlace != null && _selectedDate != null) {
                  setState(() {
                    _numberCtr.clear();
                    _purposeCtr.clear();
                    if (widget.service != ServiceType.computer) {
                      _selectedEnter = _selectedEnd = null;
                    }
                    if (!_canTime) {
                      _canTime = true;
                      _listKey.currentState!.insertAllItems(0, 4);
                    }
                  });
                }
              },
            )
          ])));
    }

    /// 날짜 선택란
    if (widget.service == ServiceType.computer) {
      _firstWidgets.insert(0, Container(
          margin: EdgeInsets.fromLTRB(
              ratio.width * 16,
              0,
              ratio.width * 16,
              ratio.height * 12
          ),
          padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 16,
              vertical: 16
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)),
          child: CustomWeekCalender(
            rowHeight: 32,
            rowWidth: 38 * ratio.width,
            cellStyle: CellStyle(
              fieldTextStyle:
              EN.label1.copyWith(color: MGColor.base3),
              normalDateTextStyle:
              EN.parag1.copyWith(color: MGColor.base1),
              normalDateBoxDecoration: BoxDecoration(
                  color: MGColor.base10,
                  borderRadius: BorderRadius.circular(4)),
              selectedDateTextStyle:
              EN.parag1.copyWith(color: Colors.white),
              selelctedDateBoxDecoration: BoxDecoration(
                  color: MGColor.brandPrimary,
                  borderRadius: BorderRadius.circular(4)),
              todayTextStyle:
              EN.parag1.copyWith(color: MGColor.brandPrimary),
              todayBoxDecoration: BoxDecoration(
                  color: MGColor.base10,
                  borderRadius: BorderRadius.circular(4)),
              rangeOutDateTextStyle:
              EN.parag1.copyWith(color: MGColor.base6),
              rangeOutDateBoxDecoration: BoxDecoration(
                  color: MGColor.base10,
                  borderRadius: BorderRadius.circular(4)),
            ),
            onSelected: (s, e) {
              _selectedEnter = s;
              _selectedEnd = e;
              comReserveStreamListener.add(widget.availableRoom);
              if (_selectedPlace != null && _selectedEnter != null) {
                setState(() {
                  if (widget.reserve != null
                      && _selectedPlace == widget.reserve!.place
                      && _selectedDate == widget.reserve!.startToDate2()) {
                    _selectedEnter = widget.reserve!.startTime;
                    _selectedEnd = widget.reserve!.endTime;
                  }
                  if (!_canTime) {
                    _canTime = true;
                    _listKey.currentState!.insertAllItems(0, 4);
                  }
                });
              }
            }
          )
      ));
    } else {
      _firstWidgets.add(Container(
          margin: EdgeInsets.fromLTRB(
              ratio.width * 16, 0, ratio.width * 16, ratio.height * 12),
          padding:
          EdgeInsets.symmetric(horizontal: ratio.width * 16, vertical: 16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: CustomDayCalender(
            init: _selectedDate,
            first: DateTime.now(),
            last: DateTime.now().add(const Duration(days: 13)),
            rowHeight: 32,
            rowWidth: 38 * ratio.width,
            cellStyle: CellStyle(
              fieldTextStyle: EN.label1.copyWith(color: MGColor.base3),
              normalDateTextStyle: EN.parag1.copyWith(color: MGColor.base1),
              normalDateBoxDecoration: BoxDecoration(
                  color: MGColor.base10,
                  borderRadius: BorderRadius.circular(4)),
              selectedDateTextStyle: EN.parag1.copyWith(color: Colors.white),
              selelctedDateBoxDecoration: BoxDecoration(
                  color: MGColor.brandPrimary,
                  borderRadius: BorderRadius.circular(4)),
              todayTextStyle: EN.parag1.copyWith(color: MGColor.brandPrimary),
              todayBoxDecoration: BoxDecoration(
                  color: MGColor.base10,
                  borderRadius: BorderRadius.circular(4)),
              rangeOutDateTextStyle: EN.parag1.copyWith(color: MGColor.base6),
              rangeOutDateBoxDecoration: BoxDecoration(
                  color: MGColor.base10,
                  borderRadius: BorderRadius.circular(4)),
            ),
            onSelected: (value) {
              _selectedDate = stdFormat3.format(value);
              if ((_selectedPlace != null || widget.service == ServiceType.lectureRoom) && _selectedDate != null) {
                setState(() {
                  _numberCtr.clear();
                  _purposeCtr.clear();
                  if (widget.reserve != null &&
                      _selectedPlace == widget.reserve!.place &&
                      _selectedDate == widget.reserve!.startToDate2()) {
                    _selectedEnter = widget.reserve!.startTime;
                    _selectedEnd = widget.reserve!.endTime;
                  } else {
                    _selectedEnter = _selectedEnd = null;
                  }
                  if (!_canTime) {
                    _canTime = true;
                    _listKey.currentState!.insertAllItems(0, 4);
                  }
                });
              }
            },
          )));
    }
  }

  /// 만약 예약을 수정하는 경우, 이전 정보와 같은지 확인하기
  bool _isSame() {
    if (widget.reserve!.place == _selectedPlace) return true;

    if (widget.reserve!.startToDate2() == _selectedDate) return true;

    if (widget.reserve!.startTime.compareTo(_selectedEnd!) == 0) return true;
    if (widget.reserve!.endTime.compareTo(_selectedEnter!) == 0) return true;

    return false;
  }

  /// 추가하는 유저에 대한 유효성 검사
  void _validateAddingUser() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
        }
        elseMessage = "정상적으로 추가됐습니다";
        _addUserGuideline = MGColor.brandPrimary;
        _userNumList.add(_numberCtr.text);
        setState(() => _numberCtr.clear());
      } else {
        _addUserGuideline = MGColor.systemError;
      }
    });
  }

  /// 추가 이용자를 나타내는 위젯
  Widget _myUserBox(String memberInfo) {
    return Container(
      key: ValueKey<String>(memberInfo),
      width: 103 * ratio.width,
      height: 26 * ratio.height,
      margin: EdgeInsets.only(top: 8 * ratio.height),
      padding: EdgeInsets.only(
        left: ratio.width * 10,
        right: ratio.width * 5
      ),
      decoration: ShapeDecoration(
        color: _isSolo ? MGColor.base4 : MGColor.brandSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(memberInfo,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: KR.parag2.copyWith(color: Colors.white)),
          ),
          GestureDetector(
            onTap: () => setState(() {
              _userNumList.removeWhere((s) => s.contains(memberInfo));
            }),
            child: const Icon(MGIcon.cross, size: 20, color: Colors.white)
          ),
        ],
      ),
    );
  }

  /// 예약하기
  Future<void> _reserve() async {
    bool allClear = false;
    late String title;
    late Function() onPressed;

    setState(() {
      _loading = true;
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        FocusScope.of(context).unfocus();
      }
      if (_numberCtr.text.isNotEmpty) {
        _numberList.add(_numberCtr.text);
      }
    });

    if (widget.service != ServiceType.computer &&
        (_selectedEnter == null || _selectedEnd == null)) {
      title = '예약 시간을 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (widget.service == ServiceType.lectureRoom
        && _numberCtr.text.isEmpty) {
      title = '인원 수를 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (widget.service != ServiceType.lectureRoom
        && !_isSolo && _userNumList.isEmpty) {
      title = '추가 이용자를 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (_purposeCtr.text.isEmpty) {
      title = '사용 목적을 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (widget.reserve != null && _isSame()) {
      title = '이전 내용과 같습니다.';
      onPressed = () => Navigator.pop(context);
    } else {
      onPressed = () => Navigator.pop(context);

      late String number, userNumber, start, end;
      number = _numberList.toString();
      userNumber = _userNumList.toString();
      number = number.substring(1, number.length - 1);
      userNumber = userNumber.substring(1, userNumber.length - 1);
      start = stdFormat2.format(_selectedEnter!);
      end = stdFormat2.format(_selectedEnd!);
      debugPrint("""
      [reservation Info]
        . room: $_selectedPlace
        . startTime: $start
        . endTime: $end
        . leader: $_leaderNumber $_leaderName
        . number: $number
        . userNumber: $userNumber
        . purpose: ${_purposeCtr.text}""");

      try {
        Map<String, dynamic>? response = widget.reserve != null
            ? await RestAPI.patchReservation(
            reservationId: widget.reserve!.reservationId,
            service: widget.service,
            place: _selectedPlace,
            startTime: start,
            endTime: end,
            leader: widget.reserve!.leaderInfo,
            number: number,
            userNumber: userNumber,
            purpose: _purposeCtr.text,
            professor: _professorCtr.text)
            : await RestAPI.addReservation(
            service: widget.service,
            place: _selectedPlace,
            startTime: start,
            endTime: end,
            number: number,
            userNumber: userNumber,
            purpose: _purposeCtr.text,
            professor: _professorCtr.text);
        if (response == null) {
          title = 'Not found';
          onPressed = () => Navigator.pop(context);
        } else if (response['reservationID'] == -1) {
          title = '[!] ${response['statusMsg']}';
          onPressed = () {
            Navigator.pop(context);
            setState(() {});
          };
        } else {
          allClear = true;
          title = '예약되었습니다!';
          onPressed = () {
            listListener.add(StreamType.reserve);
            Navigator.popUntil(context, (route) => route.isFirst);
          };
        }
      } on TimeoutException {
        title = '통신 속도가 너무 느립니다!';
        onPressed = () => Navigator.pop(context);
      } catch(_) {
        title = '예약할 수 없는 상태입니다.';
        onPressed = () => Navigator.pop(context);
      }
    }

    setState(() {
      _loading = false;
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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widgets/select_time_widgets.dart';
import 'package:mata_gachon/widgets/popup_widgets.dart';
import 'package:mata_gachon/widgets/small_widgets.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({
    Key? key,
    // required this.service,
    this.reservate
  }) : super(key: key);

  // final int service;
  final Reservate? reservate;

  @override
  State<ReservatePage> createState() => _ReservatePageState();
}
class _ReservatePageState extends State<ReservatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();

  ///textfield controllor
  final TextEditingController _stuNumCtr = TextEditingController();
  final TextEditingController _nameCtr = TextEditingController();
  final TextEditingController _purposeCtr = TextEditingController();
  final TextEditingController _professerCtr = TextEditingController();

  /// 고정 데이터
  late final int _leaderNumber; //대표자 학번
  late final String _leaderName; //대표자 이름
  final List<String> _places = ['405-4', '405-5', '405-6']; // 강의실 목록
  final List<Widget> _firstWidgets = []; // 화면에 표시되는 위젯 목록

  /// 기타
  late bool _isSolo, _loading, _canTime; // for utility
  late Color _addUserGuideline; // for widget

  /// 예약 정보
  String? _selectedRoom; //강의실
  String? _selectedDate; //날짜
  DateTime? _selectedEnter, _selectedEnd; // 이용 시작, 끝
  List<String> _usersList = []; //이용자리스트
  List<Widget> _usersWidgets = []; // └> 를 위한 위젯

  ///이용자 컨데이너 안내메세지
  String alertMessege = "대표자를 제외한 이용자의 학번과 이름을 입력해주세요!";

  @override
  void initState() {
    super.initState();

    // init
    this._loading = false;
    this._isSolo = this._canTime = false;
    this._addUserGuideline = MGcolor.primaryColor();
    this._leaderNumber = myInfo.stuNum;
    this._leaderName = myInfo.name;
    _initPage();

    // if modifing
    if (widget.reservate != null) {
      List<String> temp;
      temp = widget.reservate!.leaderInfo.split(' ');
      this._selectedRoom = widget.reservate!.place;
      this._selectedDate = widget.reservate!.startToDate();
      this._selectedEnter = widget.reservate!.startTime;
      this._selectedEnd = widget.reservate!.endTime;
      if (widget.reservate!.memberInfo.isNotEmpty) {
        this._isSolo = false;
        temp = widget.reservate!.memberInfo.split(' ');
        for (int i=0 ; i < temp.length ; i+=2) {
          _usersList.add('${temp[i]} ${temp[i+1]}');
        }
        _usersWidgets = _usersList.map((e) => _MyUserBox(e)).toList();
      } else {
        this._isSolo = true;
      }
      // Todo: 나중에 바꾸기
      this._purposeCtr.text = 'late change!';
      // 위젯
      this._canTime = true;
    }
  }

  @override
  void dispose() {
    _stuNumCtr.dispose();
    _nameCtr.dispose();
    _purposeCtr.dispose();
    _professerCtr.dispose();
    super.dispose();
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
          FutureBuilder(
            future: null,
            // future: _places != null ? null : _getPlace(),
            builder: (context, snapshot) {
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
                body: CustomScrollView(
                  slivers: [
                    SliverList.list(children: _firstWidgets),
                    SliverAnimatedList(
                      key: _listKey,
                      initialItemCount: _canTime ? 4 : 0,
                      itemBuilder: (context, index, animation) {
                        List<Widget> temp = [];

                        /// 만약 GPU 컴퓨터 예약이면, 전담 교수님 추가 위젯
                        /// 아니면, 시간 선택 위젯
                        if (service == ServiceType.computer) {
                          temp.add(Container(
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// Title
                                Text('전담 교수님', style: KR.parag1),

                                SizedBox(width: ratio.width * 36),

                                /// Textfield
                                CustomTextField(
                                  enabled: true,
                                  width: 184 * ratio.width,
                                  height: 32,
                                  controller: _professerCtr,
                                  hint: 'OOO 교수님',
                                  format: [_ProfesserFormat()],
                                )
                              ]
                            )
                          ));
                        } else temp.add(Container(
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
                            child: CustomTimePicker(
                              room: _selectedRoom,
                              date: _selectedDate!,
                              begin: widget.reservate != null ? _selectedEnter!.hour : null,
                              end: widget.reservate != null ? _selectedEnd!.hour : null,
                              setStart: (index) {
                                _selectedEnter = DateTime(
                                    _selectedEnter!.year,
                                    _selectedEnter!.month,
                                    _selectedEnter!.day,
                                    index
                                );
                              },
                              setEnd: (index) {
                                _selectedEnd = DateTime(
                                    _selectedEnter!.year,
                                    _selectedEnter!.month,
                                    _selectedEnter!.day,
                                    index + 1
                                );
                              },
                            )
                        ));

                        /// 나머지 모두
                        temp.addAll([
                          ///대표자
                          CustomContainer(
                            title: "대표자",
                            height: 52,
                            margin: EdgeInsets.fromLTRB(
                                ratio.width * 16,
                                0,
                                ratio.width * 16,
                                ratio.height * 12
                            ),
                            content: SizedBox.shrink(),
                            additionalContent: [
                              Positioned(
                                  left: 80 * ratio.width,
                                  top: 16,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$_leaderNumber",
                                        style:
                                        KR.parag2.copyWith(color: MGcolor.base3),
                                      ),
                                      SizedBox(width: 4 * ratio.width),
                                      Text(
                                        _leaderName,
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
                                              CustomTextField(
                                                enabled: !_isSolo,
                                                width: 122 * ratio.width,
                                                height: 32,
                                                controller: _stuNumCtr,
                                                hint: '202300001',
                                                format: [
                                                  FilteringTextInputFormatter.digitsOnly, //숫자만 허용
                                                  LengthLimitingTextInputFormatter(9), //9글자만 허용
                                                ],
                                                validator: (str) {
                                                  if (str!.isEmpty || str.length != 9) {
                                                    return alertMessege = "정확한 학번과 이름을 입력해 주세요";
                                                  } else if(_leaderNumber.toString() == str) {
                                                    return alertMessege = '대표자를 제외한 이용자의 학번과 이름을 입력해주세요!';
                                                  } else if (_usersWidgets.any((e) => (e.key! as ValueKey<String>).value.contains(str))) {
                                                    return alertMessege = "이미 등록된 이용자입니다!";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                              SizedBox(width: 8 * ratio.width),
                                              CustomTextField(
                                                enabled: !_isSolo,
                                                width: 92 * ratio.width,
                                                height: 32,
                                                controller: _nameCtr,
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
                                                  onTap: _isSolo ? null : _validateAddingUser,
                                                  customBorder: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(12)),
                                                  child: Ink(
                                                      width: 32 * ratio.width,
                                                      height: 32 * ratio.width,
                                                      decoration: BoxDecoration(
                                                        color: _isSolo ? MGcolor.base6
                                                            : MGcolor.primaryColor(),
                                                        borderRadius:
                                                        BorderRadius.circular(12),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                            AppinIcon.plus,
                                                            size: 16,
                                                            color: _isSolo ? MGcolor.base4
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
                                                color: _isSolo
                                                    ? MGcolor.base4
                                                    : _addUserGuideline
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
                                      SizedBox(
                                        width: ratio.width * 274,
                                        child: Wrap(
                                          spacing: 8,
                                          alignment: WrapAlignment.end,
                                          children: _usersWidgets,
                                        ),
                                      ),
                                      SizedBox(height: 8 * ratio.height),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12 * ratio.width),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() => _isSolo = !_isSolo);
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
                                                    shape: CircleBorder(),
                                                    side: BorderSide(
                                                        color: MGcolor.base3,
                                                        width: 1.6
                                                    ),
                                                    activeColor: MGcolor.primaryColor(),
                                                    onChanged: (bool? value) {
                                                      setState(() => _isSolo = value!);
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

                          /// 사용 목적
                          Container(
                            width: ratio.width * 358,
                            height: 150,
                            margin: EdgeInsets.fromLTRB(
                                ratio.width * 16,
                                0,
                                ratio.width * 16,
                                ratio.height * 12
                            ),
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
                                /// Title
                                Text('사용 목적', style: KR.subtitle3.copyWith(color: Colors.black)),

                                SizedBox(height: ratio.height * 10),

                                /// TextField
                                Expanded(child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ratio.width * 12,
                                        vertical: ratio.height * 10
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: MGcolor.primaryColor())
                                    ),
                                    alignment: Alignment.topLeft,
                                    child: TextField(
                                      controller: _purposeCtr,
                                      maxLength: 70,
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: KR.parag2,
                                      decoration: InputDecoration(
                                          hintText: '회의실을 예약하는 목적을 입력해주세요.',
                                          counterText: '',
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          hintStyle: KR.parag2.copyWith(color: MGcolor.base5)
                                      ),
                                    )
                                ))
                              ],
                            ),
                          )
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
                          Spacer(),

                          ///예약하기 버튼
                          Padding(
                            padding: EdgeInsets.only(bottom: ratio.height * 10),
                            child: ElevatedButton(
                                onPressed: _canTime ? _reservate : null,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: MGcolor.primaryColor(),
                                    disabledBackgroundColor: MGcolor.base5,
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
                        ])
                    )
                  ]
                ),
              );
            }
          ),

          /// 로딩 중
          if (_loading)
            ProgressScreen()
        ],
      ),
    );
  }

  ///
  void _initPage() {
    /// 장소 선택란
    if (service == ServiceType.lectureRoom) {
      _firstWidgets.add(Padding(
        padding: EdgeInsets.only(
            left: ratio.width * 20,
            bottom: ratio.height * 20
        ),
        child: Text(
          '강의실 위치는 예약 시 조교 확인 후 배정해드립니다.',
          style: TextStyle(
            fontSize: 11,
            color: MGcolor.primaryColor(),
            fontFamily: 'Ko'
          ),
        ),
      ));
    } else _firstWidgets.add(CustomContainer(
        title: service == ServiceType.aiSpace ? '회의실' : '컴퓨터',
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
                items: _places,
                onChanged: (value) {
                  this._selectedRoom = value;
                  if (_selectedRoom != null && _selectedDate != null) {
                    setState(() {
                      _selectedEnter = _selectedEnd = null;
                      if (!_canTime) {
                        _canTime = true;
                        _listKey.currentState!.insertAllItems(0, 4);
                      }
                    });
                  }
                },
              )
            ]
        )
    ));

    /// 날짜 선택란
    if (service == ServiceType.computer) {
      _selectedEnter = DateTime.now();
      switch (DateTime.now().weekday) {
        case 1:
          break;
        case 2:
          _selectedEnter!.subtract(Duration(days: 1));
        case 3:
          _selectedEnter!.subtract(Duration(days: 1));
        case 4:
          _selectedEnter!.subtract(Duration(days: 1));
        case 5:
          _selectedEnter!.subtract(Duration(days: 1));
          break;
        case 6:
          _selectedEnter!.add(Duration(days: 1));
        case 7:
          _selectedEnter!.add(Duration(days: 1));
          break;
      }
      _selectedEnd = _selectedEnter!.add(Duration(days: 4));
      debugPrint('${std1_format.format(_selectedEnter!)} ~ ${std1_format.format(_selectedEnd!)}');
      _selectedDate = std3_format.format(_selectedEnter!);
      _firstWidgets.add(Container(
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
            first: _selectedEnter!,
            last: _selectedEnd!,
            rowHeight: 32,
            rowWidth: 38 * ratio.width,
            cellStyle: CellStyle(
              fieldTextStyle:
              EN.label1.copyWith(color: MGcolor.base3),
              normalDateTextStyle:
              EN.parag1.copyWith(color: MGcolor.base1),
              normalDateBoxDecoration: BoxDecoration(
                  color: MGcolor.base10,
                  borderRadius: BorderRadius.circular(4)),
              selectedDateTextStyle:
              EN.parag1.copyWith(color: Colors.white),
              selelctedDateBoxDecoration: BoxDecoration(
                  color: MGcolor.primaryColor(),
                  borderRadius: BorderRadius.circular(4)),
              todayTextStyle:
              EN.parag1.copyWith(color: MGcolor.primaryColor()),
              todayBoxDecoration: BoxDecoration(
                  color: MGcolor.base10,
                  borderRadius: BorderRadius.circular(4)),
              rangeOutDateTextStyle:
              EN.parag1.copyWith(color: MGcolor.base6),
              rangeOutDateBoxDecoration: BoxDecoration(
                  color: MGcolor.base10,
                  borderRadius: BorderRadius.circular(4)),
            ),
          )
      ));
    } else _firstWidgets.add(Container(
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
        child: CustomDayCalender(
          init: _selectedDate,
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
                color: MGcolor.base10,
                borderRadius: BorderRadius.circular(4)),
            selectedDateTextStyle:
            EN.parag1.copyWith(color: Colors.white),
            selelctedDateBoxDecoration: BoxDecoration(
                color: MGcolor.primaryColor(),
                borderRadius: BorderRadius.circular(4)),
            todayTextStyle:
            EN.parag1.copyWith(color: MGcolor.primaryColor()),
            todayBoxDecoration: BoxDecoration(
                color: MGcolor.base10,
                borderRadius: BorderRadius.circular(4)),
            rangeOutDateTextStyle:
            EN.parag1.copyWith(color: MGcolor.base6),
            rangeOutDateBoxDecoration: BoxDecoration(
                color: MGcolor.base10,
                borderRadius: BorderRadius.circular(4)),
          ),
          onSelected: (value) {
            _selectedDate = std3_format.format(value);
            if ((_selectedRoom != null || service == ServiceType.lectureRoom) && _selectedDate != null) {
              setState(() {
                if (widget.reservate != null
                    && _selectedRoom == widget.reservate!.place
                    && _selectedDate == widget.reservate!.startToDate()) {
                  _selectedEnter = widget.reservate!.startTime;
                  _selectedEnd = widget.reservate!.endTime;
                } else {
                  _selectedEnter = _selectedEnd = value;
                }
                if (!_canTime) {
                  _canTime = true;
                  _listKey.currentState!.insertAllItems(0, 4);
                }
              });
            }
          },
        )
    ));
  }

  /// 만약 예약을 수정하는 경우, 이전 정보와 같은지 확인하기
  bool _isSame() {
    if (widget.reservate!.place == _selectedRoom) return true;

    if (widget.reservate!.startToDate() == _selectedDate) return true;

    if (widget.reservate!.startTime.compareTo(_selectedEnd!) == 0) return true;
    if (widget.reservate!.endTime.compareTo(_selectedEnter!) == 0) return true;

    return false;
  }

  /// 추가하는 유저에 대한 유효성 검사
  void _validateAddingUser() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        if (MediaQuery.of(context).viewInsets.bottom > 0) {
          FocusScope.of(context).unfocus();
        }
        alertMessege = "정상적으로 추가됐습니다";
        _addUserGuideline = MGcolor.primaryColor();
        _usersList.add("${_stuNumCtr.text} ${_nameCtr.text}");
        _usersWidgets.add(_MyUserBox("${_stuNumCtr.text} ${_nameCtr.text}"));
        _stuNumCtr.clear();
        _nameCtr.clear();
      } else {
        _addUserGuideline = MGcolor.systemError;
      }
    });
  }

  /// 추가 이용자를 나타내는 위젯
  Widget _MyUserBox(String memberInfo) {
    return Container(
      key: ValueKey<String>(memberInfo),
      width: 133 * ratio.width,
      height: 26 * ratio.height,
      margin: EdgeInsets.only(top: 8 * ratio.height),
      decoration: ShapeDecoration(
        color: MGcolor.secondaryColor(),
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
                  setState(() => _usersWidgets
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

  // /// 서비스에 따른 예약 장소
  // Future<void> _getPlace() async {
  //   List<String>? temp = await RestAPI.placeForService(service: widget.service);
  //   if (temp == null) {
  //     debugPrint('[Error] about getting places');
  //     Navigator.pop(context);
  //   } else {
  //     setState(() {
  //       this._places = temp;
  //       this._loading = false;
  //     });
  //   }
  // }

  /// 예약하기
  Future<void> _reservate() async {
    bool allClear = false;
    late String title;
    late Function() onPressed;

    setState(() {
      _loading = true;
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        FocusScope.of(context).unfocus();
      }
    });

    if (_selectedEnter == null || _selectedEnd == null) {
      title = '예약 시간을 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (!_isSolo && _usersList.isEmpty) {
      title = '추가 이용자를 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (_purposeCtr.text.isEmpty) {
      title = '사용 목적을 입력해주세요!';
      onPressed = () => Navigator.pop(context);
    } else if (widget.reservate != null && _isSame()) {
      title = '이전 내용과 같습니다.';
      onPressed = () => Navigator.pop(context);
    } else {
      onPressed = () => Navigator.pop(context);
      String member = _usersList.toString();
      member = member.substring(1, member.length-1);
      debugPrint("""
      [reservation Info]
        . room: $_selectedRoom
        . startTime: ${std2_format.format(_selectedEnter!)}
        . endTime: ${std2_format.format(_selectedEnd!)}
        . leader: $_leaderNumber $_leaderName
        . member: $member
        . purpose: ${_purposeCtr.text}""");

      try {
        int? uid = widget.reservate != null
            ? await RestAPI.patchReservation(
            reservationId: widget.reservate!.reservationId,
            place: _selectedRoom!,
            startTime: std2_format.format(_selectedEnter!),
            endTime: std2_format.format(_selectedEnd!),
            leader: widget.reservate!.leaderInfo,
            member: member,
            purpose: _purposeCtr.text,
            professor: _professerCtr.text
        )
            : await RestAPI.addReservation(
            place: _selectedRoom!,
            startTime: std2_format.format(_selectedEnter!),
            endTime: std2_format.format(_selectedEnd!),
            member: member,
            purpose: _purposeCtr.text,
            professor: _professerCtr.text
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
        title = '예약할 수 없는 상태입니다.';
        onPressed = () => Navigator.pop(context);
      }
    }

    setState(() {
      _loading = false;
      showDialog(
          context: context,
          barrierColor: MGcolor.barrier,
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

class _ProfesserFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return TextEditingValue();
    }
    String temp = newValue.text.split(' ')[0];
    return newValue.copyWith(
      text: '$temp 교수님',
      selection: TextSelection.collapsed(offset: temp.length)
    );
  }
}
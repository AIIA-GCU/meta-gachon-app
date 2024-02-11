import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';

class CustomDayCalender extends StatefulWidget {
  const CustomDayCalender({
    super.key,
    required this.init,
    required this.first,
    required this.last,
    required this.rowHeight,
    required this.rowWidth,
    required this.cellStyle,
    required this.onSelected
  }) ;

  final String? init;
  final DateTime first;
  final DateTime last;
  final double rowHeight;
  final double rowWidth;
  final CellStyle cellStyle;
  final Function(DateTime) onSelected;

  @override
  State<CustomDayCalender> createState() => _CustomDayCalenderState();
}
class _CustomDayCalenderState extends State<CustomDayCalender> {

  late String title;
  late DateTime rangeFirst;
  late DateTime rangeLast;

  DateTime? selectedDay;
  void toSelect(DateTime day) {
    if (day != selectedDay && cmp(day)) {
      widget.onSelected(day);
      setState(() => selectedDay = day);
    }
  }

  bool isSameDate(DateTime a, DateTime b) {
    if (a.month == b.month && a.day == b.day)
      return true;
    else return false;
  }

  bool cmp(DateTime d) {
    if (!d.isBefore(DateTime(widget.first.year, widget.first.month, widget.first.day))
        && !d.isAfter(DateTime(widget.last.year, widget.last.month, widget.last.day)))
      return true;
    else return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.init != null) {
      selectedDay = std2_format.parse(widget.init!);
    }

    rangeFirst = DateTime(widget.first.year, widget.first.month, widget.first.day);
    rangeLast = DateTime(widget.last.year, widget.last.month, widget.last.day);

    while (rangeFirst.weekday != DateTime.sunday)
      rangeFirst = rangeFirst.subtract(Duration(days: 1));
    while (rangeLast.weekday != DateTime.saturday)
      rangeLast = rangeLast.add(Duration(days: 1));

    final DateFormat format = DateFormat.MMMM();
    if (rangeFirst.year < rangeLast.year || rangeFirst.month <rangeLast.month)
      title = "${format.format(rangeFirst)} ~ ${format.format(rangeLast)}";
    else title = "${format.format(rangeFirst)}";

    // print(widget.first);
    // print(widget.last);
    // print(rangeFirst);
    // print(rangeLast);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: EN.parag1.copyWith(color: MGcolor.base1)),
          SizedBox(height: 10 * ratio.height),
          Table(
            children: <TableRow>[
              TableRow(
                children: ['일', '월', '화', '수', '목', '금', '토']
                    .map((e) => Padding(
                      padding: EdgeInsets.only(bottom: 6 * ratio.height),
                      child: Text(e, style: widget.cellStyle.fieldTextStyle, textAlign: TextAlign.center)
                    ))
                    .toList()
              ),
              TableRow(
                children: List.generate(7, (index) {
                  late TextStyle textStyle;
                  late BoxDecoration boxDecoration;
                  DateTime day = rangeFirst.add(Duration(days: index));

                  if (selectedDay != null && isSameDate(selectedDay!, day)) {
                    textStyle = widget.cellStyle.selectedDateTextStyle;
                    boxDecoration = widget.cellStyle.selelctedDateBoxDecoration;
                  }
                  else if (isSameDate(widget.first, day)) {
                    textStyle = widget.cellStyle.todayTextStyle;
                    boxDecoration = widget.cellStyle.todayBoxDecoration;
                  }
                  else if (day.isBefore(widget.first)) {
                    textStyle = widget.cellStyle.rangeOutDateTextStyle;
                    boxDecoration = widget.cellStyle.rangeOutDateBoxDecoration;
                  }
                  else {
                    textStyle = widget.cellStyle.normalDateTextStyle;
                    boxDecoration = widget.cellStyle.normalDateBoxDecoration;
                  }

                  return GestureDetector(
                    onTap: () => toSelect(day),
                    child: Container(
                      height: widget.rowHeight,
                      width: widget.rowWidth,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                        5 * ratio.width,
                        0,
                        5 * ratio.width,
                        10 * ratio.height
                      ),
                      decoration: boxDecoration,
                      child: Text(day.day.toString(), style: textStyle),
                    ),
                  );
                }).toList()
              ),
              TableRow(
                children: List.generate(7, (index) {
                  late TextStyle textStyle;
                  late BoxDecoration boxDecoration;
                  DateTime day = rangeFirst.add(Duration(days: 7+index));

                  if (selectedDay != null && selectedDay!.day == day.day) {
                    textStyle = widget.cellStyle.selectedDateTextStyle;
                    boxDecoration = widget.cellStyle.selelctedDateBoxDecoration;
                  }
                  else {
                    textStyle = widget.cellStyle.normalDateTextStyle;
                    boxDecoration = widget.cellStyle.normalDateBoxDecoration;
                  }

                  return GestureDetector(
                    onTap: () => toSelect(day),
                    child: Container(
                      height: widget.rowHeight,
                      width: widget.rowWidth,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                          5 * ratio.width,
                          0,
                          5 * ratio.width,
                          10 * ratio.height
                      ),
                      decoration: boxDecoration,
                      child: Text(day.day.toString(), style: textStyle),
                    ),
                  );
                }).toList()
              ),
              if (rangeLast.day - rangeFirst.day != 13)
                TableRow(
                  children: List.generate(7, (index) {
                    late TextStyle textStyle;
                    late BoxDecoration boxDecoration;
                    DateTime day = rangeFirst.add(Duration(days: 14+index));

                    if (selectedDay != null && selectedDay! == day) {
                      textStyle = widget.cellStyle.selectedDateTextStyle;
                      boxDecoration = widget.cellStyle.selelctedDateBoxDecoration;
                    }
                    else if (day.isAfter(widget.last)) {
                      textStyle = widget.cellStyle.rangeOutDateTextStyle;
                      boxDecoration = widget.cellStyle.rangeOutDateBoxDecoration;
                    }
                    else {
                      textStyle = widget.cellStyle.normalDateTextStyle;
                      boxDecoration = widget.cellStyle.normalDateBoxDecoration;
                    }

                    return GestureDetector(
                      onTap: () => toSelect(day),
                      child: Container(
                        height: widget.rowHeight,
                        width: widget.rowWidth,
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            5 * ratio.width,
                            0,
                            5 * ratio.width,
                            10 * ratio.height
                        ),
                        decoration: boxDecoration,
                        child: Text(day.day.toString(), style: textStyle),
                      ),
                    );
                  }).toList()
                ),
            ],
          ),
        ],
      )
    );
  }
}

class CustomWeekCalender extends StatefulWidget {
  const CustomWeekCalender({
    super.key,
    required this.first,
    required this.last,
    required this.rowHeight,
    required this.rowWidth,
    required this.cellStyle,
  }) ;

  final DateTime first;
  final DateTime last;
  final double rowHeight;
  final double rowWidth;
  final CellStyle cellStyle;

  @override
  State<CustomWeekCalender> createState() => _CustomWeekCalenderState();
}
class _CustomWeekCalenderState extends State<CustomWeekCalender> {

  late String title;
  late DateTime rangeFirst;
  late DateTime rangeLast;

  bool isSameDate(DateTime a, DateTime b) {
    if (a.month == b.month && a.day == b.day)
      return true;
    else return false;
  }

  @override
  void initState() {
    super.initState();

    rangeFirst = widget.first.subtract(Duration(days: 8));
    rangeLast = widget.last.add(Duration(days: 8));

    final DateFormat format = DateFormat.MMMM();
    if (rangeFirst.year < rangeLast.year || rangeFirst.month <rangeLast.month)
      title = "${format.format(rangeFirst)} ~ ${format.format(rangeLast)}";
    else title = "${format.format(rangeFirst)}";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: EN.parag1.copyWith(color: MGcolor.base1)),
            SizedBox(height: 10 * ratio.height),
            Table(
              children: <TableRow>[
                TableRow(
                    children: ['일', '월', '화', '수', '목', '금', '토']
                        .map((e) => Padding(
                        padding: EdgeInsets.only(bottom: 6 * ratio.height),
                        child: Text(e, style: widget.cellStyle.fieldTextStyle, textAlign: TextAlign.center)
                    ))
                        .toList()
                ),
                TableRow(
                    children: List.generate(7, (index) {
                      DateTime day = rangeFirst.add(Duration(days: index));
                      TextStyle textStyle = widget.cellStyle.rangeOutDateTextStyle;
                      BoxDecoration boxDecoration = widget.cellStyle.rangeOutDateBoxDecoration;

                      return Container(
                        height: widget.rowHeight,
                        width: widget.rowWidth,
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            5 * ratio.width,
                            0,
                            5 * ratio.width,
                            10 * ratio.height
                        ),
                        decoration: boxDecoration,
                        child: Text(day.day.toString(), style: textStyle),
                      );
                    }).toList()
                ),
                TableRow(
                    children: List.generate(7, (index) {
                      late TextStyle textStyle;
                      late BoxDecoration boxDecoration;
                      DateTime day = rangeFirst.add(Duration(days: 7+index));

                      if (day.isBefore(widget.first)) {
                        textStyle = widget.cellStyle.rangeOutDateTextStyle;
                        boxDecoration = widget.cellStyle.rangeOutDateBoxDecoration;
                      } else if (day.isAfter(widget.last)) {
                        textStyle = widget.cellStyle.normalDateTextStyle;
                        boxDecoration = widget.cellStyle.normalDateBoxDecoration;
                      } else {
                        textStyle = widget.cellStyle.selectedDateTextStyle;
                        boxDecoration = widget.cellStyle.selelctedDateBoxDecoration;
                      }

                      return Container(
                        height: widget.rowHeight,
                        width: widget.rowWidth,
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            5 * ratio.width,
                            0,
                            5 * ratio.width,
                            10 * ratio.height
                        ),
                        decoration: boxDecoration,
                        child: Text(day.day.toString(), style: textStyle),
                      );
                    }).toList()
                ),
                TableRow(
                      children: List.generate(7, (index) {
                        DateTime day = rangeFirst.add(Duration(days: 14+index));
                        TextStyle textStyle = widget.cellStyle.normalDateTextStyle;
                        BoxDecoration boxDecoration = widget.cellStyle.normalDateBoxDecoration;

                        return Container(
                          height: widget.rowHeight,
                          width: widget.rowWidth,
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              5 * ratio.width,
                              0,
                              5 * ratio.width,
                              10 * ratio.height
                          ),
                          decoration: boxDecoration,
                          child: Text(day.day.toString(), style: textStyle),
                        );
                      }).toList()
                  ),
              ],
            ),
          ],
        )
    );
  }
}

class CellStyle {
  final TextStyle fieldTextStyle;
  final TextStyle todayTextStyle;
  final TextStyle normalDateTextStyle;
  final TextStyle selectedDateTextStyle;
  final TextStyle rangeOutDateTextStyle;
  final BoxDecoration todayBoxDecoration;
  final BoxDecoration normalDateBoxDecoration;
  final BoxDecoration selelctedDateBoxDecoration;
  final BoxDecoration rangeOutDateBoxDecoration;

  CellStyle({
    required this.fieldTextStyle,
    required this.todayTextStyle,
    required this.normalDateTextStyle,
    required this.selectedDateTextStyle,
    required this.rangeOutDateTextStyle,
    required this.todayBoxDecoration,
    required this.normalDateBoxDecoration,
    required this.selelctedDateBoxDecoration,
    required this.rangeOutDateBoxDecoration
  });
}

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({
    super.key,
    required this.room,
    required this.date,
    this.begin,
    this.end,
    required this.setStart,
    required this.setEnd
  });

  final String? room;
  final String date;
  final int? begin;
  final int? end;
  final void Function(int) setStart;
  final void Function(int) setEnd;

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}
class _CustomTimePickerState extends State<CustomTimePicker> {
  final _scrollCtr = ScrollController();

  late List<bool> _availables;
  late bool _reset;

  int? _begin, _end;

  @override
  void initState() {
    super.initState();

    this._reset = true;
    this._begin = widget.begin;
    this._end = widget.end;
    if (_begin != null && _end != null) {
      _end = _end! - 1;
      debugPrint("start: $_begin | end: ${_end!+1}");
    }
  }

  @override
  void didUpdateWidget(covariant CustomTimePicker oldWidget) {
    this._reset = true;
    this._begin = widget.begin;
    this._end = widget.end;
    if (_begin != null && _end != null) {
      _end = _end! - 1;
      debugPrint("start: $_begin | end: ${_end!+1}");
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Todo: 나중에 애니메이션 추가하기
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _reset ? _availableTime() : null,
      builder: (context, snapshot) {
        /// 시간 표시용 텍스트
        late final Text beginStr, endStr;
        if (_begin != null && _end != null) {
          if (_begin! < 10) {
            beginStr = Text('0$_begin:00', style: EN.subtitle2);
          } else if (_begin! >= 24) {
            beginStr = Text('0${_begin! % 24}:00', style: EN.subtitle2);
          } else {
            beginStr = Text('$_begin:00', style: EN.subtitle2);
          }
          if (_end! < 9) {
            endStr = Text('0${_end!+1}:00', style: EN.subtitle2);
          } else if (_end! >= 23) {
            endStr = Text('0${(_end!+1) % 24}:00', style: EN.subtitle2);
          } else {
            endStr = Text('${_end!+1}:00', style: EN.subtitle2);
          }
        } else {
          beginStr = Text('00:00',
              style: EN.subtitle2.copyWith(color: MGcolor.base5));
          endStr = Text('00:00',
              style: EN.subtitle2.copyWith(color: MGcolor.base5));
        }

        return SizedBox(
          width: ratio.width * 336,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("예약 시간", style: KR.parag1),
                  SizedBox(width: 12),
                  Text(
                    '예약은 최대 3시간까지 가능합니다',
                    style: KR.label2.copyWith(color: MGcolor.primaryColor())
                  )
                ],
              ),

              SizedBox(height: ratio.height * 10),

              if (_reset)
                ...[
                  SizedBox(height: 68 + ratio.height*22)
                ]
              else
                ...[
                  /// 마이쮸 시간표
                  SingleChildScrollView(
                    controller: _scrollCtr,
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          decoration: BoxDecoration(
                              color: MGcolor.base9,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: Row(children: List.generate(24, (index) {
                            Color? color;
                            if (!_availables[index]) {
                              color = MGcolor.base6;
                            }
                            else if (_begin != null && _end != null) {
                              if (_begin! <= index && index <= _end!) {
                                color = MGcolor.primaryColor();
                              } else if (index == _begin!+1) {
                                color = MGcolor.primaryColor().withOpacity(0.2);
                              } else if (index == _begin!+2 && _availables[index]) {
                                color = MGcolor.primaryColor().withOpacity(0.2);
                              }
                            }
                            if (color == null) {
                              color = Colors.white;
                            }

                            return GestureDetector(
                              onTap: color == MGcolor.base6
                                  ? null : () => _onTap(index),
                              child: Container(
                                  width: 24,
                                  height: 28,
                                  margin: EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(3)
                                  )
                              ),
                            );
                          })),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ratio.width * 2
                          ),
                          child: Row(children: List.generate(8, (index) {
                            if (index == 7) {
                              return SizedBox(
                                  width: (24 + 3 * 2) * 3,
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('21', style: EN.label2),
                                        Text('24', style: EN.label2),
                                      ]
                                  )
                              );
                            } else {
                              return SizedBox(
                                  width: (24 + 3 * 2) * 3,
                                  child: Text('${index * 3}', style: EN.label2)
                              );
                            }
                          })),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ratio.height * 8),

                  /// 시간 표시용 텍스트
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: ratio.width * 120,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: MGcolor.primaryColor())
                          ),
                          child: beginStr
                      ),
                      SizedBox(
                          width: 22 * ratio.width,
                          child: Center(child: Text("~"))
                      ),
                      Container(
                          width: ratio.width * 120,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: MGcolor.primaryColor())
                          ),
                          child: endStr
                      ),
                    ]
                  )
                ]
            ]
          )
        );
      }
    );
  }

  /// 박스를 클릭했을 때, 시간을 설정하기
  void _onTap(int idx) {
    setState(() {
      if (_begin == null || idx < _begin! || _begin!+2 < idx) {
        widget.setStart(_begin = idx);
        widget.setEnd(_end = idx);
      } else if (_end! <= _begin!+2) {
        if (idx == _end!) {
          widget.setStart(_begin = idx);
        } else {
          widget.setEnd(_end = idx);
        }
      }
      debugPrint("start: $_begin | end: ${_end!+1}");
    });
  }

  /// 서버에서 예약 가능한 시간 확인하기
  Future<void> _availableTime() async {
    if (service == ServiceType.aiSpace) {
      _availables = List.generate(24, (_) => false);
      try {
        Map<int, bool>? times = await RestAPI
            .getAvailableTime(room: widget.room!, date: widget.date);
        int i;
        for (i = 0; i < 24; i++) {
          _availables[i] = !times![i]!;
        }
        if (_begin != null && _end != null) {
          for (i = _begin! - 1; i <= _end!; i++) {
            _availables[i] = true;
          }
        }
      } catch (e) {}
    } else {
      _availables = List.generate(24, (_) => true);
      final current = DateTime.now();
      if (widget.date == std2_format.format(current)) {
        for (int i=0 ; i <= current.hour ; i++) {
          _availables[i] = false;
        }
      }
    }
    debugPrint('available times: $_availables');
    _reset = false;
  }
}

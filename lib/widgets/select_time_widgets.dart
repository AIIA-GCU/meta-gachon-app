import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:mata_gachon/config/server/_export.dart';
import 'package:mata_gachon/widgets/button.dart';

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
    if (a.month == b.month && a.day == b.day) {
      return true;
    } else {
      return false;
    }
  }

  bool cmp(DateTime d) {
    if (!d.isBefore(DateTime(widget.first.year, widget.first.month, widget.first.day))
        && !d.isAfter(DateTime(widget.last.year, widget.last.month, widget.last.day))) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.init != null) {
      selectedDay = stdFormat3.parse(widget.init!);
    }

    rangeFirst = DateTime(widget.first.year, widget.first.month, widget.first.day);
    rangeLast = DateTime(widget.last.year, widget.last.month, widget.last.day);

    while (rangeFirst.weekday != DateTime.sunday) {
      rangeFirst = rangeFirst.subtract(const Duration(days: 1));
    }
    while (rangeLast.weekday != DateTime.saturday) {
      rangeLast = rangeLast.add(const Duration(days: 1));
    }

    final DateFormat format = DateFormat.MMMM('ko_KR');
    if (rangeFirst.year < rangeLast.year || rangeFirst.month <rangeLast.month) {
      title = "${format.format(rangeFirst)} ~ ${format.format(rangeLast)}";
    } else {
      title = format.format(rangeFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: KR.parag1.copyWith(color: MGColor.base1)),
          SizedBox(height: 10 * ratio.height),
          Table(
            children: <TableRow>[
              TableRow(
                children: ['일', '월', '화', '수', '목', '금', '토']
                    .map((e) {
                      late TextStyle style;
                      if (e == '일') {
                        style = widget.cellStyle
                            .fieldTextStyle.copyWith(color: MGColor.systemError);
                      } else {
                        style = widget.cellStyle.fieldTextStyle;
                      }
                      return Padding(
                        padding: EdgeInsets.only(bottom: 6 * ratio.height),
                        child: Text(e, style: style, textAlign: TextAlign.center)
                      );
                    })
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
    if (a.month == b.month && a.day == b.day) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    rangeFirst = widget.first.subtract(const Duration(days: 8));
    rangeLast = widget.last.add(const Duration(days: 8));

    final DateFormat format = DateFormat.MMMM();
    if (rangeFirst.year < rangeLast.year || rangeFirst.month <rangeLast.month) {
      title = "${format.format(rangeFirst)} ~ ${format.format(rangeLast)}";
    } else {
      title = format.format(rangeFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: EN.parag1.copyWith(color: MGColor.base1)),
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
  const CustomTimePicker(this.service, {
    super.key,
    required this.place,
    required this.date,
    required this.begin,
    required this.end,
    required this.setStart,
    required this.setEnd
  });

  final ServiceType service;
  final String? place;
  final String date;
  final int? begin;
  final int? end;
  final void Function(int) setStart;
  final void Function(int) setEnd;

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}
class _CustomTimePickerState extends State<CustomTimePicker>
    with WidgetsBindingObserver {
  final _scrollCtr = ScrollController();
  final List<int> times = List.generate(24, (index) => index);

  late List<bool> _availables;
  late bool _reset, _animating;
  late String _date;
  late String? _place;

  int? _begin, _end;

  @override
  void initState() {
    _reset = _animating = true;
    _date = widget.date;
    _place = widget.place;
    if (widget.begin != null && widget.end != null) {
      _begin = widget.begin;
      _end = (widget.end!+23) % 24;
      debugPrint("start: $_begin | end: ${_end!+1}");
    }
    WidgetsBinding.instance.addTimingsCallback((_) {
      if (_scrollCtr.hasClients && _animating && _date == today) {
        debugPrint('the selected date is today!');
        _animating = false;
        _actScrollController(DateTime.now().hour);
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTimePicker oldWidget) {
    if (_place != widget.place || _date != widget.date) {
      _reset = _animating = true;
      _date = widget.date;
      _place = widget.place;
      _begin = _end = null;
      if (widget.begin != null && widget.end != null) {
        _begin = widget.begin;
        _end = (widget.end!+23) % 24;
        debugPrint("start: $_begin | end: ${_end!+1}");
      }
    }
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Todo: 나중에 애니메이션 추가하기
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _reset ? _availableTime() : null,
      builder: (context, snapshot) {
        return SizedBox(
          width: ratio.width * 336,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("예약 시간", style: KR.parag1),
                  const SizedBox(width: 12),
                  Text(
                    '예약은 최대 3시간까지 가능합니다',
                    style: KR.label2.copyWith(color: MGColor.brandPrimary)
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
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          decoration: BoxDecoration(
                              color: MGColor.base9,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: Row(children: List.generate(24, (index) {
                            Color? color;
                            if (!_availables[index]) {
                              color = MGColor.base6;
                            }
                            else if (_begin != null && _end != null) {
                              if (_begin! <= index && index <= _end!) {
                                color = MGColor.brandPrimary;
                              } else if (index == _begin!+1) {
                                color = MGColor.brandPrimary.withOpacity(0.2);
                              } else if (index == _begin!+2 && _availables[index-1]) {
                                color = MGColor.brandPrimary.withOpacity(0.2);
                              }
                            }
                            color ??= Colors.white;

                            return GestureDetector(
                              onTap: color == MGColor.base6
                                  ? null : () => _onChangedTime(index),
                              child: Container(
                                  width: 24,
                                  height: 28,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
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

                  /// 드롭다운
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDropdown(
                        value: _begin == null ? null
                            : _begin! < 10 ? '0$_begin:00' : '$_begin:00',
                        hint: '00:00',
                        items: times
                            .map((i) => i < 10 ? '0$i:00' : '$i:00')
                            .toList(),
                        onChanged: (value) {
                          var temp = value!.substring(0, 2);
                          _onChangedTime(int.parse(temp));
                        },
                      ),
                      SizedBox(
                          width: 22 * ratio.width,
                          child: const Center(child: Text("~"))
                      ),
                      CustomDropdown(
                        value: _end == null ? null
                            : _end! < 10 ? '0${_end!+1}:00' : '${_end!+1}:00',
                        hint: '00:00',
                        items: times
                            .map((i) => i < 10 ? '0${i+1}:00' : '${i+1}:00')
                            .toList(),
                        onChanged: (value) {
                          var temp = value!.substring(0, 2);
                          _onChangedTime(int.parse(temp)-1);
                        },
                      )
                    ]
                  )
                ]
            ]
          )
        );
      }
    );
  }

  /// 스크롤 컨트롤러 작동시키기
  void _actScrollController(int hour) {
    double offset = hour * 30 - 90;
    double maxOffset = _scrollCtr.position.maxScrollExtent;
    if (offset >= maxOffset) offset = maxOffset;
    else if (offset <= 120) offset = 0;
    _scrollCtr.animateTo(
        offset > maxOffset ? maxOffset : offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease
    );
  }

  /// 시간 변경
  void _onChangedTime(int idx) {
    setState(() {
      if (_begin == null
          || idx < _begin! || _begin!+2 < idx
          || (_begin != 23 && !_availables[_begin!+1])) {
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
    _actScrollController(_begin!);
  }

  /// 서버에서 예약 가능한 시간 확인하기
  Future<void> _availableTime() async {
    if (widget.service == ServiceType.aiSpace) {
      _availables = List.generate(24, (_) => false);
      try {
        Map<int, bool>? times = await RestAPI
            .getAvailableTime(room: widget.place!, date: widget.date);
        int i;
        for (i = 0; i < 24; i++) {
          _availables[i] = !times![i]!;
        }
        if (_begin != null && _end != null) {
          for (i = _begin! - 1; i <= _end!; i++) {
            _availables[i] = true;
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      _availables = List.generate(24, (_) => true);
      final current = DateTime.now();
      if (widget.date == stdFormat3.format(current)) {
        for (int i=0 ; i <= current.hour ; i++) {
          _availables[i] = false;
        }
      }
    }
    debugPrint('available times: $_availables');
    _reset = false;
  }
}

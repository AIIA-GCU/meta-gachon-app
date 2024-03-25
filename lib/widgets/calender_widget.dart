import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mata_gachon/config/app/interface.dart';

import '../config/app/_export.dart';

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

    if (rangeFirst.weekday != DateTime.sunday) {
      rangeFirst = rangeFirst
          .subtract(Duration(days: rangeFirst.weekday));
    }
    if (rangeLast.weekday != DateTime.sunday) {
      rangeLast = rangeLast.add(const Duration(days: 6));
    } else if (rangeLast.weekday != DateTime.saturday) {
      rangeLast = rangeLast
          .add(Duration(days: 7 - rangeLast.weekday));
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
                    }).toList()
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
                    })
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
                    })
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
                      })
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
    required this.rowHeight,
    required this.rowWidth,
    required this.cellStyle,
    required this.onSelected
  }) ;

  final double rowHeight;
  final double rowWidth;
  final CellStyle cellStyle;
  final void Function(DateTime s, DateTime e) onSelected;

  @override
  State<CustomWeekCalender> createState() => _CustomWeekCalenderState();
}
class _CustomWeekCalenderState extends State<CustomWeekCalender> {
  final monthFormat = DateFormat.MMMM('ko_KR');

  late String title;
  late DateTime day;
  late DateTime rangeFirst;
  late DateTime rangeLast;
  late DateTime availableFirst;
  DateTime? selectedFirst, selectedLast;

  bool isSameDate(DateTime a, DateTime b) {
    if (a.month == b.month && a.day == b.day) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    day = DateTime.now();

    rangeFirst = DateTime(day.year, day.month);
    rangeLast = DateTime(day.year, day.month+1)
        .subtract(const Duration(days: 1));

    if (rangeFirst.weekday != DateTime.sunday) {
      rangeFirst = rangeFirst
          .subtract(Duration(days: rangeFirst.weekday));
    }
    if (rangeLast.weekday == DateTime.sunday) {
      rangeLast = rangeLast.subtract(const Duration(days: 1));
    } else if (rangeLast.weekday != DateTime.saturday) {
      rangeLast = rangeLast
          .subtract(Duration(days: 7 - rangeLast.weekday));
    }

    availableFirst = day;
    if (availableFirst.weekday != DateTime.monday) {
      availableFirst = availableFirst
          .add(Duration(days: 7 - availableFirst.weekday));
    }
    if (availableFirst.isAfter(rangeLast)) {
      rangeFirst = rangeFirst.add(const Duration(days: 35));
      rangeLast = rangeLast.add(const Duration(days: 35));
    }

    title = "${availableFirst.month}월";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: EN.parag1.copyWith(color: MGColor.base1)),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (availableFirst.isAfter(DateTime(day.year, day.month))) {
                          return;
                        }
                        setState(() => _setCalender(day = DateTime(day.year, day.month-1)));
                      },
                      child: Icon(MGIcon.back, size: ratio.height * 24)
                    ),
                    SizedBox(width: ratio.width * 16),
                    GestureDetector(
                      onTap: () => setState(() {
                        _setCalender(day = DateTime(day.year, day.month+1));
                      }),
                      child: Transform.rotate(
                        angle: pi,
                        child: Icon(MGIcon.back, size: ratio.height * 24),
                      )
                    ),
                  ]
                )
              ],
            ),
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
                        }).toList()
                ),
                _createWeekRow(0),
                _createWeekRow(1),
                _createWeekRow(2),
                _createWeekRow(3),
                _createWeekRow(4),
              ],
            ),
          ],
        )
    );
  }

  TableRow _createWeekRow(int week) {
    week *= 7;
    return TableRow(
        children: List.generate(7, (index) {
          DateTime day = rangeFirst.add(Duration(days: week+index));

          late int type;
          late TextStyle textStyle;
          late BoxDecoration boxDecoration;
          switch (type = _dayType(day)) {
            case 0:
              textStyle = widget.cellStyle.normalDateTextStyle;
              boxDecoration = widget.cellStyle.normalDateBoxDecoration;
              break;
            case 1:
              textStyle = widget.cellStyle.selectedDateTextStyle;
              boxDecoration = widget.cellStyle.selelctedDateBoxDecoration;
              break;
            case 2:
              textStyle = widget.cellStyle.todayTextStyle;
              boxDecoration = widget.cellStyle.todayBoxDecoration;
              break;
            case 3:
              textStyle = EN.parag1
                  .copyWith(color: MGColor.brandPrimary.withAlpha(130));
              boxDecoration = widget.cellStyle.rangeOutDateBoxDecoration;
              break;
            case 4:
              textStyle = widget.cellStyle.rangeOutDateTextStyle;
              boxDecoration = widget.cellStyle.rangeOutDateBoxDecoration;
              break;
            case 5:
              textStyle = EN.parag1.copyWith(color: MGColor.base4);
              boxDecoration = widget.cellStyle.normalDateBoxDecoration;
              break;
          }

          return GestureDetector(
            onTap: ()=> (type == 0 || type == 2 || type == 5)
                ? _onSelected(day) : null,
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
        })
    );
  }

  void _onSelected(DateTime d) {
    setState(() {
      selectedFirst = d.subtract(Duration(days: d.weekday-1));
      selectedLast = d.add(Duration(days: 5-d.weekday));
      debugPrint("${stdFormat3.format(selectedFirst!)} ~ ${stdFormat3.format(selectedLast!)}");
      widget.onSelected(selectedFirst!, selectedLast!);
    });
  }

  void _setCalender(DateTime d) {
    rangeFirst = DateTime(d.year, d.month);
    rangeLast = DateTime(d.year, d.month+1)
        .subtract(const Duration(days: 1));

    if (rangeFirst.weekday != DateTime.sunday) {
      rangeFirst = rangeFirst
          .subtract(Duration(days: rangeFirst.weekday));
    }
    if (rangeLast.weekday == DateTime.sunday) {
      rangeLast = rangeLast.subtract(const Duration(days: 1));
    } else if (rangeLast.weekday != DateTime.saturday) {
      rangeLast = rangeLast
          .subtract(Duration(days: 7 - rangeLast.weekday));
    }

    title = "${d.month}월";
  }

  ///
  /// 0 : 노말 (선택 가능)
  /// 1 : 노말 (선택됨)
  /// 2 : 오늘 (선택 가능)
  /// 3 : 오늘 (선택 불가)
  /// 4 : 걍 선택 불가
  /// 5 : 다른 달 (선택 가능)
  ///
  int _dayType(DateTime d) {
    bool today = isSameDate(d, DateTime.now());

    if (selectedFirst != null
        && !selectedFirst!.isAfter(d)
        && !selectedLast!.isBefore(d)) {
      return 1;
    }

    if (d.weekday == DateTime.saturday
        || d.weekday == DateTime.sunday
        || d.isBefore(availableFirst)) {
      return today ? 3 : 4;
    }

    if (today) return 2;
    if (d.month != day.month) return 5;
    return 0;
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
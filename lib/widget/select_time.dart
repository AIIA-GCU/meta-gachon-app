///
/// 메타가천용 캘린더
/// -
///

// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:mata_gachon/config/variable.dart';

class CustomCalender extends StatefulWidget {
  const CustomCalender({
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
  final Function(String) onSelected;

  @override
  State<CustomCalender> createState() => _CustomCalenderState();
}
class _CustomCalenderState extends State<CustomCalender> {

  late String title;
  late DateTime rangeFirst;
  late DateTime rangeLast;

  DateTime? selectedDay;
  void toSelect(DateTime day) {
    if (day != selectedDay && cmp(day)) {
      widget.onSelected(std2_format.format(day));
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
    return SizedBox(
      width: 336 * ratio.width,
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
    this.start,
    this.end,
    required this.availableTimes,
    required this.setStart,
    required this.setEnd
  });

  final int? start;
  final int? end;
  final List<bool> availableTimes;
  final Function(int) setStart;
  final Function(int) setEnd;

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}
class _CustomTimePickerState extends State<CustomTimePicker> {
  late final LinkedScrollControllerGroup _scrollCtrGroup;
  late final ScrollController _scrollCtr1, _scrollCtr2;

  int? _start, _end;

  @override
  void initState() {
    super.initState();
    _scrollCtrGroup = LinkedScrollControllerGroup();
    _scrollCtr1 = _scrollCtrGroup.addAndGet();
    _scrollCtr2 = _scrollCtrGroup.addAndGet();
  }

  @override
  void didUpdateWidget(covariant CustomTimePicker oldWidget) {
    this._start = widget.start;
    this._end = widget.end;
    if (_start != null && _end != null) {
      _end = _end! - 1;
      debugPrint("start: $_start | end: ${_end!+1}");
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollCtr1.dispose();
    _scrollCtr2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ratio.width * 336,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 타이틀
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("예약 시간", style: KR.parag1),
              SizedBox(width: 12),
              Text(
                '예약은 최대 3시간까지 가능합니다',
                style: KR.label2.copyWith(color: MGcolor.brand_orig)
              )
            ],
          ),
          
          SizedBox(height: ratio.height * 10),
          
          /// 메인
          Column(
            children: [
              /// 터치 박스
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ratio.width * 2,
                  vertical: ratio.height * 4
                ),
                decoration: BoxDecoration(
                  color: MGcolor.base6,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: SingleChildScrollView(
                  controller: _scrollCtr1,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(26, (index) {
                      Color? color;
                      if (!widget.availableTimes[index]) {
                        color = MGcolor.brand_deep;
                      }
                      else if (_start != null && _end != null) {
                        if (_start! <= index && index <= _end!) {
                          color = MGcolor.brand_orig;
                        } else if (index == _start!+1) {
                          color = MGcolor.brand_orig.withOpacity(0.2);
                        } else if (index == _start!+2 && widget.availableTimes[index-1]) {
                          color = MGcolor.brand_orig.withOpacity(0.2);
                        }
                      }
                      if (color == null) {
                        color = Colors.white;
                      }

                      return GestureDetector(
                        onTap: color != MGcolor.brand_deep
                            ? () => _onTap(index) : null,
                        behavior: HitTestBehavior.translucent,
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
                    })
                  )
                ),
              ),

              /// 시간
              SingleChildScrollView(
                controller: _scrollCtr2,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ratio.width * 2),
                  child: Row(children: List.generate(5, (index) {
                    if (index != 4) {
                      return SizedBox(
                        width: (24 + 3*2) * 6,
                        child: Text('${index * 6}', style: EN.label1),
                      );
                    } else {
                      return SizedBox(
                        width: (24 + 3*2) * 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('24', style: EN.label1),
                            Text('2', style: EN.label1)
                          ]
                        )
                      );
                    }
                  })),
                )
              )
            ],
          )
        ]
      )
    );
  }

  void _onTap(int idx) {
    setState(() {
      if (_start == null || idx < _start! || _start!+2 < idx) {
        widget.setStart(_start = idx);
        widget.setEnd(_end = idx);
      } else if (_end! <= _start!+2) {
        if (idx == _end!) {
          widget.setStart(_start = idx);
        } else {
          widget.setEnd(_end = idx);
        }
      }
      debugPrint("start: $_start | end: ${_end!+1}");
    });
  }
}

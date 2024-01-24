///
/// 메타가천용 캘린더
/// -
///

// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return LayoutBuilder(builder: (context, constrains) =>
        SizedBox(
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


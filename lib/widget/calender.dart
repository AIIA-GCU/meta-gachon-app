///
/// 메타가천용 캘린더
/// -
///

// import 'dart:js_interop';

import 'package:flutter/material.dart';

import 'package:mata_gachon/config/variable.dart';

class CustomCalender extends StatefulWidget {
  const CustomCalender({
    super.key,
    required this.first,
    required this.last,
    required this.rowHeight,
    required this.rowWidth,
    required this.cellStyle
  }) ;

  final DateTime first;
  final DateTime last;
  final double rowHeight;
  final double rowWidth;
  final CellStyle cellStyle;

  @override
  State<CustomCalender> createState() => _CustomCalenderState();
}
class _CustomCalenderState extends State<CustomCalender> {

  late DateTime rangeFirst;
  late DateTime rangeLast;

  DateTime? selected;
  void toSelect(DateTime day) {
    if (day != selected && cmp(day))
      setState(() => selected = day);
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
    rangeFirst = DateTime(widget.first.year, widget.first.month, widget.first.day);
    rangeLast = DateTime(widget.last.year, widget.last.month, widget.last.day);

    while (rangeFirst.weekday != DateTime.sunday)
      rangeFirst = rangeFirst.subtract(Duration(days: 1));
    while (rangeLast.weekday != DateTime.saturday)
      rangeLast = rangeLast.add(Duration(days: 1));

    print(widget.first);
    print(widget.last);
    print(rangeFirst);
    print(rangeLast);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) =>
        SizedBox(
          width: (326+5+5)*ratio,
          height: (139)*ratio,
          child: Table(
            children: <TableRow>[
              TableRow(
                children: ['일', '월', '화', '수', '목', '금', '토']
                    .map((e) => Padding(
                      padding: EdgeInsets.only(bottom: 6*ratio),
                      child: Text(e, style: widget.cellStyle.fieldTextStyle, textAlign: TextAlign.center)
                    ))
                    .toList()
              ),
              TableRow(
                children: List.generate(7, (index) {
                  late TextStyle textStyle;
                  late BoxDecoration boxDecoration;
                  DateTime day = rangeFirst.add(Duration(days: index));

                  if (selected != null && isSameDate(selected!, day)) {
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
                      margin: EdgeInsets.only(left: 5*ratio,right: 5*ratio,bottom: 10*ratio),
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

                  if (selected != null && selected!.day == day.day) {
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
                      margin: EdgeInsets.only(left: 5*ratio,right: 5*ratio,bottom: 10*ratio),
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

                    if (selected != null && selected! == day) {
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
                        margin: EdgeInsets.only(left: 5*ratio,right: 5*ratio,bottom: 10*ratio),
                        decoration: boxDecoration,
                        child: Text(day.day.toString(), style: textStyle),
                      ),
                    );
                  }).toList()
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


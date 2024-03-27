import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/interface.dart';

import '../config/app/_export.dart';

class SelectingComputerWidget extends StatefulWidget {
  const SelectingComputerWidget(
      this.computers,
      {super.key, required this.onSelected});

  final List<String>? computers;
  final void Function(String com) onSelected;

  @override
  State<SelectingComputerWidget> createState() => _SelectingComputerWidgetState();
}

class _SelectingComputerWidgetState extends State<SelectingComputerWidget> {
  late final Stream<List<String>> _stream;

  late List<bool>? availables;
  late bool frontRoom;

  List<String>? computers;
  int? selected;

  @override
  void initState() {
    frontRoom = true;
    comReserveStreamListener = StreamController<List<String>>.broadcast();
    _stream = comReserveStreamListener.stream;
    _stream.listen(_listen);
    if (widget.computers != null) {
      var temp = widget.computers!
          .map((e) => int.parse(e.split('-')[1])).toList();
      availables = List.generate(19,
              (index) => !temp.contains(index + 1) ? false : true);
      print('available computers: $availables');
    } else {
      availables = null;
    }
    super.initState();
  }

  void _listen(List<String> event) {
    computers = event;
    selected = null;
    var temp = event.map((e) => int.parse(e.split('-')[1])).toList();
    availables = List.generate(19,
            (index) => !temp.contains(index + 1) ? false : true);
    print('available computers: $availables');
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    comReserveStreamListener.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        ratio.width *  16,
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
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(children: [
        // title line
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("GPU 선택", style: KR.parag2),

            const Spacer(flex: 11),

            Text(
              'GPU는 일주일간 사용 가능합니다.',
              style: KR.label2.copyWith(color: MGColor.brandPrimary),
            ),

            const Spacer(flex: 30),

            GestureDetector(
              onTap: availables == null || frontRoom
                  ? null
                  : () => setState(() => frontRoom = true),
              child: Icon(
                  MGIcon.back,
                  size: ratio.height * 24,
                color: availables == null || frontRoom
                    ? MGColor.base6 : MGColor.base1,
              )
            ),
            SizedBox(width: ratio.width * 16),
            GestureDetector(
                onTap: availables != null && frontRoom
                    ? () => setState(() => frontRoom = false)
                    : null,
                child: Transform.rotate(
                  angle: pi,
                  child: Icon(
                    MGIcon.back,
                    size: ratio.height * 24,
                    color: availables != null && frontRoom
                        ? MGColor.base1 : MGColor.base6,
                  ),
                )
            )
          ],
        ),

        SizedBox(height: ratio.height * 12),

        Container(
          height: 209,
          decoration: BoxDecoration(
            color: MGColor.base9,
            borderRadius: BorderRadius.circular(4)
          ),
          child: Stack(children: _itemsInStack())
        )
      ]),
    );
  }

  List<Widget> _itemsInStack() {
    List<Widget> result = [];

    // 날짜를 선택 안 했을 때
    if (availables != null) {
      result.add(
          Align(
              alignment: Alignment.center,
              child: Text(
                  frontRoom ? '403 전' : '403 후',
                  style: KR.parag1.copyWith(color: MGColor.base3)
              )
          )
      );

      if (frontRoom) {
        result.addAll([
          _computerBox(1, top: 4, left: 111),
          _computerBox(2, top: 4, left: 168),
          _computerBox(3, top: 4, left: 219),
          _computerBox(4, top: 4, left: 272),
          _computerBox(5, top: 45, left: 272),
          _computerBox(6, top: 86, left: 272),
          _computerBox(7, top: 127, left: 272),
          _computerBox(8, top: 168, left: 272),
          _computerBox(9, top: 168, left: 219),
          _computerBox(10, top: 168, left: 168),
          _computerBox(11, top: 168, left: 111),
          _computerBox(12, top: 168, left: 58),
          _computerBox(13, top: 168, left: 4)
        ]);
      } else {
        result.addAll([
          _computerBox(14, top: 168, left: 111),
          _computerBox(15, top: 168, left: 168),
          _computerBox(16, top: 168, left: 219),
          _computerBox(17, top: 168, left: 272),
          _computerBox(18, top: 127, left: 272),
          _computerBox(19, top: 86, left: 272),
        ]);
      }
    } else {
      result.add(
          Align(
              alignment: Alignment.center,
              child: Text(
                  "날짜를 먼저 선택해 주세요.",
                  style: KR.parag1.copyWith(color: MGColor.base3)
              )
          )
      );
    }

    return result;
  }

  Widget _computerBox(int number,
      {required double top, required double left}) {
    late Color boxColor, textColor;
    if (selected != null && selected == number) {
      boxColor = MGColor.brandPrimary;
      textColor = Colors.white;
    } else {
      textColor = MGColor.base1;
      if (availables![number - 1]) {
        boxColor = Colors.white;
      } else {
        boxColor = MGColor.base6;
      }
    }
    return Positioned(
        top: top,
        left: left * ratio.width,
        child: GestureDetector(
          onTap: availables![number-1]
          ? () {
            if (selected != number) {
              widget.onSelected(computers![number-1]);
              setState(() => selected = number);
            }
          }
          : null,
          child: Container(
            height: 37,
            width: ratio.width * 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(3)
            ),
            child: Text(
              "$number",
              style: EN.parag2.copyWith(color: textColor)
            ),
          ),
        )
    );
  }
}

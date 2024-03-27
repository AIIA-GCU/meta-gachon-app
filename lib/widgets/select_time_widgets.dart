import 'package:flutter/material.dart';

import '../config/app/_export.dart';
import '../config/server/_export.dart';
import '../widgets/button.dart';

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
  late bool _reset, _animating, _areaActive;
  late String _date;
  late String? _place;

  int? _begin, _end;

  @override
  void initState() {
    _reset = _animating = true;
    _areaActive = false;
    _date = widget.date;
    _place = widget.place;

    if (widget.begin != null && widget.end != null) {
      _begin = widget.begin;
      _end = (widget.end!+23) % 24;
      debugPrint("start: $_begin | end: ${_end!+1}");
    }
    WidgetsBinding.instance.addTimingsCallback((_) {
      if (_scrollCtr.hasClients && _animating) {
        debugPrint('the selected date is today!');
        _animating = false;
        if (_date == today) {
          _actScrollController(DateTime.now().hour);
        } else {
          _actScrollController(0);
        }
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTimePicker oldWidget) {
    if (_place != widget.place || _date != widget.date) {
      _reset = _animating = true;
      _areaActive = false;
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
                              if (_areaActive) _areaActive = false;
                            }
                            else if (_begin != null && _end != null) {
                              if (_begin! <= index && index <= _end!) {
                                color = MGColor.brandPrimary;
                                _areaActive = true;
                              } else {
                                if (widget.service == ServiceType.aiSpace) {
                                  if (index == _begin!+1) {
                                    color = MGColor.brandPrimary.withOpacity(0.2);
                                  } else if (index == _begin!+2 && _availables[index-1]) {
                                    color = MGColor.brandPrimary.withOpacity(0.2);
                                  }
                                } else if (_areaActive) {
                                  color = MGColor.brandPrimary.withOpacity(0.2);
                                }
                              }
                            }
                            color ??= Colors.white;

                            return GestureDetector(
                              onTap: color == MGColor.base6
                                  ? null : () => _onChangedTime(index),
                              child: Container(
                                  width: 20,
                                  height: 20,
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
                                        Text('21', style: EN.label3),
                                        Text('24', style: EN.label3),
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
                          availables: _availables,
                          onChanged: (value) {
                            var temp = value!.substring(0, 2);
                            _onChangedTime(int.parse(temp), isBegin: true);
                          },
                        ),
                        SizedBox(
                            width: 22 * ratio.width,
                            child: const Center(child: Text("~"))
                        ),
                        CustomDropdown(
                          value: _end == null ? null
                              : _end! < 9 ? '0${_end!+1}:00' : '${_end!+1}:00',
                          hint: '00:00',
                          items: times
                              .map((i) => i < 9 ? '0${i+1}:00' : '${i+1}:00')
                              .toList(),
                          availables: _availables,
                          onChanged: (value) {
                            var temp = value!.substring(0, 2);
                            _onChangedTime(int.parse(temp)-1, isBegin: false);
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
  void _onChangedTime(int idx, {bool? isBegin}) {
    setState(() {
      if (widget.service == ServiceType.aiSpace) {
        if (_begin == null
            || idx < _begin! || _begin! + 2 < idx
            || (_begin != 23 && !_availables[_begin! + 1])
            || (isBegin != null && isBegin)) {
          widget.setStart(_begin = idx);
          widget.setEnd(_end = idx);
        } else if (_end! <= _begin! + 2) {
          if (idx == _end!) {
            widget.setStart(_begin = idx);
          } else {
            widget.setEnd(_end = idx);
          }
        }
        _actScrollController(_begin!);
      } else if (widget.service == ServiceType.lectureRoom) {
        if (_begin == null
            || idx < _begin!
            || (_begin != 23 && !_availables[_begin! + 1])
            || (isBegin != null && isBegin)) {
          widget.setStart(_begin = idx);
          widget.setEnd(_end = idx);
        } else {
          if (idx == _end!) {
            widget.setStart(_begin = idx);
          } else {
            widget.setEnd(_end = idx);
          }
        }
        _areaActive = false;
        _actScrollController(_end!);
      }
    });
    debugPrint("start: $_begin | end: ${_end!+1}");
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

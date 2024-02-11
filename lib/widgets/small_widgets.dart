///
/// 타인 인증 리스트 위젯 (AnotherGuyWidget)
/// 내 인증 리스트 위젯(myReservationWidget)
/// 팝업 위젯 (popUpWidget)
/// 예약 취소 위젯 (CancelPopUp)
///

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:mata_gachon/config/server.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widgets/popup_widgets.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ratio.height * 100,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
          width: ratio.width * 40,
          height: ratio.width * 40,
          child: CircularProgressIndicator(color: MGcolor.base6)),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Container(
      width: screen.width,
      height: screen.height,
      color: Colors.black.withOpacity(0.25),
      alignment: Alignment.center,
      child: SizedBox(
          width: ratio.width * 48,
          height: ratio.width * 48,
          child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}
class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(children: [
        Icon(AppinIcon.not, color: MGcolor.base4, size: 24),
        // 읽지 않은 알림이 있을 때, 보이기
        FutureBuilder<bool?>(
          future: RestAPI.hasUnopendNotice(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return Positioned(
                  top: 1,
                  left: 1,
                  child: CircleAvatar(
                      radius: 4,
                      backgroundColor: MGcolor.base9,
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: MGcolor.systemError,
                      )
                  )
              );
            } else {
              return SizedBox.shrink();
            }
          }
        )
      ]),
    );
  }
}

class CustomListItem extends StatelessWidget {
  CustomListItem({
    required this.uid,
    required this.name,
    required this.stuNum,
    required this.room,
    required this.date,
    required this.time,
    required this.members,
    this.review,
    this.photo
  }) {
    isReservation = photo == null;
  }

  final int uid;
  final String name;
  final int stuNum;
  final String room;
  final String date;
  final String time;
  final String members;
  final String? review;
  final Uint8List? photo;

  late final bool isReservation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        int? status;
        if (isReservation) {
          status = await RestAPI.currentReservationStatus(reservationId: uid);
        }
        showCard(context, status);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(
            horizontal: ratio.width * 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          border: isReservation && date.contains(today)
              ? Border.all(color: MGcolor.primaryColor()) : null
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room, style: KR.subtitle1),
                SizedBox(height: ratio.height * 8),
                Text(date, style: KR.parag2.copyWith(color: MGcolor.base3)),
                Text(time, style: KR.parag2.copyWith(color: MGcolor.base3))
              ],
            ),
            if (isReservation)
              Transform.translate(
                offset: Offset(0, -(ratio.height * 21)),
                child: Transform.rotate(
                  angle: pi,
                  child: Icon(
                    AppinIcon.back,
                    size: 24,
                    color: MGcolor.base3,
                  ),
                ),
              )
            else
              Container(
                  width: ratio.height * 74,
                  height: ratio.height * 74,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(photo!),
                      fit: BoxFit.fill
                    )
                  )
              )
          ],
        ),
      ),
    );
  }

  void showCard(BuildContext ctx, int? status) => showDialog(
      context: ctx,
      builder: (context) {
        if (status != null) {
          return ReservationPopup(
            Reservate(uid, '$stuNum $name', room, date, time, members),
            status
          );
        } else {
          return AdmissionPopup(
              Admit(uid, '$stuNum $name', room, date, time, members, review!, photo!));
        }
      }
  );
}

class CustomContainer extends StatelessWidget {
  final EdgeInsets? margin;
  final Widget content;
  final List<Widget>? additionalContent;
  final String title;
  final double height;

  const CustomContainer({
    required this.title,
    required this.height,
    required this.content,
    this.additionalContent,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 12 * ratio.height),
      width: 358 * ratio.width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(children: [
        Positioned(
          left: 16 * ratio.width,
          top: 16,
          child: Text(title, style: KR.parag1),
        ),
        Positioned(
            left: 80 * ratio.width,
            top: 10,
            width: 262 * ratio.width,
            height: 32,
            child: content
        ),
        ...?additionalContent //추가 위젯들 들어가는 곳
      ]),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.hint,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}
class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        alignment: Alignment.center,
        hint: Text(widget.hint, style: EN.parag2.copyWith(color: MGcolor.base3)),
        items: _addDividersAfterItems(widget.items),
        value: _selectedItem,
        onChanged: (val) {
          widget.onChanged(val);
          setState(() => _selectedItem = val);
        },

        ///드롭버튼(선택된 항목) 디자인
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.all(0),
          height: 40,
          width: 120 * ratio.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(width: 1, color: MGcolor.primaryColor()),
          ),
        ),

        ///드롭아이콘 디자인
        iconStyleData: IconStyleData(iconSize: 0),

        ///메뉴창 디자인
        dropdownStyleData: DropdownStyleData(
            offset: Offset(0, -4),
            //위치조정
            padding: EdgeInsets.zero,
            maxHeight: 120,
            //최대크기
            elevation: 0,
            //그림자 없앰
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
                color: Colors.white.withOpacity(0.9) //배경투명도
            )
        ),

        ///메뉴들(선택지들) 디자인
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 4 * ratio.width),
          customHeights: _getCustomItemsHeights(widget.items),
        ),
      ),
    );
  }

  /// 드롭다운메뉴창에 아이템(선택지)을 넣어주는 메소드입니다.
  /// 리턴값은 아이템이 각각 위젯형태로 들어간 리스트입니다.
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> inItems) {
    final List<DropdownMenuItem<String>> menuItems = [];

    ///아이템 개수만큼 반복합니다.
    for (final String item in inItems) {
      menuItems.addAll(
        [
          ///위젯형태의 아이템(선택지) 넣기
          DropdownMenuItem<String>(
              value: item,
              child: Center(
                child: Text(
                    item,
                    textAlign: TextAlign.center,
                    style: EN.parag2.copyWith(
                        color: (item == _selectedItem)
                            ? Colors.black
                            : Color(0xFF7C7C7C)
                    )
                ),
              )),
          //If it's last item, we will not add Divider after it.
          ///아이템 하나마다 끝에 divider 넣기
          if (item != inItems.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(color: MGcolor.base5),
            ),
        ],
      );
    }
    return menuItems;
  }

  ///드롭다운메뉴창에 item(선택지)의 크기를 지정해주는 메소드입니다.
  List<double> _getCustomItemsHeights(List<String> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(24);
      } else {
        itemsHeights.add(1);
      }
    }
    return itemsHeights;
  }
}

class CustomTextField extends StatelessWidget {
  final bool enabled;
  final int width;
  final int height;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? format;

  const CustomTextField({
    required this.enabled,
    required this.width,
    required this.height,
    required this.controller,
    required this.hint,
    this.validator,
    this.format,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * ratio.width,
      height: height * ratio.height,
      child: TextFormField(
          enabled: enabled,
          validator: validator,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: KR.parag2,
          controller: controller,
          inputFormatters: format,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              hintText: hint,
              errorStyle: TextStyle(fontSize: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: MGcolor.primaryColor(), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: MGcolor.primaryColor(), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: MGcolor.primaryColor(), width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: MGcolor.base4, width: 1.2),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: MGcolor.systemError, width: 1)
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: MGcolor.systemError, width: 2)
              )
          )
      ),
    );
  }
}

class TileButtonCard extends StatelessWidget {
  const TileButtonCard({
    super.key,
    this.background,
    this.shape,
    this.margin,
    this.padding,
    required this.items
  });

  final Color? background;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final List<TileButton> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin != null ? margin!
          : EdgeInsets.symmetric(vertical: ratio.height * 8),
      child: Material(
        color: background != null ? background: Colors.white,
        shape: shape != null ? shape
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: padding != null ? padding!
              : EdgeInsets.symmetric(vertical: 8),
          child: Column(children: items),
        ),
      ),
    );
  }
}

class TileButton extends StatelessWidget {
  const TileButton({
    super.key,
    this.onTap,
    this.alignment,
    this.padding,
    this.borderRadius,
    required this.child
  });

  final VoidCallback? onTap;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        alignment: alignment,
        child: child,
      ),
    );
  }
}
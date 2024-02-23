import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomButtons {
  CustomButtons._();

  static Widget bottomButton(
      String text,
      Color background,
      VoidCallback onPressed,
      [Color? disableBackground]
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        disabledBackgroundColor: disableBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(ratio.width * 358, 48),
      ),
      child: Text(
        text,
        style: EN.subtitle2.copyWith(
          fontWeight: FontWeight.w700,
          color: MGColor.brand1Tertiary,
        ),
      ),
    );
  }

  static Widget largeButton(
      String text,
      Color background,
      VoidCallback onPressed,
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: background,
          fixedSize: Size(ratio.width * 302, 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))
      ),
      child: Text(text,
        style: EN.parag1.copyWith(color: Colors.white))
    );
  }

  static Widget bigButton(
      String text,
      Color background,
      Color textColor,
      VoidCallback onPressed
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: background,
          fixedSize: Size(ratio.width * 147, 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))
      ),
      child: Text(text, style: KR.parag2.copyWith(color: textColor)),
    );
  }

  static Widget mediumButton(
      String text,
      Color background,
      Color textColor,
      VoidCallback onPressed
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: background,
          fixedSize: Size(ratio.width * 147, 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))
      ),
      child: Text(text, style: KR.parag2.copyWith(color: textColor)),
    );
  }

  static Widget smallButton(
      String text,
      VoidCallback onPressed
      ) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        child: Ink(
          decoration: BoxDecoration(
            color: MGColor.primaryColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 16, vertical: 8),
          child: Center(child: Text(
            text,
            style: KR.label1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600
            ),
          )),
        ),
      ),
    );
  }

  static Widget miniButton(
      String text,
      VoidCallback onPressed
      ) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        child: Ink(
          width: ratio.width * 77,
          decoration: BoxDecoration(
            color: MGColor.primaryColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: ratio.width * 16, vertical: 8),
          child: Center(child: Text(
            text,
            style: KR.label1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600
            ),
          )),
        ),
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  final String? value;
  final String hint;
  final List<String> items;
  final void Function(String?) onChanged;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}
class _CustomDropdownState extends State<CustomDropdown> {
  late String? _selectedItem;

  @override
  void initState() {
    _selectedItem = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomDropdown oldWidget) {
    _selectedItem = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        alignment: Alignment.center,
        hint: Text(widget.hint, style: EN.parag2.copyWith(color: MGColor.base3)),
        items: _addDividersAfterItems(widget.items),
        value: _selectedItem,
        onChanged: (val) {
          widget.onChanged(val);
          setState(() => _selectedItem = val);
        },

        ///드롭버튼(선택된 항목) 디자인
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.all(0),
          height: 32,
          width: 120 * ratio.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: MGColor.primaryColor()),
          ),
        ),

        ///드롭아이콘 디자인
        iconStyleData: const IconStyleData(iconSize: 0),

        ///메뉴창 디자인
        dropdownStyleData: DropdownStyleData(
            offset: const Offset(0, -4),
            //위치조정
            padding: EdgeInsets.zero,
            maxHeight: 120,
            //최대크기
            elevation: 0,
            //그림자 없앰
            decoration: BoxDecoration(
                boxShadow: const [
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
                    style: EN.subtitle2.copyWith(
                        color: (item == _selectedItem)
                            ? Colors.black
                            : const Color(0xFF7C7C7C)
                    )
                ),
              )),
          //If it's last item, we will not add Divider after it.
          ///아이템 하나마다 끝에 divider 넣기
          if (item != inItems.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(color: MGColor.base5),
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
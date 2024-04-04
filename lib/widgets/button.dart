///
/// button.dart
/// 2024.03.09
/// by. @protaku
///
/// Change
/// - Added comments
///
/// Content
/// [*] Class
///   - CustomButtons
///   - CustomDropdown
///   - TileButton
///

import 'package:flutter/material.dart';
import 'package:mata_gachon/config/app/_export.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

///
/// CustomButtons
///
/// Collection of helper method about button.
/// They are classified by size.
///
class CustomButtons {
  CustomButtons._();

  ///
  /// Widget bottomButton
  ///
  /// Parameter:
  /// - [text] ([String]):
  ///   The title of button
  /// - [background] ([Color]):
  ///   Color of button
  /// - [onPressed] (void Function()):
  ///   The function running when tapping button
  /// - [disableBackground] ([Color]?):
  ///   The color when button don't enable to press
  ///
  /// Return:
  /// - Customized [ElevatedButton]
  ///
  static Widget bottomButton(
      String text,
      Color background,
      VoidCallback onPressed,
      {Color? disableBackground}
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: background,
        shadowColor: Colors.transparent,
        disabledBackgroundColor: disableBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(ratio.width * 358, 48),
      ),
      child: Text(
        text,
        style: EN.subtitle3.copyWith(
          fontWeight: FontWeight.w700,
          color: MGColor.brandTertiary,
        ),
      ),
    );
  }

  ///
  /// Widget largeButton
  ///
  /// Parameter:
  /// - [text] ([String]):
  ///   The title of button
  /// - [background] ([Color]):
  ///   Color of button
  /// - [onPressed] (void Function()):
  ///   The function running when tapping button
  ///
  /// Return:
  /// - Customized [ElevatedButton]
  ///
  static Widget largeButton(
      String text,
      Color background,
      VoidCallback onPressed,
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: background,
          fixedSize: Size(ratio.width * 302, 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))
      ),
      child: Text(text,
        style: EN.parag1.copyWith(color: Colors.white))
    );
  }

  ///
  /// Widget bigButton
  ///
  /// Parameter:
  /// - [text] ([String]):
  ///   The title of button
  /// - [background] ([Color]):
  ///   Color of button
  /// - [textColor] ([Color]):
  ///   Color of title
  /// - [onPressed] (void Function()):
  ///   The function running when tapping button
  ///
  /// Return:
  /// - Customized [ElevatedButton]
  ///
  static Widget bigButton(
      String text,
      Color background,
      Color textColor,
      VoidCallback onPressed
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: background,
          fixedSize: Size(ratio.width * 159, 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: KR.parag2.copyWith(color: textColor)),
    );
  }

  ///
  /// Widget mediumButton
  ///
  /// Parameter:
  /// - [text] ([String]):
  ///   The title of button
  /// - [background] ([Color]):
  ///   Color of button
  /// - [textColor] ([Color]):
  ///   Color of title
  /// - [onPressed] (void Function()):
  ///   The function running when tapping button
  ///
  /// Return:
  /// - Customized [ElevatedButton]
  ///
  static Widget mediumButton(
      String text,
      Color background,
      Color textColor,
      VoidCallback onPressed
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: background,
          shadowColor: Colors.transparent,
          fixedSize: Size(ratio.width * 147, 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))
      ),
      child: Text(text, style: KR.parag2.copyWith(color: textColor)),
    );
  }

  ///
  /// Widget smallButton
  ///
  /// Parameter:
  /// - [text] ([String]):
  ///   The title of button
  /// - [onPressed] (void Function()):
  ///   The function running when tapping button
  ///
  /// Return:
  /// - Customized Button made by [InkWell]
  ///
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
            color: MGColor.brandPrimary,
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

  ///
  /// Widget miiButton
  ///
  /// Parameter:
  /// - [text] ([String]):
  ///   The title of button
  /// - [onPressed] (void Function()):
  ///   The function running when tapping button
  ///
  /// Return:
  /// - Customized Button made by [InkWell]
  ///
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
            color: MGColor.brandPrimary,
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

///
/// CustomDropdown
///
/// Parameter:
/// - [value] ([String]?):
///   The current selected item of dropdown
/// - [hint] ([String]):
///   The text displayed when dropdown is closed or [value] is empty
/// - [items] ([List]<[String]>):
///   Data enable to select
/// - [onChanged] (void Function(String?)):
///   Callback when item is selected
///
class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    this.value,
    required this.hint,
    required this.items,
    this.availables,
    required this.onChanged,
  }) : super(key: key);

  final String? value;
  final String hint;
  final List<String> items;
  final List<bool>? availables;
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
          int idx = widget.items.indexOf(val!);
          if (widget.availables == null || widget.availables![idx]) {
            widget.onChanged(val);
            setState(() => _selectedItem = val);
          }
        },

        ///드롭버튼(선택된 항목) 디자인
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.all(0),
          height: 32,
          width: 120 * ratio.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: MGColor.brandPrimary),
          ),
        ),

        ///드롭아이콘 디자인
        iconStyleData: const IconStyleData(iconSize: 0),

        ///메뉴창 디자인
        dropdownStyleData: DropdownStyleData(
            offset: const Offset(0, -4),
            padding: EdgeInsets.zero,
            maxHeight: 110,
            elevation: 0,
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: 0,
              )
            ], color: Colors.white.withOpacity(0.9))),

        ///메뉴들(선택지들) 디자인
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 4 * ratio.width),
          customHeights: _getCustomItemsHeights(widget.items),
        ),
      ),
    );
  }

  ///
  /// [List]<[DropdownMenuItem]<[String]>> _addDividersAfterItems
  ///
  /// Convert raw data to exclusive widget
  /// 
  /// Parameter:
  /// - [inItems] ([List]<[String]>)
  ///
  /// Return:
  /// - [List] converted [DropdownMenuItem]
  /// 
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> inItems) {
    final List<DropdownMenuItem<String>> menuItems = [];

    ///아이템 개수만큼 반복합니다.
    for (int i=0 ; i < inItems.length ; i++) {
      late Color textColor;
      if (inItems[i] == _selectedItem) {
        textColor = Colors.black;
      } else if (widget.availables != null && !widget.availables![i]) {
        textColor = MGColor.base6;
      } else {
        textColor = MGColor.base3;
      }
      menuItems.addAll([
        DropdownMenuItem<String>(
            value: inItems[i],
            child: Center(
              child: Text(
                  inItems[i],
                  textAlign: TextAlign.center,
                  style: EN.subtitle2.copyWith(color: textColor)
              ),
            )
        ),
        const DropdownMenuItem<String>(
          enabled: false,
          child: Divider(color: MGColor.base5),
        ),
      ]);
    }
    menuItems.removeLast();
    return menuItems;
  }

  ///
  /// List<double> _getCustomItemsHeights
  ///
  /// Get sizes of dropdown items
  ///
  /// Paramete:
  /// - [items] ([List]<[String]>)
  ///
  /// Return:
  /// - [List] about size
  ///
  List<double>? _getCustomItemsHeights(List<String> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < items.length; i++) {
      itemsHeights.addAll([32, 1]);
    }
    itemsHeights.removeLast();
    return itemsHeights;
  }
}

///
/// TitleButton
///
/// Customized button of tile style
///
/// Parameter:
/// - [onTap] (void Function()):
///   Callback when tapping this widget
/// - [alignment] ([Alignment]?):
///   Align contents in this widget
/// - [padding] ([EdgeInsetsGeometry]):
///   Padding in this widget
/// - [BorderRadius] ([borderRadius]):
///   Set edge round
/// - [child] ([Widget]):
///   Content of widget
///
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
    // 물결 효과 추가
    return Ink(
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          padding: padding,
          // alignment: alignment,
          child: child,
        ),
      ),
    );
  }
}
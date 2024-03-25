import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app/_export.dart';

class LongTextField extends StatelessWidget {
  LongTextField({super.key,
    required this.hint,
    required this.error,
    required this.password,
    this.shownPassword,
    this.controller,
    this.onTapToShowPassword,
    required this.onChanged,
    required this.validator
  }) {
    assert(
    (password && shownPassword == null && onTapToShowPassword == null),
    "If this widget type is password input field, parameter \"showPassword\" can't be null"
    );
  }

  final String hint;
  final String? error;
  final bool password;
  final bool? shownPassword;
  final TextEditingController? controller;

  final void Function(bool)? onTapToShowPassword;
  final void Function(String?) onChanged;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: controller,
          obscureText: password ? shownPassword! : false,
          style: KR.subtitle1,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: ratio.width * 16,
                vertical: ratio.height * 12
            ),
            hintText: hint,
            hintStyle: KR.parag2.copyWith(color: MGColor.base5),
            errorText: error,
            errorStyle: const TextStyle(fontSize: 0),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: MGColor.base5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: MGColor.base5, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: MGColor.systemError)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: MGColor.systemError, width: 2)),
          ),
          onChanged: onChanged,
          validator: validator,
        ),

        if (password)
          Positioned(
            right: 0,
            child: GestureDetector(
              onTapDown: (tapDetails) => onTapToShowPassword!(true),
              onTapUp: (tapDetails) => onTapToShowPassword!(false),
              onTapCancel: () => onTapToShowPassword!(false),
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ratio.width * 12,
                    vertical: 14
                ),
                child: Icon(shownPassword!
                    ? MGIcon.eyeOn
                    : MGIcon.eyeOff,
                  color: MGColor.base4,
                  size: ratio.width * 20,
                ),
              ),
            ),
          )
      ],
    );
  }
}

class LargeTextField extends StatelessWidget {
  const LargeTextField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller
  });

  final String title;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ratio.width * 358,
      height: 150,
      margin: EdgeInsets.fromLTRB(
          ratio.width * 16,
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
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: KR.subtitle3.copyWith(color: Colors.black)),

          SizedBox(height: ratio.height * 10),

          Expanded(child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: ratio.width * 12,
                  vertical: ratio.height * 10
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MGColor.brandPrimary)
              ),
              alignment: Alignment.topLeft,
              child: TextField(
                controller: controller,
                maxLength: 70,
                textAlign: TextAlign.start,
                maxLines: 2,
                style: KR.parag2,
                decoration: InputDecoration(
                    hintText: hint,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintStyle: KR.parag2.copyWith(color: MGColor.base5)
                ),
              )
          ))
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final bool enabled;
  final double width;
  final double height;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? format;
  final TextInputType? keyboard;

  const CustomTextField({
    required this.enabled,
    required this.width,
    required this.height,
    required this.controller,
    required this.hint,
    this.validator,
    this.format,
    this.keyboard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
          enabled: enabled,
          validator: validator,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: KR.parag2,
          controller: controller,
          inputFormatters: format,
          keyboardType: keyboard,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              hintText: hint,
              errorStyle: const TextStyle(fontSize: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: MGColor.brandPrimary, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: MGColor.brandPrimary, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: MGColor.brandPrimary, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: MGColor.base4, width: 1.2),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: MGColor.systemError, width: 1)
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: MGColor.systemError, width: 2)
              )
          )
      ),
    );
  }
}


/// 여기 밑으로 있는 코드는
/// 아직 완벽하게 이해하지 못했음
class ProfesserFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final _TextEditingValueAccumulator formatState = _TextEditingValueAccumulator(newValue);
    assert(!formatState.debugFinalized);

    final pattern = RegExp('[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]');
    final Iterable<Match> matches = pattern.allMatches(newValue.text);
    Match? previousMatch;
    for (final Match match in matches) {
      assert(match.end >= match.start);
      _processRegion(true, previousMatch?.end ?? 0, match.start, formatState);
      assert(!formatState.debugFinalized);
      _processRegion(false, match.start, match.end, formatState);
      assert(!formatState.debugFinalized);

      previousMatch = match;
    }

    _processRegion(true, previousMatch?.end ?? 0, newValue.text.length, formatState);
    assert(!formatState.debugFinalized);
    var temp1 = formatState.finalize();

    if (temp1.selection.baseOffset == 0) return const TextEditingValue();

    var temp2 = newValue.text.split(' ')[0];
    return newValue.copyWith(
        text: '$temp2 교수님',
        selection: TextSelection.collapsed(offset: temp2.length)
    );
  }

  void _processRegion(bool isBannedRegion, int regionStart, int regionEnd, _TextEditingValueAccumulator state) {
    final String replacementString = isBannedRegion ? '' : state.inputValue.text.substring(regionStart, regionEnd);

    state.stringBuffer.write(replacementString);

    if (replacementString.length == regionEnd - regionStart) return;

    int adjustIndex(int originalIndex) {
      final int replacedLength = originalIndex <= regionStart && originalIndex < regionEnd ? 0 : replacementString.length;
      final int removedLength = originalIndex.clamp(regionStart, regionEnd) - regionStart;
      return replacedLength - removedLength;
    }

    state.selection?.base += adjustIndex(state.inputValue.selection.baseOffset);
    state.selection?.extent += adjustIndex(state.inputValue.selection.extentOffset);
    state.composingRegion?.base += adjustIndex(state.inputValue.composing.start);
    state.composingRegion?.extent += adjustIndex(state.inputValue.composing.end);
  }
}

class _MutableTextRange {
  _MutableTextRange(this.base, this.extent);

  int base;
  int extent;

  static _MutableTextRange? fromComposingRange(TextRange range) {
    return range.isValid && !range.isCollapsed
        ? _MutableTextRange(range.start, range.end)
        : null;
  }

  static _MutableTextRange? fromTextSelection(TextSelection selection) {
    return selection.isValid
        ? _MutableTextRange(selection.baseOffset, selection.extentOffset)
        : null;
  }
}

// The intermediate state of a [FilteringTextInputFormatter] when it's
// formatting a new user input.
class _TextEditingValueAccumulator {
  _TextEditingValueAccumulator(this.inputValue)
      : selection = _MutableTextRange.fromTextSelection(inputValue.selection),
        composingRegion = _MutableTextRange.fromComposingRange(inputValue.composing);

  final TextEditingValue inputValue;
  final StringBuffer stringBuffer = StringBuffer();
  final _MutableTextRange? selection;
  final _MutableTextRange? composingRegion;

  bool debugFinalized = false;

  TextEditingValue finalize() {
    debugFinalized = true;
    final _MutableTextRange? selection = this.selection;
    final _MutableTextRange? composingRegion = this.composingRegion;
    return TextEditingValue(
      text: stringBuffer.toString(),
      composing: composingRegion == null || composingRegion.base == composingRegion.extent
          ? TextRange.empty
          : TextRange(start: composingRegion.base, end: composingRegion.extent),
      selection: selection == null
          ? const TextSelection.collapsed(offset: -1)
          : TextSelection(
        baseOffset: selection.base,
        extentOffset: selection.extent,
        affinity: inputValue.selection.affinity,
        isDirectional: inputValue.selection.isDirectional,
      ),
    );
  }
}
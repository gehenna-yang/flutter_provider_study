import 'package:flutter/material.dart';
import 'package:infrearnclass/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocusText;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    required this.onChanged,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocusText = false,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(color: INPUT_BORDER_COLOR, width: 1,)
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText, // 비밀번호
      autofocus: autofocusText,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(color: PRIMARY_COLOR),
        ),
      ),
    );
  }
}
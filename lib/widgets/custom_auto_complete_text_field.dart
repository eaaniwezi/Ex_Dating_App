import 'package:dating_app/data/data.dart';
import 'package:dating_app/resourses/colors.dart';
import 'package:flutter/material.dart';

import 'AutoCompeleteTxtField.dart';

class CustomAutoCompleteTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int maxLines;
  final int minLines;
  final double rightPadding;
  final void Function(String) onSubmited;

  CustomAutoCompleteTextField({this.hintText, this.controller, this.maxLines, this.minLines, this.rightPadding, this.onSubmited});

  @override
  Widget build(BuildContext context) {
    return AutoCompeleteTextField(
      suggestions: Lists.tagsSuggestions,
      controller: controller,
      collapsed: false,
      onTextSubmited: onSubmited,
      style: TextStyle(
        color: AppColors.lightBlack,
        fontSize: 16,
        height: 1.48,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.light,
        contentPadding: EdgeInsets.only(left: 20, right: rightPadding ?? 20, top: 20, bottom: 20),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.light,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.light,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.light,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.light,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
    );
  }
}

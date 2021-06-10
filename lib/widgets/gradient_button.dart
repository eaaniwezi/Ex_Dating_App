import 'package:dating_app/resourses/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  final bool isMargin;
  final double height;

  GradientButton({this.text, this.onTap, this.isMargin, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isMargin == null || isMargin == true ? EdgeInsets.symmetric(horizontal: 5, vertical: 30) : EdgeInsets.zero,
        alignment: Alignment.center,
        width: context.mediaQuerySize.width,
        height: height ?? 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: LinearGradient(
            colors: [
              AppColors.orange,
              AppColors.mistake,
            ],
            stops: [0.2165, 0.6295],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}

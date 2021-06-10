import 'package:dating_app/resourses/colors.dart';
import 'package:dating_app/screens/home_screen/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LastComment extends StatelessWidget {
  final String comment;
  final String downText;

  LastComment({
    this.comment,
    this.downText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 33, bottom: 20),
      width: context.mediaQuerySize.width > 500 ? context.mediaQuerySize.width / 2 - 15 : context.mediaQuerySize.width,
      height: 199,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/images/comments_union.svg'),
          Text(
            comment,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Gothic',
              color: AppColors.black,
              fontSize: 18,
              height: 1.36,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(FullFeedback(null /*TODO*/
                  ));
            },
            child: Row(
              children: [
                Text(
                  downText,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gothic',
                    color: AppColors.orange,
                    fontSize: 16,
                    height: 1.36,
                  ),
                ),
                SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SvgPicture.asset(
                    'assets/images/arrow_right.svg',
                    width: 27,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

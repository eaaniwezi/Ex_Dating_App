import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'gradient_button.dart';

class DialogYesOrNot extends StatelessWidget {
//

  DialogYesOrNot({
    @required this.title,
    @required this.yesTap,
  });

  final VoidCallback yesTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 40,
              child: GradientButton(
                text: 'yes'.tr,
                isMargin: false,
                onTap: yesTap,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width / 3,
              child: GradientButton(
                text: 'no'.tr,
                isMargin: false,
                onTap: () => Get.back(),
              ),
            )
          ],
        )
      ],
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF000000),
        ),
      ),
    );
  }

//
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'snackbar_error'.tr,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          height: 1,
        ),
      ),
    );
  }
}

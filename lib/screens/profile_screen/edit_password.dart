import 'dart:convert';

import 'package:dating_app/services/networking_service.dart';
import 'package:dating_app/services/snackbar_service.dart';
import 'package:dating_app/widgets/bordered_container.dart';
import 'package:dating_app/widgets/custom_textfield.dart';
import 'package:dating_app/widgets/custom_widgets.dart';
import 'package:dating_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dating_app/resourses/colors.dart';

class EditPassword extends StatefulWidget {
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
//

  bool loading = false;
  final TextEditingController oldController = TextEditingController(), newController = TextEditingController(), repeatController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.light,
      appBar: AppBar(
        leading: IconButton(
          highlightColor: Colors.white,
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
            'assets/images/appbar_arrow_left.svg',
            height: 20,
            width: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Change password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.lightBronze,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (_) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(
                shrinkWrap: true,
                children: [
                  BorderedContainer(
                    children: [
                      CustomTextField(
                        hintText: 'Old',
                        isFull: true,
                        controller: oldController,
                      ),
                      SizedBox(height: 15),
                      context.width > 500
                          ? Row(
                              children: [
                                CustomTextField(
                                  hintText: 'New',
                                  isFull: false,
                                  controller: newController,
                                ),
                                SizedBox(width: 10),
                                CustomTextField(
                                  hintText: 'Repeat',
                                  isFull: false,
                                  controller: repeatController,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                CustomTextField(
                                  hintText: 'New',
                                  isFull: true,
                                  controller: newController,
                                ),
                                SizedBox(height: 15),
                                CustomTextField(
                                  hintText: 'Repeat',
                                  isFull: true,
                                  controller: repeatController,
                                ),
                              ],
                            ),
                      SizedBox(height: 15),
                      OrangeButton(
                        text: 'Change',
                        onTap: changeButtonTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (loading) Loading(),
        ],
      ),
    );
  }

  bool validateStructure(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  changeButtonTap() async {
    setState(() {
      loading = true;
    });
    if (validateStructure(newController.text) && newController.text?.trim() == repeatController.text?.trim()) {
      try {
        final x = await NetworkingService.changePassword(
          oldPassword: oldController.text?.trim(),
          newPassword: newController.text?.trim(),
        );
        if (json.decode(x.body)['status'] == true) {
          SnackBarService.showMessage(context, 'password_changed_successfully'.tr, _scaffoldKey, Colors.green);
        } else if (json.decode(x.body)['status'] == false && (json.decode(x.body)['error']['messages']['email'][0]?.length ?? 0) > 0) {
          SnackBarService.showMessage(context, json.decode(x.body)['error']['messages']['email'][0], _scaffoldKey, Colors.red);
        } else
          throw Exception('Can\'t change password');
      } catch (_) {
        SnackBarService.showMessage(context, 'error_change_password'.tr, _scaffoldKey, Colors.red);
      }
    } else if (!validateStructure(newController.text)) {
      SnackBarService.showMessage(context, 'snackbar_sign_up_password_error'.tr, _scaffoldKey, Colors.red);
    } else if (newController.text?.trim() != repeatController.text?.trim()) {
      SnackBarService.showMessage(context, 'password_didnt_match'.tr, _scaffoldKey, Colors.red);
    }
    setState(() {
      loading = false;
    });
  }
}

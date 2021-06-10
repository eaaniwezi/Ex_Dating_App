import 'dart:convert';

import 'package:dating_app/screens/profile_screen/edit_language.dart';
import 'package:dating_app/screens/auth_screen/login_page.dart';
import 'package:dating_app/services/networking_service.dart';
import 'package:dating_app/services/snackbar_service.dart';
import 'package:dating_app/widgets/bordered_container.dart';
import 'package:dating_app/widgets/dialog_yes_or_not.dart';
import 'package:dating_app/widgets/icon_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:dating_app/services/hive_helper.dart';
import 'edit_notifications.dart';
import 'edit_password.dart';
import 'edit_social_networks.dart';
import 'support.dart';
import 'package:dating_app/resourses/colors.dart';
import 'package:dating_app/widgets/loading.dart';

class EditProfile extends StatefulWidget {
  //
  @override
  State<StatefulWidget> createState() => _EditProfileState();
  //
}

class _EditProfileState extends State<EditProfile> {
  //
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.light,
      appBar: AppBar(
        leading: IconButton(
          highlightColor: Colors.transparent,
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
          'Edit profile',
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BorderedContainer(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      children: [
                        IconWithText(
                          icon: 'assets/images/profile_personal.svg',
                          text: 'Personal information',
                          paddingBottom: 40,
                          onTap: () {
                            Get.toNamed('/personalInformation');
                          },
                        ),
                        IconWithText(
                          icon: 'assets/images/profile_social.svg',
                          text: 'Social networks',
                          paddingBottom: 40,
                          onTap: () {
                            Get.to(
                              EditSocialNetworks(),
                            );
                          },
                        ),
                        IconWithText(
                          icon: 'assets/images/profile_password.svg',
                          text: 'Change password',
                          paddingBottom: 40,
                          onTap: () {
                            Get.to(
                              EditPassword(),
                            );
                          },
                        ),
                        IconWithText(
                          icon: 'assets/images/profile_notification.svg',
                          text: 'Notifications',
                          paddingBottom: 40,
                          onTap: () {
                            Get.to(
                              EditNotifications(),
                            );
                          },
                        ),
                        IconWithText(
                          icon: 'assets/images/profile_language.svg',
                          text: 'Language',
                          paddingBottom: 50,
                          onTap: () {
                            Get.to(EditLanguage());
                          },
                        ),
                        IconWithText(
                          icon: 'assets/images/profile_support.svg',
                          text: 'Support',
                          paddingBottom: 36,
                          onTap: () {
                            Get.to(
                              Support(),
                            );
                          },
                        ),
                        IconWithText(
                          icon: 'assets/images/profile_delete_account.svg',
                          text: 'Delete account',
                          paddingBottom: 36,
                          orangeText: true,
                          onTap: sureDelete,
                        ),
                        IconWithText(
                          icon: 'assets/images/profile_logout.svg',
                          text: 'Log out',
                          paddingBottom: 0,
                          orangeText: true,
                          onTap: sureLogOut,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_loading) Loading(),
        ],
      ),
    );
  }

  void deleteAccount() async {
    Get.back();
    setState(() => _loading = true);
    final response = await NetworkingService.deleteUser();
    if (json.decode(response.body)['status'] == true) {
      await HiveHelper.deleteRefreshToken();
      setState(() => _loading = false);
      Get.offAll(LoginPage());
    } else {
      SnackBarService.showMessage(context, 'cant_delete_account'.tr, scaffoldKey);
    }
  }

  sureLogOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return DialogYesOrNot(
          title: 'sure_to_logout'.tr,
          yesTap: logOut,
        );
      },
    );
  }

  void logOut() async {
    await HiveHelper.deleteRefreshToken();
    Get.offAll(LoginPage());
  }

  void sureDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return DialogYesOrNot(
          title: 'sure_to_delete'.tr,
          yesTap: deleteAccount,
        );
      },
    );
  }

//
}

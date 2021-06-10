import 'dart:convert';

import 'package:dating_app/data/data.dart';
import 'package:dating_app/data/user_repository.dart';
import 'package:dating_app/models/user.dart';
import 'package:dating_app/screens/home_screen/all_feedbacks.dart';
import 'package:dating_app/screens/home_screen/followers.dart';
import 'package:dating_app/screens/messages/message.dart';
import 'package:dating_app/screens/profile_screen/my_profile_page.dart';
import 'package:dating_app/screens/profile_screen/support.dart';
import 'package:dating_app/services/app_endpoints.dart';
import 'package:dating_app/services/networking_service.dart';
import 'package:dating_app/states.dart';
import 'package:dating_app/widgets/bordered_container.dart';
import 'package:dating_app/widgets/error_show.dart';
import 'package:dating_app/widgets/feedback_mini.dart';
import 'package:dating_app/widgets/grey_button.dart';
import 'package:dating_app/widgets/loading.dart';
import 'package:dating_app/widgets/social_network_widgets.dart';
import 'package:dating_app/widgets/subscribe_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/resourses/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
//

  final int id;

  const Profile({
    @required this.id,
  });

  @override
  _ProfileState createState() => _ProfileState();


//
}

class _ProfileState extends State<Profile> {
//
  User user;
  bool error = false;
  bool loading = true;

  @override
  void initState() {
    start();
    super.initState();
  }

  start() async {
    try {
      print('_ProfileState user id: ${widget.id}');
      final response = await NetworkingService.getUser(id: widget.id);
      final _json = json.decode(response.body);
      if (_json['status'] == true)
        user = User.fromJson(_json['data']);
      else
        throw Exception('Profile getUser by id error');
    } catch (_) {
      error = true;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBronze,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/appbar_arrow_left.svg', height: 20, width: 20),
        ),
        centerTitle: false,
        titleSpacing: -5,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'previous_page_title'.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showProfileBottomSheet();
                },
                child: Container(
                  width: 30,
                  height: 30,
                  color: Colors.transparent,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/more_horizontal.svg',
                      width: 5,
                      height: 5,
                      color: AppColors.orange,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.lightBronze,
      ),
      body: error
          ? ErrorShow()
          : loading
              ? Loading(
                  color: Colors.transparent,
                )
              : Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.only(top: 7),
                          children: [
                            BorderedContainer(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: user.avatar_url == null
                                              ? AssetImage(
                                                  Lists.profilePhotoEmpty,
                                                )
                                              : NetworkingService.getImage(AppEndpoints.imageUrl + user.avatar_url),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.login != null ? '${user.login}' : '',
                                          style: TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        Text(
                                          (user.first_name != null || user.last_name != null) ? '${user.first_name ?? ''} ${user.last_name ?? ''}' : 'Unknown',
                                          style: TextStyle(
                                            color: AppColors.lightBlack,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        Text(
                                          user.created_at != null ? 'Joined in ${DateFormat.yMMMMd('locale'.tr).format(DateTime.parse(user.created_at))}' : '',
                                          style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        SubscribeButton(),
                                        SizedBox(height: 10),
                                        GrayButton(
                                          text: 'message'.tr,
                                          onTap: () {
                                            Get.to(Messages(
                                              name: Lists.listTopUsersName[0],
                                              avatar: Lists.listTopUsers[0],
                                              isOnline: true,
                                            ));
                                          },
                                        ),
                                        context.isTablet ? ProfileInformation(user) : Container()
                                      ],
                                    ),
                                  ],
                                ),
                                context.isTablet ? Container() : ProfileInformation(user),
                              ],
                            ),
                            BorderedContainer(
                              children: [
                                Row(
                                  mainAxisAlignment: context.mediaQuerySize.width > 500 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileMetrics(count: user.feedbacks_count, metric: 'feedbacks'.tr),
                                    ProfileMetrics(count: user.comments_count, metric: 'comments'.tr),
                                    InkWell(
                                        onTap: () {
                                          Get.to(Followers());
                                        },
                                        child: ProfileMetrics(count: user.my_subscribers_count, metric: 'followers'.tr)),
                                    ProfileMetrics(count: user.subscribers_count, metric: 'following'.tr),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            if ((user.feedbacks?.length ?? 0) > 0)
                              Column(
                                children: List.generate(
                                  user.feedbacks.length,
                                  (i) {
                                    return Column(
                                      children: [
                                        //TODO
                                        FeedbackMini(null),
                                        SizedBox(height: 10),
                                      ],
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void showProfileBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text('write'.tr),
              isDestructiveAction: false,
              onPressed: () {
                Get.back();
                //TODO
                Get.to(Messages(
                  name: Lists.listTopUsersName[0],
                  avatar: Lists.listTopUsers[0],
                  isOnline: true,
                ));
              },
            ),
            CupertinoActionSheetAction(
              child: Text('subscribe'.tr),
              isDestructiveAction: false,
              onPressed: () {
                print('Action 1 printed');
              },
            ),
            CupertinoActionSheetAction(
              child: Text('complain'.tr),
              isDestructiveAction: false,
              onPressed: () {
                Get.back();
                Get.to(Support());
              },
            ),
            CupertinoActionSheetAction(
              child: Text('block'.tr),
              isDestructiveAction: true,
              onPressed: () {
                print('Action 1 printed');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('cancel'.tr),
            isDestructiveAction: false,
            onPressed: () {
              Get.back();
            },
          ),
        );
      },
    );
  }
}

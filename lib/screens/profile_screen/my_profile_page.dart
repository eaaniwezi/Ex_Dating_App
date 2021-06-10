import 'dart:convert';
import 'package:dating_app/data/data.dart';
import 'package:dating_app/data/user_repository.dart';
import 'package:dating_app/models/user.dart';
import 'package:dating_app/services/app_endpoints.dart';
import 'package:dating_app/services/networking_service.dart';
import 'package:dating_app/widgets/bordered_container.dart';
import 'package:dating_app/widgets/error_show.dart';
import 'package:dating_app/widgets/feedback_mini.dart';
import 'package:dating_app/widgets/grey_button.dart';
import 'package:dating_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dating_app/resourses/colors.dart';
import 'package:dating_app/widgets/my_behavior.dart';
import 'package:intl/intl.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User user;
  bool loading = true;
  bool error = false;
  @override
  void initState() {
    super.initState();
/*    box.put('isYoutube', true);
    box.put('isFacebook', true);
    box.put('isTwitter', true);
    box.put('isInstagram', true);*/

    start();
  }

  void start() async {
    try {
      if (UserRepository.user == null) {
        final response = await NetworkingService.getUser();
        UserRepository.user = User.fromJson(json.decode(response.body)['data']);
      }
      user = UserRepository.user;

      if (mounted)
        setState(() {
          loading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          error = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 0),
        child: error
            ? ErrorShow()
            : loading
                ? Center(
                    child: Loading(
                    color: Colors.transparent,
                  ))
                : Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanDown: (_) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: ListView(
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
                                              user.login ?? '',
                                              style: TextStyle(
                                                color: AppColors.orange,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Text(
                                              (user.first_name ?? '') + (user.last_name ?? ''),
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
                                            GrayButton(
                                              text: 'Edit profile',
                                              onTap: editProfile,
                                            ),
                                            context.mediaQuerySize.width > 500 ? ProfileInformation(user) : Container()
                                          ],
                                        ),
                                      ],
                                    ),
                                    context.mediaQuerySize.width > 500 ? SizedBox() : ProfileInformation(user),
                                  ],
                                ),
                                BorderedContainer(
                                  children: [
                                    Row(
                                      mainAxisAlignment: context.mediaQuerySize.width > 500 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
                                      children: [
                                        ProfileMetrics(count: 0, metric: 'Feedbacks'),
                                        ProfileMetrics(count: 0, metric: 'Comments'),
                                        ProfileMetrics(
                                          count: user.my_subscribers_count ?? 0,
                                          metric: 'Followers',
                                          onTap: () {
                                            Get.toNamed('/followers');
                                          },
                                        ),
                                        ProfileMetrics(count: user.subscribers_count ?? 0, metric: 'Following'),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Column(
                                  children: List.generate(
                                    2,
                                    (i) {
                                      return Column(
                                        children: [
                                          FeedbackMini(null //TODO: feedback in profile
                                              ),
                                          SizedBox(height: 10),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  void editProfile() {
    Get.toNamed('/editProfile').then((_) => start());
  }
}

class ProfileInformation extends StatefulWidget {
  ProfileInformation(this.user);
  final User user;
  @override
  _ProfileInformationState createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        if (widget.user.country_iso_code != null || widget.user.city_iso_code != null)
          Row(
            children: [
              SvgPicture.asset('assets/images/pin.svg'),
              SizedBox(width: 6),
              Text(
                '${widget.user.country_iso_code != null ? (widget.user.country_iso_code + ', ') : ''}${widget.user.city_iso_code}',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        if (widget.user.about_me != null)
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              widget.user.about_me,
              style: TextStyle(
                color: AppColors.lightBlack,
                fontSize: 24,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
          ),
        if (widget.user.public_email != null) ...[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            width: 282,
            child: Divider(
              color: AppColors.lightGrey,
              thickness: 1,
            ),
          ),
          Text(
            widget.user.public_email ?? '',
            style: TextStyle(
              color: AppColors.lightBlack,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (false) ...[
            SizedBox(height: 10),
            Row(
              children: [
                /* box.get('isYoutube') != null && box.get('isYoutube') == true
                ? Row(
                    children: [
                      YoutubeWidget(),
                      SizedBox(width: 13),
                    ],
                  )
                : Container(),
            box.get('isFacebook') != null && box.get('isFacebook') == true
                ? Row(
                    children: [
                      FacebookWidget(),
                      SizedBox(width: 13),
                    ],
                  )
                : Container(),
            box.get('isTwitter') != null && box.get('isTwitter') == true
                ? Row(
                    children: [
                      TwitterWidget(),
                      SizedBox(width: 13),
                    ],
                  )
                : Container(),
            box.get('isInstagram') != null && box.get('isInstagram') == true ? InstagramWidget() : Container(),*/
              ],
            ),
          ]
        ]
      ],
    );
  }
}

class ProfileMetrics extends StatelessWidget {
  final int count;
  final String metric;
  final GestureTapCallback onTap;

  ProfileMetrics({this.count, this.metric, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: AppColors.lightBlack,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            metric,
            style: TextStyle(
              color: AppColors.lightBlack,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:dating_app/data/user_repository.dart';
import 'package:dating_app/models/user.dart';
import 'package:dating_app/services/networking_service.dart';
import 'package:dating_app/widgets/error_show.dart';
import 'package:dating_app/widgets/loading.dart';
import 'package:dating_app/widgets/my_behavior.dart';
import 'package:dating_app/widgets/page_title.dart';
import 'package:dating_app/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/resourses/colors.dart';
import 'package:get/get.dart';

class TopUsers extends StatefulWidget {
  @override
  _TopUsersState createState() => _TopUsersState();
}

class _TopUsersState extends State<TopUsers> {
  List<User> users;
  bool error = false;
  bool loading = true;
  List<int> subscriptions;

  @override
  void initState() {
    start();
    super.initState();
  }

  start() async {
    try {
      final getCountries = await NetworkingService.getTopUsers();
      subscriptions = await UserRepository.subscriptions();
      final _json = json.decode(getCountries.body);
      if (_json['status'] == true) {
        final data = _json['data'];
        users = User.fromJsonList(data);
        setState(() {
          loading = false;
        });
      } else
        throw Exception('');
    } catch (_) {
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
        color: AppColors.lightBronze,
        height: context.height,
        width: context.width,
        child: error
            ? ErrorShow()
            : loading
                ? Loading(
                    color: Colors.transparent,
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageTitle('Top Users'),
                        SizedBox(height: 20),
                        Expanded(
                          child: /*context.mediaQuerySize.width < 500
                    ?*/
                              ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: ListView.separated(
                              itemBuilder: (context, i) {
                                return UserCard(
                                  subscriptions: subscriptions,
                                  number: i + 1,
                                  user: users[i],
                                );
                              },
                              separatorBuilder: (context, i) {
                                return SizedBox(height: 10);
                              },
                              itemCount: users.length,
                            ),
                          )
                          /*  : SingleChildScrollView(
                        child: Wrap(
                            spacing: 10,
                            children: List.generate(5, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: UserCard(
                                    avatar: Lists.listTopUsers[i],
                                    number: i + 1,
                                    name: Lists.listTopUsersName[i],
                                    feedbacksCount:
                                        Lists.listTopUsersFeedbacksCount[i]),
                              );
                            })),
                      )*/
                          ,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

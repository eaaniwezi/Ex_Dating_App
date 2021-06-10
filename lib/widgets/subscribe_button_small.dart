import 'dart:convert';

import 'package:dating_app/models/user.dart';
import 'package:dating_app/resourses/colors.dart';
import 'package:dating_app/services/networking_service.dart';
import 'package:dating_app/widgets/text_gradient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeButtonSmall extends StatefulWidget {
//

  final User user;
  final bool isSubscribed;

  SubscribeButtonSmall({
    @required this.user,
    @required this.isSubscribed,
  });

  @override
  _SubscribeButtonSmallState createState() => _SubscribeButtonSmallState();

//
}

class _SubscribeButtonSmallState extends State<SubscribeButtonSmall> {
//
  bool loading = false;
  bool _isSubscribed;
  @override
  initState() {
    _isSubscribed = widget.isSubscribed;
    super.initState();
  }

  onButtonTap() async {
    setState(() {
      loading = true;
    });
    try {
      var response;
      if (_isSubscribed)
        response = await NetworkingService.unsubscribeID(widget.user.id);
      else
        response = await NetworkingService.subscribeID(widget.user.id);
      final _json = json.decode(response.body);
      if (_json['status'] == true) {
        _isSubscribed = !_isSubscribed;
      } else
        throw Exception('Failed to fetch subscriptions');
    } catch (_) {}
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (!loading) onButtonTap();
        },
        color: Colors.transparent,
        highlightColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: Container(
          width: context.mediaQuerySize.width < 500 ? context.mediaQuerySize.width * 0.52 : context.mediaQuerySize.width / 3.65,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: LinearGradient(
              colors: !_isSubscribed
                  ? [
                      AppColors.orange,
                      AppColors.mistake,
                    ]
                  : [
                      AppColors.lightBronze,
                      AppColors.lightBronze,
                    ],
              stops: [0, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _isSubscribed
                  ? Center(
                      child: TextGradient(
                        text: 'Unsubscribe',
                      ),
                    )
                  : Center(
                      child: Text(
                        '+ Subscribe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

//
}

import 'package:flutter/material.dart';

import 'user_feedback.dart';

class User {
//

  final int id;
  final String city_iso_code;
  final String country_iso_code;
  final String last_name;
  final String first_name;
  final String public_email;
  final String login;
  final String about_me; //"2021-01-30T08:22:59.000000Z"
  final String avatar_url;
  final String created_at;
  final String phone_verified_at;
  final String email_verified_at;

  ///
  ///
  ///
  int notifications_count;
  var notifications;
  final int subscribers_count;
  final int my_subscribers_count;
  final int feedbacks_count;
  final int comments_count;
  final List<UserFeedback> feedbacks;

  User({
    @required this.id,
    @required this.city_iso_code,
    @required this.country_iso_code,
    @required this.last_name,
    @required this.first_name,
    @required this.public_email,
    @required this.login,
    @required this.about_me,
    @required this.avatar_url,
    @required this.created_at,
    @required this.phone_verified_at,
    @required this.email_verified_at,
    @required this.subscribers_count,
    @required this.my_subscribers_count,
    @required this.feedbacks,
    @required this.feedbacks_count,
    @required this.comments_count,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return new User(
      id: map['id'] as int,
      city_iso_code: map['city_iso_code'],
      country_iso_code: map['country_iso_code'],
      last_name: map['last_name'] ?? '',
      first_name: map['first_name'] ?? '',
      public_email: map['public_email'],
      login: map['login'],
      about_me: map['about_me'],
      avatar_url: map['avatar_url'],
      created_at: map['created_at'],
      phone_verified_at: map['phone_verified_at'],
      subscribers_count: map['subscribers_count'] ?? 0,
      my_subscribers_count: map['my_subscribers_count'] ?? 0,
      feedbacks: /*map['feedbacks']*/ null,
      email_verified_at: map['email_verified_at'] ?? '',
      feedbacks_count: map['feedbacks_count'] ?? 0,
      comments_count: map['comments_count'] ?? 0,
    );
  }

  static List<User> fromJsonList(items) {
    List<User> result = [];
    for (var item in items) {
      result.add(User.fromJson(item));
    }
    return result;
  }

//
}

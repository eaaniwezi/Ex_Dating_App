import 'package:flutter/material.dart';

import 'user.dart';

class Subscription {
  final int id, user_id, sub_user_id;
  final String created_at, updated_at;
  final User user;

  const Subscription({
    @required this.id,
    @required this.user_id,
    @required this.sub_user_id,
    @required this.created_at,
    @required this.updated_at,
    @required this.user,
  });

  factory Subscription.fromJson(Map<String, dynamic> map) {
    return new Subscription(
      id: map['id'],
      user_id: map['user_id'],
      sub_user_id: map['sub_user_id'],
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
      user: User.fromJson(
        map['user'],
      ),
    );
  }

  static List<Subscription> fromJsonList(items) {
    List<Subscription> result = [];
    for (var item in items) {
      result.add(Subscription.fromJson(item));
    }
    return result;
  }

//
}

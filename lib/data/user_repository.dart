import 'dart:convert';

import 'package:dating_app/models/user.dart';
import 'package:dating_app/models/subscription.dart';
import 'package:dating_app/services/networking_service.dart';

class UserRepository {
  static User user;

  static Future<List<int>> subscriptions() async {
    try {
      final response = await NetworkingService.mySubscriptions();

      final _json = json.decode(response.body);
      if (_json['status'] == true) {
        final List<Subscription> list = Subscription.fromJsonList(_json['data']);

        final List<int> listInt = [];
        list.forEach(
          (element) => listInt.add(element.user_id),
        );
        return listInt;
      } else
        throw Exception('Failed to fetch subscriptions');
    } catch (_) {
      return [];
    }
  }

  static Future<List<int>> subscribers() async {
    return [];
  }
}

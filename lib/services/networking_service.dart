import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:dating_app/models/user_registration.dart';
import 'package:dating_app/models/user_login.dart';
import 'app_endpoints.dart';
import 'authentication_interceptor.dart';
import 'headers_interceptor.dart';
import 'hive_helper.dart';
import 'logging_interceptor.dart';

class NetworkingService {
  //
  NetworkingService._();

  static http.Client httpClient = HttpClientWithInterceptor.build(interceptors: [
    HeadersInterceptor(),
    AuthenticationInterceptor(),
    LoggingInterceptor() /* It must be last */,
  ]);

  static Future<http.Response> auth(UserLogin data) async {
    try {
      http.Response response = await httpClient.post(
        Uri.parse(AppEndpoints.auth),
        body: json.encode(data.toJson()),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> registration(UserRegistration data) async {
    try {
      http.Response registration = await httpClient.post(
        Uri.parse(AppEndpoints.registration),
        body: json.encode(data.toJson()),
      );
      return registration;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> verification(Map<String, String> data) async {
    try {
      http.Response registration = await httpClient.get(
        Uri.parse(AppEndpoints.verification + '?enterField=${data['enterField']}&has=${data['has']}'),
      );
      return registration;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> showUsers() async {
    try {
      http.Response users = await httpClient.get(
        Uri.parse(AppEndpoints.users),
      );
      return users;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> refresh(String token) async {
    try {
      http.Response response = await httpClient.post(
        Uri.parse(AppEndpoints.refresh),
        body: json.encode({'refreshToken': token}),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> allFeedbacks() async {
    try {
      http.Response response = await httpClient.get(
        Uri.parse(AppEndpoints.allFeedbacks),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> startResetPassword(String enterField) async {
    try {
      String body = json.encode({'enterField': enterField});

      http.Response response = await httpClient.post(
        Uri.parse(AppEndpoints.resetPassword),
        body: body,
      );
      /*status: true*/
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> mySubscribers() async {
    try {
      http.Response response = await httpClient.post(
        Uri.parse(AppEndpoints.mySubscribers),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> endResetPassword(String enterField, String code, String password) async {
    try {
      String body = json.encode({
        'enterField': enterField,
        'code': code,
        'password': password,
      });

      http.Response response = await httpClient.post(
        Uri.parse(AppEndpoints.resetPassword),
        body: body,
      );
      /*status: true*/
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> changePassword({
    @required String oldPassword,
    @required String newPassword,
  }) async {
    try {
      String body = json.encode({
        'password': oldPassword,
        'newPassword': newPassword,
      });

      http.Response response = await httpClient.post(
        Uri.parse(AppEndpoints.changePassword),
        body: body,
      );
      /*status: true*/
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> deleteUser() async {
    try {
      http.Response response = await httpClient.delete(
        Uri.parse(AppEndpoints.user),
      );
      /*status: true*/
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> getUser({int id}) async {
    try {
      http.Response response;
      if (id == null)
        response = await httpClient.get(
          Uri.parse(AppEndpoints.user),
        );
      else
        response = await httpClient.get(
          Uri.parse(AppEndpoints.userById(id)),
        );
      /*status: true*/
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> updateUserData(String body) async {
    try {
      http.Response response = await httpClient.put(
        Uri.parse(AppEndpoints.user),
        body: body,
      );
      /*status: true*/
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<void> addAvatar(Uint8List bytes) async {
    try {
      Map<String, String> headers = {
        "Accept": "application/json",
      }; // ignore this headers if there is no authentication

      final String token = HiveHelper.token;
      if (token != null) {
        // data.headers['Authorization'] = 'Bearer ${token}';
        headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }

      // string to uri
      var uri = Uri.parse(AppEndpoints.addAvatar);

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFileSign = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'avatar.jpeg',
      );

      // add file to multipart
      request.files.add(multipartFileSign);

      //add headers
      request.headers.addAll(headers);

      //adding params
      request.fields['type'] = 'avatar';
      // request.fields['lastName'] = 'efg';

      // send
      var response = await request.send();

      print('addAvatar statusCode: ${response.statusCode}');

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print('addAvatar response.stream  $value');
      });
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> getCountries() async {
    try {
      http.Response response = await httpClient.get(
        Uri.parse(AppEndpoints.country + '?size=999'),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> mySubscriptions() async {
    try {
      http.Response response = await httpClient.get(
        Uri.parse(
          AppEndpoints.mySubscriptions + '?size=999',
        ),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> subscribeID(int id) async {
    try {
      http.Response response = await httpClient.get(
        Uri.parse(AppEndpoints.subscribeID(id)),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> unsubscribeID(int id) async {
    try {
      http.Response response = await httpClient.get(
        Uri.parse(AppEndpoints.unsubscribeID(id)),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static Future<http.Response> getTopUsers() async {
    try {
      http.Response response = await httpClient.get(
        Uri.parse(AppEndpoints.topUsers + '?size=100'),
      );
      return response;
    } on SocketException {
      throw Exception("No Internet connection");
    } on HttpException {
      throw Exception("Couldn't find info");
    } on FormatException {
      throw Exception("Bad response format");
    }
  }

  static NetworkImage getImage(String url) {
    try {
      final String token = HiveHelper.token;
      Map<String, String> map;
      if (token != null) {
        // data.headers['Authorization'] = 'Bearer ${token}';
        map = {
          'Authorization': 'Bearer $token',
        };
      }
      return NetworkImage(url, headers: map);
    } catch (_) {}
  }

  //
}

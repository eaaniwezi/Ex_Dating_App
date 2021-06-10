import 'user.dart';
import 'package:flutter/material.dart';

class AllFeedback {
  final int id;
  final int userId;
  final String cityIsoCode;
  final String countryIsoCode;
  final String name;
  final String description;
  final String hashtag;
  final String preview;
  final String title;
  final String socialJson;
  final String language;
  final String createdAt;
  final String updatedAt;
  final int commentsCount;
  final int likesCount;
  final List<dynamic> images;
  final User user;

  /* "id": 1,
              "city_iso_code": "RU-YAR",
              "country_iso_code": "RU",
              "user_id": 1,
              "name": null,
              "description": "asdsadasdasdasdasd",
              "hashtag": null,
              "preview": "222",
              "title": "nnn",
              "social_json": null,
              "language": null,
              "created_at": "2021-01-30T08:32:37.000000Z",
              "updated_at": "2021-01-30T08:33:18.000000Z"*/

  factory AllFeedback.fromJson(Map<String, dynamic> json) {
    return AllFeedback(
      id: json['id'],
      userId: json['userId'],
      cityIsoCode: json['cityIsoCode'],
      countryIsoCode: json['countryIsoCode'],
      name: json['name'],
      description: json['description'],
      hashtag: json['hashtag'],
      preview: json['preview'],
      title: json['title'],
      socialJson: json['socialJson'],
      language: json['language'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      commentsCount: json['commentsCount'],
      likesCount: json['likesCount'],
      images: json['images'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  static List<AllFeedback> fromJsonList(items) {
    List<AllFeedback> result = [];
    for (var item in items) {
      print('item: $item');
      result.add(AllFeedback.fromJson(item));
    }
    return result;
  }

  AllFeedback({
    @required this.id,
    @required this.userId,
    @required this.cityIsoCode,
    @required this.countryIsoCode,
    @required this.name,
    @required this.description,
    @required this.hashtag,
    @required this.preview,
    @required this.title,
    @required this.socialJson,
    @required this.language,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.commentsCount,
    @required this.likesCount,
    @required this.images,
    @required this.user,
  });

  AllFeedback copyWith({
    int id,
    int userId,
    String cityIsoCode,
    String countryIsoCode,
    String name,
    String description,
    String hashtag,
    String preview,
    String title,
    String socialJson,
    String language,
    String createdAt,
    String updatedAt,
    int commentsCount,
    int likesCount,
    List<dynamic> images,
    User user,
  }) {
    if ((id == null || identical(id, this.id)) &&
        (userId == null || identical(userId, this.userId)) &&
        (cityIsoCode == null || identical(cityIsoCode, this.cityIsoCode)) &&
        (countryIsoCode == null || identical(countryIsoCode, this.countryIsoCode)) &&
        (name == null || identical(name, this.name)) &&
        (description == null || identical(description, this.description)) &&
        (hashtag == null || identical(hashtag, this.hashtag)) &&
        (preview == null || identical(preview, this.preview)) &&
        (title == null || identical(title, this.title)) &&
        (socialJson == null || identical(socialJson, this.socialJson)) &&
        (language == null || identical(language, this.language)) &&
        (createdAt == null || identical(createdAt, this.createdAt)) &&
        (updatedAt == null || identical(updatedAt, this.updatedAt)) &&
        (commentsCount == null || identical(commentsCount, this.commentsCount)) &&
        (likesCount == null || identical(likesCount, this.likesCount)) &&
        (images == null || identical(images, this.images)) &&
        (user == null || identical(user, this.user))) {
      return this;
    }

    return new AllFeedback(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cityIsoCode: cityIsoCode ?? this.cityIsoCode,
      countryIsoCode: countryIsoCode ?? this.countryIsoCode,
      name: name ?? this.name,
      description: description ?? this.description,
      hashtag: hashtag ?? this.hashtag,
      preview: preview ?? this.preview,
      title: title ?? this.title,
      socialJson: socialJson ?? this.socialJson,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
      images: images ?? this.images,
      user: user ?? this.user,
    );
  }
}

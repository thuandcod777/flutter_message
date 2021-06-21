import 'package:flutter/material.dart';

class User {
  String get id => _id;
  String username;
  String photoUrl;
  String _id;
  bool active;
  DateTime lastseen;

  User({
    @required String username,
    @required String photoUrl,
    @required bool active,
    @required DateTime lastseen,
  });

  toJson() => {
        'username': username,
        'photo_url': photoUrl,
        'active': active,
        'lastseen': lastseen,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      username: json['username'],
      photoUrl: json['photo_url'],
      active: json['active'],
      lastseen: json['lastseen'],
    );

    user._id = json['id'];

    return user;
  }
}

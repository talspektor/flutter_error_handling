import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class FakeHttpClient {
  Future<String> getResponseBody() async {
    await Future.delayed(const Duration(milliseconds: 500));
    //! No Internet Connection
    // throw SocketException('No Internet');
    //! 404
    // throw HttpException('404');
    // ! Invalid JSON (throws FormatException)
    // return 'abcd';
    return '{"userId":1,"id":1,"title":"nice title","body":"cool body"}';
  }
}

class PostService {
  final httpClient = FakeHttpClient();
  Future<Post> getOnePost() async {
    // The WORST type of error handling.
    // There's no way to get these error messages to the UI.
    try {
      final responseBody = await httpClient.getResponseBody();
      return Post.fromJson(responseBody);
    } on SocketException {
      throw Failure(message: 'No Internet connection ');
    } on HttpException {
      throw Failure(message: "Couldn't find the post");
    } on FormatException {
      throw Failure(message: 'Bad response format');
    }
  }
}

class Failure {
  final String message;

  Failure({required this.message});

  @override
  String toString() => message;
}

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      body: map['body'],
    );
  }

  static Post fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post id: $id, userId: $userId, title: $title, body: $body';
  }
}

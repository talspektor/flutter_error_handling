import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_error_handling/post_service.dart';

enum NotifierState { initial, loading, loaded }

class PostChangeNotifier extends ChangeNotifier {
  final _postService = PostService();

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  late Either<Failure, Post> _post;
  Either<Failure, Post> get post => _post;
  _setPost(Either<Failure, Post> post) {
    _post = post;
    notifyListeners();
  }

  getOnePost() async {
    _setState(NotifierState.loading);
    await Task(() => _postService.getOnePost())
        .attempt()
        .map(
          (either) => either.leftMap((ojb) {
            try {
              return ojb as Failure;
            } catch (e) {
              throw ojb;
            }
          }),
        )
        .run()
        .then((value) => _setPost(value));
    _setState(NotifierState.loaded);
  }
}

extension Taskext<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return map(
      (either) => either.leftMap((ojb) {
        try {
          return ojb as Failure;
        } catch (e) {
          throw ojb;
        }
      }),
    );
  }
}

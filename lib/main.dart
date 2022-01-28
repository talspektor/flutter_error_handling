import 'package:flutter/material.dart';
import 'package:flutter_error_handling/post_change_notifier.dart';
import 'package:provider/provider.dart';

import 'post_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: ChangeNotifierProvider(
        create: (_) => PostChangeNotifier(),
        child: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final postService = PostService();
  Future<Post>? postFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Consumer<PostChangeNotifier>(
              builder: (_, notifier, __) {
                if (notifier.state == NotifierState.initial) {
                  return const StyledText('Press the button 👇');
                } else if (notifier.state == NotifierState.loading) {
                  return const CircularProgressIndicator();
                } else {
                  return notifier.post.fold(
                    (failure) => StyledText(failure.toString()),
                    (post) => StyledText(post.toString()),
                  );
                }
              },
            ),
            TextButton(
              child: const Text('Get Post'),
              onPressed: () async {
                context.read<PostChangeNotifier>().getOnePost();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StyledText extends StatelessWidget {
  const StyledText(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 40),
    );
  }
}

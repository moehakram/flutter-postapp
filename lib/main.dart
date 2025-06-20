import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/post_cubit.dart';
import 'resource/remote_resource.dart';
import 'screen/post_list_screen.dart';

void main() {
  runApp(
    BlocProvider(create: (_) => PostCubit(RemoteResource()), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostListScreen(),
    );
  }
}

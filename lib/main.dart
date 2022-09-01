import 'package:flutter/material.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/views/first_time.view.dart';
import 'package:mam_pray/views/home.view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(FutureBuilder(
    future: AppModel.load(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }

      return Provider(
        create: (context) => (snapshot.data as AppModel),
        builder: (context, child) {
          return const MyApp();
        },
      );
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppModel>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      home:
          (model.firstname.isEmpty ? const FirstTimeView() : const HomeView()),
    );
  }
}

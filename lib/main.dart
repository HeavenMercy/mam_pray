import 'package:flutter/material.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/views/first_time.view.dart';
import 'package:mam_pray/views/home.view.dart';
import 'package:provider/provider.dart';

void main() {
  var model = AppModel.empty();

  runApp(ChangeNotifierProvider(
    create: (context) => model,
    builder: (context, child) {
      return MyApp(model: model);
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.model}) : super(key: key);

  final AppModel? model;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loading = true;

  @override
  void initState() {
    super.initState();

    if (widget.model != null) {
      widget.model!.load().then((_) => setState(() => loading = false));
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      home: (widget.model?.hasFirstName() ?? false
          ? const HomeView()
          : const FirstTimeView()),
    );
  }
}

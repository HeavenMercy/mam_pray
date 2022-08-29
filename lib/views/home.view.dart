import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppModel>(context);

    return PageContainer(
      child: Column(
        children: [
          const Text(
            'Bienvenue dans votre espace de prière',
            style: Styles.mainText,
          ),
          Text(
            model.firstname,
            style: Styles.subText,
          ),
        ],
      ),
    );
  }
}

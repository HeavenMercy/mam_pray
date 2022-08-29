import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/custom_button.widget.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppModel>(context);

    return PageContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'hello ${model.firstname},',
            textAlign: TextAlign.left,
            style: Styles.mainText,
          ),
          Utils.addFixedSpace(10),
          const Text(
            'What do you want to read today',
            textAlign: TextAlign.left,
            style: Styles.subText,
          ),
          Utils.addFlexibleSpace(),
          CustomButton(text: 'My Biblical Passages', onPressed: () {}),
          CustomButton(text: 'Add a ', onPressed: () {}),
          CustomButton(text: 'My Biblical Passages', onPressed: () {}),
          Utils.addFlexibleSpace(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/views/categories.view.dart';
import 'package:mam_pray/widgets/custom_button.widget.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:mam_pray/widgets/basic_passage.widget.dart';
import 'package:mam_pray/widgets/top_passages.widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppModel>(context);

    var topPassages = model.getTopPassages();
    var passages = model.getPassages();

    return PageContainer(
      setPadding: false,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Styles.secColor,
              boxShadow: [
                BoxShadow(color: Styles.mainColor, offset: Offset(0, 5)),
                BoxShadow(color: Styles.bgColor, offset: Offset(0, 3.5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.addFlexibleSpace(),
                Text(
                  'Welcome ${model.firstname},',
                  style: Styles.mainText
                      .copyWith(fontSize: 40, color: Styles.bgColor),
                ),
                Text(
                  Utils.getRandomsInvite(),
                  style: Styles.subText.copyWith(
                    fontSize: 18,
                    color: Styles.bgColor,
                  ),
                ),
                Utils.addFlexibleSpace(),
                Row(
                  children: [
                    Utils.addFlexibleSpace(),
                    CustomButton(
                      margin: 10,
                      padding: 10,
                      icon: Icons.settings,
                      text: 'Manage Categories',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CategoriesView(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Utils.addFixedSpace(10),
                  if (topPassages.isNotEmpty)
                    TopPassages(passages: topPassages),
                  ...passages.map((passage) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: BasicPassage(passage: passage),
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

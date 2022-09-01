import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:mam_pray/widgets/top_passages.widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppModel>(context);
    var topPassages = <Passage>[
      Passage(
          book: 'book',
          chapter: 10,
          verseStart: 1,
          verseEnd: 5,
          categories: [1, 2, 8]),
      Passage(
          book: 'Epitre Selon St Paul',
          chapter: 10,
          verseStart: 1,
          verseEnd: 5,
          categories: [1, 2, 8]),
      Passage(
          book: 'book',
          chapter: 10,
          verseStart: 1,
          verseEnd: 5,
          categories: [1, 2, 8]),
    ];

    return PageContainer(
      setPadding: false,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Styles.secColor,
              boxShadow: [
                BoxShadow(color: Styles.mainColor, offset: Offset(0, 5)),
                BoxShadow(color: Styles.bgColor, offset: Offset(0, 2)),
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
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(primary: Styles.bgColor),
                      icon: const Icon(
                        Icons.settings,
                        color: Styles.secColor,
                        size: 18,
                      ),
                      label: Text(
                        'Manage Categories',
                        style: Styles.mainText.copyWith(
                          fontSize: 15,
                          color: Styles.mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Utils.addFlexibleSpace(),
              ],
            ),
          ),
          Utils.addFixedSpace(10),
          if (topPassages.isNotEmpty) TopPassages(passages: topPassages),
        ],
      ),
    );
  }
}

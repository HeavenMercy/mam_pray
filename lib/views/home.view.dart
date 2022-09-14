import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/views/categories.view.dart';
import 'package:mam_pray/views/passage.view.dart';
import 'package:mam_pray/widgets/custom_button.widget.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:mam_pray/widgets/basic_passage.widget.dart';
import 'package:mam_pray/widgets/page_header.widget.dart';
import 'package:mam_pray/widgets/top_passages.widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<AppModel>();

    var topPassages = model.getTopPassages();
    var passages = model.getPassages();

    return PageContainer(
      child: Column(
        children: [
          Pageheader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.addFixedSpace(10),
                Text(
                  'Welcome ${model.firstname},',
                  style: Styles.mainText
                      .copyWith(fontSize: 35, color: Styles.bgColor),
                ),
                Utils.addFixedSpace(5),
                Text(
                  Utils.getRandomsInvite(),
                  style: Styles.subText.copyWith(
                    fontSize: 15,
                    color: Styles.bgColor,
                  ),
                ),
                Utils.addFixedSpace(10),
                Row(
                  children: [
                    Utils.addFlexibleSpace(),
                    CustomButton(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
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
              child: (passages.isNotEmpty
                  ? ListView(
                      children: [
                        Utils.addFixedSpace(10),
                        if (topPassages.isNotEmpty)
                          TopPassages(
                              passages: topPassages, onTap: onPassageTap),
                        ...passages.map((passage) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: BasicPassage(
                                passage: passage, onTap: onPassageTap),
                          );
                        }),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cancel,
                          color: Styles.secColor,
                        ),
                        Utils.addFixedSpace(10),
                        const Text(
                          'No passage created yet',
                          style: Styles.mainText,
                        )
                      ],
                    )),
            ),
          ),
          Row(
            children: [
              Utils.addFlexibleSpace(),
              CustomButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategoriesView(
                    forSelecion: true,
                    passage: AppModel.getEmptyPassage(),
                  ),
                )),
                icon: Icons.note_add,
                text: 'New Passage',
              ),
            ],
          )
        ],
      ),
    );
  }

  void onPassageTap(BuildContext context, Passage passage) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PassageView(passage: passage),
    ));
  }
}

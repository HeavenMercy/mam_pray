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

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const categoryAll = 'All';

  var welcomteText = Utils.getRandomsInvite();
  var selectedCategory = -1;

  @override
  Widget build(BuildContext context) {
    var model = context.watch<AppModel>();

    var topPassages = model.getTopPassages();
    var passages = model.getPassages().where((passage) =>
        ((selectedCategory == -1) ||
            passage.categories.contains(selectedCategory)));

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
                  welcomteText,
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
                        buildCategoryFilter(context),
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
                          Icons.note,
                          color: Styles.secColor,
                          size: 40,
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

  DropdownMenuItem<int> buildDropdownItem(int value, String text) {
    // var color = (selectedCategory == value ? Styles.secColor : Styles.bgColor);
    return DropdownMenuItem(
      value: value,
      child: Text(
        text,
        style: Styles.mainText.copyWith(
          color: Styles.bgColor,
          fontWeight:
              (selectedCategory == value ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  Widget buildCategoryFilter(BuildContext context) {
    var categories = context
        .read<AppModel>()
        .getActiveCategories(sortByName: true)
        .map((e) => buildDropdownItem(e.id, e.name));

    return Container(
      width: 200,
      height: 50,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(
        horizontal: 80,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Styles.secColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<int>(
        icon: const Icon(Icons.filter_alt_sharp, size: 20),
        isExpanded: true,
        items: [buildDropdownItem(-1, categoryAll), ...categories],
        value: selectedCategory,
        onChanged: (int? value) => setState(() => selectedCategory = value!),
      ),
    );
  }

  void onPassageTap(BuildContext context, Passage passage) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PassageView(passage: passage),
    ));
    context.read<AppModel>().viewPassage(passage);
  }
}

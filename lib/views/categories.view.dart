import 'package:flutter/material.dart';
import 'package:mam_pray/config/enums.config.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/category_view.widget.dart';
import 'package:mam_pray/widgets/custom_button.widget.dart';
import 'package:mam_pray/widgets/custom_textinput.widget.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:mam_pray/widgets/page_header.widget.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key, this.forSelecion = false, this.passage})
      : super(key: key);

  final bool forSelecion;
  final Passage? passage;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  var categoryFiltar = '';
  var selectedCategories = <int>[];

  @override
  Widget build(BuildContext context) {
    var model = context.watch<AppModel>();
    var result = model.findCategories(categoryFiltar);
    result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return PageContainer(
      child: Column(
        children: [
          Pageheader(
            child: Column(
              children: [
                Utils.addFixedSpace(10),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: Styles.mainText
                                .copyWith(fontSize: 30, color: Styles.bgColor),
                          ),
                          Utils.addFixedSpace(5),
                          Text(
                            'You can add, rename, delete categories',
                            style: Styles.subText
                                .copyWith(fontSize: 15, color: Styles.bgColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Utils.addFixedSpace(5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextInput(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'search...',
                          canClear: true,
                          onChanged: (value) {
                            setState(() {
                              categoryFiltar = value;
                            });
                          },
                        ),
                      ),
                    ),
                    if (result.isEmpty)
                      CustomButton(
                        padding: 10,
                        margin: 0,
                        icon: Icons.add,
                        text: 'Add',
                        onPressed: () {
                          model.addCategory(categoryFiltar);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          Utils.addFixedSpace(15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CategoryView(
                      onTap: (selected) {
                        var id = result[index].id;
                        if (selected) {
                          selectedCategories.add(id);
                        } else {
                          selectedCategories.remove(id);
                        }
                      },
                      categoryId: result[index].id,
                      state: (widget.forSelecion
                          ? CategoryViewState.select
                          : CategoryViewState.view),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

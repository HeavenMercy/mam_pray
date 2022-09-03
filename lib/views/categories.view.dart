import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/widgets/custom_button.widget.dart';
import 'package:mam_pray/widgets/custom_textinput.widget.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key, this.forSelecion = false}) : super(key: key);

  final bool forSelecion;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  var categoryName = '';
  List<Category> result = [];

  @override
  Widget build(BuildContext context) {
    var model = context.watch<AppModel>();

    return PageContainer(
      child: Column(
        children: [
          Card(
            child: Row(
              children: [
                CustomTextInput(
                  hintText: 'Category',
                  onChanged: ((value) {
                    categoryName = value;
                  }),
                ),
                if (result.isEmpty)
                  CustomButton(
                    icon: Icons.add,
                    text: 'Add',
                    onPressed: () {
                      model.addCategory(categoryName);
                    },
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

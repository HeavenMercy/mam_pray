import 'package:flutter/material.dart';
import 'package:mam_pray/config/enums.config.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/models/category.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/custom_textinput.widget.dart';
import 'package:provider/provider.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({
    Key? key,
    required this.categoryId,
    required this.state,
    required this.onTap,
  }) : super(key: key);

  final int categoryId;
  final CategoryViewState state;
  final void Function(bool selected) onTap;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  var state = CategoryViewState.none;
  var name = '';
  var selected = false;

  @override
  Widget build(BuildContext context) {
    var category = context.read<AppModel>().getCategory(widget.categoryId);

    if (state == CategoryViewState.none) state = widget.state;

    Widget view = Container();
    if (state == CategoryViewState.view) {
      view = buildForView(context, category);
    } else if (state == CategoryViewState.edit) {
      view = buildForEdit(context, category);
    } else if (state == CategoryViewState.select) {
      view = buildForSelect(context, category);
    }

    return Card(
      color: selected ? Styles.mainColor : Styles.secColor,
      shadowColor: selected ? Styles.mainColor : Styles.secColor,
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: view,
      ),
    );
  }

  Widget buildForView(BuildContext context, PassageCategory category) {
    var model = Provider.of<AppModel>(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15.0),
            child: Text(
              category.name,
              style: Styles.mainText.copyWith(
                color: Styles.bgColor,
                fontSize: 18,
              ),
            ),
          ),
        ),
        if (category.editable)
          IconButton(
            onPressed: () => setState(() {
              state = CategoryViewState.edit;
            }),
            icon: const Icon(
              Icons.edit,
              color: Styles.mainColor,
            ),
          ),
        if (category.editable)
          IconButton(
            onPressed: () => Utils.showSnackBar(
              context,
              msg: 'You will delete the category and its passages',
              action: SnackBarAction(
                label: 'CONFIRM',
                onPressed: () => model.deleteCategory(category.id),
              ),
            ),
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget buildForEdit(BuildContext context, PassageCategory category) {
    var model = Provider.of<AppModel>(context);

    return Row(
      children: [
        Expanded(
          child: CustomTextInput(
            padding: const EdgeInsets.all(10),
            initialText: category.name,
            hintText: 'Category Name',
            onChanged: (name) => this.name = name,
          ),
        ),
        IconButton(
          onPressed: () {
            if (name.isEmpty) return;
            state = CategoryViewState.none;
            model.updateCategoryName(category.id, name);
          },
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: () => setState(() {
            state = CategoryViewState.none;
          }),
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget buildForSelect(BuildContext context, PassageCategory category) {
    return GestureDetector(
      onTap: () => setState(() {
        selected = !selected;
        widget.onTap(selected);
      }),
      child: Row(
        children: [
          Expanded(child: Text(category.name)),
          Icon(selected ? Icons.close : Icons.check),
        ],
      ),
    );
  }
}

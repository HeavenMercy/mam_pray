import 'package:flutter/material.dart';
import 'package:mam_pray/config/enums.config.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/models/category.model.dart';
import 'package:mam_pray/widgets/custom_textinput.widget.dart';
import 'package:provider/provider.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key, required this.categoryId, required this.state})
      : super(key: key);

  final int categoryId;
  final CategoryViewState state;

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
      view = Card(child: buildForView(context, category));
    } else if (state == CategoryViewState.edit) {
      view = Card(child: buildForEdit(context, category));
    } else if (state == CategoryViewState.select) {
      view = buildForSelect(context, category);
    }

    return Card(
      color: selected ? Styles.mainColor : Styles.secColor,
      shadowColor: selected ? Styles.mainColor : Styles.secColor,
      elevation: 5,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(5),
        child: view,
      ),
    );
  }

  Widget buildForView(BuildContext context, PassageCategory category) {
    var model = Provider.of<AppModel>(context);

    return Row(
      children: [
        Expanded(
          child: Text(category.name),
        ),
        IconButton(
          onPressed: () => setState(() {
            state = CategoryViewState.edit;
          }),
          icon: const Icon(
            Icons.edit,
            color: Styles.mainColor,
          ),
        ),
        IconButton(
          onPressed: () => model.deleteCategory(category.id),
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
            hintText: 'Category Name',
            onChanged: (name) => this.name = name,
          ),
        ),
        IconButton(
          onPressed: () {
            if (name.isEmpty) return;
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
    return Row(
      children: [
        Expanded(child: Text(category.name)),
        const Icon(Icons.check),
      ],
    );
  }
}

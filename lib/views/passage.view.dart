import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/config/values.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/badge.widget.dart';
import 'package:mam_pray/widgets/custom_button.widget.dart';
import 'package:mam_pray/widgets/custom_textinput.widget.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:mam_pray/widgets/page_header.widget.dart';
import 'package:provider/provider.dart';

class PassageView extends StatefulWidget {
  const PassageView({Key? key, required this.passage, this.forCreation = false})
      : super(key: key);

  final Passage passage;
  final bool forCreation;

  @override
  State<PassageView> createState() => _PassageViewState();
}

class _PassageViewState extends State<PassageView> {
  var enableEdition = false;
  var showCategories = true;
  Passage? editedPassage;

  @override
  void initState() {
    super.initState();

    if (widget.forCreation) setEdition(true);
  }

  void setEdition(bool enable) {
    setState(() => enableEdition = enable);
    editedPassage = (enable ? widget.passage.copyWith() : null);
  }

  @override
  Widget build(BuildContext context) {
    double textPadding = 20;

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Pageheader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Utils.addFixedSpace(10),
                buildHeader(context, widget.passage),
                if (showCategories) Utils.addFixedSpace(30),
                if (showCategories)
                  Row(
                    children: [
                      Expanded(
                        child: buildCategoriesView(
                            context,
                            widget.passage,
                            enableEdition
                                ? widget.passage.categories.length
                                : Values.maxCategoriesCount),
                      ),
                    ],
                  ),
                Utils.addFixedSpace(10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey.shade700),
                        onPressed: () => setState(() {
                          showCategories = !showCategories;
                        }),
                        child: Icon(showCategories
                            ? Icons.keyboard_double_arrow_up
                            : Icons.keyboard_double_arrow_down),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: textPadding,
                top: textPadding * 1.5,
                right: textPadding,
              ),
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: (enableEdition
                      ? CustomTextInput(
                          hintText: '',
                          padding: const EdgeInsets.all(0),
                          initialText: editedPassage!.text,
                          type: CustomTextInputType.text,
                          onChanged: (text) => editedPassage!.text = text,
                        )
                      : Text(
                          widget.passage.text,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 20),
                        )),
                ),
              ),
            ),
          ),
          buildFooter(context, widget.passage),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context, Passage passage) {
    if (enableEdition) {
      return Row(
        children: [
          Flexible(
            flex: 4,
            child: CustomTextInput(
              initialText: editedPassage!.book,
              onChanged: (value) => editedPassage!.book = value,
              hintText: 'Book',
            ),
          ),
          const Text('    '),
          Flexible(
            flex: 1,
            child: CustomTextInput(
              textAlign: TextAlign.center,
              type: CustomTextInputType.number,
              initialText: editedPassage!.chapter.toString(),
              onChanged: (value) =>
                  editedPassage!.chapter = int.tryParse(value) ?? 0,
              hintText: 'chapter',
            ),
          ),
          Text(
            ' : ',
            style: Styles.mainText.copyWith(color: Colors.black),
          ),
          Flexible(
            flex: 1,
            child: CustomTextInput(
              textAlign: TextAlign.center,
              type: CustomTextInputType.number,
              initialText: editedPassage!.verseStart.toString(),
              onChanged: (value) =>
                  editedPassage!.verseStart = int.tryParse(value) ?? 0,
              hintText: 'from',
            ),
          ),
          Text(
            ' - ',
            style: Styles.mainText.copyWith(color: Colors.black),
          ),
          Flexible(
            flex: 1,
            child: CustomTextInput(
              textAlign: TextAlign.center,
              type: CustomTextInputType.number,
              initialText: editedPassage!.verseEnd.toString(),
              onChanged: (value) =>
                  editedPassage!.verseEnd = int.tryParse(value) ?? 0,
              hintText: 'to',
            ),
          ),
        ],
      );
    }

    var verseEnd = passage.verseEnd > 0 ? '-${passage.verseEnd}' : '';
    var dt = passage.creationDate;

    return Column(
      children: [
        Text(
          '${passage.book.toTitleCase()} ${passage.chapter}:${passage.verseStart}$verseEnd',
          style: Styles.mainText.copyWith(fontSize: 30, color: Styles.bgColor),
        ),
        Utils.addFixedSpace(5),
        Text(
          'created on: ${dt.year}/${dt.month}/${dt.day} ${dt.hour}:${dt.minute}',
          style: Styles.subText.copyWith(fontSize: 15, color: Styles.bgColor),
        )
      ],
    );
  }

  Widget buildFooter(BuildContext context, Passage passage) {
    var model = context.read<AppModel>();

    if (enableEdition) {
      return Row(
        children: [
          CustomButton(
            onPressed: () => setEdition(false),
            icon: Icons.cancel,
            text: 'Cancel',
            color: Colors.grey,
          ),
          Utils.addFlexibleSpace(),
          CustomButton(
            onPressed: () {},
            icon: Icons.download,
            text: 'Autofill Text',
            color: Styles.bgColor,
          ),
          Utils.addFlexibleSpace(),
          CustomButton(
            onPressed: () {
              model.fillPassage(passage, editedPassage!);
              setEdition(false);
            },
            icon: Icons.save,
            text: 'Save',
            color: Colors.green,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          CustomButton(
            onPressed: () => Utils.showSnackBar(
              context,
              msg: 'You will delete the passage',
              action: SnackBarAction(
                label: 'CONFIRM',
                onPressed: () {
                  model.deletePassage(passage.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
            icon: Icons.delete,
            text: 'Delete',
            color: Colors.red,
          ),
          Utils.addFlexibleSpace(),
          CustomButton(
            onPressed: () => setEdition(true),
            icon: Icons.edit,
            text: 'Edit',
          )
        ],
      );
    }
  }

  Widget buildCategoriesView(
      BuildContext context, Passage passage, int maxCount) {
    var model = context.read<AppModel>();

    var remaining = passage.categories.length;
    var leftToShow = maxCount;

    List<Widget> badges = [];
    var categories = (enableEdition ? editedPassage! : passage).categories;

    for (var id in categories) {
      if (leftToShow == -1) break;
      var category = model.getCategory(id);

      var canShow = ((leftToShow > 0) || (remaining == 1));
      badges.add(Badge(
        onDelete: ((enableEdition && canShow)
            ? () => Utils.showSnackBar(
                  context,
                  msg: 'You will remove the passage from the category',
                  action: SnackBarAction(
                    label: 'CONFIRM',
                    onPressed: () => setState(() => categories.remove(id)),
                  ),
                )
            : null),
        text: (!canShow ? '+$remaining more' : category.name),
        color: Styles.secColor,
        icon: Icons.notes,
        iconAfter: false,
      ));

      --remaining;
      --leftToShow;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: badges,
    );
  }
}

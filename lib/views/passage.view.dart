import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/config/values.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/services/bible_api.service.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/views/categories.view.dart';
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
  var viewed = false;
  var loading = false;

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
      loading: loading,
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
                        child: buildCategoriesView(context, widget.passage),
                      ),
                    ],
                  ),
                Utils.addFixedSpace(10),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade700),
                        onPressed: () => setState(() {
                          showCategories = !showCategories;
                        }),
                        child: Icon(showCategories
                            ? Icons.keyboard_double_arrow_up
                            : Icons.keyboard_double_arrow_down),
                      ),
                    ),
                    if (enableEdition) Utils.addFlexibleSpace(),
                    if (enableEdition)
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => CategoriesView(
                                      forSelecion: true,
                                      passage: editedPassage,
                                    )))
                            .then((_) => setState(() {})),
                        icon: const Icon(Icons.add),
                        label: const Text('Handle Categories'),
                      )
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
                color: Styles.secColor,
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
                          style: Styles.subText.copyWith(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                          ),
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
              onChanged: (value) => editedPassage!.verseEnd =
                  int.tryParse(value) ?? editedPassage!.verseStart,
              hintText: 'to',
            ),
          ),
        ],
      );
    }

    var verseEnd =
        passage.verseEnd > passage.verseStart ? '-${passage.verseEnd}' : '';
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
          style: Styles.subText.copyWith(
            // fontSize: 15,
            color: Styles.bgColor,
          ),
        )
      ],
    );
  }

  Widget buildFooter(BuildContext context, Passage passage) {
    var model = Provider.of<AppModel>(context, listen: false);

    if (enableEdition) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            margin: const EdgeInsets.all(5),
            onPressed: () {
              if (!widget.forCreation) {
                return setEdition(false);
              }

              Utils.showAlert(
                context,
                msg: 'You will cancel the creation of passage',
                action: AlertAction(
                  label: 'CONFIRM',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              );
            },
            icon: Icons.cancel,
            text: 'Cancel',
            color: Colors.grey,
          ),
          // Utils.addFlexibleSpace(),
          CustomButton(
            margin: const EdgeInsets.all(5),
            onPressed: () {
              if (editedPassage!.text.isNotEmpty) {
                Utils.showAlert(
                  context,
                  msg: 'You will replace the current text',
                  action: AlertAction(
                    label: 'CONFIRM',
                    onPressed: () => autoFillTextField(),
                  ),
                );
                return;
              }

              autoFillTextField();
            },
            icon: Icons.download,
            text: 'Autofill Text',
            color: Styles.bgColor,
          ),
          // Utils.addFlexibleSpace(),
          CustomButton(
            margin: const EdgeInsets.all(5),
            onPressed: () {
              if (editedPassage!.book.isEmpty) {
                Utils.showAlert(
                  context,
                  msg: 'You must set the Book',
                  action: AlertAction(label: 'OK', onPressed: () {}),
                );
                return;
              }

              if (editedPassage!.verseStart > editedPassage!.verseEnd) {
                Utils.showAlert(
                  context,
                  msg: 'starting verse is greater than ending verse',
                  action: AlertAction(label: 'OK', onPressed: () {}),
                );
                return;
              }

              model.fillPassage(passage, editedPassage!);
              if (widget.forCreation) model.addPassage(passage);

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            margin: const EdgeInsets.all(5),
            onPressed: () => Utils.showAlert(
              context,
              msg: 'You will delete the passage',
              action: AlertAction(
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
          // Utils.addFlexibleSpace(),
          CustomButton(
            margin: const EdgeInsets.all(5),
            onPressed: () => setEdition(true),
            icon: Icons.edit,
            text: 'Edit',
          )
        ],
      );
    }
  }

  void autoFillTextField() async {
    setState(() => loading = true);

    var verses = (await BibleAPIService.instance.getPassageInfo(
          editedPassage!.book,
          editedPassage!.chapter,
          editedPassage!.verseStart,
          editedPassage!.verseEnd,
        ))
            ?.verses ??
        [];

    if (verses.isNotEmpty) {
      editedPassage!.text =
          verses.map((e) => e.text.trim().replaceAll('\n', '')).join('\n\n');
    }

    setState(() => loading = false);
  }

  Widget buildCategoriesView(BuildContext context, Passage passage) {
    var model = Provider.of<AppModel>(context, listen: false);

    var remaining = passage.categories.length;
    var leftToShow = max(
      widget.passage.categories.length,
      (enableEdition
          ? widget.passage.categories.length
          : Values.maxCategoriesCount),
    );

    List<Widget> badges = [];
    var categories = (enableEdition ? editedPassage! : passage).categories;

    for (var id in categories) {
      if (leftToShow == -1) break;
      var category = model.getCategory(id);

      var canShow = ((leftToShow > 0) || (remaining == 1));
      badges.add(Badge(
        onDelete: ((enableEdition && canShow && (categories.length > 1))
            ? () => Utils.showAlert(
                  context,
                  msg: 'You will remove the passage from the category',
                  action: AlertAction(
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

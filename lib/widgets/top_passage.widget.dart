import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/badge.widget.dart';

typedef OnTopPassageTap = void Function(BuildContext context, Passage passage);

class TopPassage extends StatelessWidget {
  const TopPassage({Key? key, required this.passage, required this.onTap})
      : super(key: key);

  final Passage passage;
  final OnTopPassageTap onTap;

  @override
  Widget build(BuildContext context) {
    const Size size = Size(180, 150);
    // const double fontSize = 20;

    var verseEnd =
        passage.verseEnd > passage.verseStart ? '-${passage.verseEnd}' : '';

    return GestureDetector(
      onTap: () => onTap.call(context, passage),
      child: Card(
        elevation: 5,
        borderOnForeground: true,
        color: Styles.secColor,
        shadowColor: Styles.secColor,
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            Container(
              width: size.width,
              height: size.height / 2.5,
              decoration: BoxDecoration(
                color: Styles.bgColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
                child: Text(
                  passage.book.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Styles.mainText.copyWith(
                    // fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Styles.mainColor,
                  ),
                ),
              ),
            ),
            Utils.addFlexibleSpace(),
            Row(
              children: [
                Utils.addFixedSpace(10),
                Text(
                  'Chapter ${passage.chapter}',
                  style: Styles.mainText.copyWith(
                    // fontSize: fontSize,
                    color: Styles.bgColor,
                  ),
                ),
                Utils.addFlexibleSpace(),
                Text(
                  '${passage.verseStart}$verseEnd',
                  style: Styles.mainText.copyWith(
                    // fontSize: fontSize,
                    color: Styles.bgColor,
                  ),
                ),
              ],
            ),
            Utils.addFlexibleSpace(),
            Row(
              children: [
                Utils.addFlexibleSpace(),
                Badge(
                  icon: Icons.remove_red_eye,
                  text: passage.viewCount.toString(),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

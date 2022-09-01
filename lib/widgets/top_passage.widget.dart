import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/badge.widget.dart';

class TopPassage extends StatelessWidget {
  const TopPassage({Key? key, required this.passage}) : super(key: key);

  final Passage passage;

  @override
  Widget build(BuildContext context) {
    const Size size = Size(180, 150);
    const double fontSize = 20;

    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Styles.secColor,
        borderRadius: BorderRadius.circular(3),
      ),
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
                fontSize: fontSize,
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
              style: Styles.subText.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Styles.bgColor,
              ),
            ),
            Utils.addFlexibleSpace(),
            Text(
              '${passage.verseStart}:${passage.verseEnd}',
              style: Styles.subText.copyWith(
                fontSize: fontSize,
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
    );
  }
}

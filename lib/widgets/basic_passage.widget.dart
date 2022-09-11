import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/badge.widget.dart';

typedef OnBasicPassageTap = void Function(
    BuildContext context, Passage passage);

class BasicPassage extends StatelessWidget {
  const BasicPassage({Key? key, required this.passage, required this.onTap})
      : super(key: key);

  final Passage passage;
  final OnBasicPassageTap onTap;

  @override
  Widget build(BuildContext context) {
    const double fontSize = 20;

    return GestureDetector(
      onTap: () => onTap.call(context, passage),
      child: Card(
        elevation: 5,
        borderOnForeground: true,
        color: Styles.secColor,
        shadowColor: Styles.secColor,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    passage.book,
                    style: Styles.mainText.copyWith(
                      fontSize: fontSize,
                      color: Styles.bgColor,
                    ),
                  ),
                  Utils.addFlexibleSpace(),
                  Text(
                    '${passage.verseStart}:${passage.verseStart}',
                    style: Styles.mainText.copyWith(
                      fontSize: fontSize,
                      color: Styles.bgColor,
                    ),
                  ),
                ],
              ),
              Utils.addFixedSpace(10),
              Row(
                children: [
                  Text(
                    'Chapter ${passage.chapter}',
                    style: Styles.subText.copyWith(
                      fontSize: fontSize / 1.2,
                      color: Styles.bgColor,
                    ),
                  ),
                  Utils.addFlexibleSpace(),
                  Badge(
                    icon: Icons.remove_red_eye,
                    text: passage.viewCount.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

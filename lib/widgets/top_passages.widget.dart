import 'package:flutter/cupertino.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/top_passage.widget.dart';

class TopPassages extends StatelessWidget {
  const TopPassages({Key? key, required this.passages, required this.onTap})
      : super(key: key);

  final List<Passage> passages;
  final OnTopPassageTap onTap;

  @override
  Widget build(BuildContext context) {
    const double titleFontSize = 18;

    return Column(
      children: [
        Text(
          'TOP PASSAGES',
          style: Styles.mainText.copyWith(
            fontSize: titleFontSize,
            color: Styles.secColor,
          ),
        ),
        Utils.addFixedSpace(20),
        SizedBox(
          height: 150,
          child: ListView.builder(
            itemCount: passages.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(0.0),
              child: TopPassage(passage: passages[index], onTap: onTap),
            ),
          ),
        ),
        Utils.addFixedSpace(40),
        Text(
          'ALL PASSAGES',
          style: Styles.mainText.copyWith(
            fontSize: titleFontSize,
            color: Styles.secColor,
          ),
        ),
      ],
    );
  }
}

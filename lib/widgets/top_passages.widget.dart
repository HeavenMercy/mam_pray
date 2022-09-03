import 'package:flutter/cupertino.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/models/passage.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/widgets/top_passage.widget.dart';

class TopPassages extends StatelessWidget {
  const TopPassages({Key? key, required this.passages}) : super(key: key);

  final List<Passage> passages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'TOP PASSAGES',
          style: Styles.mainText.copyWith(
            fontSize: 20,
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
              child: TopPassage(passage: passages[index]),
            ),
          ),
        ),
        Utils.addFixedSpace(40),
        Text(
          'ALL PASSAGES',
          style: Styles.mainText.copyWith(
            fontSize: 20,
            color: Styles.secColor,
          ),
        ),
        Utils.addFixedSpace(20),
      ],
    );
  }
}

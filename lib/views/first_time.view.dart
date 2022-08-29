import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
import 'package:mam_pray/config/values.config.dart';
import 'package:mam_pray/models/app.model.dart';
import 'package:mam_pray/utils.dart';
import 'package:mam_pray/views/home.view.dart';
import 'package:mam_pray/widgets/custom_button.widget.dart';
import 'package:mam_pray/widgets/custom_textinput.widget.dart';
import 'package:mam_pray/widgets/page_container.widget.dart';
import 'package:provider/provider.dart';

class FirstTimeView extends StatefulWidget {
  const FirstTimeView({Key? key}) : super(key: key);

  @override
  State<FirstTimeView> createState() => _FirstTimeViewState();
}

class _FirstTimeViewState extends State<FirstTimeView> {
  var fname = '';
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      loading: loading,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Values.padding),
        child: Column(
          children: [
            Text(
              'Mam Pray',
              style: Styles.mainText.copyWith(fontSize: Values.titleSize),
            ),
            Utils.addFixedSpace(5),
            const Text('Welcome', style: Styles.subText),
            Utils.addFixedSpace(65),
            CustomTextInput(
              hintText: "what's your firstname?",
              prefixIcon: const Icon(Icons.person),
              onChanged: (value) => fname = value,
            ),
            Expanded(child: Container()),
            Row(
              children: [
                Utils.addFlexibleSpace(),
                CustomButton(
                  onPressed: () => onNextPressed(context),
                  text: 'Next',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onNextPressed(BuildContext context) {
    var model = Provider.of<AppModel>(context, listen: false);

    if (fname.isEmpty) {
      Utils.showSnackBar(context,
          msg: 'no firstname given',
          icon: Icons.person_off,
          action: SnackBarAction(label: 'OK', onPressed: () {}));
      return;
    }

    setState(() {
      loading = true;
    });

    model.firstname = fname;
    print('first name to save: ${model.firstname}');
    model.save().then((done) {
      if (done) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeView(),
        ));
        return;
      }

      setState(() {
        loading = false;
      });
      Utils.showSnackBar(context,
          msg: 'an error occured while saving',
          icon: Icons.error,
          action: SnackBarAction(label: 'ok', onPressed: () {}));
    });
  }
}

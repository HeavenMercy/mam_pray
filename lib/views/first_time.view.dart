import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Utils.addFixedSpace(50),
            Text(
              'Mam Pray',
              style: Styles.mainText.copyWith(fontSize: 50),
            ),
            Utils.addFixedSpace(10),
            Text('Welcome', style: Styles.subText.copyWith(fontSize: 20)),
            Utils.addFixedSpace(100),
            CustomTextInput(
              hintText: "what's your firstname?",
              prefixIcon: const Icon(Icons.person),
              onChanged: (value) => fname = value,
            ),
            Utils.addFlexibleSpace(),
            Row(
              children: [
                Utils.addFlexibleSpace(),
                CustomButton(
                  onPressed: () => onNextPressed(context),
                  text: 'Next',
                  icon: Icons.fast_forward,
                  iconAfter: true,
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

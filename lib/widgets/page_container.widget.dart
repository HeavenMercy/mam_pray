import 'package:flutter/material.dart';

import '../config/styles.config.dart';
import '../config/values.config.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({Key? key, required this.child, this.loading = false})
      : super(key: key);

  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(
              horizontal: Values.padding, vertical: Values.padding * 1.5),
          child: Stack(
            children: [
              child,
              if (loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

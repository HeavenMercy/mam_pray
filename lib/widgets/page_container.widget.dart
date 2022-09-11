import 'package:flutter/material.dart';

import '../config/styles.config.dart';

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
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              child,
              if (loading)
                Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.black.withAlpha(80),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

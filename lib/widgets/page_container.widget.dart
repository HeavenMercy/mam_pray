import 'package:flutter/material.dart';

import '../config/styles.config.dart';

class PageContainer extends StatelessWidget {
  const PageContainer(
      {Key? key,
      required this.child,
      this.setPadding = true,
      this.loading = false})
      : super(key: key);

  final Widget child;
  final bool loading;
  final bool setPadding;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var padding = setPadding
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 30)
        : null;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              if (padding != null)
                Padding(
                  padding: padding,
                  child: child,
                )
              else
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

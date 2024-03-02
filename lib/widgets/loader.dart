import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const CustomLoader({super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isLoading) {
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Stack(
        textDirection: TextDirection.ltr,
        children: [
          child,
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

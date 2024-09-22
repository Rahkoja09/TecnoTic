import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final Color backgroundColor;

  const LoadingWidget(
      {Key? key, this.backgroundColor = const Color.fromARGB(15, 52, 172, 205)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: Color.fromARGB(255, 13, 53, 102),
        size: 50,
      ),
    );
  }
}

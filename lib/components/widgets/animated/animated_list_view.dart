import 'package:flutter/material.dart';
import 'slide_in_widget.dart';

class AnimatedListView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final Duration staggerDuration;
  final Duration itemDuration;

  const AnimatedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.controller,
    this.staggerDuration = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return SlideInWidget(
          delay: staggerDuration * index,
          duration: itemDuration,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class AnimatedVisibility extends StatefulWidget {
  final Widget? child;
  final bool visible;
  const AnimatedVisibility({Key? key, required this.child, this.visible = true})
      : super(key: key);

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.visible ? widget.child : const SizedBox());
  }
}

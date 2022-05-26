import 'package:dash_playground/providers/theme_provider.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';

class Switch extends StatefulWidget {
  final double? size;
  final bool isEnabled;
  final Function() onValueChange;
  const Switch(
      {Key? key,
      this.size,
      required this.isEnabled,
      required this.onValueChange})
      : super(key: key);

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch> {
  @override
  Widget build(BuildContext context) {
    var size = widget.size ?? getProportionateHeight(36);
    var circleSize = (28 * size) / 36;
    var border = (size - circleSize) / 2;
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onValueChange,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: size,
        width: size * 2,
        decoration: BoxDecoration(
            border: Border.all(
                color: widget.isEnabled
                    ? ThemeConfig.primary
                    : const Color(0xFF3a546a),
                width: widget.isEnabled ? border : border * 0.6),
            color: widget.isEnabled
                ? ThemeConfig.primary
                : const Color(0x203a546a),
            borderRadius: BorderRadius.circular(circleSize)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              right: widget.isEnabled ? 0 : null,
              left: widget.isEnabled ? null : border,
              child: Container(
                height: widget.isEnabled ? circleSize : circleSize * 0.8,
                width: widget.isEnabled ? circleSize : circleSize * 0.8,
                decoration: BoxDecoration(
                    color: widget.isEnabled
                        ? Colors.white
                        : const Color(0xFF3a546a),
                    shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

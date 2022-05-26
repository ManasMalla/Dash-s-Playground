import 'package:dash_playground/providers/theme_provider.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight weight;
  final Color? color;
  final TextAlign align;
  const TextWidget(this.text,
      {Key? key,
      this.size,
      this.weight = FontWeight.normal,
      this.color,
      this.align = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
          fontFamily: 'Product Sans',
          fontSize: size ?? 14,
          fontWeight: weight,
          overflow: TextOverflow.visible,
          color:
              color ?? (ThemeConfig.themeMode ? Colors.white : Colors.black)),
    );
  }
}

import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:dash_playground/utils/modifiers.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedProgressBar extends StatefulWidget {
  final width;
  final duration;
  const AnimatedProgressBar(
      {Key? key,
      required this.width,
      this.duration = const Duration(seconds: 1)})
      : super(key: key);

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SplashScreenProvider>(builder: (context, provider, _) {
      return Container(
        width: Modifier.fillMaxWidth(widget.width),
        height: getProportionateHeight(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                "Please Wait...",
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: getProportionateHeight(16),
                  fontWeight: FontWeight.w600,
                  color: Color(0x3001579b),
                ),
              ),
            ),
            AnimatedContainer(
              duration: widget.duration,
              width: Modifier.fillMaxWidth(widget.width) * provider.percentage,
              height: getProportionateHeight(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Color(0xFF01579b),
              ),
              child: Center(
                child: provider.percentage >= 0.4
                    ? Text(
                        "Loading...",
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w500,
                            fontSize: getProportionateHeight(16),
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis),
                      )
                    : SizedBox(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

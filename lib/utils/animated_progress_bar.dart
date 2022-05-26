import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:dash_playground/utils/modifiers.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double width;
  final Duration duration;
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
              child: SizedBox(
                height: getProportionateHeight(16),
                child: Text(
                  "Please Wait...",
                  style: TextStyle(
                    fontFamily: 'Childish Reverie',
                    fontSize: getProportionateHeight(20),
                    color: const Color(0x3001579b),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: widget.duration,
              width: Modifier.fillMaxWidth(widget.width) * provider.percentage,
              height: getProportionateHeight(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: const Color(0xFF01579b),
              ),
              child: Center(
                child: provider.percentage >= 0.4
                    ? SizedBox(
                        height: getProportionateHeight(16),
                        child: Text(
                          "Loading...",
                          style: TextStyle(
                              fontFamily: 'Childish Reverie',
                              fontSize: getProportionateHeight(20),
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

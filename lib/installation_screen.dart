import 'package:dash_playground/providers/theme_provider.dart';
import 'package:dash_playground/utils/modifiers.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:dash_playground/utils/text_widget.dart';
import 'package:flutter/material.dart';

class InstallationScreen extends StatefulWidget {
  const InstallationScreen({Key? key}) : super(key: key);

  @override
  State<InstallationScreen> createState() => _InstallationScreenState();
}

class _InstallationScreenState extends State<InstallationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double downloadPercentage = 0.3;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateHeight(36),
        ),
        TextWidget(
          "Android Studio is powerful!",
          size: getProportionateHeight(32),
          color: Colors.amberAccent.shade700,
          weight: FontWeight.bold,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextWidget(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum.\nPraesent vehicula turpis augue, in vestibulum ante tincidunt vel.",
              align: TextAlign.center,
              color: Colors.grey.shade900),
        ),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: double.infinity,
                width: getProportionateWidth(775),
                child: Center(
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/android-studio-bumblebee.png',
                    ),
                    borderRadius:
                        BorderRadius.circular(getProportionateHeight(54)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -10,
                child: Image.asset(
                  'assets/images/android-studio.png',
                  height: getProportionateHeight(160),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: getProportionateHeight(8),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateHeight(12),
              horizontal: getProportionateWidth(32)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Downloading Android Studio Chipmunk | 2021.2.1 for Mac",
                size: getProportionateHeight(18),
              ),
              TextWidget(
                "18%",
                size: getProportionateHeight(18),
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: getProportionateHeight(18),
          color: ThemeConfig.primary.withOpacity(0.2),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: Modifier.fillMaxWidth(1.0) * downloadPercentage,
                height: getProportionateHeight(32),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(28)),
                  color: ThemeConfig.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

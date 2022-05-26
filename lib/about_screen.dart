import 'package:dash_playground/utils/size_config.dart';
import 'package:dash_playground/utils/text_widget.dart';
import 'package:dash_playground/providers/theme_provider.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12,
              ),
              Text(
                "Dash's",
                style: TextStyle(
                  fontFamily: 'Childish Reverie',
                  fontSize: getProportionateHeight(24),
                  color: ThemeConfig.primary,
                ),
              ),
              Text(
                "Playground",
                style: TextStyle(
                  fontFamily: 'Childish Reverie',
                  fontSize: getProportionateHeight(48),
                  color: ThemeConfig.primary,
                ),
              ),
              TextWidget(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque consectetur, dui non congue pretium, elit dui venenatis metus, convallis maximus nibh elit sit amet sapien. Curabitur vel enim nec augue hendrerit finibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Quisque ac augue vel augue cursus ornare. Curabitur euismod ac diam eu venenatis.\n\nIn egestas porttitor egestas. Etiam gravida hendrerit magna. Mauris hendrerit blandit viverra. Aliquam laoreet scelerisque imperdiet. Nullam dictum nisi nulla, eget elementum tellus tempor eu. \n\nSuspendisse tellus justo, dignissim id imperdiet ut, ornare at tellus. Suspendisse mattis augue urna, sit amet luctus lacus sodales sed. Proin at lacus nisl. Pellentesque porta, nisi sed pellentesque fringilla, purus urna consequat nisl, a rutrum neque ex id mauris. Suspendisse potenti. Aliquam bibendum eget tortor a fringilla.",
                size: getProportionateHeight(18),
                color: ThemeConfig.onBackground
                    .withOpacity(ThemeConfig.themeMode ? 0.6 : 1),
              ),
              SizedBox(
                height: getProportionateHeight(20),
              ),
              TextWidget(
                "Credits",
                weight: FontWeight.bold,
                size: getProportionateHeight(20),
                color: ThemeConfig.onBackground,
              ),
              SizedBox(
                height: getProportionateHeight(8),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "The Flutter Team",
                        weight: FontWeight.w500,
                        size: getProportionateHeight(20),
                        color: ThemeConfig.primary,
                      ),
                      TextWidget(
                        "Flutter SDK and Documentation",
                        size: getProportionateHeight(18),
                        color: ThemeConfig.onBackground.withOpacity(0.8),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ClipOval(
                    child: Image.network(
                      'https://yt3.ggpht.com/ytc/AKedOLRt1d4p7bPylasq_66BIC8-k3hkyVjJ2JICQITK=s900-c-k-c0x00ffffff-no-rj',
                      height: getProportionateHeight(48),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateWidth(96),
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateHeight(16),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "Sampath Balavida",
                        weight: FontWeight.w500,
                        size: getProportionateHeight(20),
                        color: ThemeConfig.primary,
                      ),
                      TextWidget(
                        "The Windows Plugin interface",
                        size: getProportionateHeight(18),
                        color: ThemeConfig.onBackground.withOpacity(0.8),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ClipOval(
                    child: Image.network(
                      'https://avatars.githubusercontent.com/u/26628788?v=4',
                      height: getProportionateHeight(48),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateWidth(96),
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateHeight(32),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Developed By  ",
                      style: TextStyle(
                        fontFamily: 'Childish Reverie',
                        fontSize: getProportionateHeight(20),
                        color: ThemeConfig.onBackground.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      "Manas Malla ©",
                      style: TextStyle(
                        fontFamily: 'Childish Reverie',
                        fontSize: getProportionateHeight(32),
                        color: ThemeConfig.onBackground,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

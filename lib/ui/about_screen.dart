import 'package:dash_playground/utils/size_config.dart';
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
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 36,
                ),
              ),
              Text(
                "Playground",
                style: TextStyle(
                  fontFamily: 'Childish Reverie',
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 64,
                ),
              ),
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque consectetur, dui non congue pretium, elit dui venenatis metus, convallis maximus nibh elit sit amet sapien. Curabitur vel enim nec augue hendrerit finibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Quisque ac augue vel augue cursus ornare. Curabitur euismod ac diam eu venenatis.\n\nIn egestas porttitor egestas. Etiam gravida hendrerit magna. Mauris hendrerit blandit viverra. Aliquam laoreet scelerisque imperdiet. Nullam dictum nisi nulla, eget elementum tellus tempor eu. \n\nSuspendisse tellus justo, dignissim id imperdiet ut, ornare at tellus. Suspendisse mattis augue urna, sit amet luctus lacus sodales sed. Proin at lacus nisl. Pellentesque porta, nisi sed pellentesque fringilla, purus urna consequat nisl, a rutrum neque ex id mauris. Suspendisse potenti. Aliquam bibendum eget tortor a fringilla.",
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Credits",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "The Flutter Team",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        "Flutter SDK and Documentation",
                      ),
                    ],
                  ),
                  const Spacer(),
                  ClipOval(
                    child: Image.asset(
                      'assets/images/flutter.jpg',
                      height: 48,
                    ),
                  ),
                  SizedBox(
                    width: 96,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sampath Balavida",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        "The Windows Plugin interface",
                      ),
                    ],
                  ),
                  const Spacer(),
                  ClipOval(
                    child: Image.network(
                      'https://avatars.githubusercontent.com/u/26628788?v=4',
                      height: 48,
                    ),
                  ),
                  SizedBox(
                    width: 96,
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.network(
                        "https://media.licdn.com/dms/image/D5603AQFYsCJRGlxWqQ/profile-displayphoto-shrink_400_400/0/1678267583894?e=1684972800&v=beta&t=t-MqdpH-RwkXyB9kadqcGVrcJlY6YTxbqzRUlAI2DmI",
                        height: 48,
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Developed By  ",
                          ),
                          Text(
                            "Manas Malla ©",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
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

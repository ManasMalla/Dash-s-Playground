import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    var screenIndex = 0;
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: getProportionateWidth(360),
          color: Color(0x2054c5f8),
          child: Container(),
        ),
        Expanded(
            child: screenIndex == 0
                ? Container()
                : screenIndex == 1
                    ? Container()
                    : screenIndex == 2
                        ? Container()
                        : screenIndex == 3
                            ? Container()
                            : screenIndex == 4
                                ? Container()
                                : Container()),
      ],
    ));
  }
}

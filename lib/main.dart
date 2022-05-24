import 'dart:io';

import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:dash_playground/utils/animated_progress_bar.dart';
import 'package:dash_playground/utils/modifiers.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SplashScreenProvider(),
      child: DashPlaygroundApp(),
    ),
  );
}

class DashPlaygroundApp extends StatefulWidget {
  const DashPlaygroundApp({Key? key}) : super(key: key);

  @override
  State<DashPlaygroundApp> createState() => _DashPlaygroundAppState();
}

class _DashPlaygroundAppState extends State<DashPlaygroundApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashPlayground(),
    );
  }
}

class DashPlayground extends StatefulWidget {
  const DashPlayground({Key? key}) : super(key: key);

  @override
  State<DashPlayground> createState() => _DashPlaygroundState();
}

class _DashPlaygroundState extends State<DashPlayground> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var provider = Provider.of<SplashScreenProvider>(context, listen: false);
    provider.updatePercentage(0.8);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/splash_screen.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(
              height: getProportionateHeight(32),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/title_ribbon.png',
                  width: Modifier.fillMaxHeight(0.8),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: getProportionateHeight(12),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'D',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: getProportionateHeight(32),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF54c5f8),
                          ),
                        ),
                        Text(
                          'ASH\'S ',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: getProportionateHeight(20),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF54c5f8),
                          ),
                        ),
                        Text(
                          'P',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: getProportionateHeight(32),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF01579b),
                          ),
                        ),
                        Text(
                          'LAYGROUND',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: getProportionateHeight(20),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF01579b),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: getProportionateHeight(8),
            ),
            AnimatedProgressBar(
              width: 0.6,
              duration:
                  Platform.isMacOS || Platform.isLinux || Platform.isWindows
                      ? Duration(seconds: 1)
                      : Duration(seconds: 2),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                onPressed: () {},
                elevation: 0,
                height: getProportionateHeight(64),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: getProportionateHeight(20),
                ),
                color: Colors.amber,
                shape: const CircleBorder(),
              ),
            ),
            SizedBox(
              height: getProportionateHeight(16),
            )
          ],
        ),
      ),
    );
  }
}

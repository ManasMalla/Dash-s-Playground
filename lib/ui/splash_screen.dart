import 'package:dash_playground/controllers/splash_controller.dart';
import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:dash_playground/utils/animated_visibility.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  StateMVC<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends StateMVC<SplashScreen> {
  late SplashScreenProvider _uiProvider;

  late SplashController splashController;

  _SplashScreenState() : super(SplashController()) {
    /// Acquire a reference to the passed Controller.
    splashController = controller as SplashController;
  }

  @override
  void initState() {
    super.initState();
    _uiProvider = Provider.of<SplashScreenProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Triage - Decide whether if the user is on desktop or not and then workout the respective work
     * Desktop: Fetch the urls of the various platform-specific dependencies and update the progress indicator based on the fetch status
     * Mobile: Nothing much to do, so just fetch all the latest projects
     * Web: Nothing much to do, so just fetch all the latest projects
     */

    if (platformCategory() != PlatformCategory.mobile) {
      InstallationProvider provider =
          Provider.of<InstallationProvider>(context, listen: false);
      splashController.fetchJSON(_uiProvider, provider, () {
        _uiProvider.updateNetworkAvailability();
        _uiProvider.updateLoadedState();
      });
    } else {
      _uiProvider.updatePercentage(1.0);
      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        _uiProvider.updateNetworkAvailability();
        _uiProvider.updateLoadedState();
      });
    }

    return Consumer<SplashScreenProvider>(builder: (context, uiProvider, _) {
      return LayoutBuilder(builder: (context, constraints) {
        WindowWidthSizeClass widthSizeClass =
            getWindowWidthSizeClass(constraints);
        return Scaffold(
          body: Row(
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(
                      widthSizeClass == WindowWidthSizeClass.compact ? 24 : 48),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const Icon(
                          Icons.flutter_dash_rounded,
                          size: 64,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          "Dash's Playgrounds",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        AnimatedVisibility(
                          visible: !_uiProvider.isLoaded,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: uiProvider.hasNetworkAvailable
                                ? LinearProgressIndicator(
                                    value: uiProvider.percentage)
                                : const LinearProgressIndicator(),
                          ),
                        ),
                        const Spacer(),
                        AnimatedVisibility(
                            visible: uiProvider.isLoaded,
                            child: FilledButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('home-screen');
                                },
                                child: const Text("Continue")))
                      ]),
                ),
              ),
              Expanded(
                flex: 3,
                child: Image.asset(
                  "assets/images/splash_screen.png",
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              )
            ],
          ),
        );
      });
    });
  }
}

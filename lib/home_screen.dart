import 'package:dash_playground/ui/about_screen.dart';
import 'package:dash_playground/ui/check_for_updates_screen.dart';
import 'package:dash_playground/ui/create_project.dart';
import 'package:dash_playground/ui/get_started_screen.dart';
import 'package:dash_playground/ui/uninstall_screen.dart';
import 'package:dash_playground/utils/animated_visibility.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldNavigationRoute = "get-started";
  getScaffoldNavigationIndex() {
    switch (scaffoldNavigationRoute) {
      case "get-started":
        return 0;
      case "create":
        return 1;
      case "customize":
        return 2;
      case "check-for-updates":
        return 3;
      case "uninstall":
        return 4;
      case "about":
        return 5;
      default:
        return 0;
    }
  }

  String getDestination(destination) {
    switch (destination) {
      case 0:
        return "get-started";
      case 1:
        return "create";
      case 2:
        return "customize";
      case 3:
        return "check-for-updates";
      case 4:
        return "uninstall";
      case 5:
        return "about";
      default:
        return "home";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: [
            AnimatedVisibility(
              visible: getWindowWidthSizeClass(constraints) ==
                  WindowWidthSizeClass.exanded,
              child: NavigationDrawer(
                  selectedIndex: getScaffoldNavigationIndex(),
                  onDestinationSelected: (destination) {
                    setState(() {
                      scaffoldNavigationRoute = getDestination(destination);
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.flutter_dash_rounded,
                            size: 36,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Dash's",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            "Playground",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const NavigationDrawerDestination(
                        icon: Icon(Icons.home_rounded),
                        label: Text("Dashboard")),
                    const NavigationDrawerDestination(
                        icon: Icon(Icons.add_circle_outline_rounded),
                        label: Text("Create")),
                    const NavigationDrawerDestination(
                        icon: Icon(Icons.edit_note_rounded),
                        label: Text("Customize")),
                    const NavigationDrawerDestination(
                        icon: Icon(Icons.system_update_alt_rounded),
                        label: Text("Check For Updates")),
                    const NavigationDrawerDestination(
                        icon: Icon(Icons.delete_outline_rounded),
                        label: Text("Uninstall")),
                    const SizedBox(
                      height: 24,
                    ),
                    const NavigationDrawerDestination(
                        icon: Icon(Icons.info_outline_rounded),
                        label: Text("About")),
                  ]),
            ),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const SizedBox(),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.help_outline_rounded))
                  ],
                ),
                body: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: scaffoldNavigationRoute == "get-started"
                      ? const GetStartedScreen()
                      : scaffoldNavigationRoute == "create"
                          ? CreateProjectScreen()
                          : scaffoldNavigationRoute == "check-for-updates"
                              ? const CheckForUpdatesScreen()
                              : scaffoldNavigationRoute == "about"
                                  ? const AboutScreen()
                                  : scaffoldNavigationRoute == "uninstall"
                                      ? const UninstallScreen()
                                      : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

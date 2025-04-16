import 'package:dash_playground/presentation/platform/windows/getting_started_screen.dart';
import 'package:fluent_ui/fluent_ui.dart';

class DashsPlaygroundWindowsApp extends StatelessWidget {
  const DashsPlaygroundWindowsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      theme: FluentThemeData(
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      title: 'Dash\'s Playground',
      home: NavigationView(
        pane: NavigationPane(
          selected: 0,
          displayMode: PaneDisplayMode.auto,
          items: [
            PaneItem(
              body: GettingStartedScreen(),
              icon: const Icon(FluentIcons.home),
              title: const Text('Home'),
            ),
            PaneItem(
              body: const Center(
                child: Text('Settings'),
              ),
              icon: const Icon(FluentIcons.settings),
              title: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

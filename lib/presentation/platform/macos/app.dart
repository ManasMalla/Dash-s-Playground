import 'package:dash_playground/presentation/platform/macos/getting_started_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class DashsPlaygroundMacOSApp extends StatelessWidget {
  const DashsPlaygroundMacOSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      home: MacosWindow(
        sidebar: Sidebar(
          builder: (context, pageScrollController) {
            return SidebarItems(
              items: const [
                SidebarItem(
                  label: Text("Get Started"),
                  section: true,
                ),
                SidebarItem(
                  label: Text("Install Flutter"),
                ),
                SidebarItem(
                  label: Text("Manage Flutter"),
                ),
                SidebarItem(
                  label: Text("Create"),
                  section: true,
                ),
                SidebarItem(
                    label: Text("Create Project"),
                    disclosureItems: [
                      SidebarItem(
                        label: Text("App"),
                        leading: MacosIcon(CupertinoIcons.app_badge),
                      ),
                      SidebarItem(
                        label: Text("Plugin"),
                        leading: MacosIcon(CupertinoIcons.archivebox),
                      ),
                    ],
                    expandDisclosureItems: true),
                SidebarItem(
                    label: Text("Open Project"),
                    leading: MacosIcon(CupertinoIcons.folder)),
                SidebarItem(
                  label: Text("Create Emulator"),
                  leading: MacosIcon(CupertinoIcons.device_phone_portrait),
                ),
              ],
              currentIndex: 0,
              onChanged: (_) {},
            );
          },
          bottom: const MacosListTile(
            leading: MacosIcon(CupertinoIcons.profile_circled),
            title: Text('Sign in'),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text('Sign in to view content'),
            ),
          ),
          minWidth: 200,
        ),
        child: MacosScaffold(
          toolBar: ToolBar(
            title: const Text('Dash\'s Playground'),
            actions: [
              ToolBarIconButton(
                label: 'Settings',
                icon: const MacosIcon(CupertinoIcons.settings),
                onPressed: () {},
                showLabel: false,
              ),
            ],
          ),
          children: [
            ContentArea(builder: (context, controller) {
              return const GettingStartedScreen();
            }),
          ],
        ),
      ),
    );
  }
}

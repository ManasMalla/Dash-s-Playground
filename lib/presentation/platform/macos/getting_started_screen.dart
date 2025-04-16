import 'package:dash_playground/controllers/initialization_controller.dart';
import 'package:dash_playground/presentation/platform/macos/installation_screen.dart';
import 'package:dash_playground/providers/installation_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path_provider/path_provider.dart';

class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> installationDirectory =
        ValueNotifier<String>("~/development/");
    getApplicationSupportDirectory().then(
      (value) {
        installationDirectory.value =
            value.path.split("/Library")[0] + "/development";
      },
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Installation Directory"),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: ValueListenableBuilder(
                              valueListenable: installationDirectory,
                              builder: (context, directory, child) {
                                return MacosTextField(
                                  placeholder: "Destination",
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: directory.toString(),
                                  ),
                                );
                              })),
                      const SizedBox(
                        width: 8,
                      ),
                      PushButton(
                        child: const Text("Change directory"),
                        controlSize: ControlSize.regular,
                        onPressed: () {
                          FilePicker.platform.getDirectoryPath().then((value) {
                            if (value != null) {
                              installationDirectory.value = value;
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          FutureBuilder(
              future: InitializationController.fetchJSON(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: ProgressCircle(
                      value: null,
                    ),
                  );
                }
                final dependencies = (snapshot.data as List<Dependency>).map(
                  (e) {
                    return DependencyWithInstallChoice(
                        dependency: e,
                        isSelected: e.name.contains("Flutter SDK")
                            ? e.version == FlutterChannel.stable.name
                            : true);
                  },
                ).toList();
                return StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var dependency = dependencies[index];
                            if (dependency.dependency.name
                                    .contains("Flutter SDK") &&
                                dependency.dependency.version != "stable") {
                              return const SizedBox();
                            }
                            String? chosenFlutterChannel = dependencies
                                .where((element) =>
                                    element.dependency.name
                                        .contains("Flutter SDK") &&
                                    element.isSelected)
                                .firstOrNull
                                ?.dependency
                                .version;
                            return Column(
                              children: [
                                CupertinoListTile(
                                  leading: MacosCheckbox(
                                      value: dependency.isSelected ||
                                          (dependency.dependency.name
                                                  .contains("Flutter")
                                              ? chosenFlutterChannel != null
                                              : false),
                                      onChanged: (value) {
                                        setState(() {
                                          dependency.isSelected = value;
                                        });
                                      }),
                                  title: Row(
                                    children: [
                                      Text(
                                        dependency.dependency.name,
                                        style: MacosTheme.of(context)
                                            .typography
                                            .headline,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      dependency.dependency.version == null
                                          ? const SizedBox()
                                          : Text(
                                              "(${dependency.dependency.version})",
                                              style: MacosTheme.of(context)
                                                  .typography
                                                  .subheadline,
                                            )
                                    ],
                                  ),
                                  trailing: Text(
                                    dependency.dependency.size.toString() +
                                        " MiB",
                                    style: MacosTheme.of(context)
                                        .typography
                                        .footnote,
                                  ),
                                ),
                                dependency.dependency.name
                                            .contains("Flutter SDK") &&
                                        (chosenFlutterChannel != null)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, bottom: 12, left: 72),
                                        child: Row(
                                          children: [
                                            MacosRadioButton(
                                              value: FlutterChannel.stable.name,
                                              groupValue: chosenFlutterChannel,
                                              onChanged: (value) {
                                                dependencies
                                                    .where((dep) => dep
                                                        .dependency.name
                                                        .contains(
                                                            "Flutter SDK"))
                                                    .forEach((element) {
                                                  if (element
                                                          .dependency.version ==
                                                      "stable") {
                                                    element.isSelected = true;
                                                  } else {
                                                    element.isSelected = false;
                                                  }
                                                });
                                                setState(
                                                  () {},
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Stable",
                                              style: MacosTheme.of(context)
                                                  .typography
                                                  .subheadline,
                                            ),
                                            const SizedBox(
                                              width: 24,
                                            ),
                                            MacosRadioButton(
                                              value: FlutterChannel.beta.name,
                                              groupValue: chosenFlutterChannel,
                                              onChanged: (value) {
                                                dependencies
                                                    .where((dep) => dep
                                                        .dependency.name
                                                        .contains(
                                                            "Flutter SDK"))
                                                    .forEach((element) {
                                                  if (element
                                                          .dependency.version ==
                                                      "beta") {
                                                    element.isSelected = true;
                                                  } else {
                                                    element.isSelected = false;
                                                  }
                                                });
                                                setState(
                                                  () {},
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Beta",
                                              style: MacosTheme.of(context)
                                                  .typography
                                                  .subheadline,
                                            ),
                                            const SizedBox(
                                              width: 24,
                                            ),
                                            MacosRadioButton(
                                              value: FlutterChannel.master.name,
                                              groupValue: chosenFlutterChannel,
                                              onChanged: (value) {
                                                dependencies
                                                    .where((dep) => dep
                                                        .dependency.name
                                                        .contains(
                                                            "Flutter SDK"))
                                                    .forEach((element) {
                                                  if (element
                                                          .dependency.version ==
                                                      "master") {
                                                    element.isSelected = true;
                                                  } else {
                                                    element.isSelected = false;
                                                  }
                                                });
                                                setState(
                                                  () {},
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Master",
                                              style: MacosTheme.of(context)
                                                  .typography
                                                  .subheadline,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                index == dependencies.length - 1
                                    ? const SizedBox()
                                    : const MacosPulldownMenuDivider()
                              ],
                            );
                          },
                          itemCount: dependencies.length,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        PushButton(
                          child: const Text("Install"),
                          controlSize: ControlSize.regular,
                          onPressed: () {
                            showMacosAlertDialog(
                                context: context,
                                builder: (context) {
                                  return MacosAlertDialog(
                                    appIcon: const MacosIcon(
                                      CupertinoIcons.exclamationmark_triangle,
                                      size: 24,
                                    ),
                                    title: const Text("Confirmation"),
                                    message: Builder(builder: (context) {
                                      final downloadSize = dependencies
                                          .where((dep) => dep.isSelected)
                                          .fold(
                                              0,
                                              (prev, dep) =>
                                                  dep.dependency.size + prev);
                                      return Text(
                                          "Total download size is ${downloadSize > 1024 ? (downloadSize / 1024).toStringAsFixed(2) : downloadSize} ${downloadSize > 1024 ? 'GiB' : 'MiB'}. The installation process may take a while. Do you want to continue?");
                                    }),
                                    primaryButton: PushButton(
                                      child: const Text("Continue"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) {
                                          return const InstallationScreen();
                                        }));
                                      },
                                      controlSize: ControlSize.large,
                                    ),
                                    secondaryButton: PushButton(
                                      secondary: true,
                                      child: const Text("Cancel"),
                                      controlSize: ControlSize.large,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  );
                });
              }),
        ],
      ),
    );
  }
}

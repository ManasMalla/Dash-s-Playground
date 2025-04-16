import 'package:dash_playground/controllers/initialization_controller.dart';
import 'package:dash_playground/providers/installation_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Installation Directory'),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<String>(
                    valueListenable: installationDirectory,
                    builder: (context, _installationDirectory, child) {
                      return TextBox(
                        placeholder: 'C:\\Program Files\\Dash\'s Playground',
                        controller:
                            TextEditingController(text: _installationDirectory),
                        readOnly: true,
                        maxLines: 1,
                      );
                    }),
              ),
              const SizedBox(
                width: 8,
              ),
              Button(
                  child: const Text("Change directory"),
                  onPressed: () {
                    FilePicker.platform.getDirectoryPath().then((value) {
                      if (value != null) {
                        installationDirectory.value = value;
                      }
                    });
                  })
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          FutureBuilder(
              future: InitializationController.fetchJSON(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: ProgressRing(),
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
                                ListTile(
                                  leading: Checkbox(
                                      checked: dependency.isSelected ||
                                          (dependency.dependency.name
                                                  .contains("Flutter")
                                              ? chosenFlutterChannel != null
                                              : false),
                                      onChanged: (value) {
                                        setState(() {
                                          dependency.isSelected =
                                              value ?? false;
                                        });
                                      }),
                                  title: Row(
                                    children: [
                                      Text(
                                        dependency.dependency.name,
                                        style: FluentTheme.of(context)
                                            .typography
                                            .bodyStrong,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      dependency.dependency.version == null
                                          ? const SizedBox()
                                          : Opacity(
                                              opacity: 0.5,
                                              child: Text(
                                                "(${dependency.dependency.version})",
                                                style: FluentTheme.of(context)
                                                    .typography
                                                    .body,
                                              ),
                                            )
                                    ],
                                  ),
                                  trailing: Text(
                                    dependency.dependency.size.toString() +
                                        " MiB",
                                    style: FluentTheme.of(context)
                                        .typography
                                        .caption,
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
                                            RadioButton(
                                              checked: chosenFlutterChannel ==
                                                  FlutterChannel.stable.name,
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
                                              style: FluentTheme.of(context)
                                                  .typography
                                                  .caption,
                                            ),
                                            const SizedBox(
                                              width: 24,
                                            ),
                                            RadioButton(
                                              
                                              checked: chosenFlutterChannel ==
                                                  FlutterChannel.beta.name,
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
                                              style: FluentTheme.of(context)
                                                  .typography
                                                  .caption,
                                            ),
                                            const SizedBox(
                                              width: 24,
                                            ),
                                            RadioButton(
                                              checked: chosenFlutterChannel ==
                                                  FlutterChannel.master.name,
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
                                              style: FluentTheme.of(context)
                                                  .typography
                                                  .caption,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                index == dependencies.length - 1
                                    ? const SizedBox()
                                    : const Divider()
                              ],
                            );
                          },
                          itemCount: dependencies.length,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FilledButton(
                          child: const Text("Install"),
                          onPressed: () {
                            // showMacosAlertDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return MacosAlertDialog(
                            //         appIcon: const MacosIcon(
                            //           FluentIcons.status_triangle_exclamation,
                            //           size: 24,
                            //         ),
                            //         title: const Text("Confirmation"),
                            //         message: Builder(builder: (context) {
                            //           final downloadSize = dependencies
                            //               .where((dep) => dep.isSelected)
                            //               .fold(
                            //                   0,
                            //                   (prev, dep) =>
                            //                       dep.dependency.size + prev);
                            //           return Text(
                            //               "Total download size is ${downloadSize > 1024 ? (downloadSize / 1024).toStringAsFixed(2) : downloadSize} ${downloadSize > 1024 ? 'GiB' : 'MiB'}. The installation process may take a while. Do you want to continue?");
                            //         }),
                            //         primaryButton: PushButton(
                            //           child: const Text("Continue"),
                            //           onPressed: () {
                            //             Navigator.of(context).pop();
                            //             // Navigator.of(context).push(
                            //             //     CupertinoPageRoute(
                            //             //         builder: (context) {
                            //             //   return const InstallationScreen();
                            //             // }));
                            //           },
                            //           controlSize: ControlSize.large,
                            //         ),
                            //         secondaryButton: PushButton(
                            //           secondary: true,
                            //           child: const Text("Cancel"),
                            //           controlSize: ControlSize.large,
                            //           onPressed: () {
                            //             Navigator.of(context).pop();
                            //           },
                            //         ),
                            //       );
                            //     });
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

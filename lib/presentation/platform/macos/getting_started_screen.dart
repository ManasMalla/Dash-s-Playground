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
                // Dependencies without Flutter.
                // Ps. Need to add them at a later stage
                final _dependencies =
                    List<Dependency>.from(snapshot.data ?? []);
                final _flutterDependencies = List<FlutterDependency>.from(
                    _dependencies
                        .where((e) => e.runtimeType == FlutterDependency));
                final dependencies = _dependencies
                    .map(
                      (e) {
                        return DependencyWithInstallChoice(
                            dependency: e, isSelected: true);
                      },
                    )
                    .where((e) => !e.dependency.name.contains("Flutter SDK"))
                    .toList();
                final flutterDependency = DependencyWithInstallChoice(
                    dependency: _dependencies
                        .where((e) => e.name.contains("Flutter SDK"))
                        .first,
                    isSelected: true);

                FlutterChannel chosenFlutterChannel = FlutterChannel.stable;

                return StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            CupertinoListTile(
                              leading: MacosCheckbox(
                                  value: flutterDependency.isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      flutterDependency.isSelected = value;
                                    });
                                  }),
                              title: Text(
                                "Flutter SDK",
                                style:
                                    MacosTheme.of(context).typography.headline,
                              ),
                              trailing: Text(
                                flutterDependency.dependency.size.toString() +
                                    " MiB",
                                style:
                                    MacosTheme.of(context).typography.footnote,
                              ),
                            ),
                            flutterDependency.isSelected
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 12, left: 72),
                                    child: Row(
                                      children: [
                                        MacosRadioButton(
                                          value: FlutterChannel.stable,
                                          groupValue: chosenFlutterChannel,
                                          onChanged: (value) {
                                            chosenFlutterChannel =
                                                FlutterChannel.stable;
                                            setState(
                                              () {},
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Stable (${_flutterDependencies.where((e) => e.channel == FlutterChannel.stable).first.version})",
                                          style: MacosTheme.of(context)
                                              .typography
                                              .subheadline,
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        ),
                                        MacosRadioButton(
                                          value: FlutterChannel.beta,
                                          groupValue: chosenFlutterChannel,
                                          onChanged: (value) {
                                            chosenFlutterChannel =
                                                FlutterChannel.beta;
                                            setState(
                                              () {},
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Beta (${_flutterDependencies.where((e) => e.channel == FlutterChannel.beta).first.version})",
                                          style: MacosTheme.of(context)
                                              .typography
                                              .subheadline,
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        ),
                                        MacosRadioButton(
                                          value: FlutterChannel.master,
                                          groupValue: chosenFlutterChannel,
                                          onChanged: (value) {
                                            chosenFlutterChannel =
                                                FlutterChannel.master;
                                            setState(
                                              () {},
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Master (${_flutterDependencies.where((e) => e.channel == FlutterChannel.master).first.version})",
                                          style: MacosTheme.of(context)
                                              .typography
                                              .subheadline,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            const MacosPulldownMenuDivider()
                          ],
                        ),
                        ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var dependency = dependencies[index];
                            return Column(
                              children: [
                                CupertinoListTile(
                                  leading: MacosCheckbox(
                                      value: dependency.isSelected,
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
                                  final finalDependencies = [
                                    ...dependencies,
                                    DependencyWithInstallChoice(
                                        dependency: _flutterDependencies
                                            .firstWhere((e) =>
                                                e.channel ==
                                                chosenFlutterChannel),
                                        isSelected:
                                            flutterDependency.isSelected)
                                  ];
                                  return MacosAlertDialog(
                                    appIcon: const MacosIcon(
                                      CupertinoIcons.exclamationmark_triangle,
                                      size: 24,
                                    ),
                                    title: const Text("Confirmation"),
                                    message: Builder(builder: (context) {
                                      final downloadSize = finalDependencies
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

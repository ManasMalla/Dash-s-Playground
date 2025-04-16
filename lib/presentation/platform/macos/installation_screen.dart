import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class InstallationScreen extends StatelessWidget {
  const InstallationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Installing'),
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return const Center(
              child: ProgressCircle(),
            );
          },
        )
      ],
    );
  }
}

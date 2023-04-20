import 'package:flutter/material.dart';

class UninstallScreen extends StatefulWidget {
  const UninstallScreen({Key? key}) : super(key: key);

  @override
  State<UninstallScreen> createState() => _UninstallScreenState();
}

class _UninstallScreenState extends State<UninstallScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Uninstall",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            width: 600,
            child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean placerat sapien at porttitor malesuada. Etiam accumsan imperdiet ante in iaculis. Proin metus tellus, sollicitudin sit amet aliquet vel, iaculis eu orci. Fusce vitae mi at lorem vehicula hendrerit. Donec eget purus sed dolor egestas placerat. Morbi sed semper ligula. Interdum et malesuada fames ac ante ipsum primis in faucibus."),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

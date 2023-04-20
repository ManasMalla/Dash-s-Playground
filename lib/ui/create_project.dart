import 'package:flutter/material.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  Set<String> selectedTemplate = {"Application"};
  Set<String> selectedPlatforms = {"Android", "iOS"};
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Project",
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
          Row(
            children: [
              Text("Template: ",
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(
                width: 32,
              ),
              SegmentedButton<String>(
                segments: [
                  "Application",
                  "Module",
                  "Package",
                  "Plugin",
                  "Plugin FFI",
                  "Sketelon"
                ].map((e) {
                  return ButtonSegment(
                    value: e,
                    label: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Text(e),
                    ),
                  );
                }).toList(),
                selected: selectedTemplate,
                onSelectionChanged: (_) {
                  setState(() {
                    selectedTemplate = _;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 48,
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Name"),
              )),
              SizedBox(
                width: 48,
              ),
              Expanded(
                  child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Package Name"),
              )),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Location",
                prefixIcon: Icon(Icons.folder_rounded)),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            children: ["Android", "iOS", "macOS", "Windows", "Desktop", "Web"]
                .map((e) {
              return InputChip(
                label: Text(e),
                onSelected: (_) {},
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

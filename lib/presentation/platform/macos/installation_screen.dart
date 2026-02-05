import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class InstallationScreen extends StatelessWidget {
  const InstallationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF121212),
      child: MacosScaffold(
        toolBar: const ToolBar(
          title: Text('Installing'),
        ),
        children: [
          ContentArea(
            builder: (context, scrollController) {
              return Center(
                child: Column(
                  children: [
                    Image.network(
                        "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg5lKYrnAXMqPfQH_kfCRWRp5iCWkTkzPkNM2n4QXw5D4nQfGDHc9NsEG4txBKEMQKhpwJiuQpN6E5rQ3sDOY9QXR_ckW15sQHRzJfPmaq1RctpRV9T5GoNS1iGSp94DeWlLQqqqehPOCJoZh8nQx_g31ynmJl8MtAW2Z_Fms1yxQPBmSRAQVDxsu1hEiw/w1200-h630-p-k-no-nu/Otter%20Meta-100.jpg"),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

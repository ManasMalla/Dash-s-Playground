import 'package:flutter/material.dart';

class DashsPlaygroundApp extends StatelessWidget {
  const DashsPlaygroundApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dash\'s Playground',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dash\'s Playground'),
        ),
        body: const Center(
          child: Text('Welcome to Dash\'s Playground!'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WardenPage extends StatefulWidget {
  const WardenPage({super.key});

  @override
  State<WardenPage> createState() => _WardenPageState();
}

class _WardenPageState extends State<WardenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warden'),
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: Column(),
    );
  }
}

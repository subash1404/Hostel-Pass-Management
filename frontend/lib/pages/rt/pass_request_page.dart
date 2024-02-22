import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hostel_pass_management/widgets/rt/custom_drawer.dart';

class PassRequestPage extends StatefulWidget {
  const PassRequestPage({super.key});

  @override
  State<PassRequestPage> createState() => _PassRequestPageState();
}

class _PassRequestPageState extends State<PassRequestPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pass Request"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Student Name",
              textAlign: TextAlign.center,
              style: textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: const Icon(
              Icons.person,
              size: 60,
            ),
          ),
          const SizedBox(height: 20),
          const Divider()
        ],
      ),
    );
  }
}

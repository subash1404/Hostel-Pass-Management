import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';

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
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 198, 198),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Deny",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 57, 43),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 179, 255, 181),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Approve",
                      style: TextStyle(
                        color: Color.fromARGB(255, 57, 139, 60),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

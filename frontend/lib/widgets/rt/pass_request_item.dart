import 'package:flutter/material.dart';
import 'package:hostel_pass_management/pages/rt/pass_request_page.dart';

class PassRequestItem extends StatelessWidget {
  const PassRequestItem({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PassRequestPage(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Student Name",
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("Gatepass")
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 0)
        ],
      ),
    );
  }
}

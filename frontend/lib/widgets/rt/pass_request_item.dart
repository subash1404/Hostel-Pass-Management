import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/rt/pass_request_page.dart';

class PassRequestItem extends StatelessWidget {
  const PassRequestItem(
      {required this.pass, required this.passRequest, super.key});
  final PassRequest pass;
  final bool passRequest;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PassRequestPage(
              pass: pass,
              passRequest: passRequest,
            ),
          ),
        );
      },
      child: Container(
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
                  pass.studentName,
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
    );
  }
}

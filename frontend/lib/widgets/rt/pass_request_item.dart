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
              alignment: Alignment.center,
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Text(
                pass.studentName[0],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    pass.studentName,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(pass.type)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

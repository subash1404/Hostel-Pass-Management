import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
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
        width: MediaQuery.of(context).size.width,
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    pass.studentName,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(pass.type),
                      if (pass.status == "Used" && !passRequest && pass.isLate!)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            // color: Color.fromARGB(110, 230, 57, 103),
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "LATE",
                            style: textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.error),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

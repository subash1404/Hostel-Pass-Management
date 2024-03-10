import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/pass_model.dart';

class PassLog extends StatelessWidget {
  const PassLog({
    required this.passlog,
    super.key,
  });

  final List<Pass> passlog;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Text(
              "Pass Log",
              style: textTheme.titleLarge,
            ),
          ),
          const Divider(
            height: 0,
          ),
          if (passlog.isEmpty)
            Expanded(
              child: const Center(
                child: Text("Empty Log"),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: passlog.map((pass) {
                    return Container(
                      // decoration: BoxDecoration(
                      //   border: Border(bottom: BorderSide(color: Colors.grey)),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.place),
                                      Text(
                                        ' ${pass.destination}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_today),
                                      SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${pass.expectedInDate} - ${pass.expectedOutDate}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            '${pass.expectedInTime} - ${pass.expectedOutTime}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.only(right: 8),
                              alignment: Alignment.center,
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.blue,
                                //   borderRadius: BorderRadius.circular(8),
                                // ),
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  pass.type,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

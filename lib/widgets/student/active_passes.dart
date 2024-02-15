import 'package:flutter/material.dart';
import 'package:hostel_pass_management/widgets/student/pass_item.dart';

class ActivePasses extends StatelessWidget {
  const ActivePasses({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(15),
      // padding: EdgeInsets.all(20),
      width: double.infinity,
      height: 200,
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
              "Active Passes",
              style: textTheme.titleLarge,
            ),
          ),
          const Divider(height: 0),
          const Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PassItem(
                  dateTime: "12 / 04 / 2024  5:30pm",
                  type: "Gatepass",
                  status: "Rejected",
                ),
                // Center(
                //   child: Text("No Currently Active Passes"),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

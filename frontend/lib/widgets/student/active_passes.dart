import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/widgets/student/pass_item.dart';

class ActivePasses extends StatelessWidget {
  const ActivePasses({
    super.key,
    required this.pass,
  });
  final Pass? pass;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(15),
      // padding: EdgeInsets.all(20),
      width: double.infinity,
      // height: 175,
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
              "Active Pass",
              style: textTheme.titleLarge,
            ),
          ),
          const Divider(height: 0),
          Column(
            children: [
              if (pass != null)
                PassItem(
                  inTime: pass!.inTime,
                  outTime: pass!.outTime,
                  inDate: pass!.inDate,
                  outDate: pass!.outDate,
                  type: pass!.type,
                  status: pass!.status,
                )
              else
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text("No Currently Active Passes"),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

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
                child: DataTable(
                  columnSpacing: 20,
                  dataRowMaxHeight: 60,
                  columns: const [
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('From')),
                    DataColumn(label: Text('To')),
                    DataColumn(label: Text('Type')),
                  ],
                  rows: passlog
                      .map(
                        (pass) => DataRow(
                          cells: [
                            DataCell(Text(pass.status)),
                            DataCell(Text("${pass.expectedInDate} ${pass.expectedInTime}")),
                            DataCell(Text("${pass.expectedOutDate} ${pass.expectedOutTime}")),
                            DataCell(Text(pass.type)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

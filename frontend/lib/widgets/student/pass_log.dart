import 'package:flutter/material.dart';

class PassLog extends StatelessWidget {
  const PassLog({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      width: double.infinity,
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
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 20,
                dataRowMaxHeight: 60,
                columns: const [
                  DataColumn(label: Text('S.No')),
                  DataColumn(label: Text('From')),
                  DataColumn(label: Text('To')),
                  DataColumn(label: Text('Type')),
                ],
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('12/02/2024 5:30 AM')),
                      DataCell(Text('Gatepass')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

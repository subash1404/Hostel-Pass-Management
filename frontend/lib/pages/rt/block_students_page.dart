import 'package:flutter/material.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';

class BlockStudentsPage extends StatefulWidget {
  const BlockStudentsPage({super.key});

  @override
  State<BlockStudentsPage> createState() => _BlockStudentsPageState();
}

class _BlockStudentsPageState extends State<BlockStudentsPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const RtDrawer(),
      appBar: AppBar(
        title: const Text('SVCE Hostel'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text(
              "Pass Requests",
              style: textTheme.titleLarge,
            ),
          ),
          const Divider(height: 0),
          DataTable(
            headingRowHeight: 30,
            dataRowMinHeight: 75,
            dataRowMaxHeight: 75,
            horizontalMargin: 15,
            columns: const [
              DataColumn(label: Text('Student Details')),
              DataColumn(
                label: Text('Year'),
              ),
              DataColumn(label: Text('Dept')),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primaryContainer,
                          ),
                          child: Text(
                            "S",
                            style: textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Student Name",
                              style: textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            const Text("Room No: 304")
                          ],
                        )
                      ],
                    ),
                  ),
                  const DataCell(
                    Text("3"),
                  ),
                  const DataCell(
                    Text("INT"),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}

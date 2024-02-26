import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockStudentsPage extends ConsumerStatefulWidget {
  const BlockStudentsPage({super.key});

  @override
  ConsumerState<BlockStudentsPage> createState() => _BlockStudentsPageState();
}

class _BlockStudentsPageState extends ConsumerState<BlockStudentsPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    final blockStudents = ref.watch(blockStudentProvider);

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
              "Block Students",
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
            rows: blockStudents
                .map(
                  (student) => DataRow(
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
                                student.username[0],
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
                                  student.username,
                                  style: textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Text("Room No: ${student.roomNo}")
                              ],
                            )
                          ],
                        ),
                      ),
                      DataCell(
                        Text((student.block).toString()),
                      ),
                      DataCell(
                        Text(
                          student.dept,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}

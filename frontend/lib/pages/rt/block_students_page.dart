import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/pages/student/student_profile_page.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockStudentsPage extends ConsumerStatefulWidget {
  const BlockStudentsPage({Key? key, this.students, this.blockNo});
  final List<BlockStudent>? students;
  final int? blockNo;

  @override
  ConsumerState<BlockStudentsPage> createState() => _BlockStudentsPageState();
}

class _BlockStudentsPageState extends ConsumerState<BlockStudentsPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    var blockStudents;
    var drawer;
    var appbar;

    if (widget.students == null) {
      blockStudents = ref.watch(blockStudentProvider);
      if (prefs!.getBool('isBoysHostelRt')!) {
        blockStudents =
            blockStudents.where((student) => student.gender == 'M').toList();
      } else {
        blockStudents =
            blockStudents.where((student) => student.gender == 'F').toList();
      }
      drawer = RtDrawer();
      appbar = AppBar(
        title: const Text('Block Students'),
        centerTitle: true,
      );
    } else {
      blockStudents = widget.students;
      drawer = null;
      appbar = null;
    }

    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: drawer,
      appBar: appbar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: blockStudents.length,
              itemBuilder: (BuildContext context, int index) {
                final student = blockStudents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentProfilePage(studentData: student),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.primaryContainer,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    student.username[0],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.username,
                                      style: textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text("Room No: ${student.roomNo}")
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  student.dept,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 1, // Adjust the height as needed
                          thickness: 1, // Adjust the thickness as needed
                          color: Color.fromARGB(255, 219, 219, 219),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

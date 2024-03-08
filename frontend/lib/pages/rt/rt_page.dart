import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/providers/rt_announcement_provider.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RtPage extends ConsumerStatefulWidget {
  const RtPage({super.key, this.warden});
  final bool? warden;

  @override
  ConsumerState<RtPage> createState() => _RtPageState();
}

class _RtPageState extends ConsumerState<RtPage> {
  @override
  Widget build(BuildContext context) {
    final passRequests;
    var students = [];
    int studentsCount = 0;
    int passesCount = 0;
    var drawer;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = RtDrawer();
    }
    if (prefs.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    if (prefs.getString("role") == "rt") {
      passRequests = ref.watch(rtPassProvider);
      students = ref.watch(blockStudentProvider);

      students.forEach((student) {
        studentsCount++;
      });
      students.forEach((student) {
        final studentPasses = passRequests.where((pass) =>
            pass.studentId == student.studentId && pass.status == "In use");
        studentPasses.forEach((pass) {
          passesCount++;
        });
      });
      print("stduents $studentsCount");
      print("pases $passesCount");
    } else {
      passRequests = ref.watch(specialPassProvider);
    }

    List<PassRequest> pendingPasses =
        passRequests.where((pass) => pass.status == 'Pending').toList();
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('SVCE Hostel'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Visibility(
                visible: studentsCount != 0,
                child: Text(
                  "Total Students: $studentsCount \n Students Outside: $passesCount",
                  style: textTheme.titleLarge,
                ),
              )),
          if (pendingPasses.length == 0)
            const Expanded(
              child: Center(
                child: Text("No pass requests. Enjoy!!"),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return PassRequestItem(
                    pass: pendingPasses[index],
                    passRequest: true,
                  );
                },
                itemCount: pendingPasses.length,
              ),
            ),
        ],
      ),
    );
  }
}

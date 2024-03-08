import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';

class StatsPage extends ConsumerStatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  @override
  Widget build(BuildContext context) {
    final students = ref.watch(hostelStudentProvider);
    final passes = ref.watch(specialPassProvider);

    List<int> blockCounts = [0, 0, 0, 0, 0, 0];
    List<int> passCount = [0, 0, 0, 0, 0, 0];

    students.forEach((student) {
      blockCounts[student.blockNo - 1]++;
    });
    students.forEach((student) {
      final studentPasses = passes.where((pass) =>
          pass.studentId == student.studentId && pass.status == "In use");
      studentPasses.forEach((pass) {
        passCount[student.blockNo - 1]++;
      });
    });

    // Build cards for each block
    List<Widget> blockCards = List.generate(6, (index) {
      return Card(
        child: ListTile(
          title: Text('Block ${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Students Out: ${passCount[index]}'),
              Text('Students In: ${blockCounts[index] - passCount[index]}'),
              Text('Total Students: ${blockCounts[index]}'),
            ],
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Stats Page'),
      ),
      drawer: WardenDrawer(),
      body: ListView(
        children: blockCards,
      ),
    );
  }
}

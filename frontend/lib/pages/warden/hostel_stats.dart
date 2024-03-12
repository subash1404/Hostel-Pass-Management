import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/warden/block_details_page.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/widgets/warden/block_tile.dart';
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
    List<PassRequest> inUsePasses =
        passes.where((pass) => pass.status == "In use").toList();
    List<PassRequest> usedPasses =
        passes.where((pass) => pass.status == "Used").toList();

    int totalStudentsIn =
        blockCounts.reduce((value, element) => value + element);
    int totalStudentsOut =
        passCount.reduce((value, element) => value + element);
    int NO_OF_BLOCKS = blockCounts.length;
    List<Widget> blockTiles = [];
    for (int i = 0; i < NO_OF_BLOCKS; i += 2) {
      blockTiles.add(
        Row(
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlockDetailPage(
                            blockNo: i + 1,
                            inUsePasses: inUsePasses,
                            students: students
                                .where((student) => student.blockNo == i + 1)
                                .toList(),
                            usedPasses: usedPasses,
                          )));
                },
                child: BlockTile(
                  blockName: "Block ${i + 1}",
                  inCount: blockCounts[i],
                  outCount: passCount[i],
                ),
              ),
            ),
            if (i + 1 < NO_OF_BLOCKS)
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlockDetailPage(
                              blockNo: i + 1,
                              inUsePasses: inUsePasses,
                              students: students
                                  .where((student) => student.blockNo == i + 2)
                                  .toList(),
                              usedPasses: usedPasses,
                            )));
                  },
                  child: BlockTile(
                    blockName: "Block ${i + 2}",
                    inCount: blockCounts[i + 1],
                    outCount: passCount[i + 1],
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 244, 250),
      appBar: AppBar(
        title: Text('Stats and Blocks'),
      ),
      drawer: WardenDrawer(),
      body: ListView(
        children: [
          ...blockTiles,
          BlockTile(
              blockName: "Overall Count",
              inCount: totalStudentsIn,
              outCount: totalStudentsOut)
        ],
      ),
    );
  }
}

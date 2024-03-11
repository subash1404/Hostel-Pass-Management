import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/warden/block_details_page.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/warden/block_tile.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPage extends ConsumerStatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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

    int totalStudentsIn =
        blockCounts.reduce((value, element) => value + element);
    int totalStudentsOut =
        passCount.reduce((value, element) => value + element);

    List<Widget> cardRows = [];
    for (int i = 0; i < 6; i += 2) {
      // final color = Theme.of(context).colorScheme.onSecondaryContainer;
      final color = Color.fromARGB(255, 234, 233, 233);
      // final color = Color.fromARGB(255, 0, 44, 80);

      final card1 = _buildCard(color, i, blockCounts, passCount);
      final card2 = _buildCard(color, i + 1, blockCounts, passCount);

      cardRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [card1, card2],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 244, 250),
      appBar: AppBar(
        title: Text('Stats and Blocks'),
      ),
      drawer: WardenDrawer(),
      // backgroundColor: Color.fromARGB(255, 231, 231, 231),
      // body: ListView(
      //   padding: EdgeInsets.all(8.0),
      //   children: [
      //     ...cardRows,
      //     _buildOverallCountRow(totalStudentsIn, totalStudentsOut),
      //   ],
      // ),
      body: Column(
        children: [
          Row(
            children: [
              BlockTile(),
              BlockTile(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(
      Color color, int index, List<int> blockCounts, List<int> passCount) {
    return Expanded(
      child: Card(
        color: color,
        elevation: 2,
        shadowColor: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Block ${index + 1}',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'In: ${blockCounts[index] - passCount[index]}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Out: ${passCount[index]}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallCountRow(int totalStudentsIn, int totalStudentsOut) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Color.fromARGB(255, 234, 233, 233),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Overall Count',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, color: Colors.green),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'In: $totalStudentsIn',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.red),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Out: $totalStudentsOut',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/pages/rt/block_students_page.dart';
import 'package:hostel_pass_management/pages/warden/warden_pass_logs_page.dart';

class BlockDetailPage extends StatefulWidget {
  const BlockDetailPage(
      {super.key,
      required this.students,
      required this.inUsePasses,
      required this.usedPasses,
      required this.blockNo});
  final List<BlockStudent> students;
  final List<PassRequest> inUsePasses;
  final List<PassRequest> usedPasses;
  final int blockNo;
  @override
  State<BlockDetailPage> createState() {
    return _BlockDetailPageState();
  }
}

class _BlockDetailPageState extends State<BlockDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isGatePass = true;
  bool isStayPass = true;

  late List<PassRequest> originalInUsePasses;
  late List<PassRequest> originalUsedPasses;

  List<PassRequest> _inUsePasses = [];
  List<PassRequest> _usedPasses = [];

  @override
  void initState() {
    super.initState();
    originalInUsePasses = widget.inUsePasses;
    originalUsedPasses = widget.usedPasses;
    _inUsePasses = List.from(originalInUsePasses);
    _usedPasses = List.from(originalUsedPasses);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void changeFilter() {
    setState(() {
      if (isGatePass && isStayPass) {
        _inUsePasses = originalInUsePasses
            .where((element) =>
                element.type == "GatePass" || element.type == "StayPass")
            .toList();
        _usedPasses = originalUsedPasses
            .where((element) =>
                element.type == "GatePass" || element.type == "StayPass")
            .toList();
      } else if (!isGatePass && !isStayPass) {
        _inUsePasses.clear();
        _usedPasses.clear();
      } else if (isGatePass) {
        _inUsePasses = originalInUsePasses
            .where((element) => element.type == "GatePass")
            .toList();
        _usedPasses = originalUsedPasses
            .where((element) => element.type == "GatePass")
            .toList();
      } else if (isStayPass) {
        _inUsePasses = originalInUsePasses
            .where((element) => element.type == "StayPass")
            .toList();
        _usedPasses = originalUsedPasses
            .where((element) => element.type == "StayPass")
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Block Detail'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (value) => setState(() {}),
          tabs: const [
            Tab(
              text: 'Details',
            ),
            Tab(text: 'In use'),
            Tab(text: 'Used'),
          ],
        ),
      ),
      body: Column(
        children: [
          _tabController.index != 0 ? SizedBox(height: 10) : SizedBox(),
          _tabController.index != 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 18),
                    FilterChip(
                      label: const Text("GatePass"),
                      onSelected: (val) {
                        setState(() {
                          isGatePass = val;
                        });
                        changeFilter();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(0),
                      selected: isGatePass,
                    ),
                    const SizedBox(width: 10),
                    FilterChip(
                      label: const Text("StayPass"),
                      onSelected: (val) {
                        setState(() {
                          isStayPass = val;
                        });
                        changeFilter();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(0),
                      selected: isStayPass,
                    ),
                  ],
                )
              : SizedBox(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BlockStudentsPage(
                  students: widget.students,
                ),
                WardenPassLogPage(
                    passes: _inUsePasses, blockNo: widget.blockNo),
                WardenPassLogPage(
                  blockNo: widget.blockNo,
                  passes: _usedPasses,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

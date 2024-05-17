import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassLogsPage extends ConsumerStatefulWidget {
  PassLogsPage({Key? key, this.inUsePasses, this.usedPasses, this.blockNo})
      : super(key: key);
  List<PassRequest>? inUsePasses;
  List<PassRequest>? usedPasses;
  final int? blockNo;
  @override
  ConsumerState<PassLogsPage> createState() => _PassLogsPageState();
}

class _PassLogsPageState extends ConsumerState<PassLogsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isGatePass = true;
  bool isStayPass = true;

  List<PassRequest> originalInUsePasses = [];
  List<PassRequest> originalUsedPasses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize the original lists based on the role
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    if (prefs!.getString("role") == "warden" &&
        widget.inUsePasses != null &&
        widget.usedPasses != null) {
      originalInUsePasses = widget.inUsePasses!
          .where((pass) => pass.blockNo == widget.blockNo)
          .toList();
      originalUsedPasses = widget.usedPasses!
          .where((pass) => pass.blockNo == widget.blockNo)
          .toList();
    } else if (prefs.getString("role") == "rt") {
      final passRequests = ref.read(rtPassProvider);
      if (prefs.getBool('isBoysHostelRt')!) {
        originalInUsePasses = passRequests
            .where((pass) => pass.status == 'In use' && pass.gender == 'M')
            .toList();
        originalUsedPasses = passRequests
            .where((pass) => pass.status == 'Used' && pass.gender == 'M')
            .toList();
      } else {
        originalInUsePasses = passRequests
            .where((pass) => pass.status == 'In use' && pass.gender == 'F')
            .toList();
        originalUsedPasses = passRequests
            .where((pass) => pass.status == 'Used' && pass.gender == 'F')
            .toList();
      }
    }
    // Initialize the state with the original lists
    setState(() {
      _inUsePasses = originalInUsePasses;
      _usedPasses = originalUsedPasses;
    });
  }

  List<PassRequest> _inUsePasses = [];
  List<PassRequest> _usedPasses = [];

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
    var drawer;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    if (prefs!.getString("role") == "student") {
      drawer = const StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = const RtDrawer();
    }
    if (prefs.getString("role") == "warden") {
      drawer = const WardenDrawer();
    }

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: const Text('Pass Logs'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'In Use'),
            Tab(text: 'Used'),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 18),
                    FilterChip(
                      label: const Text("GatePass"),
                      labelPadding: EdgeInsets.symmetric(horizontal: 12),
                      showCheckmark: false,
                      onSelected: (val) {
                        setState(() {
                          isGatePass = val;
                        });
                        changeFilter();
                      },
                      // selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(0),
                      selected: isGatePass,
                    ),
                    const SizedBox(width: 10),
                    FilterChip(
                      label: const Text("StayPass"),
                      // selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
                      labelPadding: EdgeInsets.symmetric(horizontal: 12),
                      showCheckmark: false,
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
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: _inUsePasses.length,
                  itemBuilder: (context, index) {
                    return PassRequestItem(
                      pass: _inUsePasses[index],
                      passRequest: false,
                    );
                  },
                ),
                ListView.builder(
                  itemCount: _usedPasses.length,
                  itemBuilder: (context, index) {
                    return PassRequestItem(
                      pass: _usedPasses[index],
                      passRequest: false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

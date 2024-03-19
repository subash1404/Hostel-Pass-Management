import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';

class WardenPassRequestPage extends ConsumerStatefulWidget {
  const WardenPassRequestPage({Key? key}) : super(key: key);

  @override
  _WardenPassRequestPageState createState() => _WardenPassRequestPageState();
}

class _WardenPassRequestPageState extends ConsumerState<WardenPassRequestPage> {
  @override
  Widget build(BuildContext context) {
    final passRequests = ref.watch(specialPassProvider);
    final List<PassRequest> pendingPasses =
        passRequests.where((pass) => pass.status == 'Pending').toList();

    return Scaffold(
      drawer: const WardenDrawer(),
      appBar: AppBar(
        title: const Text('SVCE Hostel'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Boys'),
                Tab(text: 'Girls'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPasses(pendingPasses, 'M'),
                  _buildPasses(pendingPasses, 'F'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasses(List<PassRequest> passes, String gender) {
    final filteredPasses =
        passes.where((pass) => pass.gender == gender).toList();

    if (filteredPasses.isEmpty) {
      return Center(
        child: Text('No pass requests'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          return PassRequestItem(
            pass: filteredPasses[index],
            passRequest: true,
          );
        },
        itemCount: filteredPasses.length,
      );
    }
  }
}

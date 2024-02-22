import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/widgets/rt/custom_drawer.dart';
import 'package:hostel_pass_management/widgets/rt/pass_request_item.dart';

class RtPage extends StatefulWidget {
  const RtPage({super.key});

  @override
  State<RtPage> createState() => _RtPageState();
}

class _RtPageState extends State<RtPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: RtDrawer(),
      appBar: AppBar(
        title: Text('SVCE Hostel'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text(
              "Pass Requests",
              style: textTheme.titleLarge,
            ),
          ),
          PassRequestItem(),
          PassRequestItem(),
          PassRequestItem(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/announcement_model.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/pages/student/new_pass_page.dart';
import 'package:hostel_pass_management/providers/student_announcement_provider.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/student/active_passes.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/student/pass_log.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentPage extends ConsumerStatefulWidget {
  const StudentPage({super.key});

  @override
  ConsumerState<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends ConsumerState<StudentPage> {
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  @override
  Widget build(BuildContext context) {
    final List<Pass> passes = ref.watch(studentPassProvider);
    final activePass = ref.read(studentPassProvider.notifier).getActivePass();
    final List<Announcement>? announcement =
        ref.read(studentAnnouncementNotifier);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVCE Hostel'),
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  scrollControlDisabledMaxHeightRatio: 0.5,
                  context: context,
                  builder: (context) {
                    return announcement!.isNotEmpty
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SingleChildScrollView(
                                child: ListTile(
                                  title: Text(
                                    announcement[0].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                  subtitle: Text(
                                    announcement[0].message,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: const Align(
                              alignment: Alignment.topLeft,
                              child: Center(
                                child: Text("No announcements"),
                              ),
                            ),
                          ); // Return empty SizedBox if there's no announcement
                  },
                );
              },
              icon: const Icon(Icons.notifications_none))
        ],
      ),
      floatingActionButton: Hero(
        tag: "newpass",
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          child: InkWell(
            onTap: activePass == null
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewPassPage(),
                      ),
                    );
                  }
                : () {
                    showModalBottomSheet(
                      scrollControlDisabledMaxHeightRatio: 0.7,
                      context: context,
                      builder: (context) {
                        return QrBottomSheet();
                      },
                    );
                  },
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              width: 130,
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      activePass == null ? Icons.add : Icons.qr_code_rounded,
                      size: 25,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    Text(activePass == null ? "New Pass" : "Show QR")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      drawer: const StudentDrawer(),
      body: Column(
        children: [
          ActivePasses(
            pass: activePass,
          ),
          Expanded(
            child: PassLog(
              passlog: passes,
            ),
          ),
        ],
      ),
    );
  }
}

class QrBottomSheet extends ConsumerStatefulWidget {
  QrBottomSheet({super.key});

  @override
  ConsumerState<QrBottomSheet> createState() => _QrBottomSheetState();
}

class _QrBottomSheetState extends ConsumerState<QrBottomSheet> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Pass activePass = ref.read(studentPassProvider.notifier).getActivePass()!;

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: colorScheme.background,
            ),
            child: Column(
              children: [
                Text(
                  "Scan QR at Entrance",
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.width * .85,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorScheme.primaryContainer,
                  ),
                  child: activePass.status == "Approved"
                      ? QrImageView(
                          data: activePass.qrId,
                          semanticsLabel: "skuf",
                        )
                      : const Center(
                          child: Text("Pass not yet approved"),
                        ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Use this QR for Exit and Entry",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

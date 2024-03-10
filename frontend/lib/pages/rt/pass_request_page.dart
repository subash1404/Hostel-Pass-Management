import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_pass_management/models/pass_model.dart';
import 'package:hostel_pass_management/models/pass_request_model.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/pass_tile.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassRequestPage extends ConsumerStatefulWidget {
  const PassRequestPage({
    required this.pass,
    required this.passRequest,
    super.key,
  });

  final PassRequest pass;
  final bool passRequest;
  @override
  ConsumerState<PassRequestPage> createState() {
    return _PassRequestPageState();
  }
}

class _PassRequestPageState extends ConsumerState<PassRequestPage> {
  @override
  var selectedParent = null;
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    bool warden = false;
    if (prefs!.getString("role") == "warden") {
      warden = true;
    }
    if (prefs.getString("role") == "rt") {
      warden = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pass Request"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: colorScheme.primaryContainer,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            height: 60,
                            width: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 30,
                            )),
                        // const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // prefs!.getString("username")!,
                              // "Naveen Naveen Naveen Naveen Naveen",
                              widget.pass.studentName,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              style: textTheme.bodyLarge!.copyWith(
                                color: const Color.fromARGB(255, 25, 32, 42),
                                // color: Color.fromARGB(255, 112, 106, 106),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.pass.roomNo} / ${widget.pass.dept}",
                              style: textTheme.bodyMedium!.copyWith(
                                color: const Color.fromARGB(255, 96, 102, 110),
                                // fontSize: 17,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: PassTile(
                      title: "Pass Type",
                      content: widget.pass.type,
                    ),
                  ),
                  Expanded(
                    child: PassTile(
                      title: "Destination",
                      content: widget.pass.destination,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: PassTile(
                      title: "Leave On",
                      content:
                          "${widget.pass.expectedOutDate}\n${widget.pass.expectedOutTime}",
                    ),
                  ),
                  Expanded(
                    child: PassTile(
                      title: "Return On",
                      content:
                          "${widget.pass.expectedInDate}\n${widget.pass.expectedInTime}",
                    ),
                  ),
                ],
              ),
              Container(
                  width: double.infinity,
                  child:
                      PassTile(title: "Reason", content: widget.pass.reason)),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'PASS INFORMATION',
              //         style: textTheme.bodyLarge!.copyWith(
              //           fontWeight: FontWeight.bold,
              //           color: const Color.fromARGB(255, 30, 75, 130),
              //         ),
              //       ),
              //       Container(
              //         margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              //         decoration: BoxDecoration(
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black.withOpacity(0.2),
              //               spreadRadius: 1,
              //               blurRadius: 1,
              //               offset: const Offset(0, 1),
              //             ),
              //           ],
              //           borderRadius: BorderRadius.circular(20),
              //           color: Colors.white,
              //         ),
              //         child: Column(
              //           children: [
              //             ProfileItem(
              //               attribute: "Pass Type",
              //               value: widget.pass.type,
              //             ),
              //             const Divider(height: 0),
              //             ProfileItem(
              //               attribute: "Destination",
              //               value: widget.pass.destination,
              //             ),
              //             const Divider(height: 0),
              //             ProfileItem(
              //               attribute: "Leave On",
              //               value:
              //                   "${widget.pass.expectedOutDate} / ${widget.pass.expectedOutTime}",
              //             ),
              //             const Divider(height: 0),
              //             ProfileItem(
              //               attribute: "Return On",
              //               value:
              //                   "${widget.pass.expectedInDate} / ${widget.pass.expectedInTime}",
              //             ),
              //             const Divider(height: 0),
              //             ProfileItem(
              //                 attribute: "Reason", value: widget.pass.reason),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Card(
                elevation: 1, // Adjust the elevation as needed
                margin: const EdgeInsets.all(8), // Adjust the margin as needed
                child: Padding(
                  padding:
                      const EdgeInsets.all(16), // Adjust the padding as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6), // Adjust the height as needed
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                // Call function to make a call to mother's number
                              },
                              child: Ink(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                  // border: Border.all(
                                  //     width: 3,
                                  //     color: Colors.grey[
                                  //         200]!)
                                ), // Adjust the background color as needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Mother',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            6), // Adjust the height as needed
                                    Text(
                                      widget.pass.motherPhNo,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {},
                              child: Ink(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Father',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      widget.pass.fatherPhNo,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 1,
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirmed With',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedParent = 'father';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                  color: selectedParent == 'father'
                                      ? const Color.fromARGB(255, 1, 46, 76)
                                      : Colors.grey[300]!,
                                ), // Add border color
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'Father',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedParent = 'mother';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                  color: selectedParent == 'mother'
                                      ? const Color.fromARGB(255, 1, 46, 76)
                                      : Colors.grey[300]!,
                                ), // Add border color
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'Mother',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Visibility(
                visible: widget.passRequest,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 198, 198),
                          ),
                          onPressed: warden
                              ? () async {
                                  ref
                                      .read(specialPassProvider.notifier)
                                      .rejectPassRequest(widget.pass.passId);
                                  Navigator.of(context).pop();
                                }
                              : () async {
                                  ref
                                      .read(rtPassProvider.notifier)
                                      .rejectPassRequest(widget.pass.passId);
                                  Navigator.of(context).pop();
                                },
                          child: const Text(
                            "Deny",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 57, 43),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 179, 255, 181),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: warden
                              ? () async {
                                  if (selectedParent != null) {
                                    ref
                                        .read(
                                          specialPassProvider.notifier,
                                        )
                                        .approvePassRequest(
                                          widget.pass.passId,
                                          selectedParent!,
                                        );
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .clearMaterialBanners();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please select a parent.'),
                                      ),
                                    );
                                  }
                                }
                              : () async {
                                  if (selectedParent != null) {
                                    ref
                                        .read(rtPassProvider.notifier)
                                        .approvePassRequest(
                                          widget.pass.passId,
                                          selectedParent!,
                                        );
                                    Navigator.of(context).pop();
                                  } else {
                                    // Handle case where no parent is selected
                                    ScaffoldMessenger.of(context)
                                        .clearMaterialBanners();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Please select a parent.'),
                                    ));
                                  }
                                },
                          child: const Text(
                            "Approve",
                            style: TextStyle(
                              color: Color.fromARGB(255, 57, 139, 60),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

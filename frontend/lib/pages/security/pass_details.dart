import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_pass_management/models/block_student_model.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/logout_tile.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/security/security_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PassDetails extends StatefulWidget {
  const PassDetails({super.key, required this.qrData});
  final String qrData;

  @override
  State<PassDetails> createState() => _PassDetailsState();
}

class _PassDetailsState extends State<PassDetails> {
  String? profileBuffer;
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  bool isPassLoading = false;
  bool isButtonLoading = false;
  late var passData;

  void getPass() async {
    setState(() {
      isPassLoading = true;
    });
    try {
      var passResponse = await http.get(
        Uri.parse(
            "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/getDetails/${widget.qrData}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs!.getString("jwtToken")!,
        },
      );

      passData = jsonDecode(passResponse.body);

      if (passResponse.statusCode > 399) {
        throw passData["message"];
      }
      print(passData);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    } finally {
      setState(() {
        isPassLoading = false;
      });
    }
  }

  // void confirmScan() async {
  //   setState(() {
  //     isButtonLoading = true;
  //   });
  //   try {
  //     response = await http.post(
  //       Uri.parse(
  //           "${dotenv.env["BACKEND_BASE_API"]}/${prefs!.getString("role")}/pass/confirmScan/${widget.qrData}"),
  //       body: jsonEncode({"action": "ENTRY"}),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": prefs!.getString("jwtToken")!,
  //       },
  //     );

  //     var responseData = jsonDecode(response.body);

  //     if (response.statusCode > 399) {
  //       throw responseData["message"];
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).clearSnackBars();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Something went wrong"),
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       isButtonLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    getPass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // print(prefs!.getString("profileBuffer"));

    return Scaffold(
      body: Scaffold(
        backgroundColor: const Color(0xf5f4fa),
        floatingActionButton: FloatingActionButton.extended(
          // backgroundColor: colorScheme.errorContainer,
          backgroundColor: Color.fromARGB(255, 179, 255, 181),
          onPressed: () {},
          label: Row(
            children: [
              Icon(Icons.check),
              SizedBox(width: 5),
              Text("Confirm Entry"),
            ],
          ),
        ),
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 153, 0, 255),
          // foregroundColor: Colors.white,
          title: const Text(
            "Student Pass",
          ),
          // centerTitle: true,
        ),
        drawer: SecurityDrawer(),
        body: isPassLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.all(30),
                      width: double.infinity,
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
                        color: Color.fromARGB(255, 179, 255, 181),
                        // color: colorScheme.errorContainer,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: profileBuffer == null
                                ? const Icon(
                                    Icons.person_rounded,
                                    size: 100,
                                  )
                                : Image.memory(
                                    base64Decode(profileBuffer!),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            passData["username"],
                            textAlign: TextAlign.center,
                            style: textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                ProfileItem(
                                  attribute: "Room No",
                                  value: passData["roomNo"].toString(),
                                ),
                                const Divider(height: 0),
                                ProfileItem(
                                  attribute: "Pass Type",
                                  value: passData["passType"],
                                ),
                                const Divider(height: 0),
                                ProfileItem(
                                  attribute: "Leaving Time",
                                  value: passData["leavingTime"],
                                ),
                                const Divider(height: 0),
                                ProfileItem(
                                  attribute: "Retruning Time",
                                  value: passData["returningTime"],
                                ),
                                const Divider(height: 0),
                                ProfileItem(
                                  attribute: "Approved by",
                                  value: passData["approvedBy"],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // InkWell(
                          //   onTap: () {},
                          //   borderRadius: BorderRadius.circular(15),
                          //   child: Ink(
                          //     padding: EdgeInsets.symmetric(vertical: 20),
                          //     width: double.infinity,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(15),
                          //       color: Color.fromARGB(255, 179, 255, 181),
                          //     ),
                          //     child: Text(
                          //       "Entry Log",
                          //       style: textTheme.titleMedium!.copyWith(
                          //         fontWeight: FontWeight.bold,
                          //         color: Color.fromARGB(255, 22, 71, 23),
                          //       ),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

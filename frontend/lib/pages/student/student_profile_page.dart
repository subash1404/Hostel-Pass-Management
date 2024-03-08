import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final String? profileBuffer = null;
  SharedPreferences? prefs = SharedPreferencesManager.preferences;

  void fetchProfilePic() {}

  @override
  void initState() {
    fetchProfilePic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextStyle customFont = GoogleFonts.lato();
    // print(prefs!.getString("profileBuffer"));

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 153, 0, 255),
          // foregroundColor: Colors.white,
          title: const Text(
            "Profile",
          ),
          // centerTitle: true,
        ),
        drawer: const StudentDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                // padding: EdgeInsets.all(30),
                color: const Color.fromARGB(255, 242, 242, 242),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      prefs!.getString("username")!,
                      textAlign: TextAlign.center,
                      style: customFont.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.memory(
                        base64Decode(prefs!.getString("profileBuffer")!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Academic Information',
                        style: customFont.copyWith(
                          color: const Color.fromARGB(255, 86, 86, 86),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Year",
                      value: "${prefs!.getInt("year")}",
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Department",
                      value: prefs!.getString("dept")!,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Section",
                      value: prefs!.getString("section")!,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Admission Number",
                      value: prefs!.getString("studentId")!,
                    ),
                    // ProfileItem(
                    //   path: "assets/images/svce.png",
                    //   attribute: "Branch",
                    //   value: "Information Technology",
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Personal Information',
                        style: customFont.copyWith(
                          color: const Color.fromARGB(255, 86, 86, 86),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Email",
                      value: prefs!.getString("dept")!,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Phone No",
                      value: prefs!.getString("phNo")!,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Father's Name",
                      value: prefs!.getString("fatherName")!,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Mother's Name",
                      value: prefs!.getString("motherName")!,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Parent's Phone Number",
                      value:
                          "${prefs!.getString("fatherPhNo")!}  /  ${prefs!.getString("motherPhNo")!}",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Hostel Information',
                        style: customFont.copyWith(
                          color: const Color.fromARGB(255, 86, 86, 86),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Block No",
                      value: prefs!.getInt("blockNo").toString(),
                    ),
                    ProfileItem(
                      path: "assets/images/svce.png",
                      attribute: "Room No",
                      value: prefs!.getInt("roomNo").toString(),
                    ),
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

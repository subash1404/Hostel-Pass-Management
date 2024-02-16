import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_pass_management/widgets/common/profile_item.dart';
import 'package:hostel_pass_management/widgets/student/custom_drawer.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  String? username;
  String? email;
  String? userId;
  String? phno;
  String? city;
  String? college;
  String? branch;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextStyle customFont = GoogleFonts.lato();

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 153, 0, 255),
          // foregroundColor: Colors.white,
          title: const Text("Profile"),
          // centerTitle: true,
        ),
        drawer: const CustomDrawer(),
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
                      "Subash",
                      textAlign: TextAlign.center,
                      style: customFont.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Image.asset(
                      'assets/images/none.png',
                      height: 150,
                      width: 150,
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
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Year",
                        value: "subash@gmail.com"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Department",
                        value: "64623434455"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Section",
                        value: "Chennai"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Admission Number",
                        value: "Sri venkateswara"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Branch",
                        value: "Information Technology"),
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
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Email",
                        value: "subash@gmail.com"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Phone No",
                        value: "64623434455"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Father's Name",
                        value: "Chennai"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Mother's Name",
                        value: "Sri venkateswara"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Parent's Phone Number",
                        value: "Information Technology"),
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
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Block No",
                        value: "subash@gmail.com"),
                    const ProfileItem(
                        path: "assets/images/svce.png",
                        attribute: "Room No",
                        value: "64623434455"),
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

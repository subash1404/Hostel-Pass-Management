import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_pass_management/pages/common/forget_password.dart';
import 'package:hostel_pass_management/pages/rt/rt_page.dart';
import 'package:hostel_pass_management/pages/student/student_page.dart';
import 'package:hostel_pass_management/pages/warden/hostel_stats.dart';
import 'package:hostel_pass_management/pages/warden/warden_page.dart';
import 'package:hostel_pass_management/providers/rt_announcement_provider.dart';
import 'package:hostel_pass_management/providers/block_students_provider.dart';
import 'package:hostel_pass_management/providers/hostel_students_provider.dart';
import 'package:hostel_pass_management/providers/rt_pass_provider.dart';
import 'package:hostel_pass_management/providers/student_announcement_provider.dart';
import 'package:hostel_pass_management/providers/student_pass_provider.dart';
import 'package:hostel_pass_management/providers/warden_pass_provider.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/utils/validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  SharedPreferences? prefs = SharedPreferencesManager.preferences;
  bool isForgotPassLoading = false;
  void login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    try {
      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": _emailController.text,
            "password": _passController.text,
          },
        ),
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      if (responseData["role"] == "student") {
        await prefs?.setString('jwtToken', responseData['jwtToken']);
        await prefs?.setString('uid', responseData['uid']);
        await prefs?.setString('studentId', responseData['studentId']);
        await prefs?.setString('email', responseData['email']);
        await prefs?.setString('username', responseData['username']);
        await prefs?.setString('role', responseData['role']);
        await prefs?.setString('phNo', responseData['phNo']);
        await prefs?.setInt('blockNo', responseData['blockNo']);
        await prefs?.setString('dept', responseData['dept']);
        await prefs?.setString('fatherName', responseData['fatherName']);
        await prefs?.setString('motherName', responseData['motherName']);
        await prefs?.setString('fatherPhNo', responseData['fatherPhNo']);
        await prefs?.setString('motherPhNo', responseData['motherPhNo']);
        await prefs?.setString('regNo', responseData['regNo']);
        await prefs?.setInt('year', responseData['year']);
        await prefs?.setString('section', responseData['section']);
        await prefs?.setInt('roomNo', responseData['roomNo']);

        await ref.read(studentPassProvider.notifier).loadPassFromDB();
        await ref
            .read(studentAnnouncementNotifier.notifier)
            .loadAnnouncementsFromDB();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const StudentPage(),
          ),
        );
      } else if (responseData["role"] == "rt") {
        await prefs?.setString('jwtToken', responseData['jwtToken']);
        await prefs?.setString('uid', responseData['uid']);
        await prefs?.setString('rtId', responseData['rtId']);
        await prefs?.setString('username', responseData['username']);
        await prefs?.setString('email', responseData['email']);
        await prefs?.setString('role', responseData['role']);
        await prefs?.setString('phNo', responseData['phNo']);
        await prefs?.setInt('permanentBlock', responseData['permanentBlock']);

        List<String> temporaryBlock = [];

        responseData["temporaryBlock"].forEach(
          (block) {
            temporaryBlock.add(block.toString());
          },
        );

        await prefs?.setStringList('temporaryBlock', temporaryBlock);

        await ref.read(blockStudentProvider.notifier).loadBlockStudentsFromDB();

        await ref.read(rtPassProvider.notifier).loadPassRequestsFromDB();
        await ref
            .read(rtAnnouncementNotifier.notifier)
            .loadAnnouncementsFromDB();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RtPage(),
          ),
        );
      } else if (responseData["role"] == "warden") {
        await prefs?.setString('jwtToken', responseData['jwtToken']);
        await prefs?.setString('uid', responseData['uid']);
        await prefs?.setString('wardenId', responseData['wardenId']);
        await prefs?.setString('username', responseData['username']);
        await prefs?.setString('email', responseData['email']);
        await prefs?.setString('role', responseData['role']);
        await prefs?.setString('phNo', responseData['phNo']);

        await ref
            .read(hostelStudentProvider.notifier)
            .loadHostelStudentsFromDB();
        await ref.read(specialPassProvider.notifier).getSpecailPassesFromDB();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WardenPage(),
            // builder: (context) => StatsPage(),
          ),
        );
      } else if (responseData["role"] == "security") {}
    } catch (err) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
          ),
        ),
      );
    }
  }

  void forgotPass() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email"),
        ),
      );
      return;
    }
    if (!isEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid email"),
        ),
      );
      return;
    }
    setState(() {
      isForgotPassLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/auth/forgotPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "email": _emailController.text,
          },
        ),
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode > 399) {
        throw responseData["message"];
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ForgetPassword(
            email: _emailController.text,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    } finally {
      setState(() {
        isForgotPassLoading = false;
      });
    }
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 130,
                ),
                const SizedBox(height: 60),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    "Login",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(229, 0, 0, 0),
                        fontSize: 28),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 5, 44,
                                  76), // Set your desired color here
                              width: 2.0, // Set the width of the border
                            ),
                          ),
                          labelText: "Admission No",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Colors.black, fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return "The email should not be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _passController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 5, 44,
                                  76), // Set your desired color here
                              width: 2.0, // Set the width of the border
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color.fromARGB(255, 1, 46, 76),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),

                          labelText: "Password",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Colors.black, fontSize: 20),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          // prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        validator: (pass) {
                          if (pass == null || pass.isEmpty) {
                            return "The password should not be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          // padding: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 20),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 1, 46, 76),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 3, 2, 39))),
                          child: IconButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: colorScheme.primaryContainer,
                                ),
                            icon: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            // icon: const Icon(Icons.arrow_forward, size: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextButton(
                  onPressed: isForgotPassLoading ? null : forgotPass,
                  child: isForgotPassLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 15, 60, 91)
                              // color: colorScheme.primary,
                              ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(bottom: 12),
      //   child:
      // ),
    );
  }
}

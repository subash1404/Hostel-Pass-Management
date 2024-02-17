import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hostel_pass_management/pages/common/forget_password.dart';
import 'package:hostel_pass_management/pages/student/student_page.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/utils/validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/user/login"),
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

      await prefs?.setString('jwtToken', responseData['jwtToken']);
      await prefs?.setString('uid', responseData['uid']);
      await prefs?.setString('studentId', responseData['studentId']);
      await prefs?.setString('email', responseData['email']);
      await prefs?.setString('name', responseData['name']);
      await prefs?.setString('role', responseData['role']);
      await prefs?.setString('phno', responseData['phno']);
      await prefs?.setInt('block', responseData['block']);
      await prefs?.setString('dept', responseData['dept']);
      await prefs?.setString('fatherName', responseData['fatherName']);
      await prefs?.setString('motherName', responseData['motherName']);
      await prefs?.setString('fatherphno', responseData['fatherphno']);
      await prefs?.setString('motherphno', responseData['motherphno']);
      await prefs?.setString('regNo', responseData['regNo']);
      await prefs?.setInt('year', responseData['year']);
      await prefs?.setString('section', responseData['section']);
      await prefs?.setInt('roomNo', responseData['roomNo']);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => StudentPage(),
        ),
      );
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
        Uri.parse("${dotenv.env["BACKEND_BASE_API"]}/user/forgotPassword"),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SVCE HOSTEL",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/svce.png',
                  height: 130,
                  width: 130,
                ),
                const SizedBox(height: 24),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return "The email should not be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        validator: (pass) {
                          if (pass == null || pass.isEmpty) {
                            return "The password should not be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 50,
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: isForgotPassLoading ? null : forgotPass,
                        child: isForgotPassLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.primary,
                                ),
                              ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudentPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Test Navigate",
                          style: TextStyle(
                              fontSize: 12, color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

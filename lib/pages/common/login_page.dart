import 'package:flutter/material.dart';
import 'package:hostel_pass_management/pages/student/homepage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "SVCE HOSTEL",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  Image.asset(
                    'assets/images/svce.png',
                    height: 130,
                    width: 130,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Text(
                        //   "Login",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 24),
                        // ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email_outlined)),
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return "The email should not be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passController,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock_outline)),
                          validator: (pass) {
                            if (pass == null || pass.isEmpty) {
                              return "The password should not be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Center(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {}, //login,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromARGB(58, 142, 66, 255),
                              ),
                              width: MediaQuery.of(context).size.width - 225,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30),
                              child: Center(
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Test Navigate",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

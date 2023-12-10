import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:new_sdk_demo/screens/dashboard_screen.dart';
import 'package:new_sdk_demo/users_auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'forgot_password.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  final FirebaseAuthService auth = FirebaseAuthService();

  List<Color> colors = [
    Color.fromARGB(255, 103, 180, 243),
    Color.fromARGB(255, 32, 201, 239)
  ];

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  // Method to validate inputs
  String _validateInputs() {
    String errorMessage = '';

    if (loginEmailController.text.isEmpty &&
        loginPasswordController.text.isEmpty) {
      errorMessage = "Please fill empty fields";
    } else if (loginEmailController.text.isEmpty) {
      errorMessage = 'Email is required';
    } else if (loginPasswordController.text.isEmpty) {
      errorMessage = 'Password is required';
    }

    return errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Lottie.asset("assets/images/login_animation.json"),
                  Text(
                    "Get Logged In From Here",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 12),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextField(
                      controller:
                          loginEmailController, // Connect controller here
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Your Email',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 12),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextField(
                      controller:
                          loginPasswordController, // Connect controller here
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  InkWell(
                    onTap: () {
                      Get.to(() => ForgotPassword());
                    },
                    child: Text(
                      "Forgot Password ? ",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  MaterialButton(
                      color: const Color.fromARGB(255, 1, 72, 130),
                      height: 20.h,
                      minWidth: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        String errorMessage = _validateInputs();
                        if (errorMessage.isNotEmpty) {
                          // Show the error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          );
                        } else {
                          try {
                            String uname = loginEmailController.text;
                            String password = loginPasswordController.text;

                            User? user = await auth.signInWithEmailPassword(
                                uname, password);

                            if (user != null) {
                              Get.offAll(() => DashBoardScreen(),
                                  arguments: user.uid);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    " Invalid Credentias ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              );

                              loginEmailController.clear();
                              loginPasswordController.clear();
                            }
                          } on FirebaseAuthException catch (fe) {
                            print(fe);
                          }
                        }

                        // Validate inputs before proceeding
                      }),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "don't have an account ? ",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => RegisterScreen());
                        },
                        child: Text(
                          "Sign Up ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

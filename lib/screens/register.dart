import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:new_sdk_demo/users_auth/firebase_auth_service.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpConfirmPasswordController =
      TextEditingController();
  TextEditingController signUpNameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final FirebaseAuthService auth = FirebaseAuthService();

  List<Color> colors = [
    Color.fromARGB(255, 103, 180, 243),
    Color.fromARGB(255, 32, 201, 239)
  ];

  @override
  void dispose() {
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    signUpNameController.dispose();
    super.dispose();
  }

  String _validateInputs() {
    if (signUpEmailController.text.isEmpty ||
        signUpNameController.text.isEmpty ||
        signUpPasswordController.text.isEmpty ||
        signUpConfirmPasswordController.text.isEmpty) {
      return 'Please fill all fields ';
    }

    if (signUpPasswordController.text.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!EmailValidator.validate(signUpEmailController.text)) {
      return 'Please enter a valid email address';
    }

    if (signUpPasswordController.text != signUpConfirmPasswordController.text) {
      return 'Password and Confirm Password must match';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Lottie.asset('assets/images/sign_up.json'),
                  Text(
                    "Get Registered From Here",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 12.sp),
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
                      keyboardType: TextInputType.emailAddress,
                      controller: signUpEmailController,
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
                    "Name ",
                    style: TextStyle(fontSize: 12.sp),
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
                      controller: signUpNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Your Name',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(fontSize: 12.sp),
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
                      controller: signUpPasswordController,
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
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Confirm Password",
                    style: TextStyle(fontSize: 12.sp),
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
                      controller: signUpConfirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Confirm Password',
                        contentPadding: EdgeInsets.all(10),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
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
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
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
                        String uname = signUpConfirmPasswordController.text;
                        String password = signUpPasswordController.text;
                        String email = signUpEmailController.text;
                        String name = signUpNameController.text;

                        try {
                          User? user = await auth.signUpWithEmailPassword(
                              email, password, name);

                          User? userid = FirebaseAuth.instance.currentUser;

                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(userid?.uid)
                              .set({
                            'email': email,
                            'password': password,
                            'confirm-password': uname,
                            'createdAt': DateTime.now(),
                            'name': name,
                            'userId': userid?.uid,
                          });

                          if (user != null) {
                            FirebaseAuth.instance.signOut();
                            Get.to(() => LoginScreen());
                          }
                        } on FirebaseAuthException catch (e) {
                          print(e.message);
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "already have an account ? ",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => LoginScreen());
                        },
                        child: Text(
                          "Sign In ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
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
